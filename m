From: akpm@linux-foundation.org
Subject: [merged] mb862xxfb-fix-acceleration-module-license.patch removed from -mm tree
Date: Wed, 07 Apr 2010 11:50:06 -0400
Message-ID: <201004071851.o37IpW0u001309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576Ab0DGSwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Apr 2010 14:52:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, v.sitdikov@gmail.com, virtuoso@slind.org, mm-commits@vger.kernel.org


The patch titled
     mb862xxfb: fix acceleration module license
has been removed from the -mm tree.  Its filename was
     mb862xxfb-fix-acceleration-module-license.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Alexander Shishkin <virtuoso@slind.org>
Cc: Valentin Sitdikov <v.sitdikov@gmail.com>
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
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
xen-fix-build-when-sysrq-is-disabled.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

