From: akpm@linux-foundation.org
Subject: + vsprintf-remove-%n-handling.patch added to -mm tree
Date: Tue, 28 Jan 2014 13:59:44 -0800
Message-ID: <52e82850.Ba6I5WFr412ozugE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbaA1V7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 16:59:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, rmallon@gmail.com

Subject: + vsprintf-remove-%n-handling.patch added to -mm tree
To: rmallon@gmail.com,keescook@chromium.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 13:59:44 -0800


The patch titled
     Subject: vsprintf: remove %n handling
has been added to the -mm tree.  Its filename is
     vsprintf-remove-%n-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vsprintf-remove-%n-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vsprintf-remove-%n-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Mallon <rmallon@gmail.com>
Subject: vsprintf: remove %n handling

All in-kernel users of %n in format strings have now been removed and the
%n directive is ignored.  Remove the handling of %n so that it is treated
the same as any other invalid format string directive.  Keep a warning in
place to deter new instances of %n in format strings.

Signed-off-by: Ryan Mallon <rmallon@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   45 +++++++++------------------------------------
 1 file changed, 9 insertions(+), 36 deletions(-)

diff -puN lib/vsprintf.c~vsprintf-remove-%n-handling lib/vsprintf.c
--- a/lib/vsprintf.c~vsprintf-remove-%n-handling
+++ a/lib/vsprintf.c
@@ -364,7 +364,6 @@ enum format_type {
 	FORMAT_TYPE_SHORT,
 	FORMAT_TYPE_UINT,
 	FORMAT_TYPE_INT,
-	FORMAT_TYPE_NRCHARS,
 	FORMAT_TYPE_SIZE_T,
 	FORMAT_TYPE_PTRDIFF
 };
@@ -1533,10 +1532,6 @@ qualifier:
 		return fmt - start;
 		/* skip alnum */
 
-	case 'n':
-		spec->type = FORMAT_TYPE_NRCHARS;
-		return ++fmt - start;
-
 	case '%':
 		spec->type = FORMAT_TYPE_PERCENT_CHAR;
 		return ++fmt - start;
@@ -1559,6 +1554,15 @@ qualifier:
 	case 'u':
 		break;
 
+	case 'n':
+		/*
+		 * Since %n poses a greater security risk than utility, treat
+		 * it as an invalid format specifier. Warn about its use so
+		 * that new instances don't get added.
+		 */
+		WARN_ONCE(1, "Please remove ignored %%n in '%s'\n", fmt);
+		/* Fall-through */
+
 	default:
 		spec->type = FORMAT_TYPE_INVALID;
 		return fmt - start;
@@ -1732,20 +1736,6 @@ int vsnprintf(char *buf, size_t size, co
 			++str;
 			break;
 
-		case FORMAT_TYPE_NRCHARS: {
-			/*
-			 * Since %n poses a greater security risk than
-			 * utility, ignore %n and skip its argument.
-			 */
-			void *skip_arg;
-
-			WARN_ONCE(1, "Please remove ignored %%n in '%s'\n",
-					old_fmt);
-
-			skip_arg = va_arg(args, void *);
-			break;
-		}
-
 		default:
 			switch (spec.type) {
 			case FORMAT_TYPE_LONG_LONG:
@@ -2020,19 +2010,6 @@ do {									\
 				fmt++;
 			break;
 
-		case FORMAT_TYPE_NRCHARS: {
-			/* skip %n 's argument */
-			u8 qualifier = spec.qualifier;
-			void *skip_arg;
-			if (qualifier == 'l')
-				skip_arg = va_arg(args, long *);
-			else if (_tolower(qualifier) == 'z')
-				skip_arg = va_arg(args, size_t *);
-			else
-				skip_arg = va_arg(args, int *);
-			break;
-		}
-
 		default:
 			switch (spec.type) {
 
@@ -2191,10 +2168,6 @@ int bstr_printf(char *buf, size_t size,
 			++str;
 			break;
 
-		case FORMAT_TYPE_NRCHARS:
-			/* skip */
-			break;
