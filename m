From: akpm@linux-foundation.org
Subject: + mm-simplify-try_to_unmap_one.patch added to -mm tree
Date: Wed, 18 Nov 2009 15:18:11 -0800
Message-ID: <200911182318.nAINIBBp015783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35830 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757376AbZKRXSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Nov 2009 18:18:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, hugh.dickins@tiscali.co.uk


The patch titled
     mm: simplify try_to_unmap_one()
has been added to the -mm tree.  Its filename is
     mm-simplify-try_to_unmap_one.patch

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
Subject: mm: simplify try_to_unmap_one()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

SWAP_MLOCK mean "We marked the page as PG_MLOCK, please move it to
unevictable-lru". So, following code is easy confusable.

        if (vma->vm_flags & VM_LOCKED) {
                ret = SWAP_MLOCK;
                goto out_unmap;
        }

Plus, if the VMA doesn't have VM_LOCKED, We don't need to check
the needed of calling mlock_vma_page().

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/rmap.c~mm-simplify-try_to_unmap_one mm/rmap.c
--- a/mm/rmap.c~mm-simplify-try_to_unmap_one
+++ a/mm/rmap.c
@@ -779,10 +779,9 @@ static int try_to_unmap_one(struct page 
 	 * skipped over this mm) then we should reactivate it.
 	 */
 	if (!(flags & TTU_IGNORE_MLOCK)) {
-		if (vma->vm_flags & VM_LOCKED) {
-			ret = SWAP_MLOCK;
-			goto out_unmap;
-		}
+		if (vma->vm_flags & VM_LOCKED)
+			goto out_mlock;
+
 		if (TTU_ACTION(flags) == TTU_MUNLOCK)
 			goto out_unmap;
 	}
@@ -855,18 +854,19 @@ static int try_to_unmap_one(struct page 
 
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
+out:
+	return ret;
 
-	if (ret == SWAP_MLOCK) {
-		ret = SWAP_AGAIN;
-		if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
-			if (vma->vm_flags & VM_LOCKED) {
-				mlock_vma_page(page);
-				ret = SWAP_MLOCK;
-			}
-			up_read(&vma->vm_mm->mmap_sem);
+out_mlock:
+	pte_unmap_unlock(pte, ptl);
+
+	if (down_read_trylock(&vma->vm_mm->mmap_sem)) {
+		if (vma->vm_flags & VM_LOCKED) {
+			mlock_vma_page(page);
+			ret = SWAP_MLOCK;
 		}
+		up_read(&vma->vm_mm->mmap_sem);
 	}
-out:
 	return ret;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-allow-memory-hotplug-and-hibernation-in-the-same-kernel.patch
linux-next.patch
oom-dump-stack-and-vm-state-when-oom-killer-panics.patch
readahead-add-blk_run_backing_dev.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-move-inc_zone_page_statenr_isolated-to-just-isolated-place.patch
rmap-simplify-try_to_unmap_file.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process-fix.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42-checkpatch-fixes.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
mm-add-numa-node-symlink-for-memory-section-in-sysfs.patch
mm-refactor-register_cpu_under_node.patch
mm-refactor-unregister_cpu_under_node.patch
mm-add-numa-node-symlink-for-cpu-devices-in-sysfs.patch
documentation-abi-sys-devices-system-cpu-cpu-node.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
mm-memory_hotplug-make-offline_pages-static.patch
mm-simplify-try_to_unmap_one.patch
procfs-allow-threads-to-rename-siblings-via-proc-pid-tasks-tid-comm.patch
maintainers-mark-cifs-mailing-list-as-moderated-for-non-subscribers.patch
lib-introduce-strim.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

