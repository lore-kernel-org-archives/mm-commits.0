From: akpm@osdl.org
Subject: + use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch added to -mm tree
Date: Sun, 28 Jan 2007 15:45:53 -0800
Message-ID: <200701282345.l0SNjrkM006260@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42238 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008AbXA1XqB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 18:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, Markus.Lidel@shadowconnect.com


The patch titled
     use __u8/__u32 in userspace ioctl defines for I2O
has been added to the -mm tree.  Its filename is
     use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use __u8/__u32 in userspace ioctl defines for I2O
From: Mike Frysinger <vapier@gentoo.org>

Make sure exported I2O ioctls utilize userspace safe types.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/i2o-dev.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN include/linux/i2o-dev.h~use-__u8-__u32-in-userspace-ioctl-defines-for-i2o include/linux/i2o-dev.h
--- a/include/linux/i2o-dev.h~use-__u8-__u32-in-userspace-ioctl-defines-for-i2o
+++ a/include/linux/i2o-dev.h
@@ -24,12 +24,13 @@
 #define MAX_I2O_CONTROLLERS	32
 
 #include <linux/ioctl.h>
+#include <linux/types.h>
 
 /*
  * I2O Control IOCTLs and structures
  */
 #define I2O_MAGIC_NUMBER	'i'
-#define I2OGETIOPS		_IOR(I2O_MAGIC_NUMBER,0,u8[MAX_I2O_CONTROLLERS])
+#define I2OGETIOPS		_IOR(I2O_MAGIC_NUMBER,0,__u8[MAX_I2O_CONTROLLERS])
 #define I2OHRTGET		_IOWR(I2O_MAGIC_NUMBER,1,struct i2o_cmd_hrtlct)
 #define I2OLCTGET		_IOWR(I2O_MAGIC_NUMBER,2,struct i2o_cmd_hrtlct)
 #define I2OPARMSET		_IOWR(I2O_MAGIC_NUMBER,3,struct i2o_cmd_psetget)
@@ -37,7 +38,7 @@
 #define I2OSWDL 		_IOWR(I2O_MAGIC_NUMBER,5,struct i2o_sw_xfer)
 #define I2OSWUL 		_IOWR(I2O_MAGIC_NUMBER,6,struct i2o_sw_xfer)
 #define I2OSWDEL		_IOWR(I2O_MAGIC_NUMBER,7,struct i2o_sw_xfer)
-#define I2OVALIDATE		_IOR(I2O_MAGIC_NUMBER,8,u32)
+#define I2OVALIDATE		_IOR(I2O_MAGIC_NUMBER,8,__u32)
 #define I2OHTML 		_IOWR(I2O_MAGIC_NUMBER,9,struct i2o_html)
 #define I2OEVTREG		_IOW(I2O_MAGIC_NUMBER,10,struct i2o_evt_id)
 #define I2OEVTGET		_IOR(I2O_MAGIC_NUMBER,11,struct i2o_evt_info)
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
search-a-little-harder-for-mkimage.patch
some-rtc-documentation-updates.patch
