From: akpm@linux-foundation.org
Subject: - basic-braille-screen-reader-support-fixes.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:24:15 -0700
Message-ID: <200804300624.m3U6OFZM031658@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757375AbYD3GZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: samuel.thibault@ens-lyon.org, dtor@mail.ru, jikos@jikos.cz, mm-commits@vger.kernel.org


The patch titled
     Braille screen reader fixes
has been removed from the -mm tree.  Its filename was
     basic-braille-screen-reader-support-fixes.patch

This patch was dropped because it was folded into basic-braille-screen-reader-support.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Braille screen reader fixes
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Braille screen reader fixes:
- console_cmdline's brl_options field is only required when braille
console support is enabled.
- Use strlcpy to copy the console name.
- braille console support depends on VT support.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/accessibility/Kconfig |    1 +
 kernel/printk.c               |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/accessibility/Kconfig~basic-braille-screen-reader-support-fixes drivers/accessibility/Kconfig
--- a/drivers/accessibility/Kconfig~basic-braille-screen-reader-support-fixes
+++ a/drivers/accessibility/Kconfig
@@ -8,6 +8,7 @@ menuconfig ACCESSIBILITY
 if ACCESSIBILITY
 config A11Y_BRAILLE_CONSOLE
 	bool "Console on braille device"
+	depends on VT
 	depends on SERIAL_CORE_CONSOLE
 	---help---
 	  Enables console output on a braille device connected to a 8250
diff -puN kernel/printk.c~basic-braille-screen-reader-support-fixes kernel/printk.c
--- a/kernel/printk.c~basic-braille-screen-reader-support-fixes
+++ a/kernel/printk.c
@@ -111,7 +111,9 @@ struct console_cmdline
 	char	name[8];			/* Name of the driver	    */
 	int	index;				/* Minor dev. to use	    */
 	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
 	char	*brl_options;			/* Options for braille driver */
+#endif
 };
 
 #define MAX_CMDLINECONSOLES 8
@@ -829,10 +831,11 @@ static int __add_preferred_console(char 
 	if (!brl_options)
 		selected_console = i;
 	c = &console_cmdline[i];
-	memcpy(c->name, name, sizeof(c->name));
-	c->name[sizeof(c->name) - 1] = 0;
+	strlcpy(c->name, name, sizeof(c->name));
 	c->options = options;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
 	c->brl_options = brl_options;
+#endif
 	c->index = idx;
 	return 0;
 }
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

origin.patch
consoles-switch-to-int-put_char-method.patch
basic-braille-screen-reader-support.patch
basic-braille-screen-reader-support-fixes.patch
basic-braille-screen-reader-support-ppc-fix.patch
basic-braille-screen-reader-support-doc.patch
basic-braille-screen-reader-support-makefile-fix.patch

