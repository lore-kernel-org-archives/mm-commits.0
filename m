From: akpm@linux-foundation.org
Subject: + scsi-fix-if-n-if-cases-missing-semicolons-when-false.patch added to -mm tree
Date: Tue, 23 Oct 2007 13:42:04 -0700
Message-ID: <200710232042.l9NKg4Gr005475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34923 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752554AbXJWUmt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 16:42:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, James.Bottomley@steeleye.com, osst@riede.org


The patch titled
     scsi: fix if (...) \n #if... cases missing semicolons when false
has been added to the -mm tree.  Its filename is
     scsi-fix-if-n-if-cases-missing-semicolons-when-false.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: scsi: fix if (...) \n #if... cases missing semicolons when fal=
se
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Willem Riede <osst@riede.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/osst.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/osst.c~scsi-fix-if-n-if-cases-missing-semicolons=
-when-false drivers/scsi/osst.c
--- a/drivers/scsi/osst.c~scsi-fix-if-n-if-cases-missing-semicolons-whe=
n-false
+++ a/drivers/scsi/osst.c
@@ -593,10 +593,11 @@ static int osst_verify_frame(struct osst
 	if (aux->frame_type !=3D OS_FRAME_TYPE_DATA &&
 	    aux->frame_type !=3D OS_FRAME_TYPE_EOD &&
 	    aux->frame_type !=3D OS_FRAME_TYPE_MARKER) {
-		if (!quiet)
+		if (!quiet) {
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Skipping frame, frame type %x\n", name, =
aux->frame_type);
 #endif
+		}
 		goto err_out;
 	}
 	if (aux->frame_type =3D=3D OS_FRAME_TYPE_EOD &&
@@ -606,11 +607,12 @@ static int osst_verify_frame(struct osst
 		goto err_out;
 	}
         if (frame_seq_number !=3D -1 && ntohl(aux->frame_seq_num) !=3D=
 frame_seq_number) {
-		if (!quiet)
+		if (!quiet) {
 #if DEBUG
 			printk(OSST_DEB_MSG "%s:D: Skipping frame, sequence number %u (expe=
cted %d)\n",=20
 					    name, ntohl(aux->frame_seq_num), frame_seq_number);
 #endif
+		}
 		goto err_out;
 	}
 	if (aux->frame_type =3D=3D OS_FRAME_TYPE_MARKER) {
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

origin.patch
watchdog-fix-if-n-if-cases-missing-semicolons-when-false.patch
