From: akpm@linux-foundation.org
Subject: - more-sanity-checks-for-dmar.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:59 -0800
Message-ID: <200711272033.lARKXxik029012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35876 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756329AbXK0UhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:37:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fenghua.yu@intel.com, greg@kroah.com, mgross@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     More Sanity checks for DMAR
has been removed from the -mm tree.  Its filename was
     more-sanity-checks-for-dmar.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: More Sanity checks for DMAR
From: Fenghua Yu <fenghua.yu@intel.com>

Add and changes a few sanity checks in dmar.c.

1.  The haw field in ACPI DMAR table in VT-d spec doesn't describe the
   range of haw.  But since DMA page size is 4KB in DMA remapping, haw
   should be at least 4KB.  The current VT-d code in dmar.c returns failure
   when haw==0.  This sanity check is not accurate and execution can pass
   when haw is less than one page size 4KB.  This patch changes the haw
   sanity check to validate if haw is less than 4KB.

2. Add dmar_rmrr_units verification.

3. Add parse_dmar_table() verification.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Cc: Greg KH <greg@kroah.com>
Acked-by: mark gross <mgross@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/dmar.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff -puN drivers/pci/dmar.c~more-sanity-checks-for-dmar drivers/pci/dmar.c
--- a/drivers/pci/dmar.c~more-sanity-checks-for-dmar
+++ a/drivers/pci/dmar.c
@@ -25,6 +25,7 @@
 
 #include <linux/pci.h>
 #include <linux/dmar.h>
+#include "iova.h"
 
 #undef PREFIX
 #define PREFIX "DMAR:"
@@ -263,8 +264,8 @@ parse_dmar_table(void)
 	if (!dmar)
 		return -ENODEV;
 
-	if (!dmar->width) {
-		printk (KERN_WARNING PREFIX "Zero: Invalid DMAR haw\n");
+	if (dmar->width < PAGE_SHIFT_4K - 1) {
+		printk(KERN_WARNING PREFIX "Invalid DMAR haw\n");
 		return -EINVAL;
 	}
 
@@ -301,11 +302,24 @@ parse_dmar_table(void)
 int __init dmar_table_init(void)
 {
 
-	parse_dmar_table();
+	int ret;
+
+	ret = parse_dmar_table();
+	if (ret) {
+		printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
+		return ret;
+	}
+
 	if (list_empty(&dmar_drhd_units)) {
 		printk(KERN_INFO PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
+
+	if (list_empty(&dmar_rmrr_units)) {
+		printk(KERN_INFO PREFIX "No RMRR found\n");
+		return -ENODEV;
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from fenghua.yu@intel.com are

git-cpufreq.patch
