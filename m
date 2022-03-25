Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89DDC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357382AbiCYBdy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357458AbiCYBdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50FDBF513
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B7B261937
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73FCC340EC;
        Fri, 25 Mar 2022 01:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171877;
        bh=0Px1vZ/2fv2mpzjGy8iZEPoWUUxhIO7Z3TGtAeR8gIE=;
        h=Date:To:From:Subject:From;
        b=Td+1qaKoYTkiD3GwCb+OgZ8pesk2hT/CYFWUqxgHeD8vkh5Pl+YYLGJlcYKZK7V/v
         M1KWsoZJWQlc32Oup9fykhGUkB+4sePhGIjxZ7F+gdMo2EE7H/Be3aVQgY8hk0HVfr
         pAzsFPNdPYdfpVymrYYs15rSsyErXVUFVza4Vzzg=
Date:   Thu, 24 Mar 2022 18:31:17 -0700
To:     mm-commits@vger.kernel.org, rppt@linux.ibm.com, david@redhat.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-mmzoneh-remove-unused-macros.patch removed from -mm tree
Message-Id: <20220325013117.A73FCC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmzone.h: remove unused macros
has been removed from the -mm tree.  Its filename was
     mm-mmzoneh-remove-unused-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/mmzone.h: remove unused macros

Remove pgdat_page_nr, nid_page_nr and NODE_MEM_MAP. They are unused now.

Link: https://lkml.kernel.org/r/20220127093210.62293-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/linux/mmzone.h~mm-mmzoneh-remove-unused-macros
+++ a/include/linux/mmzone.h
@@ -931,12 +931,6 @@ typedef struct pglist_data {
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
 #define node_spanned_pages(nid)	(NODE_DATA(nid)->node_spanned_pages)
-#ifdef CONFIG_FLATMEM
-#define pgdat_page_nr(pgdat, pagenr)	((pgdat)->node_mem_map + (pagenr))
-#else
-#define pgdat_page_nr(pgdat, pagenr)	pfn_to_page((pgdat)->node_start_pfn + (pagenr))
-#endif
-#define nid_page_nr(nid, pagenr) 	pgdat_page_nr(NODE_DATA(nid),(pagenr))
 
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 #define node_end_pfn(nid) pgdat_end_pfn(NODE_DATA(nid))
@@ -1112,7 +1106,6 @@ static inline struct pglist_data *NODE_D
 {
 	return &contig_page_data;
 }
-#define NODE_MEM_MAP(nid)	mem_map
 
 #else /* CONFIG_NUMA */
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

