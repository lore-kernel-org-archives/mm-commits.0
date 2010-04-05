From: akpm@linux-foundation.org
Subject: + mb862xxfb-fix-acceleration-module-license.patch added to -mm tree
Date: Mon, 05 Apr 2010 12:59:53 -0700
Message-ID: <201004051959.o35JxrPD005971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452Ab0DEUAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, valentin.sitdikov@siemens.com, virtuoso@slind.org


The patch titled
     mb862xxfb: fix acceleration module license
has been added to the -mm tree.  Its filename is
     mb862xxfb-fix-acceleration-module-license.patch

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
Subject: mb862xxfb: fix acceleration module license
From: Randy Dunlap <randy.dunlap@oracle.com>

mb862xxfb_accel built as a separate module, but it does not have a
MODULE_LICENSE, so it taints the kernel.  Add a MODULE_LICENSE to it (same
as mb862xxfb license).

mb862xxfb_accel: module license 'unspecified' taints kernel.

Or should mb862xxfb_accel be built into the mb862xxfb binary file instead?

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Alexander Shishkin <virtuoso@slind.org>
Cc: Valentin Sitdikov <valentin.sitdikov@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/mb862xx/mb862xxfb_accel.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-fix-acceleration-module-license drivers/video/mb862xx/mb862xxfb_accel.c
--- a/drivers/video/mb862xx/mb862xxfb_accel.c~mb862xxfb-fix-acceleration-module-license
+++ a/drivers/video/mb862xx/mb862xxfb_accel.c
@@ -16,6 +16,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #if defined(CONFIG_OF)
@@ -330,3 +331,5 @@ void mb862xxfb_init_accel(struct fb_info
 	info->fix.accel = 0xff;	/*FIXME: add right define */
 }
 EXPORT_SYMBOL(mb862xxfb_init_accel);
+
+MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
mb862xxfb-fix-acceleration-module-license.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
kernelh-convert-rounding-macros-to-statement-expressions-add-add_mod.patch
xen-fix-build-when-sysrq-is-disabled.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

