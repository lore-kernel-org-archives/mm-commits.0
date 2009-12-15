From: akpm@linux-foundation.org
Subject: [merged] vsprintf-factorize-null-string.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:13 -0800
Message-ID: <200912152157.nBFLvDOU015702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933802AbZLOV5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: factorize "(null)" string
has been removed from the -mm tree.  Its filename was
     vsprintf-factorize-null-string.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsprintf: factorize "(null)" string
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

This patchset reduces lib/lib.a code size by 482 bytes on my Core 2 wit=
h
gcc 4.4.1 even considering that it exports a newly defined function
skip_spaces() to drivers:

   text    data     bss     dec     hex filename
  64867     840     592   66299   102fb (TOTALS-lib.a-BEFORE)
  64641     584     592   65817   10119 (TOTALS-lib.a-AFTER)
and implements some code tidy up.

Besides reducing lib.a size, it converts many in-tree drivers to use th=
e
newly defined function, which makes another small reduction on kernel s=
ize
overall when those drivers are used.


This patch:

Change "<NULL>" to "(null)", unifying 3 equal strings.
glibc also uses "(null)" for the same purpose.

It decreases code size by 7 bytes:
 text    data     bss     dec     hex filename
15765       0       8   15773    3d9d vsprintf.o (ex lib/lib.a-BEFORE)
15758       0       8   15766    3d96 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-factorize-null-string lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-factorize-null-string
+++ a/lib/vsprintf.c
@@ -546,12 +546,12 @@ static char *number(char *buf, char *end
 	return buf;
 }
=20
-static char *string(char *buf, char *end, char *s, struct printf_spec =
spec)
+static char *string(char *buf, char *end, const char *s, struct printf=
_spec spec)
 {
 	int len, i;
=20
 	if ((unsigned long)s < PAGE_SIZE)
-		s =3D "<NULL>";
+		s =3D "(null)";
=20
 	len =3D strnlen(s, spec.precision);
=20
@@ -1498,7 +1498,7 @@ do {									\
 			size_t len;
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
-				save_str =3D "<NULL>";
+				save_str =3D "(null)";
 			len =3D strlen(save_str);
 			if (str + len + 1 < end)
 				memcpy(str, save_str, len + 1);
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

origin.patch
pid-tighten-pidmap-spinlock-critical-section-by-removing-kfree.patch
pid-reduce-code-size-by-using-a-pointer-to-iterate-over-array.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
