From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:03 -0800
Message-ID: <200912152152.nBFLq3Tr015156@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761233AbZLOVxg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:53:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macli@brc.ubc.ca, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     mm/vmscan: change comment generic_file_write to __generic_file_aio_write
has been removed from the -mm tree.  Its filename was
     mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmscan: change comment generic_file_write to __generic_file_aio_write
From: Vincent Li <macli@brc.ubc.ca>

Commit 543ade1fc9 ("Streamline generic_file_* interfaces and filemap
cleanups") removed generic_file_write() in filemap.  Change the comment in
vmscan pageout() to __generic_file_aio_write().

Signed-off-by: Vincent Li <macli@brc.ubc.ca>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write
+++ a/mm/vmscan.c
@@ -358,7 +358,7 @@ static pageout_t pageout(struct page *pa
 	 * stalls if we need to run get_block().  We could test
 	 * PagePrivate for that.
 	 *
-	 * If this process is currently in generic_file_write() against
+	 * If this process is currently in __generic_file_aio_write() against
 	 * this page's queue, we can perform writeback even if that
 	 * will block.
 	 *
_

Patches currently in -mm which might be from macli@brc.ubc.ca are

origin.patch

