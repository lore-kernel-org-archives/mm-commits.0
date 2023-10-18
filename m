Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A147FCDB485
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344835AbjJRVhj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbjJRVgw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:36:52 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43692D68
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:36:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA396C433C9;
        Wed, 18 Oct 2023 21:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664959;
        bh=Y1LFlL+JuH4vb0BkrBPOR4KLi7pOEX6n/W8hBxBhfU4=;
        h=Date:To:From:Subject:From;
        b=p5g7OZOlO7+7vrckkK9iPb1sYOEII9mZmXlOHeU1/kBcRAcluiyoWeX56oGtFsU3+
         5ybZnJ34BiQd8IG+kigR4jT4Yu0wB6LdLjbNGJz/VNPEFTxWdZkVURvSRkyqMUgQWV
         gyHH2k5VxggDf4wXfACKAJARg47XpQuRywAy0d80=
Date:   Wed, 18 Oct 2023 14:35:59 -0700
To:     mm-commits@vger.kernel.org, vschneid@redhat.com,
        vincent.guittot@linaro.org, sclaibin@gmail.com,
        rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com,
        mingo@kernel.org, mgorman@suse.de, juri.lelli@redhat.com,
        dietmar.eggemann@arm.com, bsegall@google.com, bristot@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] filemap-remove-use-of-wait-bookmarks.patch removed from -mm tree
Message-Id: <20231018213559.CA396C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: remove use of wait bookmarks
has been removed from the -mm tree.  Its filename was
     filemap-remove-use-of-wait-bookmarks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: filemap: remove use of wait bookmarks
Date: Tue, 10 Oct 2023 04:58:28 +0100

The original problem of the overly long list of waiters on a locked page
was solved properly by commit 9a1ea439b16b ("mm:
put_and_wait_on_page_locked() while page is migrated").  In the meantime,
using bookmarks for the writeback bit can cause livelocks, so we need to
stop using them.

Link: https://lkml.kernel.org/r/20231010035829.544242-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Bin Lai <sclaibin@gmail.com>
Cc: Benjamin Segall <bsegall@google.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

--- a/mm/filemap.c~filemap-remove-use-of-wait-bookmarks
+++ a/mm/filemap.c
@@ -1133,32 +1133,13 @@ static void folio_wake_bit(struct folio
 	wait_queue_head_t *q = folio_waitqueue(folio);
 	struct wait_page_key key;
 	unsigned long flags;
-	wait_queue_entry_t bookmark;
 
 	key.folio = folio;
 	key.bit_nr = bit_nr;
 	key.page_match = 0;
 
-	bookmark.flags = 0;
-	bookmark.private = NULL;
-	bookmark.func = NULL;
-	INIT_LIST_HEAD(&bookmark.entry);
-
 	spin_lock_irqsave(&q->lock, flags);
-	__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, &bookmark);
-
-	while (bookmark.flags & WQ_FLAG_BOOKMARK) {
-		/*
-		 * Take a breather from holding the lock,
-		 * allow pages that finish wake up asynchronously
-		 * to acquire the lock and remove themselves
-		 * from wait queue
-		 */
-		spin_unlock_irqrestore(&q->lock, flags);
-		cpu_relax();
-		spin_lock_irqsave(&q->lock, flags);
-		__wake_up_locked_key_bookmark(q, TASK_NORMAL, &key, &bookmark);
-	}
+	__wake_up_locked_key(q, TASK_NORMAL, &key);
 
 	/*
 	 * It's possible to miss clearing waiters here, when we woke our page
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-make-folio_create_empty_buffers-return-a-buffer_head.patch
mpage-convert-map_buffer_to_folio-to-folio_create_empty_buffers.patch
ext4-convert-to-folio_create_empty_buffers.patch
buffer-add-get_nth_bh.patch
gfs2-convert-inode-unstuffing-to-use-a-folio.patch
gfs2-convert-gfs2_getbuf-to-folios.patch
gfs2-convert-gfs2_getjdatabuf-to-use-a-folio.patch
gfs2-convert-gfs2_write_buf_to_page-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_freeze_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_grab_buffer-to-use-a-folio.patch
nilfs2-convert-nilfs_copy_page-to-nilfs_copy_folio.patch
nilfs2-convert-nilfs_mdt_forget_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_get_frozen_buffer-to-use-a-folio.patch
nilfs2-remove-nilfs_page_get_nth_block.patch
nilfs2-convert-nilfs_lookup_dirty_data_buffers-to-use-folio_create_empty_buffers.patch
ntfs-convert-ntfs_read_block-to-use-a-folio.patch
ntfs-convert-ntfs_writepage-to-use-a-folio.patch
ntfs-convert-ntfs_prepare_pages_for_non_resident_write-to-folios.patch
ntfs3-convert-ntfs_zero_range-to-use-a-folio.patch
ocfs2-convert-ocfs2_map_page_blocks-to-use-a-folio.patch
reiserfs-convert-writepage-to-use-a-folio.patch
ufs-add-ufs_get_locked_folio-and-ufs_put_locked_folio.patch
ufs-use-ufs_get_locked_folio-in-ufs_alloc_lastblock.patch
ufs-convert-ufs_change_blocknr-to-use-folios.patch
ufs-remove-ufs_get_locked_page.patch
buffer-remove-folio_create_empty_buffers.patch

