Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06EF5C43217
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353834AbiCYBdo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352429AbiCYBc2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:32:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CBB85C667
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12F40B826FE
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5AEC340EC;
        Fri, 25 Mar 2022 01:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171852;
        bh=Gfzv4Kr0G/qCpdlpu/23grJv3xcYckL4A+GF3sZqGbI=;
        h=Date:To:From:Subject:From;
        b=dDf+jnxVsKdbS38yugFTfbCmKRs6InaypD940q2Gl0bFg3WIw2Vd79rx1XEI28CKU
         RCuBFazBdtC46WQhnPmrdKoTGdQShhl/qSLCN3BpITb06q2r+epvOE2gB8yn14fiWr
         k4/k61yljKZXiX3JncWaUVsFxiuaMyBBOFa72fTY=
Date:   Thu, 24 Mar 2022 18:30:52 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, rientjes@google.com,
        peterx@redhat.com, mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch removed from -mm tree
Message-Id: <20220325013052.9C5AEC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

userfaultfd calls copy_huge_page_from_user() which does not do any cache
flushing for the target page.  Then the target page will be mapped to the
user space with a different address (user address), which might have an
alias issue with the kernel address used to copy the data from the user
to.  Fix this issue by flushing dcache in copy_huge_page_from_user().

Link: https://lkml.kernel.org/r/20220210123058.79206-4-songmuchun@bytedance.com
Fixes: fa4d75c1de13 ("userfaultfd: hugetlbfs: add copy_huge_page_from_user for hugetlb userfaultfd support")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lars Persson <lars.persson@axis.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory.c~mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user
+++ a/mm/memory.c
@@ -5444,6 +5444,8 @@ long copy_huge_page_from_user(struct pag
 		if (rc)
 			break;
 
+		flush_dcache_page(subpage);
+
 		cond_resched();
 	}
 	return ret_val;
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


