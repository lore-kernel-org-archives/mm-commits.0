Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F63C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiEJEUC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbiEJES1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:18:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDCF5A2C6
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD037B817CC
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1C1C385C7;
        Tue, 10 May 2022 04:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156056;
        bh=PFmDOWr+cm7pwcYySu0hwHn8k1tyionSAmd4MYQJ4uI=;
        h=Date:To:From:Subject:From;
        b=TkmASfgZiY99QxtBabB7XPb7y14DyMHafo5iKVOEx2rvGiB3pYxfxkkbIDCuDhbf8
         7J1K6QYCIgdj+kbxDorp1o2s8piuq2kG9Tsj68hockDrkXPAMInXNW/IvKs/Rts3Tc
         hIT78yNdT8l1CY8fN5SWIv4jrYA7PtG93cQQFSoU=
Date:   Mon, 09 May 2022 21:14:15 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, mike.kravetz@oracle.com,
        baolin.wang@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-missing-cache-flushing-in-hugetlb_unshare_all_pmds.patch removed from -mm tree
Message-Id: <20220510041416.7C1C1C385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb: add missing cache flushing in hugetlb_unshare_all_pmds()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-missing-cache-flushing-in-hugetlb_unshare_all_pmds.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: hugetlb: add missing cache flushing in hugetlb_unshare_all_pmds()

Missed calling flush_cache_range() before removing the sharing PMD
entrires, otherwise data consistence issue may be occurred on some
architectures whose caches are strict and require a virtual>physical
translation to exist for a virtual address.  Thus add it.

Now no architectures enabling PMD sharing will be affected, since they do
not have a VIVT cache.  That means this issue can not be happened in
practice so far.

Link: https://lkml.kernel.org/r/47441086affcabb6ecbe403173e9283b0d904b38.1650956489.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/419b0e777c9e6d1454dcd906e0f5b752a736d335.1650781755.git.baolin.wang@linux.alibaba.com
Fixes: 6dfeaff93be1 ("hugetlb/userfaultfd: unshare all pmds for hugetlbfs when register wp")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~mm-hugetlb-add-missing-cache-flushing-in-hugetlb_unshare_all_pmds
+++ a/mm/hugetlb.c
@@ -6886,6 +6886,7 @@ void hugetlb_unshare_all_pmds(struct vm_
 	if (start >= end)
 		return;
 
+	flush_cache_range(vma, start, end);
 	/*
 	 * No need to call adjust_range_if_pmd_sharing_possible(), because
 	 * we have already done the PUD_SIZE alignment.
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


