Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6D3C43461
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D58208C7
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262572;
	bh=tHoI2OKKbnDdQoI4H40lRqwLc+rBI1kpurzOITT55yk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ON4EoL5YugEujAXp5NgJBdUitGxEMF41oH8mVA/+ZQMTIMBA+i8GJgJOkriRo9OPk
	 fWkLE20ElyqU2++1COD2hXGkvBfIistHkP3EBCEk1wHzeoC/38uDuxmsy5UP+XIBw0
	 cM0z9yZDjnu3MmdCcrmXG4uA/uwt8OmiTLHAEt0I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgIDXgM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXgL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:36:11 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 822272078E;
        Fri,  4 Sep 2020 23:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262570;
        bh=tHoI2OKKbnDdQoI4H40lRqwLc+rBI1kpurzOITT55yk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=coSTLQ8q/IUuHE0BRuefvr+nkFD5C7o8ldVN9ekfR9HsxUzprTtca6dKvVpCKB1fk
         7/SNl1850WRVYXWfnzxCBcleKwCxL+tKdavzIvIKk6mNJXZs+RavMTudUb3H2WQTCv
         bRKM0yLoMyzhf5sq322OX5A/bFoF1sKNPmn8Hv1Q=
Date:   Fri, 04 Sep 2020 16:36:10 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, linux-mm@kvack.org,
        lixinhai.lxh@gmail.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 16/19] mm/hugetlb: try preferred node first when
 alloc gigantic page from cma
Message-ID: <20200904233610.-O0mh69Ys%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/hugetlb: try preferred node first when alloc gigantic page from cma

Since commit cf11e85fc08cc6a4 ("mm: hugetlb: optionally allocate gigantic
hugepages using cma"), the gigantic page would be allocated from node
which is not the preferred node, although there are pages available from
that node.  The reason is that the nid parameter has been ignored in
alloc_gigantic_page().

Besides, the __GFP_THISNODE also need be checked if user required to alloc
only from the preferred node.

After this patch, the preferred node is tried first before other allowed
nodes, and don't try to allocate from other nodes if __GFP_THISNODE is
specified.  If user don't specify the preferred node, the current node
will be used as preferred node, which makes sure consistent behavior of
allocating gigantic and non-gigantic hugetlb page.

Link: https://lkml.kernel.org/r/20200902025016.697260-1-lixinhai.lxh@gmail.com
Fixes: cf11e85fc08cc6a4 ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma
+++ a/mm/hugetlb.c
@@ -1250,21 +1250,32 @@ static struct page *alloc_gigantic_page(
 		int nid, nodemask_t *nodemask)
 {
 	unsigned long nr_pages = 1UL << huge_page_order(h);
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
 
 #ifdef CONFIG_CMA
 	{
 		struct page *page;
 		int node;
 
-		for_each_node_mask(node, *nodemask) {
-			if (!hugetlb_cma[node])
-				continue;
-
-			page = cma_alloc(hugetlb_cma[node], nr_pages,
-					 huge_page_order(h), true);
+		if (hugetlb_cma[nid]) {
+			page = cma_alloc(hugetlb_cma[nid], nr_pages,
+					huge_page_order(h), true);
 			if (page)
 				return page;
 		}
+
+		if (!(gfp_mask & __GFP_THISNODE)) {
+			for_each_node_mask(node, *nodemask) {
+				if (node == nid || !hugetlb_cma[node])
+					continue;
+
+				page = cma_alloc(hugetlb_cma[node], nr_pages,
+						huge_page_order(h), true);
+				if (page)
+					return page;
+			}
+		}
 	}
 #endif
 
_
