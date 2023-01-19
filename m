Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A745C678D4
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbjASBUG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjASBSB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F9D6922F
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2248B81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84FFAC433D2;
        Thu, 19 Jan 2023 01:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090943;
        bh=fTndUb2bxOZ2t7QC4hY0LIOXUPcaZiokjgc9eSB08WA=;
        h=Date:To:From:Subject:From;
        b=YgMY9M1ILsjF8GS6EOwHk1vDT1EM+7+aSCqVg+uiRObBEf35tIaM5kSl2yEcbxhhR
         tHDiALdkEWPwWrEZ80ShK2kZEufpxUaS2p8P+ZE4ljpxV4q8Xaq66catcEwEVrvokl
         lWSp7fWCdsM9x0RInzCmGcZLJfR9iQ2TK6XNrXds=
Date:   Wed, 18 Jan 2023 17:15:43 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, tytso@mit.edu,
        mark@fasheh.com, joseph.qi@linux.alibaba.com, jlbec@evilplan.org,
        jack@suse.com, almaz.alexandrovich@paragon-software.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch removed from -mm tree
Message-Id: <20230119011543.84FFAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: jbd2,ocfs2: move jbd2_journal_submit_inode_data_buffers to ocfs2
has been removed from the -mm tree.  Its filename was
     jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: jbd2,ocfs2: move jbd2_journal_submit_inode_data_buffers to ocfs2
Date: Thu, 29 Dec 2022 06:10:29 -1000

jbd2_journal_submit_inode_data_buffers is only used by ocfs2, so move it
there to prepare for removing generic_writepages.

Link: https://lkml.kernel.org/r/20221229161031.391878-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/commit.c     |   25 -------------------------
 fs/jbd2/journal.c    |    1 -
 fs/ocfs2/journal.c   |   16 +++++++++++++++-
 include/linux/jbd2.h |    2 --
 4 files changed, 15 insertions(+), 29 deletions(-)

--- a/fs/jbd2/commit.c~jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2
+++ a/fs/jbd2/commit.c
@@ -177,31 +177,6 @@ static int journal_wait_on_commit_record
 	return ret;
 }
 
-/*
- * write the filemap data using writepage() address_space_operations.
- * We don't do block allocation here even for delalloc. We don't
- * use writepages() because with delayed allocation we may be doing
- * block allocation in writepages().
- */
-int jbd2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
-{
-	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
-	struct writeback_control wbc = {
-		.sync_mode =  WB_SYNC_ALL,
-		.nr_to_write = mapping->nrpages * 2,
-		.range_start = jinode->i_dirty_start,
-		.range_end = jinode->i_dirty_end,
-	};
-
-	/*
-	 * submit the inode data buffers. We use writepage
-	 * instead of writepages. Because writepages can do
-	 * block allocation with delalloc. We need to write
-	 * only allocated blocks here.
-	 */
-	return generic_writepages(mapping, &wbc);
-}
-
 /* Send all the data buffers related to an inode */
 int jbd2_submit_inode_data(journal_t *journal, struct jbd2_inode *jinode)
 {
--- a/fs/jbd2/journal.c~jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2
+++ a/fs/jbd2/journal.c
@@ -89,7 +89,6 @@ EXPORT_SYMBOL(jbd2_journal_try_to_free_b
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_write);
 EXPORT_SYMBOL(jbd2_journal_inode_ranged_wait);
-EXPORT_SYMBOL(jbd2_journal_submit_inode_data_buffers);
 EXPORT_SYMBOL(jbd2_journal_finish_inode_data_buffers);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
--- a/fs/ocfs2/journal.c~jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2
+++ a/fs/ocfs2/journal.c
@@ -15,6 +15,7 @@
 #include <linux/time.h>
 #include <linux/random.h>
 #include <linux/delay.h>
+#include <linux/writeback.h>
 
 #include <cluster/masklog.h>
 
@@ -841,6 +842,19 @@ bail:
 	return status;
 }
 
+static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
+{
+	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
+	struct writeback_control wbc = {
+		.sync_mode =  WB_SYNC_ALL,
+		.nr_to_write = mapping->nrpages * 2,
+		.range_start = jinode->i_dirty_start,
+		.range_end = jinode->i_dirty_end,
+	};
+
+	return generic_writepages(mapping, &wbc);
+}
+
 int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
 {
 	int status = -1;
@@ -910,7 +924,7 @@ int ocfs2_journal_init(struct ocfs2_supe
 
 	journal->j_journal = j_journal;
 	journal->j_journal->j_submit_inode_data_buffers =
-		jbd2_journal_submit_inode_data_buffers;
+		ocfs2_journal_submit_inode_data_buffers;
 	journal->j_journal->j_finish_inode_data_buffers =
 		jbd2_journal_finish_inode_data_buffers;
 	journal->j_inode = inode;
--- a/include/linux/jbd2.h~jbd2ocfs2-move-jbd2_journal_submit_inode_data_buffers-to-ocfs2
+++ a/include/linux/jbd2.h
@@ -1570,8 +1570,6 @@ extern int	   jbd2_journal_inode_ranged_
 extern int	   jbd2_journal_inode_ranged_wait(handle_t *handle,
 			struct jbd2_inode *inode, loff_t start_byte,
 			loff_t length);
-extern int	   jbd2_journal_submit_inode_data_buffers(
-			struct jbd2_inode *jinode);
 extern int	   jbd2_journal_finish_inode_data_buffers(
 			struct jbd2_inode *jinode);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
_

Patches currently in -mm which might be from hch@lst.de are


