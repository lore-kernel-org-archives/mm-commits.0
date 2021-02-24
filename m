Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ED0C43381
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC1E464E09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbhBXUKo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbhBXUJx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:09:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B6F64F1F;
        Wed, 24 Feb 2021 20:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197352;
        bh=gB3hb8WuHHV/SNs+QFMV+iCPOAETqI6CRyNbgfNVZZA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ioQmKqMGtd7p7x2I/paqYKYpsLdZJnsm0pyysVvaYWNv0b3oCnvKmgVDwxDiAp6eH
         JwFf8eOn5nJ+pGEik/M0Ts9pdH0RuywNkmZebNGtkW0c/ZVmn4uJv1vtikChJRYZuZ
         0kj9yIYHUUbOcJFEDNnqGUmh4ta5fN5hMhMPkCMA=
Date:   Wed, 24 Feb 2021 12:09:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gerald.schaefer@linux.ibm.com,
        hca@linux.ibm.com, linux-mm@kvack.org, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com, svens@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 151/173] hugetlb: fix uninitialized subpool
 pointer
Message-ID: <20210224200911.aP4lDAAYo%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
