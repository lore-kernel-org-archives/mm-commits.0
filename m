Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FFEC678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjASBOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjASBOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3933A68438
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C86FE61B16
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B600C433F0;
        Thu, 19 Jan 2023 01:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090834;
        bh=3gdX1fopfMVOpo4wwS+tw5xkd+qFYJ8fwDp84rvFeSw=;
        h=Date:To:From:Subject:From;
        b=xN1lJAOh4XnefANQbcRWFZyC543ANoH5jRLSn5YxUwLgp2AoqKoRjfBclzMj3Ce2Q
         QCOzlAE/qTxcILwBi08aZ11aF1g/HU1amKjXPnP/dhK6QyErIb8bfGiMz6I9zofE8n
         QC/TYUzTnOqfoBHfHVHYXPUDuvBzypuGsinr+4kU=
Date:   Wed, 18 Jan 2023 17:13:53 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch removed from -mm tree
Message-Id: <20230119011354.2B600C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: make hugetlb_follow_page_mask() safe to pmd unshare
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: make hugetlb_follow_page_mask() safe to pmd unshare
Date: Fri, 16 Dec 2022 10:52:19 -0500

Since hugetlb_follow_page_mask() walks the pgtable, it needs the vma lock
to make sure the pgtable page will not be freed concurrently.

Link: https://lkml.kernel.org/r/20221216155219.2043714-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-make-hugetlb_follow_page_mask-safe-to-pmd-unshare
+++ a/mm/hugetlb.c
@@ -6396,9 +6396,10 @@ struct page *hugetlb_follow_page_mask(st
 	if (WARN_ON_ONCE(flags & FOLL_PIN))
 		return NULL;
 
+	hugetlb_vma_lock_read(vma);
 	pte = huge_pte_offset(mm, haddr, huge_page_size(h));
 	if (!pte)
-		return NULL;
+		goto out_unlock;
 
 	ptl = huge_pte_lock(h, mm, pte);
 	entry = huge_ptep_get(pte);
@@ -6421,6 +6422,8 @@ struct page *hugetlb_follow_page_mask(st
 	}
 out:
 	spin_unlock(ptl);
+out_unlock:
+	hugetlb_vma_unlock_read(vma);
 	return page;
 }
 
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

