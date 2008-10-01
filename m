From: akpm@linux-foundation.org
Subject: - fix-a-race-condtion-of-oops_in_progress-fix2.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:38:44 -0700
Message-ID: <200810012138.m91LcijR005266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYJAVjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     build error fix of "fix a race condition of oops_in_progress"
has been removed from the -mm tree.  Its filename was
     fix-a-race-condtion-of-oops_in_progress-fix2.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: build error fix of "fix a race condition of oops_in_progress"
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Patch against: mmotm 09/13
Patch name: fix-a-race-condtion-of-oops_in_progress-fix2.patch
Applied after: fix-a-race-condtion-of-oops_in_progress-fix.patch

if CONFIG_DEBUG_MUTEXES=y, mutex.c makes following build error.
because oops_in_progress was changed from int to atomic_t.

------------------------------------------------------------------
  CC      kernel/mutex.o
kernel/mutex.c: In function '__mutex_lock_common':
kernel/mutex.c:135: error: wrong type argument to unary exclamation mark
kernel/mutex.c:135: error: wrong type argument to unary exclamation mark
kernel/mutex.c:183: error: wrong type argument to unary exclamation mark
kernel/mutex.c:183: error: wrong type argument to unary exclamation mark
kernel/mutex.c: In function '__mutex_unlock_common_slowpath':
kernel/mutex.c:240: error: wrong type argument to unary exclamation mark
kernel/mutex.c:240: error: wrong type argument to unary exclamation mark
kernel/mutex.c: In function '__mutex_trylock_slowpath':
kernel/mutex.c:351: error: wrong type argument to unary exclamation mark
kernel/mutex.c:351: error: wrong type argument to unary exclamation mark
make[1]: *** [kernel/mutex.o] Error 1
make: *** [kernel] Error 2
---------------------------------------------------------------

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debug_locks.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/debug_locks.h~fix-a-race-condtion-of-oops_in_progress-fix2 include/linux/debug_locks.h
--- a/include/linux/debug_locks.h~fix-a-race-condtion-of-oops_in_progress-fix2
+++ a/include/linux/debug_locks.h
@@ -17,7 +17,7 @@ extern int debug_locks_off(void);
 ({									\
 	int __ret = 0;							\
 									\
-	if (!oops_in_progress && unlikely(c)) {				\
+	if (!atomic_read(&oops_in_progress) && unlikely(c)) {		\
 		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN_ON(1);					\
 		__ret = 1;						\
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-do_generic_file_read-never-gets-a-null-filp-argument.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-nommu-fix.patch
unevictable-lru-infrastructure-remember-pages-active-state.patch
unevictable-lru-infrastructure-defer-vm-event-counting.patch
unevictable-infrastructure-lru-add-event-counting-with-statistics.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-add-event-counts-to-list-scan.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
doc-unevictable-lru-and-mlocked-pages-documentation-update-2.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-__mlock_vma_pages_range-comment-block.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-backout-locked_vm-adjustment-during-mmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-fix-return-value-for-munmap-mlock-vma-race.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-update-locked_vm-on-munmap-of-mlocked-region.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-mlocked-pages-add-event-counting-with-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mlock-revert-mainline-handling-of-mlock-error-return.patch
mlock-make-mlock-error-return-posixly-correct.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-unlockless-reclaim.patch
fix-a-race-condtion-of-oops_in_progress-fix2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

