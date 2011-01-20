From: akpm@linux-foundation.org
Subject: + console-allow-to-retain-boot-console-via-boot-option-keep_bootcon.patch added to -mm tree
Date: Wed, 19 Jan 2011 16:19:55 -0800
Message-ID: <201101200019.p0K0JtUj012186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493Ab1ATAUn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 19:20:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fdinitto@redhat.com, alan@lxorguk.ukuu.org.uk, davem@davemloft.net, fabbione@fabbione.net, gregkh@suse.de


The patch titled
     console: allow to retain boot console via boot option keep_bootcon
has been added to the -mm tree.  Its filename is
     console-allow-to-retain-boot-console-via-boot-option-keep_bootcon.patch

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
Subject: console: allow to retain boot console via boot option keep_bootcon
From: Fabio M. Di Nitto <fdinitto@redhat.com>

On some architectures, the boot process involves de-registering the boot
console (early boot), initialize drivers and then re-register the console.

This mechanism introduces a window in which no printk can happen on the
console and messages are buffered and then printed once the new console is
available.

If a kernel crashes during this window, all it's left on the boot console
is "console [foo] enabled, bootconsole disabled" making debug of the crash
rather 'interesting'.

By adding "keep_bootcon" option, do not unregister the boot console, that
will allow to printk everything that is happening up to the crash.

The option is clearly meant only for debugging purposes as it introduces
lots of duplicated info printed on console, but will make bug report from
users easier as it doesn't require a kernel build just to figure out where
we crash.

Signed-off-by: Fabio M. Di Nitto <fabbione@fabbione.net>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    6 ++++++
 kernel/printk.c                     |   16 +++++++++++++++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff -puN Documentation/kernel-parameters.txt~console-allow-to-retain-boot-console-via-boot-option-keep_bootcon Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~console-allow-to-retain-boot-console-via-boot-option-keep_bootcon
+++ a/Documentation/kernel-parameters.txt
@@ -859,6 +859,12 @@ and is between 256 and 4096 characters. 
 			       If specified, z/VM IUCV HVC accepts connections
 			       from listed z/VM user IDs only.
 
+	keep_bootcon	[KNL]
+			Do not unregister boot console at start. This is only
+			useful for debugging when something happens in the window
+			between unregistering the boot console and initializing
+			the real console.
+
 	i2c_bus=	[HW] Override the default board specific I2C bus speed
 			     or register an additional I2C bus that is not
 			     registered from board initialization code.
diff -puN kernel/printk.c~console-allow-to-retain-boot-console-via-boot-option-keep_bootcon kernel/printk.c
--- a/kernel/printk.c~console-allow-to-retain-boot-console-via-boot-option-keep_bootcon
+++ a/kernel/printk.c
@@ -1222,6 +1222,18 @@ void console_start(struct console *conso
 }
 EXPORT_SYMBOL(console_start);
 
+static int __read_mostly keep_bootcon;
+
+static int __init keep_bootcon_setup(char *str)
+{
+	keep_bootcon = 1;
+	printk(KERN_INFO "debug: skip boot console de-registration.\n");
+
+	return 0;
+}
+
+early_param("keep_bootcon", keep_bootcon_setup);
+
 /*
  * The console driver calls this routine during kernel initialization
  * to register the console printing procedure with printk() and to
@@ -1369,7 +1381,9 @@ void register_console(struct console *ne
 	 * users know there might be something in the kernel's log buffer that
 	 * went to the bootconsole (that they do not see on the real console)
 	 */
-	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
+	if (bcon &&
+	    ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV) &&
+	    !keep_bootcon) {
 		/* we need to iterate through twice, to make sure we print
 		 * everything out, before we unregister the console(s)
 		 */
_

Patches currently in -mm which might be from fdinitto@redhat.com are

console-allow-to-retain-boot-console-via-boot-option-keep_bootcon.patch

