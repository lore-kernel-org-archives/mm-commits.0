Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04889C4320A
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:14:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB5360F35
	for <mm-commits@archiver.kernel.org>; Wed, 11 Aug 2021 01:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhHKBPG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Aug 2021 21:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:32982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhHKBPF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 10 Aug 2021 21:15:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A842B60EE9;
        Wed, 11 Aug 2021 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628644482;
        bh=I8saIn5ntaqaFlbSF6/mndZQuFpwTs7Z7fUpKPaHTgw=;
        h=Date:From:To:Subject:From;
        b=y9dDBC6DTI3UK+d9Zx2Z71hYhUjFyUl1NSwoUfZGBfoknmnVql3JUTlkNXGHqkluM
         oilwVc5DhEOQOarS4wFiBVNPtntSzoL4Fjf6s/Bvm7/2q0JqDk1FKQvCb1L9zJeGQL
         Cim2YANiyNZ/7rUJIQqV6P8timPHXIWRkAHsPi8A=
Date:   Tue, 10 Aug 2021 18:14:42 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, minchan@kernel.org, mhocko@suse.com,
        linmiaohe@huawei.com, iamjoonsoo.kim@lge.com, hughd@google.com,
        hannes@cmpxchg.org, david@redhat.com, shy828301@gmail.com
Subject:  +
 revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch added
 to -mm tree
Message-ID: <20210811011442.TOnWi%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: swap: check if swap backing device is congested or not"
has been added to the -mm tree.  Its filename is
     revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

revert-mm-shmem-fix-shmem_swapin-race-with-swapoff.patch
revert-mm-swap-check-if-swap-backing-device-is-congested-or-not.patch

