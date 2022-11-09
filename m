Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DD9C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiKIB0l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKIB0k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:26:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEEC6034D
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:26:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 160BD61802
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B41CC433D6;
        Wed,  9 Nov 2022 01:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957198;
        bh=eeL8RfLRnAEjc4BE2J71k8HU8F70gzh2OrB7l3pmj+k=;
        h=Date:To:From:Subject:From;
        b=sDOz5kXnMU1aT7/dR+pL47wcazVg9C0BJUiZR+IiWV6gVQuh0Uu6YvnNm0tEhTRLt
         NWH2vnFVMQAA+sgnECRKYCX1n4sf/L34rEfnULy7X3u1vgVggtK2iauL2EOjMeLwRv
         aGsx7W0VsLkiaIvK6yFkAXicwQivh9U4v5zhF95A=
Date:   Tue, 08 Nov 2022 17:26:37 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@linux.dev, mpe@ellerman.id.au, david@redhat.com,
        christophe.leroy@csgroup.eu, baolin.wang@linux.alibaba.com,
        aneesh.kumar@linux.ibm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch removed from -mm tree
Message-Id: <20221109012638.6B41CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4
has been removed from the -mm tree.  Its filename was
     hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch

This patch was dropped because it was folded into hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4
Date: Fri, 28 Oct 2022 11:11:08 -0700

remove vma (pmd sharing) locking as this can be called with FOLL_NOWAIT,
per Peter

Link: https://lkml.kernel.org/r/20221028181108.119432-1-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4
+++ a/mm/hugetlb.c
@@ -6240,17 +6240,9 @@ struct page *hugetlb_follow_page_mask(st
 		return NULL;
 
 retry:
-	/*
-	 * vma lock prevents racing with another thread doing a pmd unshare.
-	 * This keeps pte as returned by huge_pte_offset valid.
-	 */
-	hugetlb_vma_lock_read(vma);
-
 	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
-	if (!pte) {
-		hugetlb_vma_unlock_read(vma);
+	if (!pte)
 		return NULL;
-	}
 
 	ptl = huge_pte_lock(h, mm, pte);
 	entry = huge_ptep_get(pte);
@@ -6284,7 +6276,6 @@ retry:
 	}
 out:
 	spin_unlock(ptl);
-	hugetlb_vma_unlock_read(vma);
 	return page;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch
selftests-vm-update-hugetlb-madvise.patch

