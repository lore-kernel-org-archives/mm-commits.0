From: akpm@linux-foundation.org
Subject: [failures] mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch removed from -mm tree
Date: Wed, 14 Nov 2012 14:19:04 -0800
Message-ID: <20121114221904.D72AA100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55440 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423511Ab2KNWTG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:19:06 -0500
Received: by mail-gh0-f202.google.com with SMTP id z15so102868ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:19:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, hughd@google.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@elte.hu, ralf@linux-mips.org, riel@redhat.com, tglx@linutronix.de, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-on-sparc64-architecture-fix
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-vm_unmapped_area-on-sparc64-architecture-fix

remove now-unused COLOUR_ALIGN_DOWN()

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michel Lespinasse <walken@google.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/kernel/sys_sparc_64.c |   11 -----------
 1 file changed, 11 deletions(-)

diff -puN arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture-fix arch/sparc/kernel/sys_sparc_64.c
--- a/arch/sparc/kernel/sys_sparc_64.c~mm-use-vm_unmapped_area-on-sparc64-architecture-fix
+++ a/arch/sparc/kernel/sys_sparc_64.c
@@ -84,17 +84,6 @@ static inline unsigned long COLOUR_ALIGN
 	return base + off;
 }
 
-static inline unsigned long COLOUR_ALIGN_DOWN(unsigned long addr,
-					      unsigned long pgoff)
-{
-	unsigned long base = addr & ~(SHMLBA-1);
-	unsigned long off = (pgoff<<PAGE_SHIFT) & (SHMLBA-1);
-
-	if (base + off <= addr)
-		return base + off;
-	return base - off;
-}
-
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct mm_struct *mm = current->mm;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
swapfile-fix-name-leak-in-swapoff-fix.patch
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
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
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
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

