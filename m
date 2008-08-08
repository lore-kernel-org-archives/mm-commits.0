From: akpm@linux-foundation.org
Subject: + hso-fix-oops-in-read-write-callbacks.patch added to -mm tree
Date: Fri, 08 Aug 2008 13:29:15 -0700
Message-ID: <200808082029.m78KTFsH026952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752993AbYHHU3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2008 16:29:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blino@mandriva.com, alan@redhat.com, gregkh@suse.de, jari.tenhunen@iki.fi


The patch titled
     hso: fix oops in read/write callbacks
has been added to the -mm tree.  Its filename is
     hso-fix-oops-in-read-write-callbacks.patch

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
Subject: hso: fix oops in read/write callbacks
From: Olivier Blin <blino@mandriva.com>

The tty may be closed already when the read/write callbacks are called. 
This patch checks that the ttys still exist before waking them up.

Signed-off-by: Olivier Blin <blino@mandriva.com>
Acked-by: Alan Cox <alan@redhat.com>
Cc: Jari Tenhunen <jari.tenhunen@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/usb/hso.c~hso-fix-oops-in-read-write-callbacks drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~hso-fix-oops-in-read-write-callbacks
+++ a/drivers/net/usb/hso.c
@@ -1467,7 +1467,8 @@ static void hso_std_serial_write_bulk_ca
 		return;
 	}
 	hso_put_activity(serial->parent);
-	tty_wakeup(serial->tty);
+	if (serial->tty)
+		tty_wakeup(serial->tty);
 	hso_kick_transmit(serial);
 
 	D1(" ");
@@ -1538,7 +1539,8 @@ static void ctrl_callback(struct urb *ur
 			clear_bit(HSO_SERIAL_FLAG_RX_SENT, &serial->flags);
 	} else {
 		hso_put_activity(serial->parent);
-		tty_wakeup(serial->tty);
+		if (serial->tty)
+			tty_wakeup(serial->tty);
 		/* response to a write command */
 		hso_kick_transmit(serial);
 	}
_

Patches currently in -mm which might be from blino@mandriva.com are

hso-fix-oops-in-read-write-callbacks.patch
hso-fix-refcounting-on-the-ttyhsx-devices.patch
git-unionfs.patch

