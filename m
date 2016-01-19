From: akpm@linux-foundation.org
Subject: [merged]
 printk-only-unregister-boot-consoles-when-necessary.patch removed from -mm
 tree
Date: Tue, 19 Jan 2016 12:14:50 -0800
Message-ID: <569e993a.LXiioE+aHhB0cI4V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: treding@nvidia.com, arnd@arndb.de, gregkh@linuxfoundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: only unregister boot consoles when necessary
has been removed from the -mm tree.  Its filename was
     printk-only-unregister-boot-consoles-when-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Thierry Reding <treding@nvidia.com>
Subject: printk: only unregister boot consoles when necessary

Boot consoles are typically replaced by proper consoles during the boot
process.  This can be problematic if the boot console data is part of the
init section that is reclaimed late during boot.  If the proper console
does not register before this point in time, the boot console will need to
be removed (so that the freed memory is not accessed), leaving the system
without output for some time.

There are various reasons why the proper console may not register early
enough, such as deferred probe or the driver being a loadable module.  If
that happens, there is some amount of time where no console messages are
visible to the user, which in turn can mean that they won't see crashes or
other potentially useful information.

To avoid this situation, only remove the boot console when it resides in
the init section.  Code exists to replace the boot console by the proper
console when it is registered, keeping a seamless transition between the
boot and proper consoles.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-only-unregister-boot-consoles-when-necessary kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-only-unregister-boot-consoles-when-necessary
+++ a/kernel/printk/printk.c
@@ -48,6 +48,7 @@
 #include <linux/uio.h>
 
 #include <asm/uaccess.h>
+#include <asm-generic/sections.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/printk.h>
@@ -2658,13 +2659,36 @@ int unregister_console(struct console *c
 }
 EXPORT_SYMBOL(unregister_console);
 
+/*
+ * Some boot consoles access data that is in the init section and which will
+ * be discarded after the initcalls have been run. To make sure that no code
+ * will access this data, unregister the boot consoles in a late initcall.
+ *
+ * If for some reason, such as deferred probe or the driver being a loadable
+ * module, the real console hasn't registered yet at this point, there will
+ * be a brief interval in which no messages are logged to the console, which
+ * makes it difficult to diagnose problems that occur during this time.
+ *
+ * To mitigate this problem somewhat, only unregister consoles whose memory
+ * intersects with the init section. Note that code exists elsewhere to get
+ * rid of the boot console as soon as the proper console shows up, so there
+ * won't be side-effects from postponing the removal.
+ */
 static int __init printk_late_init(void)
 {
 	struct console *con;
 
 	for_each_console(con) {
 		if (!keep_bootcon && con->flags & CON_BOOT) {
-			unregister_console(con);
+			/*
+			 * Make sure to unregister boot consoles whose data
+			 * resides in the init section before the init section
+			 * is discarded. Boot consoles whose data will stick
+			 * around will automatically be unregistered when the
+			 * proper console replaces them.
+			 */
+			if (init_section_intersects(con, sizeof(*con)))
+				unregister_console(con);
 		}
 	}
 	hotcpu_notifier(console_cpu_notify, 0);
_

Patches currently in -mm which might be from treding@nvidia.com are


