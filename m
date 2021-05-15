Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A540CC433B4
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82BB261176
	for <mm-commits@archiver.kernel.org>; Sat, 15 May 2021 00:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEOA2e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 May 2021 20:28:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhEOA2e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 May 2021 20:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6491561444;
        Sat, 15 May 2021 00:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621038442;
        bh=3/9Ox0agGVL/dQY6tNQC0j5SrRwoKhe5WPL15rf3sCs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pdX+dsQT8We1s7iNMIqjQAf5OKj8uG/ruuhqZxGI27LJG2uNNt8IZOuO106MIcG8P
         4fMvmBUpuzFmbHza9OylSXcReF53dKATL60vpafK2IxkNgAV/9FccT1D47LnbOI87s
         RUPD0PrAUvA5cLMa2/uvqS4gFfcsm0/r/6UkELTk=
Date:   Fri, 14 May 2021 17:27:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 07/13] ksm: revert "use GET_KSM_PAGE_NOLOCK to get
 ksm page in remove_rmap_item_from_tree()"
Message-ID: <20210515002722.gaOMpxsKF%akpm@linux-foundation.org>
In-Reply-To: <20210514172634.9018621171d5334ceee97e95@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: ksm: revert "use GET_KSM_PAGE_NOLOCK to get ksm page in remove_rmap_item_from_tree()"

This reverts commit 3e96b6a2e9ad929a3230a22f4d64a74671a0720b.  General
Protection Fault in rmap_walk_ksm() under memory pressure:
remove_rmap_item_from_tree() needs to take page lock, of course.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2105092253500.1127@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/ksm.c~ksm-revert-use-get_ksm_page_nolock-to-get-ksm-page-in-remove_rmap_item_from_tree
+++ a/mm/ksm.c
@@ -776,11 +776,12 @@ static void remove_rmap_item_from_tree(s
 		struct page *page;
 
 		stable_node = rmap_item->head;
-		page = get_ksm_page(stable_node, GET_KSM_PAGE_NOLOCK);
+		page = get_ksm_page(stable_node, GET_KSM_PAGE_LOCK);
 		if (!page)
 			goto out;
 
 		hlist_del(&rmap_item->hlist);
+		unlock_page(page);
 		put_page(page);
 
 		if (!hlist_empty(&stable_node->hlist))
_
