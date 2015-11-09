From: akpm@linux-foundation.org
Subject: [merged]
 lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch removed from
 -mm tree
Date: Mon, 09 Nov 2015 11:45:52 -0800
Message-ID: <5640f7f0.utNiU/onn9kRo+c+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbKITpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 14:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: also improve sanity check in bstr_printf()
has been removed from the -mm tree.  Its filename was
     lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: lib/vsprintf.c: also improve sanity check in bstr_printf()

Quoting from 2aa2f9e21e4e ("lib/vsprintf.c: improve sanity check in
vsnprintf()"):

    On 64 bit, size may very well be huge even if bit 31 happens to be 0.
    Somehow it doesn't feel right that one can pass a 5 GiB buffer but not a
    3 GiB one.  So cap at INT_MAX as was probably the intention all along.
    This is also the made-up value passed by sprintf and vsprintf.

I should have seen this copy-pasted instance back then, but let's just
do it now.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Martin Kletzander <mkletzan@redhat.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/vsprintf.c~lib-vsprintfc-also-improve-sanity-check-in-bstr_printf lib/vsprintf.c
--- a/lib/vsprintf.c~lib-vsprintfc-also-improve-sanity-check-in-bstr_printf
+++ a/lib/vsprintf.c
@@ -2270,7 +2270,7 @@ int bstr_printf(char *buf, size_t size,
 	char *str, *end;
 	const char *args = (const char *)bin_buf;
 
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE(size > INT_MAX))
 		return 0;
 
 	str = buf;
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch
slabh-sprinkle-__assume_aligned-attributes.patch

