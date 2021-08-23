Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 618E4C4320A
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4848D613A8
	for <mm-commits@archiver.kernel.org>; Mon, 23 Aug 2021 18:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhHWSYv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Aug 2021 14:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230154AbhHWSYu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Aug 2021 14:24:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB421613A6;
        Mon, 23 Aug 2021 18:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1629743048;
        bh=7MUK+xa2TLnVbHsr3h0szYAUFUUMG7y8GLoD7tyeuec=;
        h=Date:From:To:Subject:From;
        b=xHha8vqZ7coUCB9XELvrmNX1z3CEB00sPGl3Ro3Ac1EneNYEJ1GHhYYCAm9hHjAPz
         9Nn0tc+c+cYrLuEOlDt/11l3wS9fiM3TMNXgW3w+R+Wlh82aSnGRaKA7ifPEiwAbsn
         MHhUYhQmbN8V2slGYaVQpL5PQRUhn4dgpZg3Uqj0=
Date:   Mon, 23 Aug 2021 11:24:07 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hannes@cmpxchg.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, linmiaohe@huawei.com, mhocko@suse.com,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch
 removed from -mm tree
Message-ID: <20210823182407.X5Jjg0Rw6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: swap: check if swap backing device is congested or not"
has been removed from the -mm tree.  Its filename was
     revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-dont-drop-slab-caches-for-offlining-non-lru-page.patch
doc-hwpoison-correct-the-support-for-hugepage.patch
mm-hwpoison-dump-page-for-unhandlable-page.patch

