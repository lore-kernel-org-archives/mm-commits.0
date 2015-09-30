From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-remove-special-handling-in-pointer.patch added to -mm tree
Date: Wed, 30 Sep 2015 14:32:47 -0700
Message-ID: <560c54ff.0Ei3OeMCVN+SV3dG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbbI3Vcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: remove SPECIAL handling in pointer()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-remove-special-handling-in-pointer.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-remove-special-handling-in-pointer.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-remove-special-handling-in-pointer.patch

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
Subject: lib/vsprintf.c: remove SPECIAL handling in pointer()

As a quick

   git grep -E '%[ +0#-]*#[ +0#-]*(\*|[0-9]+)?(\.(\*|[0-9]+)?)?p'

shows, nobody uses the # flag with %p. Should one try to do so, one
will be met with

  warning: `#' flag used with `%p' gnu_printf format [-Wformat]

(POSIX and C99 both say "... For other conversion specifiers, the
behavior is undefined.". Obviously, the kernel can choose to define
the behaviour however it wants, but as long as gcc issues that
warning, users are unlikely to show up.)

Since default_width is effectively always 2*sizeof(void*), we can
simplify the prologue of pointer() and save a few instructions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Martin Kletzander <mkletzan@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-remove-special-handling-in-pointer lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-remove-special-handling-in-pointer
+++ a/lib/vsprintf.c
@@ -1460,7 +1460,7 @@ static noinline_for_stack
 char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 	      struct printf_spec spec)
 {
-	int default_width = 2 * sizeof(void *) + (spec.flags & SPECIAL ? 2 : 0);
+	const int default_width = 2 * sizeof(void *);
 
 	if (!ptr && *fmt != 'K') {
 		/*
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

