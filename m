From: akpm@linux-foundation.org
Subject: [merged] scripts-pnmtologo-fix-for-plain-pbm.patch removed from -mm tree
Date: Mon, 26 Nov 2012 14:21:55 -0800
Message-ID: <20121126222155.A2C8E10004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39389 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab2KZWV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Nov 2012 17:21:58 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so840689vcd.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Nov 2012 14:21:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas@biessmann.de, geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/pnmtologo: fix for plain PBM
has been removed from the -mm tree.  Its filename was
     scripts-pnmtologo-fix-for-plain-pbm.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
=46rom: Andreas Bie=DFmann <andreas@biessmann.de>
Subject: scripts/pnmtologo: fix for plain PBM

PBM generated with current tools do not have a whitespace between the
digits.  Therefore the pnmtologo tool fails to gernerate the required
C-Array for these images.  This patch fixes that behaviour and can hand=
le
both 'old style' and 'new style' PBM files.

Signed-off-by: Andreas Bie=DFmann <andreas@biessmann.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/pnmtologo.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/pnmtologo.c~scripts-pnmtologo-fix-for-plain-pbm scrip=
ts/pnmtologo.c
--- a/scripts/pnmtologo.c~scripts-pnmtologo-fix-for-plain-pbm
+++ a/scripts/pnmtologo.c
@@ -74,6 +74,7 @@ static unsigned int logo_height;
 static struct color **logo_data;
 static struct color logo_clut[MAX_LINUX_LOGO_COLORS];
 static unsigned int logo_clutsize;
+static int is_plain_pbm =3D 0;
=20
 static void die(const char *fmt, ...)
     __attribute__ ((noreturn)) __attribute ((format (printf, 1, 2)));
@@ -103,6 +104,11 @@ static unsigned int get_number(FILE *fp)
     val =3D 0;
     while (isdigit(c)) {
 	val =3D 10*val+c-'0';
+	/* some PBM are 'broken'; GiMP for example exports a PBM without spac=
e
+	 * between the digits. This is Ok cause we know a PBM can only have a=
 '1'
+	 * or a '0' for the digit. */
+	if (is_plain_pbm)
+		break;
 	c =3D fgetc(fp);
 	if (c =3D=3D EOF)
 	    die("%s: end of file\n", filename);
@@ -167,6 +173,7 @@ static void read_image(void)
     switch (magic) {
 	case '1':
 	    /* Plain PBM */
+	    is_plain_pbm =3D 1;
 	    for (i =3D 0; i < logo_height; i++)
 		for (j =3D 0; j < logo_width; j++)
 		    logo_data[i][j].red =3D logo_data[i][j].green =3D
_

Patches currently in -mm which might be from andreas@biessmann.de are

linux-next.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
