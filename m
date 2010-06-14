From: akpm@linux-foundation.org
Subject: + pids-fix-a-race-in-pid-generation-that-causes-pids-to-be-reused-immediately.patch added to -mm tree
Date: Mon, 14 Jun 2010 16:59:10 -0700
Message-ID: <201006142359.o5ENxAmG006549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab0FNX7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 19:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sqazi@google.com, a.p.zijlstra@chello.nl, ebiederm@xmission.com, mingo@elte.hu, sukadev@us.ibm.com, tytso@mit.edu


The patch titled
     pids: fix a race in pid generation that causes pids to be reused immediately
has been added to the -mm tree.  Its filename is
     pids-fix-a-race-in-pid-generation-that-causes-pids-to-be-reused-immediately.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pids: fix a race in pid generation that causes pids to be reused immediately
From: Salman <sqazi@google.com>

A program that repeatedly forks and waits is susceptible to having the
same pid repeated, especially when it competes with another instance of
the same program.  This is really bad for bash implementation. 
Furthermore, many shell scripts assume that pid numbers will not be used
for some length of time.

Race Description:

A                                    B

// pid == offset == n                // pid == offset == n + 1
test_and_set_bit(offset, map->page)
                                     test_and_set_bit(offset, map->page);
                                     pid_ns->last_pid = pid;
pid_ns->last_pid = pid;
                                     // pid == n + 1 is freed (wait())

                                     // Next fork()...
                                     last = pid_ns->last_pid; // == n
                                     pid = last + 1;

Code to reproduce it (Running multiple instances is more effective):

#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

// The distance mod 32768 between two pids, where the first pid is expected
// to be smaller than the second.
int PidDistance(pid_t first, pid_t second) {
  return (second + 32768 - first) % 32768;
}

int main(int argc, char* argv[]) {
  int failed = 0;
  pid_t last_pid = 0;
  int i;
  printf("%d\n", sizeof(pid_t));
  for (i = 0; i < 10000000; ++i) {
    if (i % 32786 == 0)
      printf("Iter: %d\n", i/32768);
    int child_exit_code = i % 256;
    pid_t pid = fork();
    if (pid == -1) {
      fprintf(stderr, "fork failed, iteration %d, errno=%d", i, errno);
      exit(1);
    }
    if (pid == 0) {
      // Child
      exit(child_exit_code);
    } else {
      // Parent
      if (i > 0) {
        int distance = PidDistance(last_pid, pid);
        if (distance == 0 || distance > 30000) {
          fprintf(stderr,
                  "Unexpected pid sequence: previous fork: pid=%d, "
                  "current fork: pid=%d for iteration=%d.\n",
                  last_pid, pid, i);
          failed = 1;
        }
      }
      last_pid = pid;
      int status;
      int reaped = wait(&status);
      if (reaped != pid) {
        fprintf(stderr,
                "Wait return value: expected pid=%d, "
                "got %d, iteration %d\n",
                pid, reaped, i);
        failed = 1;
      } else if (WEXITSTATUS(status) != child_exit_code) {
        fprintf(stderr,
                "Unexpected exit status %x, iteration %d\n",
                WEXITSTATUS(status), i);
        failed = 1;
      }
    }
  }
  exit(failed);
}

Thanks to Ted Tso for the key ideas of this implementation.

Signed-off-by: Salman Qazi <sqazi@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff -puN kernel/pid.c~pids-fix-a-race-in-pid-generation-that-causes-pids-to-be-reused-immediately kernel/pid.c
--- a/kernel/pid.c~pids-fix-a-race-in-pid-generation-that-causes-pids-to-be-reused-immediately
+++ a/kernel/pid.c
@@ -122,6 +122,43 @@ static void free_pidmap(struct upid *upi
 	atomic_inc(&map->nr_free);
 }
 
+/*
+ * If we started walking pids at 'base', is 'a' seen before 'b'?
+ */
+static int pid_before(int base, int a, int b)
+{
+	/*
+	 * This is the same as saying
+	 *
+	 * (a - base + MAXUINT) % MAXUINT < (b - base + MAXUINT) % MAXUINT
+	 * and that mapping orders 'a' and 'b' with respect to 'base'.
+	 */
+	return (unsigned)(a - base) < (unsigned)(b - base);
+}
+
+/*
+ * We might be racing with someone else trying to set pid_ns->last_pid.
+ * We want the winner to have the "later" value, because if the
+ * "earlier" value prevails, then a pid may get reused immediately.
+ *
+ * Since pids rollover, it is not sufficient to just pick the bigger
+ * value.  We have to consider where we started counting from.
+ *
+ * 'base' is the value of pid_ns->last_pid that we observed when
+ * we started looking for a pid.
+ *
+ * 'pid' is the pid that we eventually found.
+ */
+static void set_last_pid(struct pid_namespace *pid_ns, int base, int pid)
+{
+	int prev;
+	int last_write = base;
+	do {
+		prev = last_write;
+		last_write = cmpxchg(&pid_ns->last_pid, prev, pid);
+	} while ((prev != last_write) && (pid_before(base, last_write, pid)));
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
@@ -154,7 +191,7 @@ static int alloc_pidmap(struct pid_names
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
 					atomic_dec(&map->nr_free);
-					pid_ns->last_pid = pid;
+					set_last_pid(pid_ns, last, pid);
 					return pid;
 				}
 				offset = find_next_offset(map, offset);
_

Patches currently in -mm which might be from sqazi@google.com are

pids-fix-a-race-in-pid-generation-that-causes-pids-to-be-reused-immediately.patch

