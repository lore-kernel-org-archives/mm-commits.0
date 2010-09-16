From: akpm@linux-foundation.org
Subject: + proc-pid-smaps-fix-dirty-pages-accounting.patch added to -mm tree
Date: Thu, 16 Sep 2010 12:41:04 -0700
Message-ID: <201009161941.o8GJf4ou009732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab0IPTlM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Sep 2010 15:41:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hughd@google.com, mpm@selenic.com


The patch titled
     /proc/pid/smaps: fix dirty pages accounting
has been added to the -mm tree.  Its filename is
     proc-pid-smaps-fix-dirty-pages-accounting.patch

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
Subject: /proc/pid/smaps: fix dirty pages accounting
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Currently, /proc/<pid>/smaps has wrong dirty pages accounting. 
Shared_Dirty and Private_Dirty output only pte dirty pages and ignore
PG_dirty page flag.  It is difference against documentation, but also
inconsistent against Referenced field.  (Referenced checks both pte and
page flags)

This patch fixes it.

Test program:

 large-array.c
 ---------------------------------------------------
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>

 char array[1*1024*1024*1024L];

 int main(void)
 {
         memset(array, 1, sizeof(array));
         pause();

         return 0;
 }
 ---------------------------------------------------

Test case:
 1. run ./large-array
 2. cat /proc/`pidof large-array`/smaps
 3. swapoff -a
 4. cat /proc/`pidof large-array`/smaps again

Test result:
 <before patch>

00601000-40601000 rw-p 00000000 00:00 0
Size:            1048576 kB
Rss:             1048576 kB
Pss:             1048576 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:    218992 kB   <-- showed pages as clean incorrectly
Private_Dirty:    829584 kB
Referenced:       388364 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB

 <after patch>

00601000-40601000 rw-p 00000000 00:00 0
Size:            1048576 kB
Rss:             1048576 kB
Pss:             1048576 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:   1048576 kB  <-- fixed
Referenced:       388480 kB
Swap:                  0 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~proc-pid-smaps-fix-dirty-pages-accounting fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~proc-pid-smaps-fix-dirty-pages-accounting
+++ a/fs/proc/task_mmu.c
@@ -363,13 +363,13 @@ static int smaps_pte_range(pmd_t *pmd, u
 			mss->referenced += PAGE_SIZE;
 		mapcount = page_mapcount(page);
 		if (mapcount >= 2) {
-			if (pte_dirty(ptent))
+			if (pte_dirty(ptent) || PageDirty(page))
 				mss->shared_dirty += PAGE_SIZE;
 			else
 				mss->shared_clean += PAGE_SIZE;
 			mss->pss += (PAGE_SIZE << PSS_SHIFT) / mapcount;
 		} else {
-			if (pte_dirty(ptent))
+			if (pte_dirty(ptent) || PageDirty(page))
 				mss->private_dirty += PAGE_SIZE;
 			else
 				mss->private_clean += PAGE_SIZE;
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

oom-always-return-a-badness-score-of-non-zero-for-eligible-tasks.patch
linux-next.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path.patch
vmscan-check-all_unreclaimable-in-direct-reclaim-path-v2.patch
proc-pid-smaps-fix-dirty-pages-accounting.patch
proc-pid-smaps-export-amount-of-anonymous-memory-in-a-mapping.patch
oom-filter-unkillable-tasks-from-tasklist-dump.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled.patch
vmscan-prevent-background-aging-of-anon-page-in-no-swap-system.patch
mm-mempolicy-check-return-code-of-check_range.patch
mm-add-account_page_writeback.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat.patch
writeback-add-nr_dirtied-and-nr_written-to-proc-vmstat-update.patch
writeback-add-sys-devices-system-node-node-vmstat.patch
writeback-add-sys-devices-system-node-node-vmstat-update.patch
writeback-report-dirty-thresholds-in-proc-vmstat.patch
vmscan-delete-dead-code.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
reiser4.patch

