From: akpm@linux-foundation.org
Subject: - intel-iommu-fault_reason_index_cleanuppatch.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:18 -0800
Message-ID: <200802082011.m18KBxZd010158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40464 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755313AbYBHVDI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:03:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgross@linux.intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     intel-iommu: fault_reason index cleanup
has been removed from the -mm tree.  Its filename was
     intel-iommu-fault_reason_index_cleanuppatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: intel-iommu: fault_reason index cleanup
From: mark gross <mgross@linux.intel.com>

Fix an off by one bug in the fault reason string reporting function, and
clean up some of the code around this buglet.

[akpm@linux-foundation.org: cleanup]
Signed-off-by: mark gross <mgross@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   11 +++++------
 include/linux/dmar.h      |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-fault_reason_index_cleanuppatch drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-fault_reason_index_cleanuppatch
+++ a/drivers/pci/intel-iommu.c
@@ -745,7 +745,7 @@ static int iommu_disable_translation(str
 
 /* iommu interrupt handling. Most stuff are MSI-like. */
 
-static char *fault_reason_strings[] =
+static const char *fault_reason_strings[] =
 {
 	"Software",
 	"Present bit in root entry is clear",
@@ -760,14 +760,13 @@ static char *fault_reason_strings[] =
 	"non-zero reserved fields in RTP",
 	"non-zero reserved fields in CTP",
 	"non-zero reserved fields in PTE",
-	"Unknown"
 };
 #define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
 
-char *dmar_get_fault_reason(u8 fault_reason)
+const char *dmar_get_fault_reason(u8 fault_reason)
 {
-	if (fault_reason >= MAX_FAULT_REASON_IDX)
-		return fault_reason_strings[MAX_FAULT_REASON_IDX - 1];
+	if (fault_reason > MAX_FAULT_REASON_IDX)
+		return "Unknown";
 	else
 		return fault_reason_strings[fault_reason];
 }
@@ -825,7 +824,7 @@ void dmar_msi_read(int irq, struct msi_m
 static int iommu_page_fault_do_one(struct intel_iommu *iommu, int type,
 		u8 fault_reason, u16 source_id, u64 addr)
 {
-	char *reason;
+	const char *reason;
 
 	reason = dmar_get_fault_reason(fault_reason);
 
diff -puN include/linux/dmar.h~intel-iommu-fault_reason_index_cleanuppatch include/linux/dmar.h
--- a/include/linux/dmar.h~intel-iommu-fault_reason_index_cleanuppatch
+++ a/include/linux/dmar.h
@@ -28,7 +28,7 @@
 #ifdef CONFIG_DMAR
 struct intel_iommu;
 
-extern char *dmar_get_fault_reason(u8 fault_reason);
+extern const char *dmar_get_fault_reason(u8 fault_reason);
 
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
