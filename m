Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1472BC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3790610D2
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:53:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347759AbhIBVyo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347861AbhIBVyX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:54:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD45C610CF;
        Thu,  2 Sep 2021 21:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619605;
        bh=RByMtfOk5RkE9/hiBo5UlJ8eITdylmGG54i2m7zU8Lw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=LWQ3JJYQfW3KyzD1ZmqLLqAen/NY+K3kVkgthD76dJOsfr00WgMHcxGMUT4MH7DBP
         Rk1BRrjSSzJHcRmavCdkTWXRoIiJZ57tOBxlHCSQ0yPBeI96ZIutucgqlGd1RIot8U
         k/tKmHI73/ism3cZQc0JVY+3+7h0FGr3xFkdFD2w=
Date:   Thu, 02 Sep 2021 14:53:24 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 065/212] fs: inode: count invalidated shadow pages
 in pginodesteal
Message-ID: <20210902215324.qoY5s-4Iu%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>
Subject: fs: inode: count invalidated shadow pages in pginodesteal

pginodesteal is supposed to capture the impact that inode reclaim has on
the page cache state.  Currently, it doesn't consider shadow pages that
get dropped this way, even though this can have a significant impact on
paging behavior, memory pressure calculations etc.

To improve visibility into these effects, make sure shadow pages get
counted when they get dropped through inode reclaim.

This changes the return value semantics of invalidate_mapping_pages()
semantics slightly, but the only two users are the inode shrinker itsel
and a usb driver that logs it for debugging purposes.

Link: https://lkml.kernel.org/r/20210614211904.14420-3-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c    |    2 +-
 mm/truncate.c |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

--- a/fs/inode.c~fs-inode-count-invalidated-shadow-pages-in-pginodesteal
+++ a/fs/inode.c
@@ -768,7 +768,7 @@ static enum lru_status inode_lru_isolate
 		return LRU_ROTATE;
 	}
 
-	if (inode_has_buffers(inode) || inode->i_data.nrpages) {
+	if (inode_has_buffers(inode) || !mapping_empty(&inode->i_data)) {
 		__iget(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(lru_lock);
--- a/mm/truncate.c~fs-inode-count-invalidated-shadow-pages-in-pginodesteal
+++ a/mm/truncate.c
@@ -483,8 +483,9 @@ static unsigned long __invalidate_mappin
 			index = indices[i];
 
 			if (xa_is_value(page)) {
-				invalidate_exceptional_entry(mapping, index,
-							     page);
+				count += invalidate_exceptional_entry(mapping,
+								      index,
+								      page);
 				continue;
 			}
 			index += thp_nr_pages(page) - 1;
@@ -512,19 +513,18 @@ static unsigned long __invalidate_mappin
 }
 
 /**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
+ * invalidate_mapping_pages - Invalidate all clean, unlocked cache of one inode
+ * @mapping: the address_space which holds the cache to invalidate
  * @start: the offset 'from' which to invalidate
  * @end: the offset 'to' which to invalidate (inclusive)
  *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
+ * This function removes pages that are clean, unmapped and unlocked,
+ * as well as shadow entries. It will not block on IO activity.
  *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
+ * If you want to remove all the pages of one inode, regardless of
+ * their use and writeback state, use truncate_inode_pages().
  *
- * Return: the number of the pages that were invalidated
+ * Return: the number of the cache entries that were invalidated
  */
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 		pgoff_t start, pgoff_t end)
_
