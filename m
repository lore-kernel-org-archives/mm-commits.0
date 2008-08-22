From: akpm@linux-foundation.org
Subject: - calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch removed from -mm tree
Date: Fri, 22 Aug 2008 15:55:48 -0700
Message-ID: <200808222255.m7MMtmZh020849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbYHVW5W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 18:57:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mingo@elte.hu, muli@il.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     calgary: fix a comparison warning the PCI Calgary 64 driver
has been removed from the -mm tree.  Its filename was
     calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: calgary: fix a comparison warning the PCI Calgary 64 driver
From: David Howells <dhowells@redhat.com>

Fix an integer comparison always false warning in the PCI Calgary 64 driver.

A u8 is being compared to something that's 512 by default, resulting in the
following warning:

arch/x86/kernel/pci-calgary_64.c:1285: warning: comparison is always false due to limited range of data type

This was introduced by patch b34e90b8f0f30151349134f87b5dc6ef75a5218c.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/pci-calgary_64.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN arch/x86/kernel/pci-calgary_64.c~calgary-fix-a-comparison-warning-the-pci-calgary-64-driver arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~calgary-fix-a-comparison-warning-the-pci-calgary-64-driver
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -1269,13 +1269,15 @@ static inline int __init determine_tce_t
 static int __init build_detail_arrays(void)
 {
 	unsigned long ptr;
-	int i, scal_detail_size, rio_detail_size;
+	unsigned numnodes, i;
+	int scal_detail_size, rio_detail_size;
 
-	if (rio_table_hdr->num_scal_dev > MAX_NUMNODES){
+	numnodes = rio_table_hdr->num_scal_dev;
+	if (numnodes > MAX_NUMNODES){
 		printk(KERN_WARNING
 			"Calgary: MAX_NUMNODES too low! Defined as %d, "
 			"but system has %d nodes.\n",
-			MAX_NUMNODES, rio_table_hdr->num_scal_dev);
+			MAX_NUMNODES, numnodes);
 		return -ENODEV;
 	}
 
@@ -1296,8 +1298,7 @@ static int __init build_detail_arrays(vo
 	}
 
 	ptr = ((unsigned long)rio_table_hdr) + 3;
-	for (i = 0; i < rio_table_hdr->num_scal_dev;
-		    i++, ptr += scal_detail_size)
+	for (i = 0; i < numnodes; i++, ptr += scal_detail_size)
 		scal_devs[i] = (struct scal_detail *)ptr;
 
 	for (i = 0; i < rio_table_hdr->num_rio_dev;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
cifs-fix-range-check.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
binfmt_elf_fdpic-support-auxvec-base-platform-string.patch
binfmt_elf_fdpic-convert-initial-stack-alignment-to-arch_align_stack.patch
binfmt_elf_fdpic-wire-up-at_execfd-at_execfn-at_secure.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mn10300-use-bcd2bin-bin2bcd.patch
mutex-subsystem-synchro-test-module.patch

