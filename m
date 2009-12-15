From: akpm@linux-foundation.org
Subject: [merged] vsprintf-pre-calculate-final-string-length-for-later-use.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:16 -0800
Message-ID: <200912152157.nBFLvG4E015705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933851AbZLOWDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:03:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: pre-calculate final string length for later use
has been removed from the -mm tree.  Its filename was
     vsprintf-pre-calculate-final-string-length-for-later-use.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsprintf: pre-calculate final string length for later use
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-pre-calculate-final-string-length-for=
-later-use lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-pre-calculate-final-string-length-for-lat=
er-use
+++ a/lib/vsprintf.c
@@ -1496,13 +1496,14 @@ do {									\
 		case FORMAT_TYPE_STR: {
 			const char *save_str =3D va_arg(args, char *);
 			size_t len;
+
 			if ((unsigned long)save_str > (unsigned long)-PAGE_SIZE
 					|| (unsigned long)save_str < PAGE_SIZE)
 				save_str =3D "(null)";
-			len =3D strlen(save_str);
-			if (str + len + 1 < end)
-				memcpy(str, save_str, len + 1);
-			str +=3D len + 1;
+			len =3D strlen(save_str) + 1;
+			if (str + len < end)
+				memcpy(str, save_str, len);
+			str +=3D len;
 			break;
 		}
=20
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
