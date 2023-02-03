Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD58C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjBCGm2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbjBCGkv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CED8FB5D
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5145A61DA5
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D2DC433EF;
        Fri,  3 Feb 2023 06:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406268;
        bh=Ynudp2o3BFEF2ngd/KJFCrmc8/56ygu5IB57Nsf2V8k=;
        h=Date:To:From:Subject:From;
        b=KzzNFxV5zTZOPHMi/7S34cl3BghvRre0xxg+RDusFGaKxkLpSAQ+sMP2iTSsQR+eY
         3iIKmOHB4m5nauNZMWMjxw6SBI6nzPWzlZd15uXHWzV7vPlb4XH/KcYN0LR60cjkGP
         /sXipjz5SR/lL2ciIAAJyFuvfHWCLkO2KkHbdr7w=
Date:   Thu, 02 Feb 2023 22:37:48 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org,
        quic_charante@quicinc.com, mhocko@suse.com, lizhe.67@bytedance.com,
        david@redhat.com, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch removed from -mm tree
Message-Id: <20230203063748.A0D2DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_ext: init page_ext early if there are no deferred struct pages
has been removed from the -mm tree.  Its filename was
     mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[pasha.tatashin@soleen.com: fix build with CONFIG_PAGE_EXTENSION=n]
  Link: https://lkml.kernel.org/r/20230118155251.2522985-1-pasha.tatashin@soleen.com
Link: https://lkml.kernel.org/r/20230117204617.1553748-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Li Zhe <lizhe.67@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages
+++ a/include/linux/page_ext.h
@@ -29,6 +29,8 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
+extern bool deferred_struct_pages;
+
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
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


