From: akpm@linux-foundation.org
Subject: [folded-dropped] virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch removed from -mm tree
Date: Thu, 15 Nov 2012 11:55:30 -0800
Message-ID: <20121115195530.EC04C100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:59556 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768870Ab2KOTzc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:55:32 -0500
Received: by mail-vc0-f202.google.com with SMTP id fy27so214211vcb.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:55:31 -0800 (PST)
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
@@ -140,7 +140,7 @@ static void fill_balloon(struct virtio_b
 
 		if (!page) {
 			dev_info_ratelimited(&vb->vdev->dev,
-					   "Out of puff! Can't get %zu pages\n",
+					   "Out of puff! Can't get %u pages\n",
 					   VIRTIO_BALLOON_PAGES_PER_PAGE);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swapfile-fix-name-leak-in-swapoff-fix.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-fix-up-zone-present-pages.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
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
mm-introduce-a-common-interface-for-balloon-pages-mobility.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-export-a-function-to-get-vm-committed-memory-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
maintainers-add-joe-to-checkpatch-maintainers.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

