Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63581C433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F56B613CD
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbhEEBdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhEEBdl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:33:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E21C7613C5;
        Wed,  5 May 2021 01:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178366;
        bh=OrItJWbICnlfpETCd5LjxemWpCar6bla7jqK8AtTpMo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I29aNMGHcgtlLvFBTcQdKMylvaHFyC8cMzXwtG4EVfuLkaRQVGlACfGqAreUAOwGg
         U9JjQsn0RsmtXcU6tDvlN5MXgM4jq57ukCHm+1Tm/O6LpPxj4zMNrkgqsKU2a082AA
         qPLhB/U63kYtscpcUWtAfFd96wj9SL/y+JlnQ7/Y=
Date:   Tue, 04 May 2021 18:32:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vishal.l.verma@intel.com, willy@infradead.org
Subject:  [patch 001/143] mm: introduce and use mapping_empty()
Message-ID: <20210505013245.CibNwhUQN%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: introduce and use mapping_empty()

Patch series "Remove nrexceptional tracking", v2.

We actually use nrexceptional for very little these days.  It's a minor
pain to keep in sync with nrpages, but the pain becomes much bigger with
the THP patches because we don't know how many indices a shadow entry
occupies.  It's easier to just remove it than keep it accurate.

Also, we save 8 bytes per inode which is nothing to sneeze at; on my
laptop, it would improve shmem_inode_cache from 22 to 23 objects per
16kB, and inode_cache from 26 to 27 objects.  Combined, that saves
a megabyte of memory from a combined usage of 25MB for both caches.
Unfortunately, ext4 doesn't cross a magic boundary, so it doesn't save
any memory for ext4.


This patch (of 4):

Instead of checking the two counters (nrpages and nrexceptional), we can
just check whether i_pages is empty.

Link: https://lkml.kernel.org/r/20201026151849.24232-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20201026151849.24232-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Vishal Verma <vishal.l.verma@intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c          |    2 +-
 fs/dax.c                |    2 +-
 fs/gfs2/glock.c         |    3 +--
 include/linux/pagemap.h |    5 +++++
 mm/truncate.c           |   18 +++---------------
 5 files changed, 11 insertions(+), 19 deletions(-)

--- a/fs/block_dev.c~mm-introduce-and-use-mapping_empty
+++ a/fs/block_dev.c
@@ -79,7 +79,7 @@ static void kill_bdev(struct block_devic
 {
 	struct address_space *mapping = bdev->bd_inode->i_mapping;
 
-	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
+	if (mapping_empty(mapping))
 		return;
 
 	invalidate_bh_lrus();
--- a/fs/dax.c~mm-introduce-and-use-mapping_empty
+++ a/fs/dax.c
@@ -965,7 +965,7 @@ int dax_writeback_mapping_range(struct a
 	if (WARN_ON_ONCE(inode->i_blkbits != PAGE_SHIFT))
 		return -EIO;
 
-	if (!mapping->nrexceptional || wbc->sync_mode != WB_SYNC_ALL)
+	if (mapping_empty(mapping) || wbc->sync_mode != WB_SYNC_ALL)
 		return 0;
 
 	trace_dax_writeback_range(inode, xas.xa_index, end_index);
--- a/fs/gfs2/glock.c~mm-introduce-and-use-mapping_empty
+++ a/fs/gfs2/glock.c
@@ -273,8 +273,7 @@ static void __gfs2_glock_put(struct gfs2
 	if (mapping) {
 		truncate_inode_pages_final(mapping);
 		if (!gfs2_withdrawn(sdp))
-			GLOCK_BUG_ON(gl, mapping->nrpages ||
-				     mapping->nrexceptional);
+			GLOCK_BUG_ON(gl, !mapping_empty(mapping));
 	}
 	trace_gfs2_glock_put(gl);
 	sdp->sd_lockstruct.ls_ops->lm_put_lock(gl);
--- a/include/linux/pagemap.h~mm-introduce-and-use-mapping_empty
+++ a/include/linux/pagemap.h
@@ -18,6 +18,11 @@
 
 struct pagevec;
 
+static inline bool mapping_empty(struct address_space *mapping)
+{
+	return xa_empty(&mapping->i_pages);
+}
+
 /*
  * Bits in mapping->flags.
  */
--- a/mm/truncate.c~mm-introduce-and-use-mapping_empty
+++ a/mm/truncate.c
@@ -295,7 +295,7 @@ void truncate_inode_pages_range(struct a
 	pgoff_t		index;
 	int		i;
 
-	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
+	if (mapping_empty(mapping))
 		goto out;
 
 	/* Offsets within partial pages */
@@ -440,9 +440,6 @@ EXPORT_SYMBOL(truncate_inode_pages);
  */
 void truncate_inode_pages_final(struct address_space *mapping)
 {
-	unsigned long nrexceptional;
-	unsigned long nrpages;
-
 	/*
 	 * Page reclaim can not participate in regular inode lifetime
 	 * management (can't call iput()) and thus can race with the
@@ -452,16 +449,7 @@ void truncate_inode_pages_final(struct a
 	 */
 	mapping_set_exiting(mapping);
 
-	/*
-	 * When reclaim installs eviction entries, it increases
-	 * nrexceptional first, then decreases nrpages.  Make sure we see
-	 * this in the right order or we might miss an entry.
-	 */
-	nrpages = mapping->nrpages;
-	smp_rmb();
-	nrexceptional = mapping->nrexceptional;
-
-	if (nrpages || nrexceptional) {
+	if (!mapping_empty(mapping)) {
 		/*
 		 * As truncation uses a lockless tree lookup, cycle
 		 * the tree lock to make sure any ongoing tree
@@ -633,7 +621,7 @@ int invalidate_inode_pages2_range(struct
 	int ret2 = 0;
 	int did_range_unmap = 0;
 
-	if (mapping->nrpages == 0 && mapping->nrexceptional == 0)
+	if (mapping_empty(mapping))
 		goto out;
 
 	pagevec_init(&pvec);
_
