Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 162EBC71153
	for <mm-commits@archiver.kernel.org>; Sun, 10 Sep 2023 21:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjIJVxe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 10 Sep 2023 17:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjIJVxe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 10 Sep 2023 17:53:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD3136
        for <mm-commits@vger.kernel.org>; Sun, 10 Sep 2023 14:53:30 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06804C433C8;
        Sun, 10 Sep 2023 21:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694382810;
        bh=Qe669+3gmnF9tt67TTvjF0Lb8CU68D3ph8KalNsQ9AU=;
        h=Date:To:From:Subject:From;
        b=QKH93F8DFqVyjqcyVL9tvqTfPAZ2z9R7jHEVYvE3YXuaRFBryhdcRagrfGjTJeQmn
         Tk8MI5e5asGF6PJcbvu/Kwq+0axvh28moVKjYpAGBRXCfVWx6R95iA+0S6Yy/L8p/3
         nAKcFmALETsOgzxhyUdKhlMZaBkwElMiTXaB94P0=
Date:   Sun, 10 Sep 2023 14:53:29 -0700
To:     mm-commits@vger.kernel.org, yuancan@huawei.com,
        muchun.song@linux.dev, mike.kravetz@oracle.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list.patch removed from -mm tree
Message-Id: <20230910215330.06804C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: use bulk allocator in alloc_vmemmap_page_list()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: hugetlb_vmemmap: use bulk allocator in alloc_vmemmap_page_list()
Date: Tue, 5 Sep 2023 18:35:08 +0800

It is needed 4095 pages(1G) or 7 pages(2M) to be allocated once in
alloc_vmemmap_page_list(), so let's add a bulk allocator interface
alloc_pages_bulk_list_node() and switch alloc_vmemmap_page_list() to use
it to accelerate page allocation.

Simple test on arm64's qemu with 1G Hugetlb, 870,842ns vs 3,845,252ns,
even if there is a certain fluctuation, it is still a nice improvement.

Link: https://lkml.kernel.org/r/20230905103508.2996474-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: Yuan Can <yuancan@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h  |    9 +++++++++
 mm/hugetlb_vmemmap.c |    6 ++++++
 2 files changed, 15 insertions(+)

--- a/include/linux/gfp.h~mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list
+++ a/include/linux/gfp.h
@@ -196,6 +196,15 @@ alloc_pages_bulk_list(gfp_t gfp, unsigne
 }
 
 static inline unsigned long
+alloc_pages_bulk_list_node(gfp_t gfp, int nid, unsigned long nr_pages, struct list_head *list)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	return __alloc_pages_bulk(gfp, nid, NULL, nr_pages, list, NULL);
+}
+
+static inline unsigned long
 alloc_pages_bulk_array(gfp_t gfp, unsigned long nr_pages, struct page **page_array)
 {
 	return __alloc_pages_bulk(gfp, numa_mem_id(), NULL, nr_pages, NULL, page_array);
--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-use-bulk-allocator-in-alloc_vmemmap_page_list
+++ a/mm/hugetlb_vmemmap.c
@@ -385,7 +385,13 @@ static int alloc_vmemmap_page_list(unsig
 	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
 	int nid = page_to_nid((struct page *)start);
 	struct page *page, *next;
+	unsigned long nr_allocated;
 
+	nr_allocated = alloc_pages_bulk_list_node(gfp_mask, nid, nr_pages, list);
+	if (!nr_allocated)
+		return -ENOMEM;
+
+	nr_pages -= nr_allocated;
 	while (nr_pages--) {
 		page = alloc_pages_node(nid, gfp_mask, 0);
 		if (!page)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


