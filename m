From: akpm@linux-foundation.org
Subject: + ibft-for-uefi-machines-actually-do-scan-acpi-for-ibft.patch added to -mm tree
Date: Wed, 21 Apr 2010 14:29:39 -0700
Message-ID: <201004212129.o3LLTdaF010488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756193Ab0DUVav (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 17:30:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad@kernel.org, James.Bottomley@HansenPartnership.com, greg@kroah.com, michaelc@cs.wisc.edu, pjones@redhat.com


The patch titled
     ibft: for UEFI machines actually do scan ACPI for iBFT
has been added to the -mm tree.  Its filename is
     ibft-for-uefi-machines-actually-do-scan-acpi-for-ibft.patch

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
Subject: ibft: for UEFI machines actually do scan ACPI for iBFT
From: Konrad Rzeszutek Wilk <konrad@kernel.org>

For machines with IBFT 1.03 do scan the ACPI table for 'iBFT' or for
'IBFT'.  If the machine is in UEFI mode, only do the ACPI table scan.  For
all other machines (pre IBFT 1.03) do a memory scan if not found in the
ACPI tables.

Acked-by: Peter Jones <pjones@redhat.com>
Tested-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/iscsi_ibft_find.c |   31 ++++++++++++++++-----------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff -puN drivers/firmware/iscsi_ibft_find.c~ibft-for-uefi-machines-actually-do-scan-acpi-for-ibft drivers/firmware/iscsi_ibft_find.c
--- a/drivers/firmware/iscsi_ibft_find.c~ibft-for-uefi-machines-actually-do-scan-acpi-for-ibft
+++ a/drivers/firmware/iscsi_ibft_find.c
@@ -56,23 +56,12 @@ static int __init acpi_find_ibft(struct 
 }
 #endif /* CONFIG_ACPI */
 
-/*
- * Routine used to find the iSCSI Boot Format Table. The logical
- * kernel address is set in the ibft_addr global variable.
- */
-unsigned long __init find_ibft_region(unsigned long *sizep)
+static int __init find_ibft_mem_scan(void)
 {
 	unsigned long pos;
 	unsigned int len = 0;
 	void *virt;
 
-	ibft_addr = NULL;
-
-	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
-	 * only use ACPI for this */
-	if (efi_enabled)
-		return 0;
-
 	for (pos = IBFT_START; pos < IBFT_END; pos += 16) {
 		/* The table can't be inside the VGA BIOS reserved space,
 		 * so skip that area */
@@ -91,6 +80,17 @@ unsigned long __init find_ibft_region(un
 			}
 		}
 	}
+	return len;
+}
+/*
+ * Routine used to find the iSCSI Boot Format Table. The logical
+ * kernel address is set in the ibft_addr global variable.
+ */
+unsigned long __init find_ibft_region(unsigned long *sizep)
+{
+
+	ibft_addr = NULL;
+
 #ifdef CONFIG_ACPI
 	/*
 	 * One spec says "IBFT", the other says "iBFT". We have to check
@@ -101,6 +101,13 @@ unsigned long __init find_ibft_region(un
 	if (!ibft_addr)
 		acpi_table_parse("iBFT", acpi_find_ibft);
 #endif /* CONFIG_ACPI */
+
+	/* iBFT 1.03 section 1.4.3.1 mandates that UEFI machines will
+	 * only use ACPI for this */
+
+	if (!ibft_addr && !efi_enabled)
+		find_ibft_mem_scan();
+
 	if (ibft_addr) {
 		*sizep = PAGE_ALIGN(ibft_addr->header.length);
 		return (u64)isa_virt_to_bus(ibft_addr);
_

Patches currently in -mm which might be from konrad@kernel.org are

linux-next.patch
ibft-update-ibft-handling-for-v103-of-the-spec.patch
ibft-for-uefi-machines-actually-do-scan-acpi-for-ibft.patch

