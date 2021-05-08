Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DDD1C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404F061424
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEHWui (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229727AbhEHWuf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BB7761402;
        Sat,  8 May 2021 22:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514173;
        bh=Pky0LaPoAoR+Ql40aH3lwZk/CZfFcSTaCX8a95L80tg=;
        h=Date:From:To:Subject:From;
        b=dWcK0rubpxy0marcSI7pjLf2XlruoelBgyU/oM9/BkMQ6ZQDsz1iemcKl9S1qtAXf
         dckP+hM32KpjPdWvzBnzWePvRjM3U8xtZcWaGWH8qj4p81Zvbv5e1TBWsbvIjIZNiY
         GbinXHNS5wdLu90uP6nkbbWjPdOVs/eWCuufVxb8=
Date:   Sat, 08 May 2021 15:49:33 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, linmiaohe@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?ksm-use-get=5Fksm=5Fpage=5Fnolock-to-get-ksm-page-in-remo?=
 =?US-ASCII?Q?ve=5Frmap=5Fitem=5Ffrom=5Ftree.patch?= removed from -mm tree
Message-ID: <20210508224933.G4KD0HG6O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ksm: use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()
has been removed from the -mm tree.  Its filename was
     ksm-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: ksm: use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()

It's unnecessary to lock the page when get ksm page if we're going to
remove the rmap item as page migration is irrelevant in this case.  Use
GET_KSM_PAGE_NOLOCK instead to save some page lock cycles.

Link: https://lkml.kernel.org/r/20210330140228.45635-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/ksm.c~ksm-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree
+++ a/mm/ksm.c
@@ -778,12 +778,11 @@ static void remove_rmap_item_from_tree(s
 		struct page *page;
 
 		stable_node = rmap_item->head;
-		page = get_ksm_page(stable_node, GET_KSM_PAGE_LOCK);
+		page = get_ksm_page(stable_node, GET_KSM_PAGE_NOLOCK);
 		if (!page)
 			goto out;
 
 		hlist_del(&rmap_item->hlist);
-		unlock_page(page);
 		put_page(page);
 
 		if (!hlist_empty(&stable_node->hlist))
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


