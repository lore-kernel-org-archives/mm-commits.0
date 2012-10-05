From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-improve-standard-conformance-of-sscanf.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:53 -0700
Message-ID: <20121005201553.B92671E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51942 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2JEUPy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:54 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236105ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, jbeulich@suse.com, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: improve standard conformance of sscanf()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-improve-standard-conformance-of-sscanf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2017,7 +2017,7 @@ int vsscanf(const char *buf, const char 
 	s16 field_width;
 	bool is_sign;
 
-	while (*fmt && *str) {
+	while (*fmt) {
 		/* skip any white space in format */
 		/* white space in format matchs any amount of
 		 * white space, including none, in the input.
@@ -2042,6 +2042,8 @@ int vsscanf(const char *buf, const char 
 		 * advance both strings to next white space
 		 */
 		if (*fmt == '*') {
+			if (!*str)
+				break;
 			while (!isspace(*fmt) && *fmt != '%' && *fmt)
 				fmt++;
 			while (!isspace(*str) && *str)
@@ -2070,7 +2072,17 @@ int vsscanf(const char *buf, const char 
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
@@ -2103,13 +2115,6 @@ int vsscanf(const char *buf, const char 
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
@@ -2210,16 +2215,6 @@ int vsscanf(const char *buf, const char 
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
