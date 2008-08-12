From: akpm@linux-foundation.org
Subject: - hso-fix-oops-in-read-write-callbacks.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:34 -0700
Message-ID: <200808122033.m7CKXYqh011799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbYHLUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:35:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blino@mandriva.com, alan@redhat.com, gregkh@suse.de, jari.tenhunen@iki.fi, mm-commits@vger.kernel.org


The patch titled
     hso: fix oops in read/write callbacks
has been removed from the -mm tree.  Its filename was
     hso-fix-oops-in-read-write-callbacks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
git-unionfs.patch

