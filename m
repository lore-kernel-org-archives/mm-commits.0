From: akpm@linux-foundation.org
Subject: - hso-fix-refcounting-on-the-ttyhsx-devices.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:37 -0700
Message-ID: <200808122033.m7CKXbOl011807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752337AbYHLUs7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:48:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: blino@mandriva.com, gregkh@suse.de, jari.tenhunen@iki.fi, rol@as2917.net, mm-commits@vger.kernel.org


The patch titled
     hso: fix refcounting on the ttyHSx devices
has been removed from the -mm tree.  Its filename was
     hso-fix-refcounting-on-the-ttyhsx-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hso: fix refcounting on the ttyHSx devices
From: Olivier Blin <blino@mandriva.com>

The references on ttyHSx devices were not decremented correctly when the
tty was closed.  The helper freeing the serial devices was never called
because of that, and the module left some dangling sysfs devices after
being unloaded.

Signed-off-by: Olivier Blin <blino@mandriva.com>
Cc: Jari Tenhunen <jari.tenhunen@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/usb/hso.c~hso-fix-refcounting-on-the-ttyhsx-devices drivers/net/usb/hso.c
--- a/drivers/net/usb/hso.c~hso-fix-refcounting-on-the-ttyhsx-devices
+++ a/drivers/net/usb/hso.c
@@ -1103,8 +1103,8 @@ static void hso_serial_close(struct tty_
 	/* reset the rts and dtr */
 	/* do the actual close */
 	serial->open_count--;
+	kref_put(&serial->parent->ref, hso_serial_ref_free);
 	if (serial->open_count <= 0) {
-		kref_put(&serial->parent->ref, hso_serial_ref_free);
 		serial->open_count = 0;
 		if (serial->tty) {
 			serial->tty->driver_data = NULL;
_

Patches currently in -mm which might be from blino@mandriva.com are

linux-next.patch
git-unionfs.patch

