Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284A2C433E2
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 20:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0499D204EA
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 20:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598818557;
	bh=vKuvxcRhsXcmdOnxZpC+IVE/+GZORlz0okk8ue+VixI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=XADiShMMRzZwIzrOvwkPwN8cea1X9fKJt2H5TfOSU5RJ1183etImKYefSQZGhAUps
	 Hn2420jNw4hrAzMwzgJqP4DOUojSXNjMHWB+u7z2CRwgmV7+3wENnaRwwe68i0Nam1
	 XMmdukPw2DCKEGXDpBA2f16qN1I6HBI+RgcB483M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgH3UPz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 16:15:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726150AbgH3UPy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 16:15:54 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D37C204EA;
        Sun, 30 Aug 2020 20:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598818553;
        bh=vKuvxcRhsXcmdOnxZpC+IVE/+GZORlz0okk8ue+VixI=;
        h=Date:From:To:Subject:From;
        b=EXa/jbNLQl/COuZmJAwoQLjO39zDXA7q3F/wXZ3VL4vW08Dc4GFzh8ePMeJ92bS3J
         ryFJfksuN0BGYi8IPQD/lC7HfPV/GJO+BUdH+RFOGqXFjY2mIkLXk2WAV+XFkoHwEs
         IiCkUQ4PfnOvDsMr8CAlleUNohK4oUIs9u30EInM=
Date:   Sun, 30 Aug 2020 13:15:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        mhocko@kernel.org, guro@fb.com, lixinhai.lxh@gmail.com
Subject:  +
 mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
 added to -mm tree
Message-ID: <20200830201552.baL4Q%akpm@linux-foundation.org>
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
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch

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

mm-hugetlb-try-preferred-node-first-when-alloc-gigantic-page-from-cma.patch
mm-isolation-avoid-checking-unmovable-pages-across-pageblock-boundary.patch

