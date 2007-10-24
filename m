From: akpm@linux-foundation.org
Subject: - usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch removed from -mm tree
Date: Wed, 24 Oct 2007 14:41:41 -0700
Message-ID: <200710242141.l9OLffhO013975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56362 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759258AbXJXVps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Oct 2007 17:45:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb serial: kill another case we pass NULL and shouldn't
has been removed from the -mm tree.  Its filename was
     usb-serial-kill-another-case-we-pass-null-and-shouldnt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb serial: kill another case we pass NULL and shouldn't
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/usb/serial/console.c~usb-serial-kill-another-case-we-pass-null-and-shouldnt drivers/usb/serial/console.c
--- a/drivers/usb/serial/console.c~usb-serial-kill-another-case-we-pass-null-and-shouldnt
+++ a/drivers/usb/serial/console.c
@@ -164,6 +164,7 @@ static int usb_console_setup(struct cons
 	}
 
 	if (serial->type->set_termios) {
+		struct ktermios dummy;
 		/* build up a fake tty structure so that the open call has something
 		 * to look at to get the cflag value */
 		tty = kzalloc(sizeof(*tty), GFP_KERNEL);
@@ -177,12 +178,13 @@ static int usb_console_setup(struct cons
 			kfree (tty);
 			return -ENOMEM;
 		}
+		memset(&dummy, 0, sizeof(struct ktermios));
 		termios->c_cflag = cflag;
 		tty->termios = termios;
 		port->tty = tty;
 
 		/* set up the initial termios settings */
-		serial->type->set_termios(port, NULL);
+		serial->type->set_termios(port, &dummy);
 		port->tty = NULL;
 		kfree (termios);
 		kfree (tty);
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
