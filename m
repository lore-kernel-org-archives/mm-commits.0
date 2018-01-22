From: akpm@linux-foundation.org
Subject: [merged] sparse-doesnt-support-struct-randomization.patch
 removed from -mm tree
Date: Mon, 22 Jan 2018 12:54:43 -0800
Message-ID: <20180122205443.Bha-I3aaV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51982 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbeAVUyo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 22 Jan 2018 15:54:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpoimboe@redhat.com, keescook@chromium.org, mawilcox@microsoft.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparse doesn't support struct randomization
has been removed from the -mm tree.  Its filename was
     sparse-doesnt-support-struct-randomization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-align-struct-page-more-aesthetically.patch
mm-de-indent-struct-page.patch
mm-remove-misleading-alignment-claims.patch
mm-improve-comment-on-page-mapping.patch
mm-introduce-_slub_counter_t.patch
mm-store-compound_dtor-compound_order-as-bytes.patch
mm-store-compound_dtor-compound_order-as-bytes-fix.patch
mm-document-how-to-use-struct-page.patch
mm-remove-reference-to-pg_buddy.patch

