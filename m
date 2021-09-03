Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D5FC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B8B8610D2
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349849AbhICU5Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350048AbhICU5M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82D1160184;
        Fri,  3 Sep 2021 20:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702571;
        bh=8oJDayGkVIHFWpXwijEkipgq7DQ1LrCQf/HvAc6u2mU=;
        h=Date:From:To:Subject:From;
        b=TdkG+qrSLcTeawmsEcs9GPbXOiNor3s038oMMXvAo2EA6k4QYaIQh90pUnZGUrwRx
         rP5m4Yvg/9VhupXS/CNcHIa0gS08DdWLdnDLhmgM/AtRtIG8w5BUj+HeeJCx+aFB7i
         8md88mVh33kb2NDbgxa+NfKXJneaf/vr5i7/yfp0=
Date:   Fri, 03 Sep 2021 13:56:11 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  [merged]
 fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch removed from
 -mm tree
Message-ID: <20210903205611.WOZeJV7pW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: inode: count invalidated shadow pages in pginodesteal
has been removed from the -mm tree.  Its filename was
     fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hannes@cmpxchg.org are

vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

