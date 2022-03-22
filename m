Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC64FC4321E
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiCVVns (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiCVVnn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:43:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18B65F4C6
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B289B81D9E
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28467C36AE3;
        Tue, 22 Mar 2022 21:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985320;
        bh=pvulDPwyizhgGDxa4jhwBc0U3Z5T0u8pV4nxemqXHIo=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=PvCTD+JzzxO/UlwcN4mHCJbJ4+rUhaARV7ubSxnLxFkENXo2LFcyV+P1fVYvg9FHz
         3IUvp9keQEPtHk5ZVtX6QiCOw0hG9NhRLCUGY2eYZnogQtdX5iNrOwQu04Qnr1jkoV
         M3etRAbIjHBkdEThQDt2D1YCf3hT5qOaKrocjV2Q=
Date:   Tue, 22 Mar 2022 14:41:59 -0700
To:     ziy@nvidia.com, rientjes@google.com, peterx@redhat.com,
        mike.kravetz@oracle.com, lars.persson@axis.com,
        kirill.shutemov@linux.intel.com, fam.zheng@bytedance.com,
        duanxiongchun@bytedance.com, axelrasmussen@google.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 068/227] mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
Message-Id: <20220322214200.28467C36AE3@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
