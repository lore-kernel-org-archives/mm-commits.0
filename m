From: akpm@linux-foundation.org
Subject: + ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch added to -mm tree
Date: Tue, 18 Dec 2007 15:38:04 -0800
Message-ID: <200712182338.lBINc4X9027802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756674AbXLRXiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Dec 2007 18:38:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, greg@kroah.com


The patch titled
     ehci-hcd: fix sparse warning about shadowing 'status' symbol
has been added to the -mm tree.  Its filename is
     ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: ehci-hcd: fix sparse warning about shadowing 'status' symbol
=46rom: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>

Signed-off-by: Marcin =C5=9Alusarz <marcin.slusarz@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ehci-hcd.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/usb/host/ehci-hcd.c~ehci-hcd-fix-sparse-warning-about=
-shadowing-status-symbol drivers/usb/host/ehci-hcd.c
--- a/drivers/usb/host/ehci-hcd.c~ehci-hcd-fix-sparse-warning-about-sha=
dowing-status-symbol
+++ a/drivers/usb/host/ehci-hcd.c
@@ -830,16 +830,16 @@ static int ehci_urb_dequeue(struct usb_h
 		/* reschedule QH iff another request is queued */
 		if (!list_empty (&qh->qtd_list)
 				&& HC_IS_RUNNING (hcd->state)) {
-			int status;
+			int schedule_status;
=20
-			status =3D qh_schedule (ehci, qh);
+			schedule_status =3D qh_schedule (ehci, qh);
 			spin_unlock_irqrestore (&ehci->lock, flags);
=20
-			if (status !=3D 0) {
+			if (schedule_status !=3D 0) {
 				// shouldn't happen often, but ...
 				// FIXME kill those tds' urbs
 				err ("can't reschedule qh %p, err %d",
-					qh, status);
+					qh, schedule_status);
 			}
 			return status;
 		}
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com a=
re

git-alsa.patch
usb-storage-initializersc-fix-signedness-difference.patch
usbdevfs_urb-__user-annotation.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
