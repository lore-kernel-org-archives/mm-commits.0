From: akpm@linux-foundation.org
Subject: - git-kgdb-fixup.patch removed from -mm tree
Date: Thu, 06 Sep 2007 17:24:36 -0700
Message-ID: <200709070024.l870Oa5B015471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44696 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932658AbXIGAYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2007 20:24:40 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l870ObqD025402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 6 Sep 2007 17:24:38 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-kgdb-fixup
has been removed from the -mm tree.  Its filename was
     git-kgdb-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-kgdb-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/Makefile   |    2 +-
 arch/i386/kernel/Makefile        |    1 +
 arch/mips/sibyte/bcm1480/irq.c   |    6 ------
 arch/mips/sibyte/sb1250/irq.c    |    6 ------
 arch/mips/tx4927/common/Makefile |    3 ---
 include/asm-i386/kdebug.h        |    1 +
 include/asm-x86_64/kdebug.h      |    1 +
 7 files changed, 4 insertions(+), 16 deletions(-)

diff -puN Documentation/DocBook/Makefile~git-kgdb-fixup Documentation/DocBook/Makefile
--- a/Documentation/DocBook/Makefile~git-kgdb-fixup
+++ a/Documentation/DocBook/Makefile
@@ -11,7 +11,7 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 	    procfs-guide.xml writing_usb_driver.xml \
 	    kernel-api.xml filesystems.xml lsm.xml usb.xml \
 	    gadget.xml libata.xml mtdnand.xml librs.xml rapidio.xml \
-	    genericirq.xml s390-drivers.xml
+	    genericirq.xml s390-drivers.xml kgdb.xml
 
 ###
 # The build process is as follows (targets):
diff -puN arch/i386/kernel/Makefile~git-kgdb-fixup arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~git-kgdb-fixup
+++ a/arch/i386/kernel/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
 obj-$(CONFIG_SMP)		+= smpcommon.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
+obj-$(CONFIG_KGDB)		+= kgdb.o kgdb-jmp.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
diff -puN include/asm-i386/kdebug.h~git-kgdb-fixup include/asm-i386/kdebug.h
--- a/include/asm-i386/kdebug.h~git-kgdb-fixup
+++ a/include/asm-i386/kdebug.h
@@ -22,6 +22,7 @@ enum die_val {
 	DIE_GPF,
 	DIE_CALL,
 	DIE_NMI_IPI,
+	DIE_PAGE_FAULT_NO_CONTEXT,
 };
 
 #endif
diff -puN include/asm-x86_64/kdebug.h~git-kgdb-fixup include/asm-x86_64/kdebug.h
--- a/include/asm-x86_64/kdebug.h~git-kgdb-fixup
+++ a/include/asm-x86_64/kdebug.h
@@ -17,6 +17,7 @@ enum die_val {
 	DIE_GPF,
 	DIE_CALL,
 	DIE_NMI_IPI,
+	DIE_PAGE_FAULT_NO_CONTEXT,
 };
 
 extern void printk_address(unsigned long address);
diff -puN arch/mips/sibyte/bcm1480/irq.c~git-kgdb-fixup arch/mips/sibyte/bcm1480/irq.c
--- a/arch/mips/sibyte/bcm1480/irq.c~git-kgdb-fixup
+++ a/arch/mips/sibyte/bcm1480/irq.c
@@ -57,7 +57,6 @@ static void bcm1480_set_affinity(unsigne
 extern unsigned long ht_eoi_space;
 #endif
 
-<<<<<<< HEAD/arch/mips/sibyte/bcm1480/irq.c
 #ifdef CONFIG_KGDB
 #include <asm/gdb-stub.h>
 extern void breakpoint(void);
@@ -82,8 +81,6 @@ extern char sb1250_duart_present[];
 #endif
 #endif
 
-=======
->>>>>>> /arch/mips/sibyte/bcm1480/irq.c
 static struct irq_chip bcm1480_irq_type = {
 	.name = "BCM1480-IMR",
 	.ack = ack_bcm1480_irq,
@@ -400,7 +397,6 @@ void __init arch_init_irq(void)
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
 
-<<<<<<< HEAD/arch/mips/sibyte/bcm1480/irq.c
 #ifdef CONFIG_KGDB
 	if (kgdb_flag) {
 		kgdb_irq = K_BCM1480_INT_UART_0 + kgdb_port;
@@ -426,8 +422,6 @@ void __init arch_init_irq(void)
 		breakpoint();
 	}
 #endif
-=======
->>>>>>> /arch/mips/sibyte/bcm1480/irq.c
 }
 
 extern void bcm1480_timer_interrupt(void);
diff -puN arch/mips/sibyte/sb1250/irq.c~git-kgdb-fixup arch/mips/sibyte/sb1250/irq.c
--- a/arch/mips/sibyte/sb1250/irq.c~git-kgdb-fixup
+++ a/arch/mips/sibyte/sb1250/irq.c
@@ -57,7 +57,6 @@ static void sb1250_set_affinity(unsigned
 extern unsigned long ldt_eoi_space;
 #endif
 
-<<<<<<< HEAD/arch/mips/sibyte/sb1250/irq.c
 #ifdef CONFIG_KGDB
 static int kgdb_irq;
 
@@ -68,8 +67,6 @@ extern char sb1250_duart_present[];
 #endif
 #endif
 
-=======
->>>>>>> /arch/mips/sibyte/sb1250/irq.c
 static struct irq_chip sb1250_irq_type = {
 	.name = "SB1250-IMR",
 	.ack = ack_sb1250_irq,
@@ -363,7 +360,6 @@ void __init arch_init_irq(void)
 #endif
 	/* Enable necessary IPs, disable the rest */
 	change_c0_status(ST0_IM, imask);
-<<<<<<< HEAD/arch/mips/sibyte/sb1250/irq.c
 
 #ifdef CONFIG_KGDB
 	if (kgdb_flag) {
@@ -384,8 +380,6 @@ void __init arch_init_irq(void)
 		sb1250_unmask_irq(0, kgdb_irq);
 	}
 #endif
-=======
->>>>>>> /arch/mips/sibyte/sb1250/irq.c
 }
 
 extern void sb1250_timer_interrupt(void);
diff -puN arch/mips/tx4927/common/Makefile~git-kgdb-fixup arch/mips/tx4927/common/Makefile
--- a/arch/mips/tx4927/common/Makefile~git-kgdb-fixup
+++ a/arch/mips/tx4927/common/Makefile
@@ -9,9 +9,6 @@
 obj-y	+= tx4927_prom.o tx4927_setup.o tx4927_irq.o
 
 obj-$(CONFIG_TOSHIBA_FPCIB0)	   += smsc_fdc37m81x.o
-<<<<<<< HEAD/arch/mips/tx4927/common/Makefile
 obj-$(CONFIG_KGDB)                 += tx4927_dbgio.o
 
 EXTRA_CFLAGS += -Werror
-=======
->>>>>>> /arch/mips/tx4927/common/Makefile
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-powerpc-fixup.patch
revert-gregkh-driver-block-device.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-netdev-all.patch
e1000e-build-fix.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net.patch
git-net-fixup.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
intel_cacheinfo-misc-section-annotation-fixes-fix.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
hpet-force-enable-on-vt8235-37-chipsets-fix.patch
x86-convert-cpu_sibling_map-to-be-a-per-cpu-variable-broke-ia64.patch
git-xfs.patch
git-xtensa.patch
git-kgdb-fixup.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
remove-bits_to_type-macro-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
