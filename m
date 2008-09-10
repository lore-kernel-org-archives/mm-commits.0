From: akpm@linux-foundation.org
Subject: + jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:51:03 -0700
Message-ID: <200809102151.m8ALp3Cn028025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481AbYIJVvK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:51:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidehiro.kawai.ez@hitachi.com, jack@suse.cz


The patch titled
     jbd: test BH_Write_EIO to detect errors on metadata buffers
has been added to the -mm tree.  Its filename is
     jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

coredump_filter-add-description-of-bit-4.patch
jbd-abort-when-failed-to-log-metadata-buffers.patch
jbd-fix-error-handling-for-checkpoint-io.patch
ext3-add-checks-for-errors-from-jbd.patch
jbd-dont-dirty-original-metadata-buffer-on-abort.patch
jbd-test-bh_write_eio-to-detect-errors-on-metadata-buffers.patch

