From: akpm@linux-foundation.org
Subject: + string-factorize-skip_spaces-and-export-it-to-be-generally-available.patch added to -mm tree
Date: Fri, 04 Dec 2009 14:32:11 -0800
Message-ID: <200912042232.nB4MWBQJ011606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932441AbZLDWc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2009 17:32:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre.goddard@gmail.com


The patch titled
     string: factorize skip_spaces and export it to be generally availa=
ble
has been added to the -mm tree.  Its filename is
     string-factorize-skip_spaces-and-export-it-to-be-generally-availab=
le.patch

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
Subject: string: factorize skip_spaces and export it to be generally av=
ailable
=46rom: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>

On the following sentence:
    while (*s && isspace(*s))
        s++;

If *s =3D=3D 0, isspace() evaluates to ((_ctype[*s] & 0x20) !=3D 0), wh=
ich
evaluates to ((0x08 & 0x20) !=3D 0) which equals to 0 as well.
If *s =3D=3D 1, we depend on isspace() result anyway. In other words,
"a char equals zero is never a space", so remove this check.

Also, *s !=3D 0 is most common case (non-null string).

=46ixed const return as noticed by Jan Engelhardt and James Bottomley.
=46ixed unnecessary extra cast on strstrip() as noticed by Jan Engelhar=
dt.

Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ctype.h  |    1 +
 include/linux/string.h |    1 +
 lib/string.c           |   19 +++++++++++++++----
 3 files changed, 17 insertions(+), 4 deletions(-)

diff -puN include/linux/ctype.h~string-factorize-skip_spaces-and-export=
-it-to-be-generally-available include/linux/ctype.h
--- a/include/linux/ctype.h~string-factorize-skip_spaces-and-export-it-=
to-be-generally-available
+++ a/include/linux/ctype.h
@@ -27,6 +27,7 @@ extern const unsigned char _ctype[];
 #define islower(c)	((__ismask(c)&(_L)) !=3D 0)
 #define isprint(c)	((__ismask(c)&(_P|_U|_L|_D|_SP)) !=3D 0)
 #define ispunct(c)	((__ismask(c)&(_P)) !=3D 0)
+/* Note: isspace() must return false for %NUL-terminator */
 #define isspace(c)	((__ismask(c)&(_S)) !=3D 0)
 #define isupper(c)	((__ismask(c)&(_U)) !=3D 0)
 #define isxdigit(c)	((__ismask(c)&(_D|_X)) !=3D 0)
diff -puN include/linux/string.h~string-factorize-skip_spaces-and-expor=
t-it-to-be-generally-available include/linux/string.h
--- a/include/linux/string.h~string-factorize-skip_spaces-and-export-it=
-to-be-generally-available
+++ a/include/linux/string.h
@@ -62,6 +62,7 @@ extern char * strnchr(const char *, size
 #ifndef __HAVE_ARCH_STRRCHR
 extern char * strrchr(const char *,int);
 #endif
+extern char * __must_check skip_spaces(const char *);
 extern char * __must_check strstrip(char *);
 #ifndef __HAVE_ARCH_STRSTR
 extern char * strstr(const char *,const char *);
diff -puN lib/string.c~string-factorize-skip_spaces-and-export-it-to-be=
-generally-available lib/string.c
--- a/lib/string.c~string-factorize-skip_spaces-and-export-it-to-be-gen=
erally-available
+++ a/lib/string.c
@@ -338,6 +338,20 @@ EXPORT_SYMBOL(strnchr);
 #endif
=20
 /**
+ * skip_spaces - Removes leading whitespace from @s.
+ * @s: The string to be stripped.
+ *
+ * Returns a pointer to the first non-whitespace character in @s.
+ */
+char *skip_spaces(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return (char *)str;
+}
+EXPORT_SYMBOL(skip_spaces);
+
+/**
  * strstrip - Removes leading and trailing whitespace from @s.
  * @s: The string to be stripped.
  *
@@ -360,10 +374,7 @@ char *strstrip(char *s)
 		end--;
 	*(end + 1) =3D '\0';
=20
-	while (*s && isspace(*s))
-		s++;
-
-	return s;
+	return skip_spaces(s);
 }
 EXPORT_SYMBOL(strstrip);
=20
_

Patches currently in -mm which might be from andre.goddard@gmail.com ar=
e

linux-next.patch
vsprintf-factorize-null-string.patch
vsprintf-pre-calculate-final-string-length-for-later-use.patch
vsprintf-give-it-some-care-to-please-checkpatchpl.patch
vsprintf-use-tolower-whenever-possible.patch
vsprintf-reduce-code-size-by-avoiding-extra-check.patch
vsprintf-move-local-vars-to-block-local-vars-and-remove-unneeded-ones.p=
atch
vsprintf-factor-out-skip_space-code-in-a-separate-function.patch
vsprintf-reuse-almost-identical-simple_strtoulx-functions.patch
ctype-constify-read-only-_ctype-string.patch
string-factorize-skip_spaces-and-export-it-to-be-generally-available.pa=
tch
string-on-strstrip-first-remove-leading-spaces-before-running-over-str.=
patch
tree-wide-convert-open-calls-to-remove-spaces-to-skip_spaces-lib-functi=
on.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
