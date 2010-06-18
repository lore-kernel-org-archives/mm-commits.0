From: akpm@linux-foundation.org
Subject: + pids-alloc_pidmap-remove-the-unnecessary-boundary-checks.patch added to -mm tree
Date: Fri, 18 Jun 2010 14:30:54 -0700
Message-ID: <201006182130.o5ILUsGT024505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34828 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752989Ab0FRVbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 17:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, ebiederm@xmission.com, mingo@elte.hu, sqazi@google.com, sukadev@us.ibm.com


The patch titled
     pids: alloc_pidmap: remove the unnecessary boundary checks
has been added to the -mm tree.  Its filename is
     pids-alloc_pidmap-remove-the-unnecessary-boundary-checks.patch

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
Subject: pids: alloc_pidmap: remove the unnecessary boundary checks
From: Oleg Nesterov <oleg@redhat.com>

alloc_pidmap() calculates max_scan so that if the initial offset != 0 we
inspect the first map->page twice.  This is correct, we want to find the
unused bits < offset in this bitmap block.  Add the comment.

But it doesn't make any sense to stop the find_next_offset() loop when we
are looking into this map->page for the second time.  We have already
already checked the bits >= offset during the first attempt, it is fine to
do this again, no matter if we succeed this time or not.

Remove this hard-to-understand code.  It optimizes the very unlikely case
when we are going to fail, but slows down the more likely case.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Salman Qazi <sqazi@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/pid.c~pids-alloc_pidmap-remove-the-unnecessary-boundary-checks kernel/pid.c
--- a/kernel/pid.c~pids-alloc_pidmap-remove-the-unnecessary-boundary-checks
+++ a/kernel/pid.c
@@ -169,7 +169,12 @@ static int alloc_pidmap(struct pid_names
 		pid = RESERVED_PIDS;
 	offset = pid & BITS_PER_PAGE_MASK;
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
-	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
+	/*
+	 * If last_pid points into the middle of the map->page we
+	 * want to scan this bitmap block twice, the second time
+	 * we start with offset == 0 (or RESERVED_PIDS).
+	 */
+	max_scan = DIV_ROUND_UP(pid_max, BITS_PER_PAGE) - !offset;
 	for (i = 0; i <= max_scan; ++i) {
 		if (unlikely(!map->page)) {
 			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -196,15 +201,7 @@ static int alloc_pidmap(struct pid_names
 				}
 				offset = find_next_offset(map, offset);
 				pid = mk_pid(pid_ns, map, offset);
-			/*
-			 * find_next_offset() found a bit, the pid from it
-			 * is in-bounds, and if we fell back to the last
-			 * bitmap block and the final block was the same
-			 * as the starting point, pid is before last_pid.
-			 */
-			} while (offset < BITS_PER_PAGE && pid < pid_max &&
-					(i != max_scan || pid < last ||
-					    !((last+1) & BITS_PER_PAGE_MASK)));
+			} while (offset < BITS_PER_PAGE && pid < pid_max);
 		}
 		if (map < &pid_ns->pidmap[(pid_max-1)/BITS_PER_PAGE]) {
 			++map;
_

Patches currently in -mm which might be from oleg@redhat.com are

oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
sys_personality-remove-the-bogus-checks-in-sys_personality-__set_personality-path.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
pids-alloc_pidmap-remove-the-unnecessary-boundary-checks.patch

