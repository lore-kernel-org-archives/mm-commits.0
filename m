From: akpm@linux-foundation.org
Subject: [merged] direct-io-submit-bio-after-boundary-buffer-is-added-to-it.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:44:46 -0700
Message-ID: <20130430184446.7AFC831C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55315 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463Ab3D3Sor (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:44:47 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so84581qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:44:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jack@suse.cz, k-mio@sx.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: direct-io: submit bio after boundary buffer is added to it
has been removed from the -mm tree.  Its filename was
     direct-io-submit-bio-after-boundary-buffer-is-added-to-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: direct-io: submit bio after boundary buffer is added to it

Currently, dio_send_cur_page() submits bio before current page and cached
sdio->cur_page is added to the bio if sdio->boundary is set.  This is
actually wrong because sdio->boundary means the current buffer is the last
one before metadata needs to be read.  So we should rather submit the bio
after the current page is added to it.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Tested-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff -puN fs/direct-io.c~direct-io-submit-bio-after-boundary-buffer-is-added-to-it fs/direct-io.c
--- a/fs/direct-io.c~direct-io-submit-bio-after-boundary-buffer-is-added-to-it
+++ a/fs/direct-io.c
@@ -672,12 +672,6 @@ static inline int dio_send_cur_page(stru
 		if (sdio->final_block_in_bio != sdio->cur_page_block ||
 		    cur_offset != bio_next_offset)
 			dio_bio_submit(dio, sdio);
-		/*
-		 * Submit now if the underlying fs is about to perform a
-		 * metadata read
-		 */
-		else if (sdio->boundary)
-			dio_bio_submit(dio, sdio);
 	}
 
 	if (sdio->bio == NULL) {
@@ -737,16 +731,6 @@ submit_page_section(struct dio *dio, str
 	    sdio->cur_page_block +
 	    (sdio->cur_page_len >> sdio->blkbits) == blocknr) {
 		sdio->cur_page_len += len;
-
-		/*
-		 * If sdio->boundary then we want to schedule the IO now to
-		 * avoid metadata seeks.
-		 */
-		if (sdio->boundary) {
-			ret = dio_send_cur_page(dio, sdio, map_bh);
-			page_cache_release(sdio->cur_page);
-			sdio->cur_page = NULL;
-		}
 		goto out;
 	}
 
@@ -758,7 +742,7 @@ submit_page_section(struct dio *dio, str
 		page_cache_release(sdio->cur_page);
 		sdio->cur_page = NULL;
 		if (ret)
-			goto out;
+			return ret;
 	}
 
 	page_cache_get(page);		/* It is in dio */
@@ -768,6 +752,16 @@ submit_page_section(struct dio *dio, str
 	sdio->cur_page_block = blocknr;
 	sdio->cur_page_fs_offset = sdio->block_in_file << sdio->blkbits;
 out:
+	/*
+	 * If sdio->boundary then we want to schedule the IO now to
+	 * avoid metadata seeks.
+	 */
+	if (sdio->boundary) {
+		ret = dio_send_cur_page(dio, sdio, map_bh);
+		dio_bio_submit(dio, sdio);
+		page_cache_release(sdio->cur_page);
+		sdio->cur_page = NULL;
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
kthread-implement-probe_kthread_data.patch
workqueue-include-workqueue-info-when-printing-debug-dump-of-a-worker-task.patch
writeback-set-worker-desc-to-identify-writeback-workers-in-task-dumps.patch

