From: akpm@linux-foundation.org
Subject: + mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write.patch added to -mm tree
Date: Fri, 16 Oct 2009 14:05:04 -0700
Message-ID: <200910162105.n9GL54TE000742@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751305AbZJPVFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 17:05:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macli@brc.ubc.ca, hch@lst.de


The patch titled
     mm/vmscan: change comment generic_file_write to __generic_file_aio_write
has been added to the -mm tree.  Its filename is
     mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-vsmcan-check-shrink_active_list-sc-isolate_pages-return-value.patch
mm-vmscan-change-comment-generic_file_write-to-__generic_file_aio_write.patch

