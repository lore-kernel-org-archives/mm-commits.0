From: akpm@linux-foundation.org
Subject: [folded-merged] swapfile-fix-name-leak-in-swapoff-fix.patch removed from -mm tree
Date: Fri, 16 Nov 2012 14:11:51 -0800
Message-ID: <20121116221151.F4136100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51493 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab2KPWLx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Nov 2012 17:11:53 -0500
Received: by mail-ye0-f202.google.com with SMTP id r11so357756yen.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Nov 2012 14:11:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dannyfeng@tencent.com, jlayton@redhat.com, viro@zeniv.linux.org.uk, xtfeng@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile-fix-name-leak-in-swapoff-fix
has been removed from the -mm tree.  Its filename was
     swapfile-fix-name-leak-in-swapoff-fix.patch

This patch was dropped because it was folded into swapfile-fix-name-leak-in-swapoff.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: swapfile-fix-name-leak-in-swapoff-fix

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Layton <jlayton@redhat.com>
Cc: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swapfile-fix-name-leak-in-swapoff-fix mm/swapfile.c
--- a/mm/swapfile.c~swapfile-fix-name-leak-in-swapoff-fix
+++ a/mm/swapfile.c
@@ -1494,9 +1494,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	BUG_ON(!current->mm);
 
 	pathname = getname(specialfile);
-	err = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
-		goto out;
+		return PTR_ERR(pathname);
 
 	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
 	err = PTR_ERR(victim);
@@ -1608,8 +1607,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 out_dput:
 	filp_close(victim, NULL);
 out:
-	if (pathname && !IS_ERR(pathname))
-		putname(pathname);
+	putname(pathname);
 	return err;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swapfile-fix-name-leak-in-swapoff.patch
revert-mm-fix-up-zone-present-pages.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-export-a-function-to-get-vm-committed-memory.patch
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
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
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

