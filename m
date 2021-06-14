Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F166DC48BE8
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCED86128B
	for <mm-commits@archiver.kernel.org>; Mon, 14 Jun 2021 22:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhFNWCy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Jun 2021 18:02:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230289AbhFNWCv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Jun 2021 18:02:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAD6361166;
        Mon, 14 Jun 2021 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623708047;
        bh=2iaO1qPUbe0P6k3E/S5+pcRzoLUErHOjLII+VhbxTvY=;
        h=Date:From:To:Subject:From;
        b=ytFVfdQaKpTCMHsmL0TFkN806yfdxS7nHD1CzfwOPscdJI99hvO4p7Kyyc5hbNzm2
         wSQtkTrFYMCpDD5i+MjzP/Hcw3G+V/60evTQO/dwKVRNHx0y1cF977cr9vdi9/+8bS
         jLZhBAPY018VkMChFDdhTWUYTEPGSFy4ydnEq2Ms=
Date:   Mon, 14 Jun 2021 15:00:47 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mm-commits@vger.kernel.org
Subject:  +
 fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch added to -mm
 tree
Message-ID: <20210614220047.FlUAVsqNI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: inode: count invalidated shadow pages in pginodesteal
has been added to the -mm tree.  Its filename is
     fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-irqsave-restore-locking-from-contexts-with-irqs-enabled.patch
fs-drop_caches-fix-skipping-over-shadow-cache-inodes.patch
fs-inode-count-invalidated-shadow-pages-in-pginodesteal.patch
vfs-keep-inodes-with-page-cache-off-the-inode-shrinker-lru.patch

