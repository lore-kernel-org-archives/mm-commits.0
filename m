From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Sun, 17 May 2009 09:30:53 -0700
Message-ID: <200905171630.n4HGUrmM001451@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbZEQQax (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:30:53 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n4HGUrNQ010263
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 17 May 2009 09:30:54 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/sibyte/bcm1480/irq.c |    5 -----
 arch/mips/sibyte/sb1250/irq.c  |    5 -----
 drivers/acpi/processor_idle.c  |    9 ---------
 3 files changed, 19 deletions(-)

diff -puN arch/mips/sibyte/bcm1480/irq.c~linux-next-git-rejects arch/mips/sibyte/bcm1480/irq.c
--- a/arch/mips/sibyte/bcm1480/irq.c~linux-next-git-rejects
+++ a/arch/mips/sibyte/bcm1480/irq.c
@@ -151,14 +151,9 @@ static int bcm1480_set_affinity(unsigned
 			____raw_writeq(cur_ints, IOADDR(A_BCM1480_IMR_MAPPER(cpu) + R_BCM1480_IMR_INTERRUPT_MASK_H + (k*BCM1480_IMR_HL_SPACING)));
 		}
 	}
-<<<<<<< HEAD:arch/mips/sibyte/bcm1480/irq.c
 	spin_unlock_irqrestore(&bcm1480_imr_lock, flags);
-=======
-	spin_unlock(&bcm1480_imr_lock);
-	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
->>>>>>> FETCH_HEAD:arch/mips/sibyte/bcm1480/irq.c
 }
 #endif
 
diff -puN arch/mips/sibyte/sb1250/irq.c~linux-next-git-rejects arch/mips/sibyte/sb1250/irq.c
--- a/arch/mips/sibyte/sb1250/irq.c~linux-next-git-rejects
+++ a/arch/mips/sibyte/sb1250/irq.c
@@ -142,14 +142,9 @@ static int sb1250_set_affinity(unsigned 
 		____raw_writeq(cur_ints, IOADDR(A_IMR_MAPPER(cpu) +
 					R_IMR_INTERRUPT_MASK));
 	}
-<<<<<<< HEAD:arch/mips/sibyte/sb1250/irq.c
 	spin_unlock_irqrestore(&sb1250_imr_lock, flags);
-=======
-	spin_unlock(&sb1250_imr_lock);
-	spin_unlock_irqrestore(&desc->lock, flags);
 
 	return 0;
->>>>>>> FETCH_HEAD:arch/mips/sibyte/sb1250/irq.c
 }
 #endif
 
diff -puN drivers/acpi/processor_idle.c~linux-next-git-rejects drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~linux-next-git-rejects
+++ a/drivers/acpi/processor_idle.c
@@ -207,27 +207,18 @@ static u32 saved_bm_rld;
 static void acpi_idle_bm_rld_save(void)
 {
 	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_RLD, &saved_bm_rld);
-<<<<<<< HEAD:drivers/acpi/processor_idle.c
-=======
 	printk(KERN_NOTICE PREFIX "saved: BM_RLD %u\n", saved_bm_rld);
->>>>>>> FETCH_HEAD:drivers/acpi/processor_idle.c
 }
 static void acpi_idle_bm_rld_restore(void)
 {
 	u32 resumed_bm_rld;
 
 	acpi_read_bit_register(ACPI_BITREG_BUS_MASTER_RLD, &resumed_bm_rld);
-<<<<<<< HEAD:drivers/acpi/processor_idle.c
-
-	if (resumed_bm_rld != saved_bm_rld)
-		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_RLD, saved_bm_rld);
-=======
 	printk(KERN_NOTICE PREFIX "resumed: BM_RLD %u\n", resumed_bm_rld);
 	if (resumed_bm_rld != saved_bm_rld) {
 		printk(KERN_WARNING PREFIX "restored BM_RLD %u\n", saved_bm_rld);
 		acpi_write_bit_register(ACPI_BITREG_BUS_MASTER_RLD, saved_bm_rld);
 	}
->>>>>>> FETCH_HEAD:drivers/acpi/processor_idle.c
 }
 
 int acpi_processor_suspend(struct acpi_device * device, pm_message_t state)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
splice-fix-error-return-code.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read.patch
input-keyboard-introduce-lm8323-driver.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
mtd-flex-onenand-support.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
drivers-usb-serial-sierrac-fix-printk-warning.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
revert-fbdev-uninline-lock_fb_info.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
videobuf-dma-contig-zero-copy-userptr-support-v3-comments-checkpatch-fixes.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
remove-put_cpu_no_resched-fix.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

