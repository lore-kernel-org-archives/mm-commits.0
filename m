From: akpm@linux-foundation.org
Subject: - ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch removed from -mm tree
Date: Fri, 21 Dec 2007 14:08:58 -0800
Message-ID: <200712212208.lBLM8wH1001745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39872 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622AbXLUWRh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     ehci-hcd: fix sparse warning about shadowing 'status' symbol
has been removed from the -mm tree.  Its filename was
     ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

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
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fi=
xes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
