Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86401C433ED
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AAF561435
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 22:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233859AbhEMWfB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 18:35:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:40394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233706AbhEMWeb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 13 May 2021 18:34:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E470F6143F;
        Thu, 13 May 2021 22:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620945200;
        bh=H8Tt1SIt7hqfGgfMpiH98YETkkZD+9fdhdFsbUW5SWw=;
        h=Date:From:To:Subject:From;
        b=yoKnnP8NzoCKkxPZBucSVKhIO9u+t/OXUWw2wwB7cCQVcW3cBzvNiRs75fvIpHtAG
         2uPEHMTdzayggrhkuzHUnQdKDw4A0Qil4hyvJtRor3CciMtNfuHlg9Mn8Y0qGPfWGX
         IySnaQl+P0R6gozkfI9kAPut/MLA5FkzP44PUW7E=
Date:   Thu, 13 May 2021 15:33:19 -0700
From:   akpm@linux-foundation.org
To:     42.hyeyoo@gmail.com, cl@linux.com, elver@google.com,
        iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, vbabka@suse.cz
Subject:  +
 =?US-ASCII?Q?mm-slub-change-run-time-assertion-in-kmalloc=5Findex-to-co?=
 =?US-ASCII?Q?mpile-time-fix.patch?= added to -mm tree
Message-ID: <20210513223319.e5vTOc5g7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: test: fix for "mm, slub: change run-time assertion in kmalloc_index() to compile-time"
has been added to the -mm tree.  Its filename is
     mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: kfence: test: fix for "mm, slub: change run-time assertion in kmalloc_index() to compile-time"

Enable using kmalloc_index() in allocator test modules again where the
size may be non-constant, while ensuring normal usage always passes a
constant size.

Split the definition into __kmalloc_index(size, size_is_constant), and a
definition of kmalloc_index(s), matching the old kmalloc_index()
interface, but that still requires size_is_constant==true.  This ensures
that normal usage of kmalloc_index() always passes a constant size.

While the __-prefix should make it clearer that the function is to be used
with care, also rewrite the "Note" to highlight the restriction (and add a
hint to kmalloc_slab()).

The alternative considered here is to export kmalloc_slab(), but given it
is internal to mm/ and not in <linux/slab.h>, we should probably avoid
exporting it.  Allocator test modules will work just fine by using
__kmalloc_index(s, false).

Link: https://lkml.kernel.org/r/20210512195227.245000695c9014242e9a00e5@linux-foundation.org
Link: https://lkml.kernel.org/r/YJ0fN5Ul8i9e/3wC@elver.google.com
Signed-off-by: Marco Elver <elver@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h    |   15 +++++++++++----
 mm/kfence/kfence_test.c |    5 +++--
 2 files changed, 14 insertions(+), 6 deletions(-)

--- a/include/linux/slab.h~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix
+++ a/include/linux/slab.h
@@ -347,10 +347,13 @@ static __always_inline enum kmalloc_cach
  * 2 = 129 .. 192 bytes
  * n = 2^(n-1)+1 .. 2^n
  *
- * Note: there's no need to optimize kmalloc_index because it's evaluated
- * in compile-time.
+ * Note: __kmalloc_index() is compile-time optimized, and not runtime optimized;
+ * typical usage is via kmalloc_index() and therefore evaluated at compile-time.
+ * Callers where !size_is_constant should only be test modules, where runtime
+ * overheads of __kmalloc_index() can be tolerated.  Also see kmalloc_slab().
  */
-static __always_inline unsigned int kmalloc_index(size_t size)
+static __always_inline unsigned int __kmalloc_index(size_t size,
+						    bool size_is_constant)
 {
 	if (!size)
 		return 0;
@@ -386,11 +389,15 @@ static __always_inline unsigned int kmal
 	if (size <=  16 * 1024 * 1024) return 24;
 	if (size <=  32 * 1024 * 1024) return 25;
 
-	BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
+	if (size_is_constant)
+		BUILD_BUG_ON_MSG(1, "unexpected size in kmalloc_index()");
+	else
+		BUG();
 
 	/* Will never be reached. Needed because the compiler may complain */
 	return -1;
 }
+#define kmalloc_index(s) __kmalloc_index(s, true)
 #endif /* !CONFIG_SLOB */
 
 void *__kmalloc(size_t size, gfp_t flags) __assume_kmalloc_alignment __malloc;
--- a/mm/kfence/kfence_test.c~mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix
+++ a/mm/kfence/kfence_test.c
@@ -197,7 +197,7 @@ static void test_cache_destroy(void)
 
 static inline size_t kmalloc_cache_alignment(size_t size)
 {
-	return kmalloc_caches[kmalloc_type(GFP_KERNEL)][kmalloc_index(size)]->align;
+	return kmalloc_caches[kmalloc_type(GFP_KERNEL)][__kmalloc_index(size, false)]->align;
 }
 
 /* Must always inline to match stack trace against caller. */
@@ -267,7 +267,8 @@ static void *test_alloc(struct kunit *te
 
 		if (is_kfence_address(alloc)) {
 			struct page *page = virt_to_head_page(alloc);
-			struct kmem_cache *s = test_cache ?: kmalloc_caches[kmalloc_type(GFP_KERNEL)][kmalloc_index(size)];
+			struct kmem_cache *s = test_cache ?:
+					kmalloc_caches[kmalloc_type(GFP_KERNEL)][__kmalloc_index(size, false)];
 
 			/*
 			 * Verify that various helpers return the right values
_

Patches currently in -mm which might be from elver@google.com are

mm-slub-change-run-time-assertion-in-kmalloc_index-to-compile-time-fix.patch
printk-introduce-dump_stack_lvl-fix.patch

