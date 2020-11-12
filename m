Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24AD8C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8252216FD
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:23:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q9kaP3K2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgKLXXy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:23:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725929AbgKLXXy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:23:54 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2AEA216C4;
        Thu, 12 Nov 2020 23:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223433;
        bh=zzxFJZ5t0T2FW/gi/cJdI4pjiEyZn2Vtmyp+PInXIrc=;
        h=Date:From:To:Subject:From;
        b=Q9kaP3K2xEjdYiE/vUopxabEt6JOX2fGaY1Mb1sHcFH4mUkJ+i4e4IRSeJj5vAICz
         85UxarVKAQjnl1pyax0WYnwllPBExXiHm1ZHBKtuvK+Nx4HH6wBItlMpT/+CbfA/gH
         s0E2UVd/9VraYjTz3BK3pu826jQtjUvMGs/BcYUI=
Date:   Thu, 12 Nov 2020 15:23:52 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-page_poison-use-static-key-more-efficiently-fix.patch added to -mm tree
Message-ID: <20201112232352.i1Ti5BOwt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: use static key more efficiently-fix
has been added to the -mm tree.  Its filename is
     mm-page_poison-use-static-key-more-efficiently-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poison-use-static-key-more-efficiently-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poison-use-static-key-more-efficiently-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_poison: use static key more efficiently-fix

Non-functional cleanups, per David Hildenbrand.

Link: https://lkml.kernel.org/r/c4eb5301-0435-d296-5d32-a76ac58787b2@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 +++++++++++++---
 mm/page_alloc.c    |    7 +++----
 mm/page_poison.c   |    4 ++--
 3 files changed, 18 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-page_poison-use-static-key-more-efficiently-fix
+++ a/include/linux/mm.h
@@ -2852,8 +2852,8 @@ extern int apply_to_existing_page_range(
 
 extern void init_mem_debugging_and_hardening(void);
 #ifdef CONFIG_PAGE_POISONING
-extern void kernel_poison_pages(struct page *page, int numpages);
-extern void kernel_unpoison_pages(struct page *page, int numpages);
+extern void __kernel_poison_pages(struct page *page, int numpages);
+extern void __kernel_unpoison_pages(struct page *page, int numpages);
 extern bool _page_poisoning_enabled_early;
 DECLARE_STATIC_KEY_FALSE(_page_poisoning_enabled);
 static inline bool page_poisoning_enabled(void)
@@ -2866,7 +2866,17 @@ static inline bool page_poisoning_enable
  */
 static inline bool page_poisoning_enabled_static(void)
 {
-	return (static_branch_unlikely(&_page_poisoning_enabled));
+	return static_branch_unlikely(&_page_poisoning_enabled);
+}
+static inline void kernel_poison_pages(struct page *page, int numpages)
+{
+	if (page_poisoning_enabled_static())
+		__kernel_poison_pages(page, numpages);
+}
+static inline void kernel_unpoison_pages(struct page *page, int numpages)
+{
+	if (page_poisoning_enabled_static())
+		__kernel_unpoison_pages(page, numpages);
 }
 #else
 static inline bool page_poisoning_enabled(void) { return false; }
--- a/mm/page_alloc.c~mm-page_poison-use-static-key-more-efficiently-fix
+++ a/mm/page_alloc.c
@@ -1271,8 +1271,8 @@ static __always_inline bool free_pages_p
 	if (want_init_on_free())
 		kernel_init_free_pages(page, 1 << order);
 
-	if (page_poisoning_enabled_static())
-		kernel_poison_pages(page, 1 << order);
+	kernel_poison_pages(page, 1 << order);
+
 	/*
 	 * arch_free_page() can make the page's contents inaccessible.  s390
 	 * does this.  So nothing which can access the page's contents should
@@ -2287,8 +2287,7 @@ inline void post_alloc_hook(struct page
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
 	kasan_alloc_pages(page, order);
-	if (page_poisoning_enabled_static())
-		kernel_unpoison_pages(page, 1 << order);
+	kernel_unpoison_pages(page, 1 << order);
 	set_page_owner(page, order, gfp_flags);
 }
 
--- a/mm/page_poison.c~mm-page_poison-use-static-key-more-efficiently-fix
+++ a/mm/page_poison.c
@@ -30,7 +30,7 @@ static void poison_page(struct page *pag
 	kunmap_atomic(addr);
 }
 
-void kernel_poison_pages(struct page *page, int n)
+void __kernel_poison_pages(struct page *page, int n)
 {
 	int i;
 
@@ -89,7 +89,7 @@ static void unpoison_page(struct page *p
 	kunmap_atomic(addr);
 }
 
-void kernel_unpoison_pages(struct page *page, int n)
+void __kernel_unpoison_pages(struct page *page, int n)
 {
 	int i;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
mm-page_poison-use-static-key-more-efficiently-fix.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking-fix.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

