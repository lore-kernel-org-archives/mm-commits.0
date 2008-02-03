From: akpm@linux-foundation.org
Subject: - mm-zero-length-iov-fix.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:43 -0800
Message-ID: <200802032022.m13KMOs0030009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32922 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752322AbYBCUWu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nickpiggin@yahoo.com.au, efault@gmx.de, fhimpe@telenet.be, npiggin@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: zero-length IOV fix
has been removed from the -mm tree.  Its filename was
     mm-zero-length-iov-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: zero-length IOV fix
From: Nick Piggin <nickpiggin@yahoo.com.au>

Zero length iovecs can go into an infinite loop in writev, because the
iovec iterator does not always advance over them.

The sequence required to trigger this is not trivial.  I think it requires
that a zero-length iovec be followed by a non-zero-length iovec which
causes a pagefault in the atomic usercopy.  This causes the writev code to
drop back into single-segment copy mode, which then tries to copy the 0
bytes of the zero-length iovec; a zero length copy looks like a failure
though, so it loops.

Put a test into iov_iter_advance to catch zero-length iovecs.  We could
just put the test in the fallback path, but I feel it is more robust to
skip over zero-length iovecs throughout the code (iovec iterator may be
used in filesystems too, so it should be robust).

Signed-off-by: Nick Piggin <npiggin@suse.de>
Tested-by: Frederik Himpe <fhimpe@telenet.be>
Cc: <stable@kernel.org>
Cc: Mike Galbraith <efault@gmx.de
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/filemap.c~mm-zero-length-iov-fix mm/filemap.c
--- a/mm/filemap.c~mm-zero-length-iov-fix
+++ a/mm/filemap.c
@@ -1749,7 +1749,11 @@ static void __iov_iter_advance_iov(struc
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
 
-		while (bytes) {
+		/*
+		 * The !iov->iov_len check ensures we skip over unlikely
+		 * zero-length segments.
+		 */
+		while (bytes || !iov->iov_len) {
 			int copy = min(bytes, iov->iov_len - base);
 
 			bytes -= copy;
@@ -2267,6 +2271,7 @@ again:
 
 		cond_resched();
 
+		iov_iter_advance(i, copied);
 		if (unlikely(copied == 0)) {
 			/*
 			 * If we were unable to copy any data at all, we must
@@ -2280,7 +2285,6 @@ again:
 						iov_iter_single_seg_count(i));
 			goto again;
 		}
-		iov_iter_advance(i, copied);
 		pos += copied;
 		written += copied;
 
_

Patches currently in -mm which might be from nickpiggin@yahoo.com.au are

origin.patch
git-unionfs.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-use-non-atomic-bit-unlock.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
fix-dirty-page-accounting-leak-with-ext3-data=journal.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-add-scan_global_lru-macro.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-nid-zid-helper-function-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-active-inactive-counter.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-mapper_ratio-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-active-inactive-imbalance-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-calculate-the-number-of-pages-to-be-scanned-per-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lru-for-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-per-zone-lock-for-cgroup.patch
rewrite-rd-fixes.patch
