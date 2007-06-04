From: akpm@linux-foundation.org
Subject: + x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch added to -mm tree
Date: Mon, 04 Jun 2007 11:53:48 -0700
Message-ID: <200706041853.l54IrmLb010903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52275 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757471AbXFDSyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 14:54:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: muli@il.ibm.com, ak@suse.de


The patch titled
     x86-64: Calgary: generalize calgary_increase_split_completion_timeout
has been added to the -mm tree.  Its filename is
     x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86-64: Calgary: generalize calgary_increase_split_completion_timeout
From: Muli Ben-Yehuda <muli@il.ibm.com>

... will be used by CalIOC2 later

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-generalize-calgary_increase_split_completion_timeout arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-generalize-calgary_increase_split_completion_timeout
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -775,8 +775,8 @@ static void calgary_watchdog(unsigned lo
 	}
 }
 
-static void __init calgary_increase_split_completion_timeout(void __iomem *bbar,
-	unsigned char busnum)
+static void __init calgary_set_split_completion_timeout(void __iomem *bbar,
+	unsigned char busnum, unsigned long timeout)
 {
 	u64 val64;
 	void __iomem *target;
@@ -802,7 +802,7 @@ static void __init calgary_increase_spli
 	/* zero out this PHB's timer bits */
 	mask = ~(0xFUL << phb_shift);
 	val64 &= mask;
-	val64 |= (CCR_2SEC_TIMEOUT << phb_shift);
+	val64 |= (timeout << phb_shift);
 	writeq(cpu_to_be64(val64), target);
 	readq(target); /* flush */
 }
@@ -836,7 +836,8 @@ static void __init calgary_enable_transl
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=7180
 	 */
 	if (busnum == 1)
-		calgary_increase_split_completion_timeout(bbar, busnum);
+		calgary_set_split_completion_timeout(bbar, busnum,
+						     CCR_2SEC_TIMEOUT);
 
 	init_timer(&tbl->watchdog_timer);
 	tbl->watchdog_timer.function = &calgary_watchdog;
_

Patches currently in -mm which might be from muli@il.ibm.com are

x86-64-calgary-generalize-calgary_increase_split_completion_timeout.patch
x86-64-calgary-update-copyright-notice.patch
x86-64-calgary-introduce-handle_quirks-for-various-chipset-quirks.patch
x86-64-calgary-introduce-chipset-specific-ops.patch
x86-64-calgary-introduce-chipset-specific-ops-fix.patch
x86-64-calgary-abstract-how-we-find-the-iommu_table-for-a-device.patch
x86-64-calgary-introduce-calioc2-support.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2.patch
x86-64-calgary-add-chip_ops-and-a-quirk-function-for-calioc2-fix.patch
x86-64-calgary-implement-calioc2-tce-cache-flush-sequence.patch
x86-64-calgary-make-dump_error_regs-a-chip-op.patch
x86-64-calgary-grab-plssr-too-when-a-dma-error-occurs.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch
x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions-fix.patch
x86-64-calgary-cleanup-of-unneeded-macros.patch
x86-64-calgary-tabify-and-trim-trailing-whitespace.patch
x86-64-calgary-only-reserve-the-first-1mb-of-io-space-for-calioc2.patch
x86-64-calgary-tidy-up-debug-printks.patch
oss-trident-massive-whitespace-removal.patch
oss-trident-fix-locking-around-write_voice_regs.patch
oss-trident-replace-deprecated-pci_find_device-with-pci_get_device.patch
