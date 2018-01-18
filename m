From: akpm@linux-foundation.org
Subject: + sparse-doesnt-support-struct-randomization.patch added to -mm
 tree
Date: Thu, 18 Jan 2018 14:12:43 -0800
Message-ID: <5a611bdb.x+Z1M71p8fIACkqH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45078 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752705AbeARWMo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jan 2018 17:12:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mawilcox@microsoft.com, jpoimboe@redhat.com, keescook@chromium.org, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparse doesn't support struct randomization
has been added to the -mm tree.  Its filename is
     sparse-doesnt-support-struct-randomization.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparse-doesnt-support-struct-randomization.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparse-doesnt-support-struct-randomization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <mawilcox@microsoft.com>
Subject: sparse doesn't support struct randomization

Without this patch, I drown in a sea of unknown attribute warnings

Link: http://lkml.kernel.org/r/20180117024539.27354-1-willy@infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~sparse-doesnt-support-struct-randomization include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~sparse-doesnt-support-struct-randomization
+++ a/include/linux/compiler-gcc.h
@@ -219,7 +219,7 @@
 /* Mark a function definition as prohibited from being cloned. */
 #define __noclone	__attribute__((__noclone__, __optimize__("no-tracer")))
 
-#ifdef RANDSTRUCT_PLUGIN
+#if defined(RANDSTRUCT_PLUGIN) && !defined(__CHECKER__)
 #define __randomize_layout __attribute__((randomize_layout))
 #define __no_randomize_layout __attribute__((no_randomize_layout))
 #endif
_

Patches currently in -mm which might be from mawilcox@microsoft.com are

sparse-doesnt-support-struct-randomization.patch
mm-align-struct-page-more-aesthetically.patch
mm-de-indent-struct-page.patch
mm-remove-misleading-alignment-claims.patch
mm-improve-comment-on-page-mapping.patch
mm-introduce-_slub_counter_t.patch
mm-store-compound_dtor-compound_order-as-bytes.patch
mm-store-compound_dtor-compound_order-as-bytes-fix.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

