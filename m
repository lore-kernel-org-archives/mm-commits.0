Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECD9C2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B1722D05
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgLPAA1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728587AbgLOX1t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:27:49 -0500
Date:   Tue, 15 Dec 2020 15:23:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074634;
        bh=DHzjAXXbGFerYtp5X0zTU4KWQesx9XqoHatUpSqLfkY=;
        h=From:To:Subject:From;
        b=stA+ztLq1+AAwFKzTQ6Xw8LTSyZTcx6zjcW/fXC2PRPpQrNquVSOxBxqgk+fLW2Zg
         DmI4NbSg9+40HwCnlA9dCYJfk8+quXqVArh2stfFqnvePUEiOu3KXi3Arkepf+28yi
         x37kUjn1m0WUXzVk8sIvmTIvwaNDXR5m0UqSDhdQ=
From:   akpm@linux-foundation.org
To:     david@redhat.com, glider@google.com, keescook@chromium.org,
        labbott@kernel.org, mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rafael.j.wysocki@intel.com,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [merged]
 mm-page_poison-remove-config_page_poisoning_zero.patch removed from -mm
 tree
Message-ID: <20201215232353.U-BVLs67Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_ZERO
has been removed from the -mm tree.  Its filename was
     mm-page_poison-remove-config_page_poisoning_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2228,12 +2228,6 @@ static inline int check_new_page(struct
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
@@ -2296,7 +2290,7 @@ inline void post_alloc_hook(struct page
 	kernel_unpoison_pages(page, 1 << order);
 	set_page_owner(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
+	if (!want_init_on_free() && want_init_on_alloc(gfp_flags))
 		kernel_init_free_pages(page, 1 << order);
 }
 
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


