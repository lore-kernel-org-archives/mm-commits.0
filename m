Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78173C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiCVVox (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236257AbiCVVon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CC8C79
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:43:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A994BB81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:43:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4278BC340EE;
        Tue, 22 Mar 2022 21:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985392;
        bh=bpaFSIc7ZBNjCH63R/S83QHOpSD0M8MAHs9Hh9FydY8=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=czwKs6ZrU8f66mUM0RC9Uf21mb6DMOUtyliQ71R3KtZk3SL+xLFw2vdDz/2PBkgTl
         lQc9pFe8103z2nEGWlZqoZv6n9qgSQVYREgKX3G3ziNjI5/noOhfciMWgdQ78B4ciC
         0UKz6/6Hwhoax3YjjOQ2Yuqev8wGK3AKOVqN7vR8=
Date:   Tue, 22 Mar 2022 14:43:11 -0700
To:     rppt@linux.ibm.com, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 092/227] mm/mmzone.h: remove unused macros
Message-Id: <20220322214312.4278BC340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
