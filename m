Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F8DC38A02
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJ1V3k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiJ1V3k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:29:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA00BDFA0
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:29:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8A22BCE2B55
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81012C433D6;
        Fri, 28 Oct 2022 21:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666992573;
        bh=odM7a6CDlGg5OoWcuKil+iN1CmmmFpQelorcsUojpso=;
        h=Date:To:From:Subject:From;
        b=Jibyz8uBogC2xjmS5kuOPYdWt93TI4zeQH0kJgUO8dLcUQOVJhPaZmElv6Vd6eq3i
         MhNn69s85psUoO1yO/LlcN7Bq236HB/Qd5/H9R/K0es1ybkETLVm/6utx5V/OFnoVN
         bPQFp6v0cdfnCr/IypT5mLWK8CbTzvlVuXAi7/Ok=
Date:   Fri, 28 Oct 2022 14:29:32 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        naoya.horiguchi@linux.dev, mpe@ellerman.id.au, david@redhat.com,
        christophe.leroy@csgroup.eu, baolin.wang@linux.alibaba.com,
        aneesh.kumar@linux.ibm.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch added to mm-unstable branch
Message-Id: <20221028212933.81012C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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


--- a/mm/hugetlb.c~hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4
+++ a/mm/hugetlb.c
@@ -6265,17 +6265,9 @@ struct page *hugetlb_follow_page_mask(st
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
@@ -6309,7 +6301,6 @@ retry:
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
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch

