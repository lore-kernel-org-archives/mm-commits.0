From: akpm@linux-foundation.org
Subject: [merged] vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:57:33 -0800
Message-ID: <200912152157.nBFLvXC7015728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761246AbZLOV6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vsprintf: reuse almost identical simple_strtoulX() functions
has been removed from the -mm tree.  Its filename was
     vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: vsprintf: reuse almost identical simple_strtoulX() functions
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

The difference between simple_strtoul() and simple_strtoull() is just
the size of the variable used to keep track of the sum of characters
converted to numbers:

unsigned long simple_strtoul() {...}
unsigned long long simple_strtoull(){...}

Both are same size on my Core 2/gcc 4.4.1.
Overflow condition is not checked on both functions, so an extremely la=
rge
string can break these functions so that they don't even notice it.

As we do not care for overflowing on these functions, always keep the s=
um
using the larger variable around (unsigned long long) on simple_strtoul=
l()
and cast it to (unsigned long) on simple_strtoul(), which then becomes
just a wrapper around simple_strtoull().

Code size decreases by 304 bytes:
   text    data     bss     dec     hex filename
  15534       0       8   15542    3cb6 vsprintf.o (ex lib/lib.a-BEFORE=
)
  15230       0       8   15238    3b86 vsprintf.o (ex lib/lib.a-AFTER)

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   48 +++++++++++++----------------------------------
 1 file changed, 14 insertions(+), 34 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-reuse-almost-identical-simple_strtoul=
x-functions lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-reuse-almost-identical-simple_strtoulx-fu=
nctions
+++ a/lib/vsprintf.c
@@ -47,14 +47,14 @@ static unsigned int simple_guess_base(co
 }
=20
 /**
- * simple_strtoul - convert a string to an unsigned long
+ * simple_strtoull - convert a string to an unsigned long long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed her=
e
  * @base: The number base to use
  */
-unsigned long simple_strtoul(const char *cp, char **endp, unsigned int=
 base)
+unsigned long long simple_strtoull(const char *cp, char **endp, unsign=
ed int base)
 {
-	unsigned long result =3D 0;
+	unsigned long long result =3D 0;
=20
 	if (!base)
 		base =3D simple_guess_base(cp);
@@ -76,54 +76,34 @@ unsigned long simple_strtoul(const char=20
=20
 	return result;
 }
-EXPORT_SYMBOL(simple_strtoul);
+EXPORT_SYMBOL(simple_strtoull);
=20
 /**
- * simple_strtol - convert a string to a signed long
+ * simple_strtoul - convert a string to an unsigned long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed her=
e
  * @base: The number base to use
  */
-long simple_strtol(const char *cp, char **endp, unsigned int base)
+unsigned long simple_strtoul(const char *cp, char **endp, unsigned int=
 base)
 {
-	if (*cp =3D=3D '-')
-		return -simple_strtoul(cp + 1, endp, base);
-
-	return simple_strtoul(cp, endp, base);
+	return simple_strtoull(cp, endp, base);
 }
-EXPORT_SYMBOL(simple_strtol);
+EXPORT_SYMBOL(simple_strtoul);
=20
 /**
- * simple_strtoull - convert a string to an unsigned long long
+ * simple_strtol - convert a string to a signed long
  * @cp: The start of the string
  * @endp: A pointer to the end of the parsed string will be placed her=
e
  * @base: The number base to use
  */
-unsigned long long simple_strtoull(const char *cp, char **endp, unsign=
ed int base)
+long simple_strtol(const char *cp, char **endp, unsigned int base)
 {
-	unsigned long long result =3D 0;
-
-	if (!base)
-		base =3D simple_guess_base(cp);
-
-	if (base =3D=3D 16 && cp[0] =3D=3D '0' && TOLOWER(cp[1]) =3D=3D 'x')
-		cp +=3D 2;
-
-	while (isxdigit(*cp)) {
-		unsigned int value;
-
-		value =3D isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
-		if (value >=3D base)
-			break;
-		result =3D result * base + value;
-		cp++;
-	}
-	if (endp)
-		*endp =3D (char *)cp;
+	if (*cp =3D=3D '-')
+		return -simple_strtoul(cp + 1, endp, base);
=20
-	return result;
+	return simple_strtoul(cp, endp, base);
 }
-EXPORT_SYMBOL(simple_strtoull);
+EXPORT_SYMBOL(simple_strtol);
=20
 /**
  * simple_strtoll - convert a string to a signed long long
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
