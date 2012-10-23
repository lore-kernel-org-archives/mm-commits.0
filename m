From: akpm@linux-foundation.org
Subject: + scripts-pnmtologo-fix-for-plain-pbm.patch added to -mm tree
Date: Tue, 23 Oct 2012 11:56:09 -0700
Message-ID: <20121023185610.231B35C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:62439 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2JWS4M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Oct 2012 14:56:12 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so252579fae.1
        for <mm-commits@vger.kernel.org>; Tue, 23 Oct 2012 11:56:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andreas@biessmann.de, geert@linux-m68k.org


The patch titled
     Subject: scripts/pnmtologo: fix for plain PBM
has been added to the -mm tree.  Its filename is
     scripts-pnmtologo-fix-for-plain-pbm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

scripts-pnmtologo-fix-for-plain-pbm.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
