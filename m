From: akpm@linux-foundation.org
Subject: + block-m68k-z2ram-correct-printing-of-sector_t.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:56:21 -0700
Message-ID: <201009212356.o8LNuLBS010349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905Ab0IUX4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, axboe@kernel.dk


The patch titled
     drivers/block/z2ram.c: correct printing of sector_t
has been added to the -mm tree.  Its filename is
     block-m68k-z2ram-correct-printing-of-sector_t.patch

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
Subject: drivers/block/z2ram.c: correct printing of sector_t
=46rom: Geert Uytterhoeven <geert@linux-m68k.org>

If CONFIG_LBDAF=3Dy, `sector_t' becomes `u64' instead of `unsigned long=
':

drivers/block/z2ram.c: In function =A1do_z2_request=A2:
drivers/block/z2ram.c:83: warning: format =A1%lu=A2 expects type =A1lon=
g unsigned int=A2, but argument 2 has type =A1sector_t=A2

Hence always cast it to `unsigned long long' for printing.  Also do the
pr_err() dance, while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/z2ram.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/z2ram.c~block-m68k-z2ram-correct-printing-of-se=
ctor_t drivers/block/z2ram.c
--- a/drivers/block/z2ram.c~block-m68k-z2ram-correct-printing-of-sector=
_t
+++ a/drivers/block/z2ram.c
@@ -80,8 +80,10 @@ static void do_z2_request(struct request
 		int err =3D 0;
=20
 		if (start + len > z2ram_size) {
-			printk( KERN_ERR DEVICE_NAME ": bad access: block=3D%lu, count=3D%u=
\n",
-				blk_rq_pos(req), blk_rq_cur_sectors(req));
+			pr_err(DEVICE_NAME ": bad access: block=3D%llu, "
+			       "count=3D%u\n",
+			       (unsigned long long)blk_rq_pos(req),
+			       blk_rq_cur_sectors(req));
 			err =3D -EIO;
 			goto done;
 		}
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
block-m68k-z2ram-correct-printing-of-sector_t.patch
m68knommu-blackfin-remove-old-assembler-only-flags-bit-definitions.patc=
h

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
