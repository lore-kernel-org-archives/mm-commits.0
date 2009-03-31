From: akpm@linux-foundation.org
Subject: [folded] fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch removed from -mm tree
Date: Tue, 31 Mar 2009 15:10:41 -0700
Message-ID: <200903312210.n2VMAfjX018484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758577AbZCaWNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Mar 2009 18:13:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kristoffer.ericson@gmail.com, krzysztof.h1@poczta.fm, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids fix
has been removed from the -mm tree.  Its filename was
     fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch

This patch was dropped because it was folded into fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids fix
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>

Update the s1d13xxxfb.h file to reflect the recent changes to the driver.

Signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/video/s1d13xxxfb.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN include/video/s1d13xxxfb.h~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix include/video/s1d13xxxfb.h
--- a/include/video/s1d13xxxfb.h~fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix
+++ a/include/video/s1d13xxxfb.h
@@ -14,13 +14,16 @@
 #define	S1D13XXXFB_H
 
 #define S1D_PALETTE_SIZE		256
-#define S1D13506_CHIP_REV		4	/* expected chip revision number for s1d13506 */
-#define S1D13806_CHIP_REV		7	/* expected chip revision number for s1d13806 */
-#define S1D_FBID			"S1D13806"
-#define S1D_DEVICENAME			"s1d13806fb"
+#define S1D_FBID			"S1D13xxx"
+#define S1D_DEVICENAME			"s1d13xxxfb"
+
+/* S1DREG_REV_CODE register = prod_id (6 bits) + revision (2 bits) */
+#define S1D13505_PROD_ID		0x3	/* 000011 */
+#define S1D13506_PROD_ID		0x4	/* 000100 */
+#define S1D13806_PROD_ID		0x7	/* 000111 */
 
 /* register definitions (tested on s1d13896) */
-#define S1DREG_REV_CODE			0x0000	/* Revision Code Register */
+#define S1DREG_REV_CODE			0x0000	/* Prod + Rev Code Register */
 #define S1DREG_MISC			0x0001	/* Miscellaneous Register */
 #define S1DREG_GPIO_CNF0		0x0004	/* General IO Pins Configuration Register 0 */
 #define S1DREG_GPIO_CNF1		0x0005	/* General IO Pins Configuration Register 1 */
@@ -141,10 +144,11 @@ struct s1d13xxxfb_regval {
 	u8	value;
 };
 
