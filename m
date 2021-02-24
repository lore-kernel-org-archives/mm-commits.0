Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00988C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2C8A64F20
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbhBXUIl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235371AbhBXUH7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C59764E24;
        Wed, 24 Feb 2021 20:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197264;
        bh=zr53lxw3Y/WxY3qjgQVBAoALDier3GA7yfrx6iT5MWY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b4FXhies5+XsKPT4ZZSQJo0IZPaRTTJljRQ62Esn6yCNGmLym8qbyEKh1alRvmsxZ
         LIOLA7ohMV9hhF6TLpVQVT/ViGGxPGE42zN6hOwSdAqbl/n6qCday60wDZO3Hu/WI5
         7EbE/nRSO1uE5SERv/zqWEvXLdIJ7xKGdyrMthR4=
Date:   Wed, 24 Feb 2021 12:07:43 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, osalvador@suse.de,
        torvalds@linux-foundation.org
Subject:  [patch 128/173] mm/hugetlb: remove unnecessary
 VM_BUG_ON_PAGE on putback_active_hugepage()
Message-ID: <20210224200743.jzLsuQCyf%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: remove unnecessary VM_BUG_ON_PAGE on putback_active_hugepage()

All callers know they are operating on a hugetlb head page.  So this
VM_BUG_ON_PAGE can not catch anything useful.

Link: https://lkml.kernel.org/r/20210209071151.44731-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-remove-unnecessary-vm_bug_on_page-on-putback_active_hugepage
+++ a/mm/hugetlb.c
@@ -5622,7 +5622,6 @@ unlock:
 
 void putback_active_hugepage(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageHead(page), page);
 	spin_lock(&hugetlb_lock);
 	set_page_huge_active(page);
 	list_move_tail(&page->lru, &(page_hstate(page))->hugepage_activelist);
_
