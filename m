Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665FEC63777
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B67B2225F
	for <mm-commits@archiver.kernel.org>; Sat, 14 Nov 2020 01:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ple3G64S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgKNBH4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 Nov 2020 20:07:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKNBH4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 13 Nov 2020 20:07:56 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 003DF2225F;
        Sat, 14 Nov 2020 01:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605316075;
        bh=7Blz4CeOQPqQFr6+JqjMA/VXZsz5Cqdci960Y7YYDPo=;
        h=Date:From:To:Subject:From;
        b=Ple3G64SXDA0RsmEkgCYCFMJnMRm1wtobksNuG+P295eId3LwOSxNaBfCGaupzVyt
         /ugPcMl3Po+krVo2G3Y5r8jZLeGiQ6VM+XMm6UUVSoHiwDK+RehBNth5z6BLMgPi1q
         KFzX+aTP3oMaU2kpZQhOHFSubbrC1IXjs91Vvyok=
Date:   Fri, 13 Nov 2020 17:07:54 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        labbott@kernel.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  + mm-page_poison-remove-config_page_poisoning_zero.patch
 added to -mm tree
Message-ID: <20201114010754.LBgdZQ7RN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_ZERO
has been added to the -mm tree.  Its filename is
     mm-page_poison-remove-config_page_poisoning_zero.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_poison-remove-config_page_poisoning_zero.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_poison-remove-config_page_poisoning_zero.patch

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
Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_ZERO

CONFIG_PAGE_POISONING_ZERO uses the zero pattern instead of 0xAA.  It was
introduced by commit 1414c7f4f7d7 ("mm/page_poisoning.c: allow for zero
poisoning"), noting that using zeroes retains the benefit of sanitizing
content of freed pages, with the benefit of not having to zero them again
on alloc, and the downside of making some forms of corruption (stray
writes of NULLs) harder to detect than with the 0xAA pattern.  Together
with CONFIG_PAGE_POISONING_NO_SANITY it made possible to sanitize the
contents on free without checking it back on alloc.

These days we have the init_on_free() option to achieve sanitization with
zeroes and to save clearing on alloc (and without checking on alloc). 
Arguably if someone does choose to check the poison for corruption on
alloc, the savings of not clearing the page are secondary, and it makes
sense to always use the 0xAA poison pattern.  Thus, remove the
CONFIG_PAGE_POISONING_ZERO option for being redundant.

Link: https://lkml.kernel.org/r/20201113104033.22907-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h       |    4 ----
 mm/Kconfig.debug             |   12 ------------
 mm/page_alloc.c              |    8 +-------
 tools/include/linux/poison.h |    6 +-----
 4 files changed, 2 insertions(+), 28 deletions(-)

--- a/include/linux/poison.h~mm-page_poison-remove-config_page_poisoning_zero
+++ a/include/linux/poison.h
@@ -27,11 +27,7 @@
 #define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
 /********** mm/page_poison.c **********/
-#ifdef CONFIG_PAGE_POISONING_ZERO
-#define PAGE_POISON 0x00
-#else
 #define PAGE_POISON 0xaa
-#endif
 
 /********** mm/page_alloc.c ************/
 
--- a/mm/Kconfig.debug~mm-page_poison-remove-config_page_poisoning_zero
+++ a/mm/Kconfig.debug
@@ -80,18 +80,6 @@ config PAGE_POISONING
 
 	  If unsure, say N
 
-config PAGE_POISONING_ZERO
-	bool "Use zero for poisoning instead of debugging value"
-	depends on PAGE_POISONING
-	help
-	   Instead of using the existing poison value, fill the pages with
-	   zeros. This makes it harder to detect when errors are occurring
-	   due to sanitization but the zeroing at free means that it is
-	   no longer necessary to write zeros when GFP_ZERO is used on
-	   allocation.
-
-	   If unsure, say N
-
 config DEBUG_PAGE_REF
 	bool "Enable tracepoint to track down page reference manipulation"
 	depends on DEBUG_KERNEL
--- a/mm/page_alloc.c~mm-page_poison-remove-config_page_poisoning_zero
+++ a/mm/page_alloc.c
@@ -2224,12 +2224,6 @@ static inline int check_new_page(struct
 	return 1;
 }
 
-static inline bool free_pages_prezeroed(void)
-{
-	return (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
-		page_poisoning_enabled_static()) || want_init_on_free();
-}
-
 #ifdef CONFIG_DEBUG_VM
 /*
  * With DEBUG_VM enabled, order-0 pages are checked for expected state when
@@ -2298,7 +2292,7 @@ static void prep_new_page(struct page *p
 {
 	post_alloc_hook(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
+	if (!want_init_on_free() && want_init_on_alloc(gfp_flags))
 		kernel_init_free_pages(page, 1 << order);
 
 	if (order && (gfp_flags & __GFP_COMP))
--- a/tools/include/linux/poison.h~mm-page_poison-remove-config_page_poisoning_zero
+++ a/tools/include/linux/poison.h
@@ -35,12 +35,8 @@
  */
 #define TIMER_ENTRY_STATIC	((void *) 0x300 + POISON_POINTER_DELTA)
 
-/********** mm/debug-pagealloc.c **********/
-#ifdef CONFIG_PAGE_POISONING_ZERO
-#define PAGE_POISON 0x00
-#else
+/********** mm/page_poison.c **********/
 #define PAGE_POISON 0xaa
-#endif
 
 /********** mm/page_alloc.c ************/
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

