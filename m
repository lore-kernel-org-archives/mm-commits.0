Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA9FC38147
	for <mm-commits@archiver.kernel.org>; Tue, 17 Jan 2023 23:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjAQXpF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Jan 2023 18:45:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjAQXoq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2023 18:44:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9BC49544
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 14:50:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E040E6153F
        for <mm-commits@vger.kernel.org>; Tue, 17 Jan 2023 22:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300A9C433D2;
        Tue, 17 Jan 2023 22:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673995841;
        bh=FgL/ARrPapSpkw//qJdSaKxv8RlVZ5gDjsYgGLmXq3Q=;
        h=Date:To:From:Subject:From;
        b=d7IPyjiiFvAAxkz/U94gmFrT1jDD1AO2u7dHCYl+cYMwKg9OFKuld3ErprnK5woi5
         i+hvg1NiNvY2YrwnqE4sbSAFyg47KfSjpPeX7jEPAbTZfua12NaVXrNyS9/S6pHsY/
         F2fYEkamnAtfz8DyVihSttJHGx0fvzv/PEBwihv4=
Date:   Tue, 17 Jan 2023 14:50:40 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        quic_charante@quicinc.com, mhocko@suse.com, lizhe.67@bytedance.com,
        david@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch added to mm-unstable branch
Message-Id: <20230117225041.300A9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_ext: init page_ext early if there are no deferred struct pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm/page_ext: init page_ext early if there are no deferred struct pages
Date: Tue, 17 Jan 2023 20:46:17 +0000

page_ext must be initialized after all struct pages are initialized. 
Therefore, page_ext is initialized after page_alloc_init_late(), and can
optionally be initialized earlier via early_page_ext kernel parameter
which as a side effect also disables deferred struct pages.

Allow to automatically init page_ext early when there are no deferred
struct pages in order to be able to use page_ext during kernel boot and
track for example page allocations early.

Link: https://lkml.kernel.org/r/20230117204617.1553748-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages
+++ a/include/linux/page_ext.h
@@ -55,6 +55,7 @@ struct page_ext {
 	unsigned long flags;
 };
 
+extern bool deferred_struct_pages;
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
--- a/init/main.c~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages
+++ a/init/main.c
@@ -855,8 +855,8 @@ static void __init mm_init(void)
 	pgtable_init();
 	debug_objects_mem_init();
 	vmalloc_init();
-	/* Should be run after vmap initialization */
-	if (early_page_ext_enabled())
+	/* If no deferred init page_ext now, as vmap is fully initialized */
+	if (!deferred_struct_pages)
 		page_ext_init();
 	/* Should be run before the first non-init thread is created */
 	init_espfix_bsp();
@@ -1628,7 +1628,7 @@ static noinline void __init kernel_init_
 	padata_init();
 	page_alloc_init_late();
 	/* Initialize page ext after all struct pages are initialized. */
-	if (!early_page_ext_enabled())
+	if (deferred_struct_pages)
 		page_ext_init();
 
 	do_basic_setup();
--- a/mm/page_alloc.c~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages
+++ a/mm/page_alloc.c
@@ -430,6 +430,8 @@ EXPORT_SYMBOL(nr_online_nodes);
 
 int page_group_by_mobility_disabled __read_mostly;
 
+bool deferred_struct_pages __meminitdata;
+
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 /*
  * During boot we initialize deferred pages on-demand, as needed, but once
@@ -6803,8 +6805,10 @@ void __meminit memmap_init_range(unsigne
 		if (context == MEMINIT_EARLY) {
 			if (overlap_memmap_init(zone, &pfn))
 				continue;
-			if (defer_init(nid, pfn, zone_end_pfn))
+			if (defer_init(nid, pfn, zone_end_pfn)) {
+				deferred_struct_pages = true;
 				break;
+			}
 		}
 
 		page = pfn_to_page(pfn);
--- a/mm/page_ext.c~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages
+++ a/mm/page_ext.c
@@ -92,7 +92,7 @@ unsigned long page_ext_size;
 static unsigned long total_usage;
 static struct page_ext *lookup_page_ext(const struct page *page);
 
-bool early_page_ext;
+bool early_page_ext __meminitdata;
 static int __init setup_early_page_ext(char *str)
 {
 	early_page_ext = true;
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

