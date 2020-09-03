Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F943C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCDA6208FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 20:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599163378;
	bh=gYIFAS7Q4EwihsdGAJRgPY7rjj3pUyvytBzXQlYZ9Xc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yS0Nn/DsizqGTuuKshH7N2j3t6zyTBxcZG1qcL0ZpNrBjfsJJtvjZWIm+wquHhXTh
	 KphXL7zOVTg0hKeXeR20i6Yrz/UV05jg1krRRpf1026V4Fb4vDzQ91cCCy2RCAgwt/
	 H+UVJi+76owevXQ9boXQ7S3S5xnxqVC9uppUeDrU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgICUCu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:02:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728988AbgICUCo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 16:02:44 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9033E208C7;
        Thu,  3 Sep 2020 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599163363;
        bh=gYIFAS7Q4EwihsdGAJRgPY7rjj3pUyvytBzXQlYZ9Xc=;
        h=Date:From:To:Subject:From;
        b=onwRyamNlPqr1mT1GTMZDeS7fdBN4WFmpos6hYqC51hnnlqYOwOd9DDmJm4pi722h
         USeELAJSjHq9g79tnFuQ4sNRZXoZxdzJa80J/3eKJ7GhFM3Ow2PIU9EQfQ/+QnBgMC
         pFtTnT5VsFiugVyNo/KjC+QOc/6bgYOdr/0Bp0co=
Date:   Thu, 03 Sep 2020 13:02:43 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mhocko@suse.com, guro@fb.com, lixinhai.lxh@gmail.com
Subject:  +
 mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
 added to -mm tree
Message-ID: <20200903200243.N7mIF%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: try preferred node first when alloc gigantic page from cma
has been added to the -mm tree.  Its filename is
     mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch

