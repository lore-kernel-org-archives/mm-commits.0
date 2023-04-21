Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0952BC7618E
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 21:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjDUVwt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 17:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbjDUVwq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 17:52:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8986F1FCB
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 14:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2501461A00
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 21:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78545C433D2;
        Fri, 21 Apr 2023 21:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682113963;
        bh=UD47jJlh/JA2WlcPEuXRMJnQX+SeNyp4AQXv9sviUPU=;
        h=Date:To:From:Subject:From;
        b=jAhzRGOiRpEG5J98BNla4FjnY0vTO5fVLURn0GgfNWqaqqgMw3odaxT9m0ughQTYm
         7VWEBtdfkUBxMcthKC4/ZvT7OboRDLXd9f7zNftjkgm5tHl3SBrEb8koVipUVzlNio
         tlmHbAURfASWw2soN/cO22vHfJg4dotDFRhS/Plw=
Date:   Fri, 21 Apr 2023 14:52:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        hughd@google.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list.patch removed from -mm tree
Message-Id: <20230421215243.78545C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: correct arg in reclaim_pages()/reclaim_clean_pages_from_list()
has been removed from the -mm tree.  Its filename was
     mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: correct arg in reclaim_pages()/reclaim_clean_pages_from_list()
Date: Mon, 17 Apr 2023 19:48:07 +0800

Both of them change the arg from page_list to folio_list when convert them
to use a folio, but not the declaration, let's correct it, also move the
reclaim_pages() from swap.h to internal.h as it only used in mm.

Link: https://lkml.kernel.org/r/20230417114807.186786-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviwed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/internal.h        |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list
+++ a/include/linux/swap.h
@@ -442,7 +442,6 @@ extern unsigned long shrink_all_memory(u
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
-extern unsigned long reclaim_pages(struct list_head *page_list);
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
--- a/mm/internal.h~mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list
+++ a/mm/internal.h
@@ -783,8 +783,9 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
+unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
-					    struct list_head *page_list);
+					    struct list_head *folio_list);
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
 #define ALLOC_WMARK_MIN		WMARK_MIN
 #define ALLOC_WMARK_LOW		WMARK_LOW
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwpoison-coredump-support-recovery-from-dump_user_range.patch

