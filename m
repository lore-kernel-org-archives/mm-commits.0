Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F58CC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 503BA61182
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhEEBig (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231124AbhEEBig (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57B3061029;
        Wed,  5 May 2021 01:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178660;
        bh=ND4XtwAZnyCjDXycHQsnq9/CvM4Kiv7K7h0WltbKdo0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VpTtSjN21J18vRZ9nEozxtFgRfYjQW1dFNmqB7ocrDhTnD1jZzMfCh9rwh3zX1L/q
         IcO5aZ87g57ltv39nezWPQ+hv9vNzNe95qLlLljqgdNf+w1nRxhl6icBgb9aRWIWna
         Tsq25fAeiMVkP7UI2siYEOnWxssQsARRQ977qXyQ=
Date:   Tue, 04 May 2021 18:37:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 092/143] ksm: use GET_KSM_PAGE_NOLOCK to get ksm
 page in remove_rmap_item_from_tree()
Message-ID: <20210505013739.aebUkfVyn%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
