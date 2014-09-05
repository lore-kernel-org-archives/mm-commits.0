From: akpm@linux-foundation.org
Subject: + kcmp-fix-standard-comparison-bug.patch added to -mm tree
Date: Fri, 05 Sep 2014 12:22:00 -0700
Message-ID: <540a0d58.K0plgOgSAS6xPevn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaIETWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Sep 2014 15:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, gorcunov@openvz.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kcmp: fix standard comparison bug
has been added to the -mm tree.  Its filename is
     kcmp-fix-standard-comparison-bug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kcmp-fix-standard-comparison-bug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kcmp-fix-standard-comparison-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: kcmp: fix standard comparison bug

The C operator <= defines a perfectly fine total ordering on the set
of values representable in a long. However, unlike its namesake in the
integers, it is not translation invariant, meaning that we do not have
"b <= c" iff "a+b <= a+c" for all a,b,c.

This means that it is always wrong to try to boil down the relationship
between two longs to a question about the sign of their difference,
because the resulting relation [a LEQ b iff a-b <= 0] is neither
anti-symmetric or transitive.  The former is due to -LONG_MIN==LONG_MIN
(take any two a,b with a-b = LONG_MIN; then a LEQ b and b LEQ a, but a !=
b).  The latter can either be seen observing that x LEQ x+1 for all x,
implying x LEQ x+1 LEQ x+2 ...  LEQ x-1 LEQ x; or more directly with the
simple example a=LONG_MIN, b=0, c=1, for which a-b < 0, b-c < 0, but a-c >
0.

Note that it makes absolutely no difference that a transmogrying bijection
has been applied before the comparison is done.  In fact, had the
obfuscation not been done, one could probably not observe the bug
(assuming all values being compared always lie in one half of the address
space, the mathematical value of a-b is always representable in a long). 
As it stands, one can easily obtain three file descriptors exhibiting the
non-transitivity of kcmp().

Side note 1: I can't see that ensuring the MSB of the multiplier is
set serves any purpose other than obfuscating the obfuscating code.

Side note 2:
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <assert.h>
#include <sys/syscall.h>

enum kcmp_type {
        KCMP_FILE,
        KCMP_VM,
        KCMP_FILES,
        KCMP_FS,
        KCMP_SIGHAND,
        KCMP_IO,
        KCMP_SYSVSEM,
        KCMP_TYPES,
};
pid_t pid;

int kcmp(pid_t pid1, pid_t pid2, int type,
	 unsigned long idx1, unsigned long idx2)
{
	return syscall(SYS_kcmp, pid1, pid2, type, idx1, idx2);
}
int cmp_fd(int fd1, int fd2)
{
	int c = kcmp(pid, pid, KCMP_FILE, fd1, fd2);
	if (c < 0) {
		perror("kcmp");
		exit(1);
	}
	assert(0 <= c && c < 3);
	return c;
}
int cmp_fdp(const void *a, const void *b)
{
	static const int normalize[] = {0, -1, 1};
	return normalize[cmp_fd(*(int*)a, *(int*)b)];
}
#define MAX 100 /* This is plenty; I've seen it trigger for MAX==3 */
int main(int argc, char *argv[])
{
	int r, s, count = 0;
	int REL[3] = {0,0,0};
	int fd[MAX];
	pid = getpid();
	while (count < MAX) {
		r = open("/dev/null", O_RDONLY);
		if (r < 0)
			break;
		fd[count++] = r;
	}
	printf("opened %d file descriptors\n", count);
	for (r = 0; r < count; ++r) {
		for (s = r+1; s < count; ++s) {
			REL[cmp_fd(fd[r], fd[s])]++;
		}
	}
	printf("== %d\t< %d\t> %d\n", REL[0], REL[1], REL[2]);
	qsort(fd, count, sizeof(fd[0]), cmp_fdp);
	memset(REL, 0, sizeof(REL));

	for (r = 0; r < count; ++r) {
		for (s = r+1; s < count; ++s) {
			REL[cmp_fd(fd[r], fd[s])]++;
		}
	}
	printf("== %d\t< %d\t> %d\n", REL[0], REL[1], REL[2]);
	return (REL[0] + REL[2] != 0);
}

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>
"Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/kcmp.c~kcmp-fix-standard-comparison-bug kernel/kcmp.c
--- a/kernel/kcmp.c~kcmp-fix-standard-comparison-bug
+++ a/kernel/kcmp.c
@@ -44,11 +44,12 @@ static long kptr_obfuscate(long v, int t
  */
 static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
 {
-	long ret;
+	long t1, t2;
 
-	ret = kptr_obfuscate((long)v1, type) - kptr_obfuscate((long)v2, type);
+	t1 = kptr_obfuscate((long)v1, type);
+	t2 = kptr_obfuscate((long)v2, type);
 
-	return (ret < 0) | ((ret > 0) << 1);
+	return (t1 < t2) | ((t1 > t2) << 1);
 }
 
 /* The caller must have pinned the task */
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
kcmp-fix-standard-comparison-bug.patch
linux-next.patch

