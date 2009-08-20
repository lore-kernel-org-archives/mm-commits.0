From: akpm@linux-foundation.org
Subject: + nftl-fix-offset-alignments.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:26:03 -0700
Message-ID: <200908202126.n7KLQ3Yl014807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41234 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303AbZHTV0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:26:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dimitri.gorokhovik@free.fr, dwmw2@infradead.org, scott@canonical.com, tim.gardner@canonical.com


The patch titled
     nftl: fix offset alignments
has been added to the -mm tree.  Its filename is
     nftl-fix-offset-alignments.patch

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
Subject: nftl: fix offset alignments
=46rom: dimitri.gorokhovik@free.fr
Return-Path: <dimitri.gorokhovik@free.fr>
X-Spam-Checker-Version: SpamAssassin 3.2.4 (2008-01-01) on y.localdomai=
n
X-Spam-Level:=20
X-Spam-Status: No, score=3D0.0 required=3D5.0 tests=3Dnone autolearn=3D=
ham
	version=3D3.2.4
Received: from y.localdomain (y.localdomain [127.0.0.1])
	by y.localdomain (8.14.2/8.14.2) with ESMTP id n7KLGOeb024890
	for <akpm@localhost>; Thu, 20 Aug 2009 14:16:25 -0700
Received: from imap1.linux-foundation.org [140.211.169.55]
	by y.localdomain with POP3 (fetchmail-6.3.8)
	for <akpm@localhost> (single-drop); Thu, 20 Aug 2009 14:16:25 -0700 (P=
DT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [=
140.211.169.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.=
1) with ESMTP id n7KLENDv026441
	for <akpm@imap1.linux-foundation.org>; Thu, 20 Aug 2009 14:14:23 -0700
Received: from wmproxy1-g27.free.fr (wmproxy1-g27.free.fr [212.27.42.91=
])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with E=
SMTP id n7KLDkPS021661
	for <akpm@linux-foundation.org>; Thu, 20 Aug 2009 14:13:48 -0700
Received: from wmproxy1-g27.free.fr (localhost [127.0.0.1])
	by wmproxy1-g27.free.fr (Postfix) with ESMTP id ADA7B2E7C;
	Thu, 20 Aug 2009 23:13:45 +0200 (CEST)
Received: from zimbra3-e1.priv.proxad.net (zimbra3-e1.priv.proxad.net [=
172.20.243.153])
	by wmproxy1-g27.free.fr (Postfix) with ESMTP id 986B52BCE;
	Thu, 20 Aug 2009 23:13:45 +0200 (CEST)
Date: Thu, 20 Aug 2009 23:13:46 +0200 (CEST)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Scott James Remnant <scott@canonical.com>,
        Julia Lawall <julia@diku.dk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <420676341.3665461250802826403.JavaMail.root@zimbra3-e1.pri=
v.proxad.net>
In-Reply-To: <20090819163426.fa90cf9f.akpm@linux-foundation.org>
Subject: Re: [PATCH] nftl: fix offset alignments
MIME-Version: 1.0
Content-Type: text/plain; charset=3Dutf-8
X-Originating-IP: [79.85.212.132]
X-Mailer: Zimbra 5.0 (ZimbraWebClient - [unknown] (Linux)/5.0.15_GA_281=
5.UBUNTU8_64)
X-Authenticated-User: dimitri.gorokhovik@free.fr
X-Virus-Scanned: ClamAV using ClamSMTP
Received-SPF: none (domain of dimitri.gorokhovik@free.fr does not desig=
nate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.188 $
X-Scanned-By: MIMEDefang 2.63 on 140.211.169.13
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by imap1.linux-foun=
dation.org id n7KLENDv026441

"Andrew Morton" <akpm@linux-foundation.org> a =C3=A9crit :
> On Wed, 19 Aug 2009 00:06:28 +0200 (CEST) dimitri.gorokhovik@free.fr
> wrote:
> ...
> > +	typeof(offs) mask =3D mtd->writesize - 1;
>=20
> I see no reason to use typeof here.  Plain old
>=20
> 	loff_t mask =3D mtd->writesize - 1;
>=20
> would be more conventional.

I use typeoff in this way to guard masking code against absent-minded
modifications.=20

Attached is a corrected version as suggested.=20

Maybe Julia can come up with a clever rule for detecting unusual maskin=
g=20
operations automatically :-) ?=20

---
Subject: nftl: fix offset alignments

Arithmetic conversion in the mask computation makes the upper word
of the second argument passed down to mtd->read_oob(), be always 0
(assuming 'offs' being a 64-bit signed long long type, and
'mtd->writesize' being a 32-bit unsigned int type).

This patch applies over the other one adding masking in nftl_write,
"nftl: write support is broken".

Signed-off-by: Dimitri Gorokhovik <dimitri.gorokhovik@free.fr>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Tim Gardner <tim.gardner@canonical.com>
Cc: Scott James Remnant <scott@canonical.com>
---
 drivers/mtd/nftlcore.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/nftlcore.c b/drivers/mtd/nftlcore.c
index 665d3eb..1002e18 100644
--- a/drivers/mtd/nftlcore.c
+++ b/drivers/mtd/nftlcore.c
@@ -135,16 +135,17 @@ static void nftl_remove_dev(struct mtd_blktrans_d=
ev *dev)
 int nftl_read_oob(struct mtd_info *mtd, loff_t offs, size_t len,
 		  size_t *retlen, uint8_t *buf)
 {
+	loff_t mask =3D mtd->writesize - 1;
 	struct mtd_oob_ops ops;
 	int res;
=20
 	ops.mode =3D MTD_OOB_PLACE;
-	ops.ooboffs =3D offs & (mtd->writesize - 1);
+	ops.ooboffs =3D offs & mask;
 	ops.ooblen =3D len;
 	ops.oobbuf =3D buf;
 	ops.datbuf =3D NULL;
=20
-	res =3D mtd->read_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
+	res =3D mtd->read_oob(mtd, offs & ~mask, &ops);
 	*retlen =3D ops.oobretlen;
 	return res;
 }
@@ -155,16 +156,17 @@ int nftl_read_oob(struct mtd_info *mtd, loff_t of=
fs, size_t len,
 int nftl_write_oob(struct mtd_info *mtd, loff_t offs, size_t len,
 		   size_t *retlen, uint8_t *buf)
 {
+	loff_t mask =3D mtd->writesize - 1;
 	struct mtd_oob_ops ops;
 	int res;
=20
 	ops.mode =3D MTD_OOB_PLACE;
-	ops.ooboffs =3D offs & (mtd->writesize - 1);
+	ops.ooboffs =3D offs & mask;
 	ops.ooblen =3D len;
 	ops.oobbuf =3D buf;
 	ops.datbuf =3D NULL;
=20
-	res =3D mtd->write_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
+	res =3D mtd->write_oob(mtd, offs & ~mask, &ops);
 	*retlen =3D ops.oobretlen;
 	return res;
 }
@@ -177,17 +179,18 @@ int nftl_write_oob(struct mtd_info *mtd, loff_t o=
ffs, size_t len,
 static int nftl_write(struct mtd_info *mtd, loff_t offs, size_t len,
 		      size_t *retlen, uint8_t *buf, uint8_t *oob)
 {
+	loff_t mask =3D mtd->writesize - 1;
 	struct mtd_oob_ops ops;
 	int res;
=20
 	ops.mode =3D MTD_OOB_PLACE;
-	ops.ooboffs =3D offs & (mtd->writesize - 1);
+	ops.ooboffs =3D offs & mask;
 	ops.ooblen =3D mtd->oobsize;
 	ops.oobbuf =3D oob;
 	ops.datbuf =3D buf;
 	ops.len =3D len;
=20
-	res =3D mtd->write_oob(mtd, offs & ~(mtd->writesize - 1), &ops);
+	res =3D mtd->write_oob(mtd, offs & ~mask, &ops);
 	*retlen =3D ops.retlen;
 	return res;
 }
--=20
1.6.3.3


Patches currently in -mm which might be from dimitri.gorokhovik@free.fr=
 are

nftl-write-support-is-broken.patch
nftl-fix-offset-alignments.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
