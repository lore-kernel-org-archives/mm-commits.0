From: akpm@linux-foundation.org
Subject: + sxc-fix-dbl-statement-if-add-missing-braces.patch added to -mm tree
Date: Thu, 19 Feb 2009 13:19:46 -0800
Message-ID: <200902192119.n1JLJkxV023705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbZBSVT5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 16:19:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ilpo.jarvinen@helsinki.fi, error27@gmail.com


The patch titled
     sx.c: fix dbl statement if - add missing braces
has been added to the -mm tree.  Its filename is
     sxc-fix-dbl-statement-if-add-missing-braces.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sx.c: fix dbl statement if - add missing braces
=46rom: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>

Caused by 736d54533aed (sx.c: fix missed unlock_kernel() on error path =
in
sx_fw_ioctl()).  You guys keep breaking things this way in every single
kernel release in at least couple of places...  :-(

Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/char/sx.c~sxc-fix-dbl-statement-if-add-missing-braces=
 drivers/char/sx.c
--- a/drivers/char/sx.c~sxc-fix-dbl-statement-if-add-missing-braces
+++ a/drivers/char/sx.c
@@ -1746,9 +1746,10 @@ static long sx_fw_ioctl(struct file *fil
 		sx_dprintk(SX_DEBUG_FIRMWARE, "returning type=3D %ld\n", rc);
 		break;
 	case SXIO_DO_RAMTEST:
-		if (sx_initialized)	/* Already initialized: better not ramtest the b=
oard.  */
+		if (sx_initialized) {	/* Already initialized: better not ramtest the=
 board.  */
 			rc =3D -EPERM;
 			break;
+		}
 		if (IS_SX_BOARD(board)) {
 			rc =3D do_memtest(board, 0, 0x7000);
 			if (!rc)
_

Patches currently in -mm which might be from ilpo.jarvinen@helsinki.fi =
are

sxc-fix-dbl-statement-if-add-missing-braces.patch
linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
