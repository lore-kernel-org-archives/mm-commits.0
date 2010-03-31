From: akpm@linux-foundation.org
Subject: + xen-fix-build-when-sysrq-is-disabled.patch added to -mm tree
Date: Wed, 31 Mar 2010 13:24:10 -0700
Message-ID: <201003312024.o2VKOAkY006432@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757833Ab0CaUYu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Mar 2010 16:24:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, chrisw@sous-sol.org, jeremy@xensource.com


The patch titled
     xen: fix build when SYSRQ is disabled
has been added to the -mm tree.  Its filename is
     xen-fix-build-when-sysrq-is-disabled.patch

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
Subject: xen: fix build when SYSRQ is disabled
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error when CONFIG_MAGIC_SYSRQ is not enabled:

drivers/xen/manage.c:223: error: implicit declaration of function 'handle_sysrq'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/manage.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/xen/manage.c~xen-fix-build-when-sysrq-is-disabled drivers/xen/manage.c
--- a/drivers/xen/manage.c~xen-fix-build-when-sysrq-is-disabled
+++ a/drivers/xen/manage.c
@@ -195,6 +195,7 @@ static void shutdown_handler(struct xenb
 	kfree(str);
 }
 
+#ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handler(struct xenbus_watch *watch, const char **vec,
 			  unsigned int len)
 {
@@ -224,15 +225,16 @@ static void sysrq_handler(struct xenbus_
 		handle_sysrq(sysrq_key, NULL);
 }
 
-static struct xenbus_watch shutdown_watch = {
-	.node = "control/shutdown",
-	.callback = shutdown_handler
-};
-
 static struct xenbus_watch sysrq_watch = {
 	.node = "control/sysrq",
 	.callback = sysrq_handler
 };
+#endif
+
+static struct xenbus_watch shutdown_watch = {
+	.node = "control/shutdown",
+	.callback = shutdown_handler
+};
 
 static int setup_shutdown_watcher(void)
 {
@@ -244,11 +246,13 @@ static int setup_shutdown_watcher(void)
 		return err;
 	}
 
+#ifdef CONFIG_MAGIC_SYSRQ
 	err = register_xenbus_watch(&sysrq_watch);
 	if (err) {
 		printk(KERN_ERR "Failed to set sysrq watcher\n");
 		return err;
 	}
+#endif
 
 	return 0;
 }
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

