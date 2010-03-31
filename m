From: akpm@linux-foundation.org
Subject: + usb-fix-serial-build-when-sysrq-is-disabled.patch added to -mm tree
Date: Wed, 31 Mar 2010 13:23:30 -0700
Message-ID: <201003312023.o2VKNUV1006412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757760Ab0CaUYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 16:24:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     usb: fix serial build when SYSRQ is disabled
has been added to the -mm tree.  Its filename is
     usb-fix-serial-build-when-sysrq-is-disabled.patch

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
Subject: usb: fix serial build when SYSRQ is disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_MAGIC_SYSRQ is not enabled:

drivers/usb/serial/generic.c:566: error: implicit declaration of function 'handle_sysrq'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/generic.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/usb/serial/generic.c~usb-fix-serial-build-when-sysrq-is-disabled drivers/usb/serial/generic.c
--- a/drivers/usb/serial/generic.c~usb-fix-serial-build-when-sysrq-is-disabled
+++ a/drivers/usb/serial/generic.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <linux/sysrq.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/module.h>
@@ -558,6 +559,7 @@ void usb_serial_generic_unthrottle(struc
 	}
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ
 int usb_serial_handle_sysrq_char(struct tty_struct *tty,
 			struct usb_serial_port *port, unsigned int ch)
 {
@@ -571,6 +573,13 @@ int usb_serial_handle_sysrq_char(struct 
 	}
 	return 0;
 }
+#else
+int usb_serial_handle_sysrq_char(struct tty_struct *tty,
+			struct usb_serial_port *port, unsigned int ch)
+{
+	return 0;
+}
+#endif
 EXPORT_SYMBOL_GPL(usb_serial_handle_sysrq_char);
 
 int usb_serial_handle_break(struct usb_serial_port *port)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
drm-fix-build-error-when-sysrq-is-disabled.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
led-driver-for-the-soekris-net5501-board-fix-2.patch
leds-route-kbd-leds-through-the-generic-leds-layer-leds-input-depends-on-input.patch
scsi-fix-convert-scsi_scanc-kernel-doc.patch
scsi-update-drivers-tools-url-references.patch
usb-fix-serial-build-when-sysrq-is-disabled.patch
xen-fix-build-when-sysrq-is-disabled.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

