From: akpm@linux-foundation.org
Subject: - fs-partitions-efi-convert-to-pr_debug.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:02:03 -0700
Message-ID: <200807252302.m6PN23iW003772@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbYGYXCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:02:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, Matt_Domsch@dell.com, mm-commits@vger.kernel.org


The patch titled
     fs/partitions/efi: convert to pr_debug
has been removed from the -mm tree.  Its filename was
     fs-partitions-efi-convert-to-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/partitions/efi: convert to pr_debug
From: Thomas Gleixner <tglx@linutronix.de>

convert the local Dprintk() compile time debug printk wrappers to the
generic pr_debug() wrapper.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/partitions/efi.c |   42 +++++++++++++++++-------------------------
 1 file changed, 17 insertions(+), 25 deletions(-)

diff -puN fs/partitions/efi.c~fs-partitions-efi-convert-to-pr_debug fs/partitions/efi.c
--- a/fs/partitions/efi.c~fs-partitions-efi-convert-to-pr_debug
+++ a/fs/partitions/efi.c
@@ -95,13 +95,6 @@
 #include "check.h"
 #include "efi.h"
 
-#undef EFI_DEBUG
-#ifdef EFI_DEBUG
-#define Dprintk(x...) printk(KERN_DEBUG x)
-#else
-#define Dprintk(x...)
-#endif
-
 /* This allows a kernel command line option 'gpt' to override
  * the test for invalid PMBR.  Not __initdata because reloading
  * the partition tables happens after init too.
@@ -305,10 +298,10 @@ is_gpt_valid(struct block_device *bdev, 
 
 	/* Check the GUID Partition Table signature */
 	if (le64_to_cpu((*gpt)->signature) != GPT_HEADER_SIGNATURE) {
-		Dprintk("GUID Partition Table Header signature is wrong:"
-			"%lld != %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->signature),
-			(unsigned long long)GPT_HEADER_SIGNATURE);
+		pr_debug("GUID Partition Table Header signature is wrong:"
+			 "%lld != %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->signature),
+			 (unsigned long long)GPT_HEADER_SIGNATURE);
 		goto fail;
 	}
 
@@ -318,9 +311,8 @@ is_gpt_valid(struct block_device *bdev, 
 	crc = efi_crc32((const unsigned char *) (*gpt), le32_to_cpu((*gpt)->header_size));
 
 	if (crc != origcrc) {
-		Dprintk
-		    ("GUID Partition Table Header CRC is wrong: %x != %x\n",
-		     crc, origcrc);
+		pr_debug("GUID Partition Table Header CRC is wrong: %x != %x\n",
+			 crc, origcrc);
 		goto fail;
 	}
 	(*gpt)->header_crc32 = cpu_to_le32(origcrc);
@@ -328,9 +320,9 @@ is_gpt_valid(struct block_device *bdev, 
 	/* Check that the my_lba entry points to the LBA that contains
 	 * the GUID Partition Table */
 	if (le64_to_cpu((*gpt)->my_lba) != lba) {
-		Dprintk("GPT my_lba incorrect: %lld != %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->my_lba),
-			(unsigned long long)lba);
+		pr_debug("GPT my_lba incorrect: %lld != %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->my_lba),
+			 (unsigned long long)lba);
 		goto fail;
 	}
 
@@ -339,15 +331,15 @@ is_gpt_valid(struct block_device *bdev, 
 	 */
 	lastlba = last_lba(bdev);
 	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
-		Dprintk("GPT: first_usable_lba incorrect: %lld > %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
-			(unsigned long long)lastlba);
+		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
+			 (unsigned long long)lastlba);
 		goto fail;
 	}
 	if (le64_to_cpu((*gpt)->last_usable_lba) > lastlba) {
-		Dprintk("GPT: last_usable_lba incorrect: %lld > %lld\n",
-			(unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
-			(unsigned long long)lastlba);
+		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
+			 (unsigned long long)lastlba);
 		goto fail;
 	}
 
@@ -360,7 +352,7 @@ is_gpt_valid(struct block_device *bdev, 
 			le32_to_cpu((*gpt)->sizeof_partition_entry));
 
 	if (crc != le32_to_cpu((*gpt)->partition_entry_array_crc32)) {
-		Dprintk("GUID Partitition Entry Array CRC check failed.\n");
+		pr_debug("GUID Partitition Entry Array CRC check failed.\n");
 		goto fail_ptes;
 	}
 
@@ -616,7 +608,7 @@ efi_partition(struct parsed_partitions *
 		return 0;
 	}
 
-	Dprintk("GUID Partition Table is valid!  Yea!\n");
+	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
 		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
linux-next.patch
x86-pci-replace-dbg-with-pr_debug.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
ntp-let-update_persistent_clock-sleep.patch
migrate_timers-add-comment-use-spinlock_irq.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
timekeeping-fix-rounding-problem-during-clock-update.patch
aes-x86_64-asm-implementation-optimization.patch
ntp-fix-calculation-of-the-next-jiffie-to-trigger-rtc-sync.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-bnx2x.patch
dma-mapping-x86-per-device-dma_mapping_ops-support.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix.patch
dma-mapping-x86-per-device-dma_mapping_ops-support-fix-2.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-infiniband.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-more-sparc.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error-ibmvscsi.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary-checkpatch-fixes.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
use-warn-in-kernel-irq-managec.patch

