From: akpm@linux-foundation.org
Subject: +
 include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse.patch added to -mm tree
Date: Wed, 14 Oct 2015 16:24:17 -0700
Message-ID: <561ee421.O1O4nAx5Sxsy3a1+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbJNXYS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 19:24:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, Valdis.Kletnieks@vt.edu, sparse@chrisli.org, valdis.kletnieks@vt.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/compiler-gcc.h: hide assume_aligned attribute from sparse
has been added to the -mm tree.  Its filename is
     include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse.patch

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
Subject: include/linux/compiler-gcc.h: hide assume_aligned attribute from sparse

The patch "slab.h: sprinkle __assume_aligned attributes" causes *tons* of
whinges if you do 'make C=2' with sparse 0.5.0:

  CHECK   drivers/media/usb/pwc/pwc-if.c
include/linux/slab.h:307:43: error: attribute '__assume_aligned__': unknown attribute
include/linux/slab.h:308:58: error: attribute '__assume_aligned__': unknown attribute
include/linux/slab.h:337:73: error: attribute '__assume_aligned__': unknown attribute
include/linux/slab.h:375:74: error: attribute '__assume_aligned__': unknown attribute
include/linux/slab.h:378:80: error: attribute '__assume_aligned__': unknown attribute

sparse apparently pretends to be gcc >= 4.9, yet isn't prepared to handle
all the function attributes supported by those gccs and complains loudly. 
So hide the definition of __assume_aligned from it (so that the generic
one in compiler.h gets used).

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: "Christopher Li" <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse
+++ a/include/linux/compiler-gcc.h
@@ -211,7 +211,7 @@
 #endif
 
 
-#if GCC_VERSION >= 40900
+#if GCC_VERSION >= 40900 && !defined(__CHECKER__)
 /*
  * __assume_aligned(n, k): Tell the optimizer that the returned
  * pointer can be assumed to be k modulo n. The second argument is
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

compilerh-add-support-for-function-attribute-assume_aligned.patch
include-linux-compiler-gcch-hide-assume_aligned-attribute-from-sparse.patch
slabh-sprinkle-__assume_aligned-attributes.patch
lib-dynamic_debugc-use-kstrdup_const.patch
lib-vsprintfc-handle-invalid-format-specifiers-more-robustly.patch
lib-vsprintfc-also-improve-sanity-check-in-bstr_printf.patch
lib-vsprintfc-remove-special-handling-in-pointer.patch
test_printf-test-printf-family-at-runtime.patch
lib-vsprintfc-update-documentation.patch
lib-introduce-kvasprintf_const.patch
kobject-use-kvasprintf_const-for-formatting-name.patch

