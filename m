From: akpm@linux-foundation.org
Subject: [merged] vsprintf-remove-%n-handling.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:44 -0700
Message-ID: <533f08dc.cDak9EFfiWrfKxPJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43193 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbaDDTcp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, keescook@chromium.org, rmallon@gmail.com

Subject: [merged] vsprintf-remove-%n-handling.patch removed from -mm tree
To: rmallon@gmail.com,keescook@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:44 -0700


The patch titled
     Subject: vsprintf: remove %n handling
has been removed from the -mm tree.  Its filename was
     vsprintf-remove-%n-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1538,10 +1537,6 @@ qualifier:
 		return fmt - start;
 		/* skip alnum */
 
-	case 'n':
-		spec->type = FORMAT_TYPE_NRCHARS;
-		return ++fmt - start;
-
 	case '%':
 		spec->type = FORMAT_TYPE_PERCENT_CHAR;
 		return ++fmt - start;
@@ -1564,6 +1559,15 @@ qualifier:
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
@@ -1737,20 +1741,6 @@ int vsnprintf(char *buf, size_t size, co
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
@@ -2025,19 +2015,6 @@ do {									\
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
 
@@ -2196,10 +2173,6 @@ int bstr_printf(char *buf, size_t size,
 			++str;
 			break;
 
-		case FORMAT_TYPE_NRCHARS:
-			/* skip */
-			break;
