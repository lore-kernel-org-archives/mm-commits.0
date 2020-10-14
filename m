Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 301C6C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D3E22248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709190;
	bh=qeg6738eq1oGMNOnb9/+RNsVfMEZNRShEa6pmWdV0EQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pQiL7anKqtd5+QKa9kbwx5hIWiyBWRSW+tXrlZZ51Oagxe73GKJeQ2G36L4TUu8sn
	 TgEyruqpFXFhbIvUbrljftancf5E+lgS8/hxlq6OnK9azp8nCSIOk+M/h0FomyJThc
	 7mwSgKAYwqPjhR98oGeYETVEBpfUz9/xK5gCHiuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389383AbgJNU7u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387696AbgJNU7u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:59:50 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA1E2068E;
        Wed, 14 Oct 2020 20:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709189;
        bh=qeg6738eq1oGMNOnb9/+RNsVfMEZNRShEa6pmWdV0EQ=;
        h=Date:From:To:Subject:From;
        b=blYVN3mMixD6t6djqO9B09ILGxlKk2to3Cq1XZ0IiuY09AhRKlHGrmuGrRxntthoO
         lsavU+e68u+aGeNBTjL+lltpQctvZNqOxXtxsrITuMehvG2eriVDQYgMG2yPQQ0Dvs
         0RrmhI8eqGFjLxr2d6+/IXRM7mQe2uw+ZTj0of3w=
Date:   Wed, 14 Oct 2020 13:59:49 -0700
From:   akpm@linux-foundation.org
To:     linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  [merged]
 mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch
 removed from -mm tree
Message-ID: <20201014205949.UPTzpRQ0C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap.c: fix incomplete comment in lru_cache_add_inactive_or_unevictable()
has been removed from the -mm tree.  Its filename was
     mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap.c: fix incomplete comment in lru_cache_add_inactive_or_unevictable()

Since commit 9c4e6b1a7027 ("mm, mlock, vmscan: no more skipping
pagevecs"), unevictable pages do not goes directly back onto zone's
unevictable list.

Link: https://lkml.kernel.org/r/20200927122209.59328-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/swap.c~mm-fix-incomplete-comment-in-lru_cache_add_inactive_or_unevictable
+++ a/mm/swap.c
@@ -481,9 +481,7 @@ EXPORT_SYMBOL(lru_cache_add);
  * @vma:   vma in which page is mapped for determining reclaimability
  *
  * Place @page on the inactive or unevictable LRU list, depending on its
- * evictability.  Note that if the page is not evictable, it goes
- * directly back onto it's zone's unevictable list, it does NOT use a
- * per cpu pagevec.
+ * evictability.
  */
 void lru_cache_add_inactive_or_unevictable(struct page *page,
 					 struct vm_area_struct *vma)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

