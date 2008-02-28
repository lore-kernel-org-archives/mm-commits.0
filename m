From: akpm@linux-foundation.org
Subject: + basic-braille-screen-reader-support-fixes.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:45:20 -0800
Message-ID: <200802280045.m1S0jKCb007439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758082AbYB1AqH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:46:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, dtor@mail.ru, jikos@jikos.cz


The patch titled
     Braille screen reader fixes
has been added to the -mm tree.  Its filename is
     basic-braille-screen-reader-support-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -805,10 +807,11 @@ static int __add_preferred_console(char 
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

keyboard-notifier-documentation.patch
input-put-ledstate-in-the-keyboard-notifier-fix.patch
vt-notifier-fix-for-vt-switch.patch
vt-notifier-extension-for-accessibility.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
basic-braille-screen-reader-support.patch
basic-braille-screen-reader-support-fixes.patch
