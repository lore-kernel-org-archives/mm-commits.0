Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A4EC4338F
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4C2B6105A
	for <mm-commits@archiver.kernel.org>; Tue,  3 Aug 2021 21:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhHCVtx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Aug 2021 17:49:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230459AbhHCVtt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Aug 2021 17:49:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63E5160F9C;
        Tue,  3 Aug 2021 21:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628027376;
        bh=EwLKOUoTLj1fOiyIJbVu6hQaGiQDwKKRs7z4YvZxHbQ=;
        h=Date:From:To:Subject:From;
        b=r225DBsBO9ktsmk7MU7WzCtNTJovm9V/xGUHJmgPA7ycZP5CZ5tvC1JYvHxQ8CKBI
         Vs1GQmoQBB0KQzb/M5kY9TJAt/+4o9IvqQ3tNcwcnpW9DvsDinqHDA5FaOBR46slKp
         PpOK6EpQaC0EsM4+wUURlOGVzfOlH2oFM6N4YZ5w=
Date:   Tue, 03 Aug 2021 14:49:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        feng.tang@intel.com
Subject:  [to-be-updated]
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch removed
 from -mm tree
Message-ID: <20210803214936.EOll8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix compile warning for !CONFIG_NUMA build
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/hugetlb: fix compile warning for !CONFIG_NUMA build

Stephen Rothwell reported the i386 build with CONFIG_NUMA=n will have a
warning:

mm/hugetlb.c: In function 'dequeue_huge_page_vma':
mm/hugetlb.c:1180:1: warning: label 'check_reserve' defined but not used [-Wunused-label]
 1180 | check_reserve:
       | ^~~~~~~~~~~~~

introduced by commit
    df178183cf05 ("mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY")

Link: https://lkml.kernel.org/r/20210719084752.GA51285@shbuild999.sh.intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2
+++ a/mm/hugetlb.c
@@ -1177,7 +1177,9 @@ static struct page *dequeue_huge_page_vm
 #endif
 	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
 
+#ifdef CONFIG_NUMA
 check_reserve:
+#endif
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
 		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

