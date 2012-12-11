From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:42:53 -0800
Message-ID: <20121211234254.21440200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:61438 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab2LKXm5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:42:57 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so1864wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:42:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, dhillf@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix
has been removed from the -mm tree.  Its filename was
     mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch

This patch was dropped because it was folded into mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix

cleanups

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix
+++ a/fs/hugetlbfs/inode.c
@@ -1049,7 +1049,7 @@ static int __init init_hugetlbfs_fs(void
 		goto out;
 
 	i = 0;
-	for_each_hstate (h) {
+	for_each_hstate(h) {
 		char buf[50];
 		unsigned ps_kb = 1U << (h->order + PAGE_SHIFT - 10);
 
@@ -1058,9 +1058,8 @@ static int __init init_hugetlbfs_fs(void
 							buf);
 
 		if (IS_ERR(hugetlbfs_vfsmount[i])) {
-				pr_err(
-			"hugetlb: Cannot mount internal hugetlbfs for page size %uK",
-			       ps_kb);
+			pr_err("hugetlb: Cannot mount internal hugetlbfs for "
+				"page size %uK", ps_kb);
 			error = PTR_ERR(hugetlbfs_vfsmount[i]);
 			hugetlbfs_vfsmount[i] = NULL;
 		}
@@ -1090,7 +1089,7 @@ static void __exit exit_hugetlbfs_fs(voi
 	rcu_barrier();
 	kmem_cache_destroy(hugetlbfs_inode_cachep);
 	i = 0;
-	for_each_hstate (h)
+	for_each_hstate(h)
 		kern_unmount(hugetlbfs_vfsmount[i++]);
 	unregister_filesystem(&hugetlbfs_fs_type);
 	bdi_destroy(&hugetlbfs_backing_dev_info);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-mm-fix-balloon_page_movable-page-flags-check-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

