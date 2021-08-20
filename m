Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D39CC4320A
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1402C61101
	for <mm-commits@archiver.kernel.org>; Fri, 20 Aug 2021 02:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhHTCEt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 Aug 2021 22:04:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234428AbhHTCEq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 19 Aug 2021 22:04:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77F6D610FE;
        Fri, 20 Aug 2021 02:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629425049;
        bh=v0VoGgFdcA4u75ps2l+O4sbayTrwRy1+gC9JbSq0H0w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cwK4EO3I2uaUqBDXdh8LCt2xrzXTcc4vKqwslA4IHNQqbNXe3n7pWgeQLsftJUqPq
         7+3V7YZwew8WmQXvafufUqp0WlwGWYmuevkl/iD0jaMMCrjruE2J7ITBvUnyy33UxU
         e9duxHQI4kQOEaKcBA4O/Q2B3OjzewJuOp8FgBsY=
Date:   Thu, 19 Aug 2021 19:04:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, hannes@cmpxchg.org,
        hughd@google.com, iamjoonsoo.kim@lge.com, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 02/10] Revert "mm: swap: check if swap backing
 device is congested or not"
Message-ID: <20210820020409.TZFRMik-6%akpm@linux-foundation.org>
In-Reply-To: <20210819190327.14fc4e97102e1af7929e30af@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: Revert "mm: swap: check if swap backing device is congested or not"

Due to the change about how block layer detects congestion the
justification of commit 8fd2e0b505d1 ("mm: swap: check if swap backing
device is congested or not") doesn't stand anymore, so the commit could be
just reverted in order to solve the race reported by commit 2efa33fc7f6e
("mm/shmem: fix shmem_swapin() race with swapoff").  The fix was reverted
by the previous patch.

Link: https://lkml.kernel.org/r/20210810202936.2672-3-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Suggested-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/mm/swap_state.c~revert-mm-swap-check-if-swap-backing-device-is-congested-or-not
+++ a/mm/swap_state.c
@@ -628,13 +628,6 @@ struct page *swap_cluster_readahead(swp_
 	if (!mask)
 		goto skip;
 
-	/* Test swap type to make sure the dereference is safe */
-	if (likely(si->flags & (SWP_BLKDEV | SWP_FS_OPS))) {
-		struct inode *inode = si->swap_file->f_mapping->host;
-		if (inode_read_congested(inode))
-			goto skip;
-	}
-
 	do_poll = false;
 	/* Read a page_cluster sized and aligned cluster around offset. */
 	start_offset = offset & ~mask;
_
