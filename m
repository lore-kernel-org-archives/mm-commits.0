From: akpm@linux-foundation.org
Subject: + drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:34:01 -0800
Message-ID: <200702272034.l1RKY5Xc027536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50782 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091AbXB0Uh2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:37:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tilman@imap.cc, bunk@stusta.de, kkeil@suse.de


The patch titled
     drivers/isdn/gigaset: build asyncdata.o into the gigaset module (fix)
has been added to the -mm tree.  Its filename is
     drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/isdn/gigaset: build asyncdata.o into the gigaset module (fix)
From: Tilman Schmidt <tilman@imap.cc>

a) Remove #define acrobatics that have become unnecessary by the move of
   asyncdata.o into the common part.

b) Correct the rule for building the common part into the kernel when
   some or all hardware specific parts are built as modules.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/gigaset/Makefile    |    9 +++++----
 drivers/isdn/gigaset/asyncdata.c |    5 -----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff -puN drivers/isdn/gigaset/Makefile~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix drivers/isdn/gigaset/Makefile
--- a/drivers/isdn/gigaset/Makefile~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix
+++ a/drivers/isdn/gigaset/Makefile
@@ -1,8 +1,9 @@
 gigaset-y := common.o interface.o proc.o ev-layer.o i4l.o asyncdata.o
 usb_gigaset-y := usb-gigaset.o
-bas_gigaset-y := bas-gigaset.o isocdata.o
 ser_gigaset-y := ser-gigaset.o
+bas_gigaset-y := bas-gigaset.o isocdata.o
 
-obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
-obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o
+obj-$(CONFIG_ISDN_DRV_GIGASET) += gigaset.o
+obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o
+obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o
+obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o
diff -puN drivers/isdn/gigaset/asyncdata.c~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix drivers/isdn/gigaset/asyncdata.c
--- a/drivers/isdn/gigaset/asyncdata.c~drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix
+++ a/drivers/isdn/gigaset/asyncdata.c
@@ -13,11 +13,6 @@
  * =====================================================================
  */
 
-/* not set by Kbuild when building both ser_gigaset and usb_gigaset */
-#ifndef KBUILD_MODNAME
-#define KBUILD_MODNAME "asy_gigaset"
-#endif
-
 #include "gigaset.h"
 #include <linux/crc-ccitt.h>
 #include <linux/bitrev.h>
_

Patches currently in -mm which might be from tilman@imap.cc are

drivers-isdn-gigaset-build-asyncdatao-into-the-gigaset-module-fix.patch
drivers-isdn-gigaset-mark-some-static-data-as-const-v2.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio-fix-sparse-fix.patch
