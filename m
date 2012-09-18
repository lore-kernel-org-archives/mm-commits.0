From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-improve-standard-conformance-of-sscanf.patch added to -mm tree
Date: Tue, 18 Sep 2012 14:37:04 -0700
Message-ID: <20120918213704.BD7D41E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63266 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2IRVhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 17:37:06 -0400
Received: by yhl10 with SMTP id 10so48518yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 14:37:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@suse.com, jbeulich@suse.com, konrad.wilk@oracle.com


The patch titled
     Subject: lib/vsprintf.c: improve standard conformance of sscanf()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-improve-standard-conformance-of-sscanf.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: lib/vsprintf.c: improve standard conformance of sscanf()

Xen's pciback points out a couple of deficiencies with vsscanf()'s
standard conformance:

- Trailing character matching cannot be checked by the caller: With a
  format string of "(%x:%x.%x) %n" absence of the closing parenthesis
  cannot be checked, as input of "(00:00.0)" doesn't cause the %n to be
  evaluated (because of the code not skipping white space before the
  trailing %n).

- The parameter corresponding to a trailing %n could get filled even if
  there was a matching error: With a format string of "(%x:%x.%x)%n",
  input of "(00:00.0]" would still fill the respective variable pointed to
  (and hence again make the mismatch non-detectable by the caller).

This patch aims at fixing those, but leaves other non-conforming aspects
of it untouched, among them these possibly relevant ones:

- improper handling of the assignment suppression character '*' (blindly
  discarding all succeeding non-white space from the format and input
  strings),

- not honoring conversion specifiers for %n, - not recognizing the C99
  conversion specifier 't' (recognized by vsprintf()).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-improve-standard-conformance-of-sscanf lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-improve-standard-conformance-of-sscanf
+++ a/lib/vsprintf.c
@@ -2019,7 +2019,7 @@ int vsscanf(const char *buf, const char 
 	s16 field_width;
 	bool is_sign;
 
-	while (*fmt && *str) {
+	while (*fmt) {
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
@@ -2044,6 +2044,8 @@ int vsscanf(const char *buf, const char 
 		 * advance both strings to next white space
 		 */
 		if (*fmt == '*') {
+			if (!*str)
+				break;
 			while (!isspace(*fmt) && *fmt != '%' && *fmt)
 				fmt++;
 			while (!isspace(*str) && *str)
@@ -2072,7 +2074,17 @@ int vsscanf(const char *buf, const char 
 			}
 		}
 
-		if (!*fmt || !*str)
+		if (!*fmt)
+			break;
+
+		if (*fmt == 'n') {
+			/* return number of characters read so far */
+			*va_arg(args, int *) = str - buf;
+			++fmt;
+			continue;
+		}
+
+		if (!*str)
 			break;
 
 		base = 10;
@@ -2105,13 +2117,6 @@ int vsscanf(const char *buf, const char 
 			num++;
 		}
 		continue;
-		case 'n':
-			/* return number of characters read so far */
-		{
-			int *i = (int *)va_arg(args, int*);
-			*i = str - buf;
-		}
-		continue;
 		case 'o':
 			base = 8;
 			break;
@@ -2212,16 +2217,6 @@ int vsscanf(const char *buf, const char 
 		str = next;
 	}
 
-	/*
-	 * Now we've come all the way through so either the input string or the
-	 * format ended. In the former case, there can be a %n at the current
-	 * position in the format that needs to be filled.
-	 */
-	if (*fmt == '%' && *(fmt + 1) == 'n') {
-		int *p = (int *)va_arg(args, int *);
-		*p = str - buf;
-	}
