From: akpm@linux-foundation.org
Subject: [merged] lib-stringc-simplify-strnstr.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:24 -0800
Message-ID: <201003091907.o29J7OqX031332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab0CITWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre.goddard@gmail.com, fweisbec@gmail.com, joe@perches.com, lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     lib/string.c: simplify strnstr()
has been removed from the -mm tree.  Its filename was
     lib-stringc-simplify-strnstr.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: lib/string.c: simplify strnstr()
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Joe Perches <joe@perches.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/string.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN lib/string.c~lib-stringc-simplify-strnstr lib/string.c
--- a/lib/string.c~lib-stringc-simplify-strnstr
+++ a/lib/string.c
@@ -689,13 +689,13 @@ EXPORT_SYMBOL(strstr);
  */
 char *strnstr(const char *s1, const char *s2, size_t len)
 {
-	size_t l1 =3D len, l2;
+	size_t l2;
=20
 	l2 =3D strlen(s2);
 	if (!l2)
 		return (char *)s1;
-	while (l1 >=3D l2) {
-		l1--;
+	while (len >=3D l2) {
+		len--;
 		if (!memcmp(s1, s2, l2))
 			return (char *)s1;
 		s1++;
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
