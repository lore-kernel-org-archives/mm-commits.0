Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1E7C433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3E2564E09
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:11:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235375AbhBXULS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235402AbhBXUKK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:10:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AACCB64E09;
        Wed, 24 Feb 2021 20:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197370;
        bh=wR6AXF6Q1HrYX1lGQbY3h6eyj9AgwCkMouT0JLup6T0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=r/9s3y6n6dVkTZacf5i0orv9gfvc/+MB+CCSlq1ugwfkg0mRvgbGSn6jJegeZ9+0p
         Tl3fdrPaL1nwZRISIZjsAzijIHz6/3tVqfyCH2dQ6pVwnFp0pNqmJAESNz1+3WqFoj
         KQ5G1O3NQevrGTDrxltwLHNG3lixnEIGEf8eYCoc=
Date:   Wed, 24 Feb 2021 12:09:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 156/173] mm/compaction: remove duplicated
 VM_BUG_ON_PAGE !PageLocked
Message-ID: <20210224200929._jmZRUUuN%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/compaction: remove duplicated VM_BUG_ON_PAGE !PageLocked

The VM_BUG_ON_PAGE(!PageLocked(page), page) is also done in PageMovable.
Remove this explicitly one.

Link: https://lkml.kernel.org/r/20210109081420.46030-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-remove-duplicated-vm_bug_on_page-pagelocked
+++ a/mm/compaction.c
@@ -137,7 +137,6 @@ EXPORT_SYMBOL(__SetPageMovable);
 
 void __ClearPageMovable(struct page *page)
 {
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	/*
 	 * Clear registered address_space val with keeping PAGE_MAPPING_MOVABLE
_
