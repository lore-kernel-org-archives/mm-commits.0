From: akpm@linux-foundation.org
Subject: [merged] lib-vsprintfc-remove-special-handling-in-pointer.patch
 removed from -mm tree
Date: Mon, 09 Nov 2015 11:45:54 -0800
Message-ID: <5640f7f2.5pj0g3jdYvnfeqQ5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbKITpy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: remove SPECIAL handling in pointer()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-remove-special-handling-in-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch
slabh-sprinkle-__assume_aligned-attributes.patch

