Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C7DC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7F7B64F28
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234849AbhBYTfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:35:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235077AbhBYTc7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:32:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C620764FB0;
        Thu, 25 Feb 2021 19:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280708;
        bh=j20657STG7SI+DnLdtE3kv3SNlTmCubO0Z9RlwhKFhc=;
        h=Date:From:To:Subject:From;
        b=pM4RCGe7Pfljs4kaWs0xBVdYgmPkTZwfXhKDgYPbpSIZW6m2GWca0yzjSsFBeWdGP
         XxnEp1t8qKaZmFKo7UXwtBMqLS/FU4mEburwDYRRv2ABwbrneu2MjjZ/rwxq8/m2d0
         +MzKON1ifuUqSE9PodhSTiBQT2aA/yn1lOuqvjDc=
Date:   Thu, 25 Feb 2021 11:18:27 -0800
From:   akpm@linux-foundation.org
To:     gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com, svens@linux.ibm.com
Subject:  [merged] hugetlb-fix-uninitialized-subpool-pointer.patch
 removed from -mm tree
Message-ID: <20210225191827.nZQhnfvOm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix uninitialized subpool pointer
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-uninitialized-subpool-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix uninitialized subpool pointer

Gerald Schaefer reported a panic on s390 in hugepage_subpool_put_pages()
with linux-next 5.12.0-20210222.
Call trace:
  hugepage_subpool_put_pages.part.0+0x2c/0x138
  __free_huge_page+0xce/0x310
  alloc_pool_huge_page+0x102/0x120
  set_max_huge_pages+0x13e/0x350
  hugetlb_sysctl_handler_common+0xd8/0x110
  hugetlb_sysctl_handler+0x48/0x58
  proc_sys_call_handler+0x138/0x238
  new_sync_write+0x10e/0x198
  vfs_write.part.0+0x12c/0x238
  ksys_write+0x68/0xf8
  do_syscall+0x82/0xd0
  __do_syscall+0xb4/0xc8
  system_call+0x72/0x98

This is a result of the change which moved the hugetlb page subpool
pointer from page->private to page[1]->private.  When new pages are
allocated from the buddy allocator, the private field of the head
page will be cleared, but the private field of subpages is not modified.
Therefore, old values may remain.

Fix by initializing hugetlb page subpool pointer in prep_new_huge_page().

Link: https://lkml.kernel.org/r/20210223215544.313871-1-mike.kravetz@oracle.com
Fixes: f1280272ae4d ("hugetlb: use page.private for hugetlb specific page flags")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-fix-uninitialized-subpool-pointer
+++ a/mm/hugetlb.c
@@ -1465,6 +1465,7 @@ static void prep_new_huge_page(struct hs
 {
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
+	hugetlb_set_page_subpool(page, NULL);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
 	spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


