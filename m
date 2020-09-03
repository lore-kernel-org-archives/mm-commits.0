Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC86C433E9
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749D6208C7
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 19:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599163154;
	bh=TemimDKil+1enUNBK7fqlz+oIJrNpXb51aJUO3XRpiQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=GrajbKPZHO3J0M/L4t9ClFCW6g5g2aN/XwwLDoEjg4TVPsKFVJFqRjL4lS2lLzFU+
	 m2qfoWe8ymPRev5antrn0OmbwVIUduXmcv4/e+2WDnSNcFNdmgUVZQFl4CrlQqETtN
	 NhFba8eHLFEiJPRnHiVAFrv22TgvEf7Pl+XC+ez8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgICT7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 15:59:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727065AbgICT7N (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 15:59:13 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC75C20716;
        Thu,  3 Sep 2020 19:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599163152;
        bh=TemimDKil+1enUNBK7fqlz+oIJrNpXb51aJUO3XRpiQ=;
        h=Date:From:To:Subject:From;
        b=UOrUsufIRbnUNynK51z8RBHCsAtm5PBaOOggLdWu91aGOsgB8mTNcyU/93ZIDiZ8g
         EjPyjKw7twpVlTuwjqRT2H1s7Mw4ATxrz5O2sw9bj9nzZX+rCOO710jmFiGgtlZm3S
         vAow6gi57WMPXJilq2NyG3slyiZaplZwo+SDCz6E=
Date:   Thu, 03 Sep 2020 12:59:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mhocko@kernel.org, guro@fb.com, lixinhai.lxh@gmail.com
Subject:  [to-be-updated]
 mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
 removed from -mm tree
Message-ID: <20200903195911.vpLmH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: try preferred node first when alloc gigantic page from cma
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Li Xinhai <lixinhai.lxh@gmail.com>
Subject: mm/hugetlb: try preferred node first when alloc gigantic page from cma

Since commit cf11e85fc08cc6a4 ("mm: hugetlb: optionally allocate gigantic
hugepages using cma"), the gigantic page would be allocated from node
which is not the preferred node, although there are pages available from
that node.  The reason is that the nid parameter has been ignored in
alloc_gigantic_page().

After this patch, the preferred node is tried first before other allowed
nodes.

Link: http://lkml.kernel.org/r/20200830140418.605627-1-lixinhai.lxh@gmail.com
Fixes: cf11e85fc08cc6a4 ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Li Xinhai <lixinhai.lxh@gmail.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma
+++ a/mm/hugetlb.c
@@ -1256,8 +1256,15 @@ static struct page *alloc_gigantic_page(
 		struct page *page;
 		int node;
 
+		if (hugetlb_cma[nid]) {
+			page = cma_alloc(hugetlb_cma[nid], nr_pages,
+					huge_page_order(h), true);
+			if (page)
+				return page;
+		}
+
 		for_each_node_mask(node, *nodemask) {
-			if (!hugetlb_cma[node])
+			if (node == nid || !hugetlb_cma[node])
 				continue;
 
 			page = cma_alloc(hugetlb_cma[node], nr_pages,
_

Patches currently in -mm which might be from lixinhai.lxh@gmail.com are

mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch

