From: akpm@linux-foundation.org
Subject: + drivers-edac-add-cell-xdr-memory-types.patch added to -mm tree
Date: Fri, 19 Oct 2007 14:18:06 -0700
Message-ID: <200710192118.l9JLI6B8020590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54287 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966665AbXJSVSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 17:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com


The patch titled
     drivers-edac: add Cell XDR memory types
has been added to the -mm tree.  Its filename is
     drivers-edac-add-cell-xdr-memory-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: add Cell XDR memory types
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Add the definitions for the Rambus XDR memory type used by the Cell processor.
It's a pre-requisite for the followup Cell EDAC patch.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h     |    2 ++
 drivers/edac/edac_mc_sysfs.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-add-cell-xdr-memory-types drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-add-cell-xdr-memory-types
+++ a/drivers/edac/edac_core.h
@@ -136,6 +136,7 @@ enum mem_type {
 	MEM_DDR2,		/* DDR2 RAM */
 	MEM_FB_DDR2,		/* fully buffered DDR2 */
 	MEM_RDDR2,		/* Registered DDR2 RAM */
+	MEM_XDR,		/* Rambus XDR */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -152,6 +153,7 @@ enum mem_type {
 #define MEM_FLAG_DDR2           BIT(MEM_DDR2)
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
 #define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
+#define MEM_FLAG_XDR            BIT(MEM_XDR)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-add-cell-xdr-memory-types drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-add-cell-xdr-memory-types
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -73,7 +73,8 @@ static const char *mem_types[] = {
 	[MEM_RMBS] = "RMBS",
 	[MEM_DDR2] = "Unbuffered-DDR2",
 	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
-	[MEM_RDDR2] = "Registered-DDR2"
+	[MEM_RDDR2] = "Registered-DDR2",
+	[MEM_XDR] = "XDR"
 };
 
 static const char *dev_types[] = {
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
remove-unused-flush_tlb_pgtables.patch
define-global-bit-macro.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-ppc64.patch
add-documentation-for-extended-crashkernel-syntax.patch
git-x86.patch
intel-iommu-fix-for-iommu-early-crash-2.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
