From: akpm@linux-foundation.org
Subject: - fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:04 -0700
Message-ID: <200708242055.l7OKt4Nq013936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbXHXUzY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 16:55:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgetz@blackfin.uclinux.org, kraxel@redhat.com, lethal@linux-sh.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fix - ensure we don't use bootconsoles after init has been released
has been removed from the -mm tree.  Its filename was
     fix-ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
