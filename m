From: akpm@linux-foundation.org
Subject: [wrecked] drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:12:14 -0800
Message-ID: <20121126221216.20A19100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45508 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab2KZWMZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:12:25 -0500
Received: by mail-qa0-f74.google.com with SMTP id g40so534486qab.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:12:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/tty/serial/serial_core.c: fix uart_get_attr_port() shift
has been removed from the -mm tree.  Its filename was
     drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch

This patch was dropped because other changes were merged, which wrecked this patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/tty/serial/serial_core.c: fix uart_get_attr_port() shift

drivers/tty/serial/serial_core.c: In function 'uart_get_attr_port':
drivers/tty/serial/serial_core.c:2412: warning: left shift count >= width of type

Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/serial_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/tty/serial/serial_core.c~drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift drivers/tty/serial/serial_core.c
--- a/drivers/tty/serial/serial_core.c~drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift
+++ a/drivers/tty/serial/serial_core.c
@@ -2407,9 +2407,13 @@ static ssize_t uart_get_attr_port(struct
 {
 	struct serial_struct tmp;
 	struct tty_port *port = dev_get_drvdata(dev);
+	unsigned long ioaddr;
 
 	uart_get_info(port, &tmp);
-	return snprintf(buf, PAGE_SIZE, "0x%lX\n", (unsigned long)(tmp.port | (tmp.port_high << HIGH_BITS_OFFSET)));
+	ioaddr = tmp.port;
+	if (HIGH_BITS_OFFSET)
+		ioaddr |= (unsigned long)tmp.port_high << HIGH_BITS_OFFSET;
+	return snprintf(buf, PAGE_SIZE, "0x%lX\n", ioaddr);
 }
 
 static ssize_t uart_get_attr_irq(struct device *dev,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

futex-avoid-wake_futex-for-a-pi-futex_q-fix.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
drivers-video-add-support-for-the-solomon-ssd1307-oled-controller-checkpatch-fixes.patch
irq-tsk-comm-is-an-array.patch
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
mm-cma-skip-watermarks-check-for-already-isolated-blocks-in-split_free_page-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
mm-add-a-reminder-comment-for-__gfp_bits_shift.patch
numa-add-config_movable_node-for-movable-dedicated-node-fix.patch
mm-introduce-new-field-managed_pages-to-struct-zone-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
backlight-add-of_find_backlight_by_node-function-fix.patch
backlight-88pm860x_bl-remove-an-unnecessary-line-continuation-fix.patch
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

