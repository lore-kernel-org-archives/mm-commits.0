Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9AEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383697AbiEMTV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383767AbiEMTVD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA2F377EA
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2F562256
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A964C34113;
        Fri, 13 May 2022 19:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469661;
        bh=koUevvYC2FqH2zudVOrd/IYU+AevnE5QPrHI2DFHQ1o=;
        h=Date:To:From:Subject:From;
        b=G77LyYwqoNtBRvsjx5/s+gsMaMdhjSzjdj78iCnOJpHYEjCGbh6LDMQ7rBJlAT9mT
         IW5zNqKJQNnuV4oDkPTUU/zw5hX8VKI00PZ5wt2vnNlESqnxnBM/a6hfsoT9FrpQ8b
         ZqGle/CtfW1h4mxQVFEO4UbglM/KTFC4MdgKelpY=
Date:   Fri, 13 May 2022 12:21:00 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rppt@linux.vnet.ibm.com, nadav.amit@gmail.com,
        mike.kravetz@oracle.com, kirill@shutemov.name, jglisse@redhat.com,
        hughd@google.com, david@redhat.com, axelrasmussen@google.com,
        apopple@nvidia.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch removed from -mm tree
Message-Id: <20220513192101.0A964C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: hook page faults for uffd write protection
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-hook-page-faults-for-uffd-write-protection.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: hook page faults for uffd write protection

Hook up hugetlbfs_fault() with the capability to handle userfaultfd-wp
faults.

We do this slightly earlier than hugetlb_cow() so that we can avoid taking
some extra locks that we definitely don't need.

Link: https://lkml.kernel.org/r/20220405014901.14590-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: "Kirill A . Shutemov" <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-hook-page-faults-for-uffd-write-protection
+++ a/mm/hugetlb.c
@@ -5737,6 +5737,26 @@ vm_fault_t hugetlb_fault(struct mm_struc
 	if (unlikely(!pte_same(entry, huge_ptep_get(ptep))))
 		goto out_ptl;
 
+	/* Handle userfault-wp first, before trying to lock more pages */
+	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(huge_ptep_get(ptep)) &&
+	    (flags & FAULT_FLAG_WRITE) && !huge_pte_write(entry)) {
+		struct vm_fault vmf = {
+			.vma = vma,
+			.address = haddr,
+			.real_address = address,
+			.flags = flags,
+		};
+
+		spin_unlock(ptl);
+		if (pagecache_page) {
+			unlock_page(pagecache_page);
+			put_page(pagecache_page);
+		}
+		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+		i_mmap_unlock_read(mapping);
+		return handle_userfault(&vmf, VM_UFFD_WP);
+	}
+
 	/*
 	 * hugetlb_wp() requires page locks of pte_page(entry) and
 	 * pagecache_page, so here we need take the former one
_

Patches currently in -mm which might be from peterx@redhat.com are


