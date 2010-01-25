From: akpm@linux-foundation.org
Subject: + lib-stringc-simplify-strnstr.patch added to -mm tree
Date: Mon, 25 Jan 2010 14:42:53 -0800
Message-ID: <201001252242.o0PMgrSf015442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab0AYWnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jan 2010 17:43:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com, fweisbec@gmail.com, joe@perches.com, lizf@cn.fujitsu.com


The patch titled
     lib/string.c: simplify strnstr()
has been added to the -mm tree.  Its filename is
     lib-stringc-simplify-strnstr.patch

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

lib-stringc-simplify-stricmp.patch
lib-stringc-simplify-strnstr.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
