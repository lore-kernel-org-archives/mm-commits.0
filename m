From: akpm@linux-foundation.org
Subject: + drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch added to -mm tree
Date: Thu, 14 Oct 2010 15:22:38 -0700
Message-ID: <201010142222.o9EMMcrU022858@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755255Ab0JNWWm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Oct 2010 18:22:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.hennerich@analog.com, chrisv@cyberswitching.com, vapier@gentoo.org


The patch titled
     drivers/misc/ad525x_dpot.c: fix part name typos in defines
has been added to the -mm tree.  Its filename is
     drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch

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
Subject: drivers/misc/ad525x_dpot.c: fix part name typos in defines
From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Chris Verges <chrisv@cyberswitching.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ad525x_dpot.c |   10 +++++-----
 drivers/misc/ad525x_dpot.h |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/misc/ad525x_dpot.c~drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines drivers/misc/ad525x_dpot.c
--- a/drivers/misc/ad525x_dpot.c~drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines
+++ a/drivers/misc/ad525x_dpot.c
@@ -166,7 +166,7 @@ static s32 dpot_read_i2c(struct dpot_dat
 	case DPOT_UID(AD5280_ID):
 	case DPOT_UID(AD5282_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5291_RDAC_AB;
+			0 : DPOT_AD5282_RDAC_AB;
 		return dpot_read_r8d8(dpot, ctrl);
 	case DPOT_UID(AD5170_ID):
 	case DPOT_UID(AD5171_ID):
@@ -175,7 +175,7 @@ static s32 dpot_read_i2c(struct dpot_dat
 	case DPOT_UID(AD5172_ID):
 	case DPOT_UID(AD5173_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5272_3_A0;
+			0 : DPOT_AD5172_3_A0;
 		return dpot_read_r8d8(dpot, ctrl);
 	default:
 		if ((reg & DPOT_REG_TOL) || (dpot->max_pos > 256))
@@ -273,7 +273,7 @@ static s32 dpot_write_i2c(struct dpot_da
 	case DPOT_UID(AD5280_ID):
 	case DPOT_UID(AD5282_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5291_RDAC_AB;
+			0 : DPOT_AD5282_RDAC_AB;
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
 	case DPOT_UID(AD5171_ID):
@@ -289,12 +289,12 @@ static s32 dpot_write_i2c(struct dpot_da
 	case DPOT_UID(AD5172_ID):
 	case DPOT_UID(AD5173_ID):
 		ctrl = ((reg & DPOT_RDAC_MASK) == DPOT_RDAC0) ?
-			0 : DPOT_AD5272_3_A0;
+			0 : DPOT_AD5172_3_A0;
 		if (reg & DPOT_ADDR_OTP) {
 			tmp = dpot_read_r8d16(dpot, ctrl);
 			if (tmp >> 14) /* Ready to Program? */
 				return -EFAULT;
-			ctrl |= DPOT_AD5270_2_3_FUSE;
+			ctrl |= DPOT_AD5170_2_3_FUSE;
 		}
 		return dpot_write_r8d8(dpot, ctrl, value);
 		break;
diff -puN drivers/misc/ad525x_dpot.h~drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines drivers/misc/ad525x_dpot.h
--- a/drivers/misc/ad525x_dpot.h~drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines
+++ a/drivers/misc/ad525x_dpot.h
@@ -166,14 +166,14 @@ enum dpot_devid {
 #define DPOT_AD5291_RDAC	0x01
 #define DPOT_AD5291_READ_RDAC	0x02
 
-/* AD524x use special commands */
 #define DPOT_AD5291_RDAC_AB	0x80
 
+#define DPOT_AD5282_RDAC_AB	0x80
 #define DPOT_AD5273_FUSE	0x80
-#define DPOT_AD5270_2_3_FUSE	0x20
-#define DPOT_AD5270_2_3_OW	0x08
-#define DPOT_AD5272_3_A0	0x08
-#define DPOT_AD5270_2FUSE	0x80
+#define DPOT_AD5170_2_3_FUSE	0x20
+#define DPOT_AD5170_2_3_OW	0x08
+#define DPOT_AD5172_3_A0	0x08
+#define DPOT_AD5170_2FUSE	0x80
 
 struct dpot_data;
 
_

Patches currently in -mm which might be from michael.hennerich@analog.com are

linux-next.patch
drivers-misc-ad525x_dpot-fix-typo-in-spi-write16-and-write24-transfer-counts.patch
drivers-misc-ad525x_dpot-fix-part-name-typos-in-defines.patch
drivers-misc-ad525x_dpot-new-features.patch
misc-devices-do-not-enable-by-default.patch

