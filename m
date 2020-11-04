Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA471C4742C
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2561206C1
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 01:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604451986;
	bh=RuuMB5wnB7+mvWLhrp1SOgTTsFegUcOCopph71WezuM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=xnvLUMIYEtcnDC1CJw8WmmHO0ExhWJzYhtmdKLXLX5cU3KTDUGTsAtaR5II308kqD
	 XyN7zlrbrL3lEwH/XGRPGjLuAvufvOOLQb2+Bk8IeLVh7HyD+DWDtsSIPShulQiNkt
	 XDTTJgsqiu4+ZNjz4nMG5czAiVu0nBdsMlDrYoV0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgKDBG0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 20:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbgKDBGZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 20:06:25 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 017F62065E;
        Wed,  4 Nov 2020 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604451983;
        bh=RuuMB5wnB7+mvWLhrp1SOgTTsFegUcOCopph71WezuM=;
        h=Date:From:To:Subject:From;
        b=DSbBRn1/0qAIBNBfZ5gUicY9rm7a8cxK19tBHTsS8Ivc1CR3/UhuEv/ngiSBTdg+5
         c6q3Q6pN0ninjyxY0Z5/fRatnfhLEpBow7PWknNldj/X7yG1c4Yg6fTyz0pYewsXeE
         GdHYMh6tG0z+8MjGTwAvHjNauNMe//4MHzWyBp9I=
Date:   Tue, 03 Nov 2020 17:06:22 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, rjw@rjwysocki.net,
        pavel@ucw.cz, mhocko@kernel.org, mateusznosek0@gmail.com,
        len.brown@intel.com, labbott@kernel.org, keescook@chromium.org,
        glider@google.com, david@redhat.com, akinobu.mita@gmail.com,
        vbabka@suse.cz
Subject:  + mm-page_poison-remove-config_page_poisoning_zero.patch
 added to -mm tree
Message-ID: <20201104010622.Cp-Wk%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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
@@ -2214,12 +2214,6 @@ static inline int check_new_page(struct
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
@@ -2289,7 +2283,7 @@ static void prep_new_page(struct page *p
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
mm-page_alloc-do-not-rely-on-the-order-of-page_poison-and-init_on_alloc-free-parameters.patch
mm-page_poison-use-static-key-more-efficiently.patch
kernel-power-allow-hibernation-with-page_poison-sanity-checking.patch
mm-page_poison-remove-config_page_poisoning_no_sanity.patch
mm-page_poison-remove-config_page_poisoning_zero.patch

