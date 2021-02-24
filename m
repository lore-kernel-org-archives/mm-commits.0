Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0059C43219
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 01:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9831764ED1
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 01:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhBXBDK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Feb 2021 20:03:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:32778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234370AbhBXAoN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Feb 2021 19:44:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAB7664EBB;
        Wed, 24 Feb 2021 00:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614126548;
        bh=Jf1qWEvIDNCyeraLQlJPFQzwBfL8LI83ibC7xbutuOU=;
        h=Date:From:To:Subject:From;
        b=xlMdhL5oJuY0zAo7fopXuw+s+ZEWeDq3meaELDM2b0Pgp1PJ8rTChsy9hXYFUlL3x
         uxl7lwyAZKe+P1eESD0YVOBcSy0OLTSttCiPqI334+wbotRwTbLKRL3HvLX2VHhxcR
         AuLMAjTgRlVKtrfk6NxNv4ms1qrcGigquKaeMvQU=
Date:   Tue, 23 Feb 2021 16:29:07 -0800
From:   akpm@linux-foundation.org
To:     gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, songmuchun@bytedance.com, svens@linux.ibm.com
Subject:  +
 hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch added to
 -mm tree
Message-ID: <20210224002907.FTzYUsFN7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix uninitialized subpool pointer
has been added to the -mm tree.  Its filename is
     hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb.c~hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix
+++ a/mm/hugetlb.c
@@ -1526,6 +1526,7 @@ static void prep_new_huge_page(struct hs
 {
 	INIT_LIST_HEAD(&page->lru);
 	set_compound_page_dtor(page, HUGETLB_PAGE_DTOR);
+	hugetlb_set_page_subpool(page, NULL);
 	set_hugetlb_cgroup(page, NULL);
 	set_hugetlb_cgroup_rsvd(page, NULL);
 	spin_lock(&hugetlb_lock);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-update_and_free_page-contig-page-struct-assumption.patch
hugetlb-fix-copy_huge_page_from_user-contig-page-struct-assumption.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags.patch
hugetlb-use-pageprivate-for-hugetlb-specific-page-flags-fix.patch
hugetlb-convert-page_huge_active-hpagemigratable-flag.patch
hugetlb-convert-pagehugetemporary-to-hpagetemporary-flag.patch
hugetlb-convert-pagehugefreed-to-hpagefreed-flag.patch
mm-hugetlb-change-hugetlb_reserve_pages-to-type-bool.patch
hugetlbfs-remove-special-hugetlbfs_set_page_dirty.patch

