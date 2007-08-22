From: akpm@linux-foundation.org
Subject: + fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch added to -mm tree
Date: Tue, 21 Aug 2007 22:03:40 -0700
Message-ID: <200708220503.l7M53eBN028342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbXHVFEB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 01:04:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rgetz@blackfin.uclinux.org, kraxel@redhat.com, lethal@linux-sh.org, vapier.adi@gmail.com


The patch titled
     fix - ensure we don't use bootconsoles after init has been released
has been added to the -mm tree.  Its filename is
     fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix - ensure we don't use bootconsoles after init has been released
From: Robin Getz <rgetz@blackfin.uclinux.org>

Gerd Hoffmann pointed out that my patch from yesterday can lead to a null
pointer dereference if the kernel is booted with no console, and no
earlyprintk defined.  This fixes that issue.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Gerd Hoffmann" <kraxel@redhat.com>
Cc: "Paul Mundt" <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN kernel/printk.c~fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released kernel/printk.c
--- a/kernel/printk.c~fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released
+++ a/kernel/printk.c
@@ -1085,10 +1085,12 @@ EXPORT_SYMBOL(unregister_console);
 
 static int __init disable_boot_consoles(void)
 {
-	if (console_drivers->flags & CON_BOOT) {
-		printk(KERN_INFO "turn off boot console %s%d\n",
-			console_drivers->name, console_drivers->index);
-		return unregister_console(console_drivers);
+	if (console_drivers != NULL) {
+		if (console_drivers->flags & CON_BOOT) {
+			printk(KERN_INFO "turn off boot console %s%d\n",
+				console_drivers->name, console_drivers->index);
+			return unregister_console(console_drivers);
+		}
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from rgetz@blackfin.uclinux.org are

origin.patch
fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
