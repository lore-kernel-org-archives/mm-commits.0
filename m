From: akpm@linux-foundation.org
Subject: [folded-merged] virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch removed from -mm tree
Date: Tue, 11 Dec 2012 15:52:10 -0800
Message-ID: <20121211235210.D6430100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41991 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2LKXwM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Dec 2012 18:52:12 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so11695qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Dec 2012 15:52:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aquini@redhat.com, yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix
has been removed from the -mm tree.  Its filename was
     virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch

This patch was dropped because it was folded into virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix

avoid having multiple return points in fill_balloon()

Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix
+++ a/drivers/virtio/virtio_balloon.c
@@ -151,13 +151,9 @@ static void fill_balloon(struct virtio_b
 		totalram_pages--;
 	}
 
-	/* Didn't get any?  Oh well. */
-	if (vb->num_pfns == 0) {
-		mutex_unlock(&vb->balloon_lock);
-		return;
-	}
-
-	tell_host(vb, vb->inflate_vq);
+	/* Did we get any? */
+	if (vb->num_pfns != 0)
+		tell_host(vb, vb->inflate_vq);
 	mutex_unlock(&vb->balloon_lock);
 }
 
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
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch

