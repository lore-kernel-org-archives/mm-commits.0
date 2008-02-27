From: akpm@linux-foundation.org
Subject: + drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch added to -mm tree
Date: Wed, 27 Feb 2008 15:17:17 -0800
Message-ID: <200802272317.m1RNHHRD003505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758262AbYB0XSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 18:18:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ray-lk@madrabbit.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org, gregkh@suse.de


The patch titled
     drivers/usb/serial/io_ti.c: remove unneeded null tty check
has been added to the -mm tree.  Its filename is
     drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch

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
Subject: drivers/usb/serial/io_ti.c: remove unneeded null tty check
From: Ray Lee <ray-lk@madrabbit.org>

The Coverity checker (and Adrian Bunk) spotted an inconsistent NULL check of
port->tty (it's blindly dereferenced later without the check).

Alan Cox confirmed the check can go.

Signed-off-by: Ray Lee <ray-lk@madrabbit.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-remove-unneeded-null-tty-check drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-remove-unneeded-null-tty-check
+++ a/drivers/usb/serial/io_ti.c
@@ -1942,8 +1942,7 @@ static int edge_open (struct usb_serial_
 	if (edge_port == NULL)
 		return -ENODEV;
 
-	if (port->tty)
-		port->tty->low_latency = low_latency;
+	port->tty->low_latency = low_latency;
 
 	port_number = port->number - port->serial->minor;
 	switch (port_number) {
_

Patches currently in -mm which might be from ray-lk@madrabbit.org are

drivers-usb-serial-io_tic-remove-unneeded-null-tty-check.patch
