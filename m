From: akpm@linux-foundation.org
Subject: [merged] vsprintf-factor-out-skip_space-code-in-a-separate-function.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:30 -0800
Message-ID: <200912152157.nBFLvUF1015725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57118 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761310AbZLOWGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:06:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: factor out skip_space code in a separate function
has been removed from the -mm tree.  Its filename was
     vsprintf-factor-out-skip_space-code-in-a-separate-function.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsprintf: factor out skip_space code in a separate function
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

When converting more caller sites, the inline decision will be left up =
to gcc.

It decreases code size:
 text    data     bss     dec     hex filename
15710       0       8   15718    3d66 vsprintf.o (ex lib/lib.a-BEFORE)
15534       0       8   15542    3cb6 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-factor-out-skip_space-code-in-a-separ=
ate-function lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-factor-out-skip_space-code-in-a-separate-=
function
+++ a/lib/vsprintf.c
@@ -1786,6 +1786,13 @@ EXPORT_SYMBOL_GPL(bprintf);
=20
 #endif /* CONFIG_BINARY_PRINTF */
=20
+static noinline char *skip_space(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return (char *)str;
+}
+
 /**
  * vsscanf - Unformat a buffer into a list of arguments
  * @buf:	input buffer
@@ -1807,10 +1814,8 @@ int vsscanf(const char *buf, const char=20
 		 * white space, including none, in the input.
 		 */
 		if (isspace(*fmt)) {
-			while (isspace(*fmt))
-				++fmt;
-			while (isspace(*str))
-				++str;
+			fmt =3D skip_space(fmt);
+			str =3D skip_space(str);
 		}
=20
 		/* anything that is not a conversion must match exactly */
@@ -1880,8 +1885,7 @@ int vsscanf(const char *buf, const char=20
 			if (field_width =3D=3D -1)
 				field_width =3D INT_MAX;
 			/* first, skip leading white space in buffer */
-			while (isspace(*str))
-				str++;
+			str =3D skip_space(str);
=20
 			/* now copy until next white space */
 			while (*str && !isspace(*str) && field_width--)
@@ -1923,8 +1927,7 @@ int vsscanf(const char *buf, const char=20
 		/* have some sort of integer conversion.
 		 * first, skip white space in buffer.
 		 */
-		while (isspace(*str))
-			str++;
+		str =3D skip_space(str);
=20
 		digit =3D *str;
 		if (is_sign && digit =3D=3D '-')
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
