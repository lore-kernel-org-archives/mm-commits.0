From: akpm@linux-foundation.org
Subject: [folded-merged] virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:52:13 -0800
Message-ID: <20121211235214.4FA0F200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:39349 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753346Ab2LKXwQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:52:16 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so2049eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:52:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix
has been removed from the -mm tree.  Its filename was
     virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch

This patch was dropped because it was folded into virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix

drivers/virtio/virtio_balloon.c: In function 'fill_balloon':
drivers/virtio/virtio_balloon.c:142:4: warning: format '%zu' expects argument of type 'size_t', but argument 3 has type 'long unsigned int' [-Wformat]

The type of PAGE_SIZE is different on different architectures (or at
least, it used to be).  Make things predictable.

Cc: Rafael Aquini <aquini@redhat.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix
+++ a/drivers/virtio/virtio_balloon.c
@@ -34,7 +34,7 @@
  * multiple balloon pages.  All memory counters in this driver are in balloon
  * page units.
  */
-#define VIRTIO_BALLOON_PAGES_PER_PAGE (PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
+#define VIRTIO_BALLOON_PAGES_PER_PAGE (unsigned)(PAGE_SIZE >> VIRTIO_BALLOON_PFN_SHIFT)
 #define VIRTIO_BALLOON_ARRAY_PFNS_MAX 256
 
 struct virtio_balloon
@@ -141,7 +141,7 @@ static void fill_balloon(struct virtio_b
 		if (!page) {
 			if (printk_ratelimit())
 				dev_printk(KERN_INFO, &vb->vdev->dev,
-					   "Out of puff! Can't get %zu pages\n",
+					   "Out of puff! Can't get %u pages\n",
 					   VIRTIO_BALLOON_PAGES_PER_PAGE);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-introduce-mm_find_pmd.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7.patch
mm-check-rb_subtree_gap-correctness.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses.patch
mm-vm_unmapped_area-lookup-function.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture.patch
mm-use-vm_unmapped_area-on-mips-architecture.patch
mm-use-vm_unmapped_area-on-arm-architecture.patch
mm-use-vm_unmapped_area-on-sh-architecture.patch
mm-use-vm_unmapped_area-on-sparc32-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture.patch
mm-use-vm_unmapped_area-on-sparc64-architecture.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

