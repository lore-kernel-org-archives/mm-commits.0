Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2877DC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06FCA613EA
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhEEBeb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231946AbhEEBeb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1EA2613E6;
        Wed,  5 May 2021 01:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178414;
        bh=W5fWt2bQwRkfEfcOcU+bZaSXH4aNyDy5lNwC0vsQoB4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=D4GjuqxtMi88+amz2POuIVwOtzmIkSJR0jcTgIX8kAzqBGybOOpFoHMbrlhNLB0si
         hN/lgyz/m1uJC8wPNEzzKzr6OsgFPIa33cPE3YM2wW8ThY/RK7nk3lZH9yrPX8HLIc
         htet66LTH9vHZ3soU6OEH3adLiG07959W3CXoyGM=
Date:   Tue, 04 May 2021 18:33:34 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 016/143] mm/hugetlb: avoid calculating
 fault_mutex_hash in truncate_op case
Message-ID: <20210505013334.AJTMagO2i%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: avoid calculating fault_mutex_hash in truncate_op case

The fault_mutex hashing overhead can be avoided in truncate_op case
because page faults can not race with truncation in this routine.  So
calculate hash for fault_mutex only in !truncate_op case to save some cpu
cycles.

Link: https://lkml.kernel.org/r/20210308112809.26107-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-hugetlb-avoid-calculating-fault_mutex_hash-in-truncate_op-case
+++ a/fs/hugetlbfs/inode.c
@@ -482,10 +482,9 @@ static void remove_inode_hugepages(struc
 
 		for (i = 0; i < pagevec_count(&pvec); ++i) {
 			struct page *page = pvec.pages[i];
-			u32 hash;
+			u32 hash = 0;
 
 			index = page->index;
-			hash = hugetlb_fault_mutex_hash(mapping, index);
 			if (!truncate_op) {
 				/*
 				 * Only need to hold the fault mutex in the
@@ -493,6 +492,7 @@ static void remove_inode_hugepages(struc
 				 * page faults.  Races are not possible in the
 				 * case of truncation.
 				 */
+				hash = hugetlb_fault_mutex_hash(mapping, index);
 				mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			}
 
_
