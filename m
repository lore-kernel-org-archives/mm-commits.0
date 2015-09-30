From: akpm@linux-foundation.org
Subject: + lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
 added to -mm tree
Date: Wed, 30 Sep 2015 14:32:45 -0700
Message-ID: <560c54fd.x68Txf9bwDrFnOvV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47335 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789AbbI3Vcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:32:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com, keescook@chromium.org, mkletzan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf.c: also improve sanity check in bstr_printf()
has been added to the -mm tree.  Its filename is
     lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch

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

lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

