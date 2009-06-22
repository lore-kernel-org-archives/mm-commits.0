From: akpm@linux-foundation.org
Subject: + edac-add-ddr3-memory-type-for-mpc85xx-edac.patch added to -mm tree
Date: Mon, 22 Jun 2009 12:32:32 -0700
Message-ID: <200906221932.n5MJWWjx008479@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbZFVTct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 15:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yang.shi@windriver.com, norsk5@yahoo.com


The patch titled
     edac: add DDR3 memory type for MPC85xx EDAC
has been added to the -mm tree.  Its filename is
     edac-add-ddr3-memory-type-for-mpc85xx-edac.patch

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
Subject: edac: add DDR3 memory type for MPC85xx EDAC
From: Yang Shi <yang.shi@windriver.com>

Since some new MPC85xx SOCs support DDR3 memory now, so add DDR3 memory
type for MPC85xx EDAC.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h     |    4 ++++
 drivers/edac/edac_mc_sysfs.c |    4 +++-
 drivers/edac/mpc85xx_edac.c  |    6 ++++++
 drivers/edac/mpc85xx_edac.h  |    1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_core.h~edac-add-ddr3-memory-type-for-mpc85xx-edac drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~edac-add-ddr3-memory-type-for-mpc85xx-edac
+++ a/drivers/edac/edac_core.h
@@ -150,6 +150,8 @@ enum mem_type {
 	MEM_FB_DDR2,		/* fully buffered DDR2 */
 	MEM_RDDR2,		/* Registered DDR2 RAM */
 	MEM_XDR,		/* Rambus XDR */
+	MEM_DDR3,		/* DDR3 RAM */
+	MEM_RDDR3,		/* Registered DDR3 RAM */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -167,6 +169,8 @@ enum mem_type {
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
 #define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
 #define MEM_FLAG_XDR            BIT(MEM_XDR)
+#define MEM_FLAG_DDR3		 BIT(MEM_DDR3)
+#define MEM_FLAG_RDDR3		 BIT(MEM_RDDR3)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
diff -puN drivers/edac/edac_mc_sysfs.c~edac-add-ddr3-memory-type-for-mpc85xx-edac drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~edac-add-ddr3-memory-type-for-mpc85xx-edac
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -94,7 +94,9 @@ static const char *mem_types[] = {
 	[MEM_DDR2] = "Unbuffered-DDR2",
 	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
 	[MEM_RDDR2] = "Registered-DDR2",
-	[MEM_XDR] = "XDR"
+	[MEM_XDR] = "XDR",
+	[MEM_DDR3] = "Unbuffered-DDR3",
+	[MEM_RDDR3] = "Registered-DDR3"
 };
 
 static const char *dev_types[] = {
diff -puN drivers/edac/mpc85xx_edac.c~edac-add-ddr3-memory-type-for-mpc85xx-edac drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-add-ddr3-memory-type-for-mpc85xx-edac
+++ a/drivers/edac/mpc85xx_edac.c
@@ -757,6 +757,9 @@ static void __devinit mpc85xx_init_csrow
 		case DSC_SDTYPE_DDR2:
 			mtype = MEM_RDDR2;
 			break;
+		case DSC_SDTYPE_DDR3:
+			mtype = MEM_RDDR3;
+			break;
 		default:
 			mtype = MEM_UNKNOWN;
 			break;
@@ -769,6 +772,9 @@ static void __devinit mpc85xx_init_csrow
 		case DSC_SDTYPE_DDR2:
 			mtype = MEM_DDR2;
 			break;
+		case DSC_SDTYPE_DDR3:
+			mtype = MEM_DDR3;
+			break;
 		default:
 			mtype = MEM_UNKNOWN;
 			break;
diff -puN drivers/edac/mpc85xx_edac.h~edac-add-ddr3-memory-type-for-mpc85xx-edac drivers/edac/mpc85xx_edac.h
--- a/drivers/edac/mpc85xx_edac.h~edac-add-ddr3-memory-type-for-mpc85xx-edac
+++ a/drivers/edac/mpc85xx_edac.h
@@ -53,6 +53,7 @@
 
 #define DSC_SDTYPE_DDR		0x02000000
 #define DSC_SDTYPE_DDR2		0x03000000
+#define DSC_SDTYPE_DDR3		0x07000000
 #define DSC_X32_EN	0x00000020
 
 /* Err_Int_En */
_

Patches currently in -mm which might be from yang.shi@windriver.com are

edac-add-ddr3-memory-type-for-mpc85xx-edac.patch

