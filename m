From: akpm@linux-foundation.org
Subject: + include-of-linux-typesh-is-preferred-over-asm-typesh.patch added to -mm tree
Date: Wed, 14 Jan 2009 17:11:10 -0800
Message-ID: <200901150111.n0F1BAnW013668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbZAOBL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Jan 2009 20:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@infradead.org, jaswinderrajput@gmail.com, mingo@elte.hu, sam@ravnborg.org


The patch titled
     include of <linux/types.h> is preferred over <asm/types.h>
has been added to the -mm tree.  Its filename is
     include-of-linux-typesh-is-preferred-over-asm-typesh.patch

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
Subject: include of <linux/types.h> is preferred over <asm/types.h>
From: Jaswinder Singh Rajput <jaswinder@infradead.org>

Impact: fix 15 make headers_check warnings:

include of <linux/types.h> is preferred over <asm/types.h>

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/agpgart.h      |    1 -
 include/linux/atm_idt77105.h |    2 +-
 include/linux/capi.h         |    2 +-
 include/linux/connector.h    |    2 +-
 include/linux/cyclades.h     |    2 --
 include/linux/fb.h           |    2 +-
 include/linux/if_pppol2tp.h  |    2 +-
 include/linux/if_pppox.h     |    2 +-
 include/linux/input.h        |    2 +-
 include/linux/joystick.h     |    2 +-
 include/linux/kvm.h          |    2 +-
 include/linux/loop.h         |    2 +-
 include/linux/matroxfb.h     |    2 +-
 include/linux/phantom.h      |    2 +-
 include/linux/radeonfb.h     |    2 +-
 15 files changed, 13 insertions(+), 16 deletions(-)

diff -puN include/linux/agpgart.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/agpgart.h
--- a/include/linux/agpgart.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/agpgart.h
@@ -52,7 +52,6 @@
 
 #ifndef __KERNEL__
 #include <linux/types.h>
-#include <asm/types.h>
 
 struct agp_version {
 	__u16 major;
diff -puN include/linux/atm_idt77105.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/atm_idt77105.h
--- a/include/linux/atm_idt77105.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/atm_idt77105.h
@@ -7,7 +7,7 @@
 #ifndef LINUX_ATM_IDT77105_H
 #define LINUX_ATM_IDT77105_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/atmioc.h>
 #include <linux/atmdev.h>
 
diff -puN include/linux/capi.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/capi.h
--- a/include/linux/capi.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/capi.h
@@ -12,7 +12,7 @@
 #ifndef __LINUX_CAPI_H__
 #define __LINUX_CAPI_H__
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/ioctl.h>
 #ifndef __KERNEL__
 #include <linux/kernelcapi.h>
diff -puN include/linux/connector.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/connector.h
--- a/include/linux/connector.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/connector.h
@@ -22,7 +22,7 @@
 #ifndef __CONNECTOR_H
 #define __CONNECTOR_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define CN_IDX_CONNECTOR		0xffffffff
 #define CN_VAL_CONNECTOR		0xffffffff
diff -puN include/linux/cyclades.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/cyclades.h
--- a/include/linux/cyclades.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/cyclades.h
@@ -150,8 +150,6 @@ struct CYZ_BOOT_CTRL {
  *	architectures and compilers.
  */
 
-#include <asm/types.h>
-
 typedef __u64  ucdouble;		/* 64 bits, unsigned */
 typedef __u32  uclong;			/* 32 bits, unsigned */
 typedef __u16  ucshort;		/* 16 bits, unsigned */
diff -puN include/linux/fb.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/fb.h
--- a/include/linux/fb.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/fb.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_FB_H
 #define _LINUX_FB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/i2c.h>
 
 struct dentry;
diff -puN include/linux/if_pppol2tp.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/if_pppol2tp.h
--- a/include/linux/if_pppol2tp.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/if_pppol2tp.h
@@ -15,7 +15,7 @@
 #ifndef __LINUX_IF_PPPOL2TP_H
 #define __LINUX_IF_PPPOL2TP_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #ifdef __KERNEL__
 #include <linux/in.h>
diff -puN include/linux/if_pppox.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/if_pppox.h
--- a/include/linux/if_pppox.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/if_pppox.h
@@ -17,7 +17,7 @@
 #define __LINUX_IF_PPPOX_H
 
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/byteorder.h>
 
 #ifdef  __KERNEL__
diff -puN include/linux/input.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/input.h
--- a/include/linux/input.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/input.h
@@ -16,7 +16,7 @@
 #include <sys/time.h>
 #include <sys/ioctl.h>
 #include <sys/types.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #endif
 
 /*
diff -puN include/linux/joystick.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/joystick.h
--- a/include/linux/joystick.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/joystick.h
@@ -27,7 +27,7 @@
  * Vojtech Pavlik, Ucitelska 1576, Prague 8, 182 00 Czech Republic
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/input.h>
 
 /*
diff -puN include/linux/kvm.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/kvm.h
--- a/include/linux/kvm.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/kvm.h
@@ -7,7 +7,7 @@
  * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 #include <linux/ioctl.h>
 #include <asm/kvm.h>
diff -puN include/linux/loop.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/loop.h
--- a/include/linux/loop.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/loop.h
@@ -80,7 +80,7 @@ enum {
 };
 
 #include <asm/posix_types.h>	/* for __kernel_old_dev_t */
-#include <asm/types.h>		/* for __u64 */
+#include <linux/types.h>	/* for __u64 */
 
 /* Backwards compatibility version */
 struct loop_info {
diff -puN include/linux/matroxfb.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/matroxfb.h
--- a/include/linux/matroxfb.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/matroxfb.h
@@ -2,7 +2,7 @@
 #define __LINUX_MATROXFB_H__
 
 #include <asm/ioctl.h>
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/videodev2.h>
 
 struct matroxioc_output_mode {
diff -puN include/linux/phantom.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/phantom.h
--- a/include/linux/phantom.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/phantom.h
@@ -10,7 +10,7 @@
 #ifndef __PHANTOM_H
 #define __PHANTOM_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 /* PHN_(G/S)ET_REG param */
 struct phm_reg {
diff -puN include/linux/radeonfb.h~include-of-linux-typesh-is-preferred-over-asm-typesh include/linux/radeonfb.h
--- a/include/linux/radeonfb.h~include-of-linux-typesh-is-preferred-over-asm-typesh
+++ a/include/linux/radeonfb.h
@@ -2,7 +2,7 @@
 #define __LINUX_RADEONFB_H__
 
 #include <asm/ioctl.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define ATY_RADEON_LCD_ON	0x00000001
 #define ATY_RADEON_CRT_ON	0x00000002
_

Patches currently in -mm which might be from jaswinder@infradead.org are

origin.patch
include-of-linux-typesh-is-preferred-over-asm-typesh.patch
linux-next.patch

