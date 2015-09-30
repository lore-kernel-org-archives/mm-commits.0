From: akpm@linux-foundation.org
Subject: +
 lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch added to -mm tree
Date: Wed, 30 Sep 2015 14:32:43 -0700
Message-ID: <560c54fb.B6ZJv44e0uWePKLh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47327 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbbI3Vco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: handle invalid format specifiers more robustly
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: handle invalid format specifiers more robustly

If we meet any invalid or unsupported format specifier, 'handling' it by
just printing it as a literal string is not safe: Presumably the format
string and the arguments passed gcc's type checking, but that means
something like sprintf(buf, "%n %pd", &intvar, dentry) would end up
interpreting &intvar as a struct dentry*.

When the offending specifier was %n it used to be at the end of the format
string, but we can't rely on that always being the case.  Also, gcc
doesn't complain about some more or less exotic qualifiers (or 'length
modifiers' in posix-speak) such as 'j' or 'q', but being unrecognized by
the kernel's printf implementation, they'd be interpreted as unknown
specifiers, and the rest of arguments would be interpreted wrongly.

So let's complain about anything we don't understand, not just %n, and
stop pretending that we'd be able to make sense of the rest of the
format/arguments.  If the offending specifier is in a printk() call we
unfortunately only get a "BUG: recent printk recursion!", but at least
direct users of the sprintf family will be caught.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Martin Kletzander <mkletzan@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-handle-invalid-format-specifiers-more-robustly lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-handle-invalid-format-specifiers-more-robustly
+++ a/lib/vsprintf.c
@@ -1772,14 +1772,14 @@ qualifier:
 
 	case 'n':
 		/*
-		 * Since %n poses a greater security risk than utility, treat
-		 * it as an invalid format specifier. Warn about its use so
-		 * that new instances don't get added.
+		 * Since %n poses a greater security risk than
+		 * utility, treat it as any other invalid or
+		 * unsupported format specifier.
 		 */
-		WARN_ONCE(1, "Please remove ignored %%n in '%s'\n", fmt);
 		/* Fall-through */
 
 	default:
+		WARN_ONCE(1, "Please remove unsupported %%%c in format string\n", *fmt);
 		spec->type = FORMAT_TYPE_INVALID;
 		return fmt - start;
 	}
@@ -1920,10 +1920,15 @@ int vsnprintf(char *buf, size_t size, co
 			break;
 
 		case FORMAT_TYPE_INVALID:
-			if (str < end)
-				*str = '%';
-			++str;
-			break;
+			/*
+			 * Presumably the arguments passed gcc's type
+			 * checking, but there is no safe or sane way
+			 * for us to continue parsing the format and
+			 * fetching from the va_list; the remaining
+			 * specifiers and arguments would be out of
+			 * sync.
+			 */
+			goto out;
 
 		default:
 			switch (spec.type) {
@@ -1968,6 +1973,7 @@ int vsnprintf(char *buf, size_t size, co
 		}
 	}
 
+out:
 	if (size > 0) {
 		if (str < end)
 			*str = '\0';
@@ -2165,9 +2171,10 @@ do {									\
 
 		switch (spec.type) {
 		case FORMAT_TYPE_NONE:
-		case FORMAT_TYPE_INVALID:
 		case FORMAT_TYPE_PERCENT_CHAR:
 			break;
+		case FORMAT_TYPE_INVALID:
+			goto out;
 
 		case FORMAT_TYPE_WIDTH:
 		case FORMAT_TYPE_PRECISION:
@@ -2229,6 +2236,7 @@ do {									\
 		}
 	}
 
+out:
 	return (u32 *)(PTR_ALIGN(str, sizeof(u32))) - bin_buf;
 #undef save_arg
 }
@@ -2351,12 +2359,14 @@ int bstr_printf(char *buf, size_t size,
 			break;
 
 		case FORMAT_TYPE_PERCENT_CHAR:
-		case FORMAT_TYPE_INVALID:
 			if (str < end)
 				*str = '%';
 			++str;
 			break;
 
+		case FORMAT_TYPE_INVALID:
+			goto out;
+
 		default: {
 			unsigned long long num;
 
@@ -2399,6 +2409,7 @@ int bstr_printf(char *buf, size_t size,
 		} /* switch(spec.type) */
 	} /* while(*fmt) */
 
+out:
 	if (size > 0) {
 		if (str < end)
 			*str = '\0';
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

