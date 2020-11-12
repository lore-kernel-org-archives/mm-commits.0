Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73226C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:27:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A914216FD
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:27:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufBr74FC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgKLX1Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:27:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbgKLX1X (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:27:23 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E18D622201;
        Thu, 12 Nov 2020 23:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605223642;
        bh=3F4eIhprxOEjMEiqv+YLxGAUxoCmR3h10YvQapVtMdw=;
        h=Date:From:To:Subject:From;
        b=ufBr74FC4oD4iHW4xDFBzGedy3Xdg3eJ9bx9L5rFAKmfjnQbpviltt7EtxcQWE06l
         vEeBJLQJsFwPDNckgl3bPlCf+hXao4lqUk2NtZDY8Ec45rt3sqZsCzOEdCY/zMVmQP
         YJo3I8VSDuGubZIuOqEOOg1xXADylb//kYFYq97o=
Date:   Thu, 12 Nov 2020 15:27:21 -0800
From:   akpm@linux-foundation.org
To:     akinobu.mita@gmail.com, david@redhat.com, glider@google.com,
        keescook@chromium.org, labbott@kernel.org, len.brown@intel.com,
        mateusznosek0@gmail.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, pavel@ucw.cz, rjw@rjwysocki.net,
        rppt@linux.ibm.com, vbabka@suse.cz
Subject:  [to-be-updated]
 mm-page_poison-remove-config_page_poisoning_zero.patch removed from -mm
 tree
Message-ID: <20201112232721.4YUZ1q9hW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_poison: remove CONFIG_PAGE_POISONING_ZERO
has been removed from the -mm tree.  Its filename was
     mm-page_poison-remove-config_page_poisoning_zero.patch

This patch was dropped because an updated version will be merged

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

Link: https://lkml.kernel.org/r/20201103152237.9853-6-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Mateusz Nosek <mateusznosek0@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
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
@@ -2222,12 +2222,6 @@ static inline int check_new_page(struct
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
@@ -2297,7 +2291,7 @@ static void prep_new_page(struct page *p
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

