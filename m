Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 346FBC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F9BD613E2
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbhEEBe0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhEEBeZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08255613E6;
        Wed,  5 May 2021 01:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178409;
        bh=Urbs9n7EhANDy7UQlSfMpsKF12gwGX6zdeW0mzfRb+M=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=C9H2o9a0eSMHYIISfPptLgFjiWSBKigSdhLLMwwXs8QFFDsIBcCu+NipIAojRdKf9
         Wc4iknlo6tkZcUGg6+gQscDtMB713uo+ngKtbaqyef4xxCSclJDSOXI3QR/ybs6vlH
         9+/mVSzNgv5MRq5TiHne+XmSsMkNtjOO2ruTWHTk=
Date:   Tue, 04 May 2021 18:33:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 014/143] mm/hugetlb_cgroup: remove unnecessary
 VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()
Message-ID: <20210505013328.0g7AQfwkl%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb_cgroup: remove unnecessary VM_BUG_ON_PAGE in hugetlb_cgroup_migrate()

!PageHuge(oldhpage) is implicitly checked in page_hstate() above, so we
remove this explicit one.

Link: https://lkml.kernel.org/r/20210308112809.26107-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-remove-unnecessary-vm_bug_on_page-in-hugetlb_cgroup_migrate
+++ a/mm/hugetlb_cgroup.c
@@ -784,7 +784,6 @@ void hugetlb_cgroup_migrate(struct page
 	if (hugetlb_cgroup_disabled())
 		return;
 
-	VM_BUG_ON_PAGE(!PageHuge(oldhpage), oldhpage);
 	spin_lock(&hugetlb_lock);
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
_
