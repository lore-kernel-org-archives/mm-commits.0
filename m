Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FEAC677F1
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjASBOz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjASBOF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE10B689C7
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65E1061B18
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A2CC433D2;
        Thu, 19 Jan 2023 01:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090835;
        bh=QCjgYPWAPXHbPXOFmMlI4P+XPlwP46fSUGmxbl+btoI=;
        h=Date:To:From:Subject:From;
        b=dfpGkWis9WQydIiVkUxo4p0yr93I/RWK1i/m7nDeP1Rrlb+mi10wnF4Kue1q4Gaxu
         A9gDGzaT8h4woLo+qJssKXMNQpflYmgj3IZ4zTms8/TSgWN97ag0dZ2VZKc3AcHY0P
         rKx86M0kuT+PHG9oaCeVJYEa3Zabsfn09pOiRPhE=
Date:   Wed, 18 Jan 2023 17:13:55 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch removed from -mm tree
Message-Id: <20230119011355.C3A2CC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: make follow_hugetlb_page() safe to pmd unshare
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: make follow_hugetlb_page() safe to pmd unshare
Date: Fri, 16 Dec 2022 10:52:23 -0500

Since follow_hugetlb_page() walks the pgtable, it needs the vma lock to
make sure the pgtable page will not be freed concurrently.

Link: https://lkml.kernel.org/r/20221216155223.2043727-1-peterx@redhat.com
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

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-make-follow_hugetlb_page-safe-to-pmd-unshare
+++ a/mm/hugetlb.c
@@ -6454,6 +6454,7 @@ long follow_hugetlb_page(struct mm_struc
 			break;
 		}
 
+		hugetlb_vma_lock_read(vma);
 		/*
 		 * Some archs (sparc64, sh*) have multiple pte_ts to
 		 * each hugepage.  We have to make sure we get the
@@ -6478,6 +6479,7 @@ long follow_hugetlb_page(struct mm_struc
 		    !hugetlbfs_pagecache_present(h, vma, vaddr)) {
 			if (pte)
 				spin_unlock(ptl);
+			hugetlb_vma_unlock_read(vma);
 			remainder = 0;
 			break;
 		}
@@ -6499,6 +6501,8 @@ long follow_hugetlb_page(struct mm_struc
 
 			if (pte)
 				spin_unlock(ptl);
+			hugetlb_vma_unlock_read(vma);
+
 			if (flags & FOLL_WRITE)
 				fault_flags |= FAULT_FLAG_WRITE;
 			else if (unshare)
@@ -6561,6 +6565,7 @@ long follow_hugetlb_page(struct mm_struc
 			remainder -= pages_per_huge_page(h);
 			i += pages_per_huge_page(h);
 			spin_unlock(ptl);
+			hugetlb_vma_unlock_read(vma);
 			continue;
 		}
 
@@ -6590,6 +6595,7 @@ long follow_hugetlb_page(struct mm_struc
 			if (WARN_ON_ONCE(!try_grab_folio(pages[i], refs,
 							 flags))) {
 				spin_unlock(ptl);
+				hugetlb_vma_unlock_read(vma);
 				remainder = 0;
 				err = -ENOMEM;
 				break;
@@ -6601,6 +6607,7 @@ long follow_hugetlb_page(struct mm_struc
 		i += refs;
 
 		spin_unlock(ptl);
+		hugetlb_vma_unlock_read(vma);
 	}
 	*nr_pages = remainder;
 	/*
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

