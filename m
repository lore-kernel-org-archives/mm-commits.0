From: akpm@linux-foundation.org
Subject: - jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:40:36 -0700
Message-ID: <200810241940.m9OJeawI000946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbYJXTkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:40:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidehiro.kawai.ez@hitachi.com, jack@suse.cz, sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     jbd: test BH_Write_EIO to detect errors on metadata buffers
has been removed from the -mm tree.  Its filename was
     jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: jbd: test BH_Write_EIO to detect errors on metadata buffers
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>

__try_to_free_cp_buf(), __process_buffer(), and __wait_cp_io() test
BH_Uptodate flag to detect write I/O errors on metadata buffers.  But by
commit 95450f5a7e53d5752ce1a0d0b8282e10fe745ae0 "ext3: don't read inode
block if the buffer has a write error"(*), BH_Uptodate flag can be set to
inode buffers with BH_Write_EIO in order to avoid reading old inode data. 
So now, we have to test BH_Write_EIO flag of checkpointing inode buffers
instead of BH_Uptodate.  This patch does it.

Signed-off-by: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Acked-by: Jan Kara <jack@suse.cz>
Acked-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/checkpoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/jbd/checkpoint.c~jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers fs/jbd/checkpoint.c
--- a/fs/jbd/checkpoint.c~jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers
+++ a/fs/jbd/checkpoint.c
@@ -94,7 +94,7 @@ static int __try_to_free_cp_buf(struct j
 	struct buffer_head *bh = jh2bh(jh);
 
 	if (jh->b_jlist == BJ_None && !buffer_locked(bh) &&
-	    !buffer_dirty(bh) && buffer_uptodate(bh)) {
+	    !buffer_dirty(bh) && !buffer_write_io_error(bh)) {
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
 		ret = __journal_remove_checkpoint(jh) + 1;
 		jbd_unlock_bh_state(bh);
@@ -199,7 +199,7 @@ restart:
 			spin_lock(&journal->j_list_lock);
 			goto restart;
 		}
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 
 		/*
@@ -268,7 +268,7 @@ static int __process_buffer(journal_t *j
 		ret = 1;
 	} else if (!buffer_dirty(bh)) {
 		ret = 1;
-		if (unlikely(!buffer_uptodate(bh)))
+		if (unlikely(buffer_write_io_error(bh)))
 			ret = -EIO;
 		J_ASSERT_JH(jh, !buffer_jbddirty(bh));
 		BUFFER_TRACE(bh, "remove from checkpoint");
_

Patches currently in -mm which might be from hidehiro.kawai.ez@hitachi.com are


