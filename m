From: akpm@linux-foundation.org
Subject: - ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch removed from -mm tree
Date: Tue, 21 Aug 2007 12:49:58 -0700
Message-ID: <200708211950.l7LJnwuR007768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53268 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758628AbXHUTuY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Aug 2007 15:50:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rgetz@blackfin.uclinux.org, kraxel@redhat.com, lethal@linux-sh.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ensure we don't use bootconsoles after init has been released
has been removed from the -mm tree.  Its filename was
     ensure-we-dont-use-bootconsoles-after-init-has-been-released.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ensure we don't use bootconsoles after init has been released
From: Robin Getz <rgetz@blackfin.uclinux.org>

This is a followup to the cleanups for earlyprintk patch from Gerd Hoffmann

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511

This ensures that a bootconsole is unregistered if it is not replaced.
The current implementation spews garbage out the bootconsole in this case,
since the bootconsole structure is normally in the init section, and is
freed, but still used.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk.c |   11 +++++++++++
 1 files changed, 11 insertions(+)

diff -puN kernel/printk.c~ensure-we-dont-use-bootconsoles-after-init-has-been-released kernel/printk.c
--- a/kernel/printk.c~ensure-we-dont-use-bootconsoles-after-init-has-been-released
+++ a/kernel/printk.c
@@ -1206,6 +1206,17 @@ int unregister_console(struct console *c
 }
 EXPORT_SYMBOL(unregister_console);
 
+static int __init disable_boot_consoles(void)
+{
+	if (console_drivers->flags & CON_BOOT) {
+		printk(KERN_INFO "turn off boot console %s%d\n",
+			console_drivers->name, console_drivers->index);
+		return unregister_console(console_drivers);
+	}
+	return 0;
+}
+late_initcall(disable_boot_consoles);
+
 /**
  * tty_write_message - write a message to a certain tty, not just the console.
  * @tty: the destination tty_struct
_

Patches currently in -mm which might be from rgetz@blackfin.uclinux.org are

origin.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
