From: akpm@linux-foundation.org
Subject: + usb-hso-make-tty_operations-const.patch added to -mm tree
Date: Fri, 08 Aug 2008 13:29:21 -0700
Message-ID: <200808082029.m78KTLK7026958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752883AbYHHU3m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 16:29:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gregkh@suse.de, ajb@spheresystems.co.uk, arjan@infradead.org


The patch titled
     USB: HSO: make tty_operations const
has been added to the -mm tree.  Its filename is
     usb-hso-make-tty_operations-const.patch

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
Subject: USB: HSO: make tty_operations const
From: Greg Kroah-Hartman <gregkh@suse.de>

As recommended by Arjan.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Bird <ajb@spheresystems.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/hso.c~usb-hso-make-tty_operations-const drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~usb-hso-make-tty_operations-const
+++ a/drivers/net/usb/hso.c
@@ -2725,7 +2725,7 @@ static int hso_mux_submit_intr_urb(struc
 }
 
 /* operations setup of the serial interface */
-static struct tty_operations hso_serial_ops = {
+static const struct tty_operations hso_serial_ops = {
 	.open = hso_serial_open,
 	.close = hso_serial_close,
 	.write = hso_serial_write,
_

Patches currently in -mm which might be from gregkh@suse.de are

linux-next.patch
hso-fix-oops-in-read-write-callbacks.patch
hso-fix-refcounting-on-the-ttyhsx-devices.patch
usb-hso-make-tty_operations-const.patch
usb-hso-minor-fixes-due-to-code-review.patch
drivers-usb-class-cdc-wdmc-fix-build-with-config_pm=n.patch
unrevert-usb-dont-explicitly-reenable-root-hub-status-interrupts.patch

