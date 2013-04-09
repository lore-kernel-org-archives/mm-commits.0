From: akpm@linux-foundation.org
Subject: + direct-io-submit-bio-after-boundary-buffer-is-added-to-it.patch added to -mm tree
Date: Tue, 09 Apr 2013 13:48:30 -0700
Message-ID: <20130409204830.81F6631C18B@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:36233 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147Ab3DIUsb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Apr 2013 16:48:31 -0400
Received: by mail-ie0-f202.google.com with SMTP id qd14so1867295ieb.3
        for <mm-commits@vger.kernel.org>; Tue, 09 Apr 2013 13:48:31 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, k-mio@sx.jp.nec.com


The patch titled
     Subject: direct-io: submit bio after boundary buffer is added to it
has been added to the -mm tree.  Its filename is
     direct-io-submit-bio-after-boundary-buffer-is-added-to-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
direct-io-fix-boundary-block-handling.patch
direct-io-submit-bio-after-boundary-buffer-is-added-to-it.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix.patch
mm-make-snapshotting-pages-for-stable-writes-a-per-bio-operation-fix-fix.patch

