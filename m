From: akpm@linux-foundation.org
Subject: - option-termios-handling.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:55 -0700
Message-ID: <200710242141.l9OLft5i013998@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44569 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755522AbXJXVpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     option: termios handling
has been removed from the -mm tree.  Its filename was
     option-termios-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: option: termios handling
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

For the devices that have no hardware settings set up the termios return
properly.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/option.c~option-termios-handling drivers/usb/serial/option.c
--- a/drivers/usb/serial/option.c~option-termios-handling
+++ a/drivers/usb/serial/option.c
@@ -311,7 +311,8 @@ static void option_set_termios(struct us
 			struct ktermios *old_termios)
 {
 	dbg("%s", __FUNCTION__);
-
+	/* Doesn't support option setting */
+	tty_termios_copy_hw(port->tty->termios, old_termios);
 	option_send_setup(port);
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-libata-all.patch
serial-keep-the-dtr-setting-for-serial-console.patch
initio-fix-conflict-when-loading-driver.patch
geode-lists-are-subscriber-only.patch
tty-kill-tty_flipbuf_size.patch
drivers-edac-turnon-edac-device-error-logging.patch
drivers-edac-use-round_jiffies_relative.patch
drivers-edac-add-cell-xdr-memory-types.patch
drivers-edac-add-cell-mc-driver.patch
drivers-edac-i3000-code-tidying.patch
drivers-edac-i3000-replace-macros-with-functions.patch
drivers-edac-add-freescale-mpc85xx-driver.patch
drivers-edac-add-marvell-mv64x60-driver.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
