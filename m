From: akpm@linux-foundation.org
Subject: + direct-io-fix-boundary-block-handling.patch added to -mm tree
Date: Fri, 08 Mar 2013 16:08:48 -0800
Message-ID: <20130309000848.7393731C1B5@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:41990 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab3CIAIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 19:08:49 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so218841qen.4
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 16:08:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, k-mio@sx.jp.nec.com


The patch titled
     Subject: direct-io: Fix boundary block handling
has been added to the -mm tree.  Its filename is
     direct-io-fix-boundary-block-handling.patch

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
Subject: direct-io: Fix boundary block handling

When we read/write a file sequentially, we will read/write not only the
data blocks but also the indirect blocks that may not be physically
adjacent to the data blocks.  So filesystems sets BG_Boundary flag to
submit the previous I/O before reading/writing an indirect block.

However generic direct IO code mishandles buffer_boundary() flag, sets
sdio->boundary before each submit_page_section() call which results in
sending only one page bios as underlying code thinks this page is the last
in the contiguous extent.  So fix the problem by setting sdio->boundary
only if the current page is really the last one in the mapped extent.

Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/direct-io.c~direct-io-fix-boundary-block-handling fs/direct-io.c
--- a/fs/direct-io.c~direct-io-fix-boundary-block-handling
+++ a/fs/direct-io.c
@@ -969,7 +969,8 @@ do_holes:
 			this_chunk_bytes = this_chunk_blocks << blkbits;
 			BUG_ON(this_chunk_bytes == 0);
 
-			sdio->boundary = buffer_boundary(map_bh);
+			if (this_chunk_blocks == sdio->blocks_available)
+				sdio->boundary = buffer_boundary(map_bh);
 			ret = submit_page_section(dio, sdio, page,
 						  offset_in_page,
 						  this_chunk_bytes,
_

Patches currently in -mm which might be from jack@suse.cz are

linux-next.patch
fs-return-eagain-when-o_nonblock-write-should-block-on-frozen-fs.patch
fs-fix-hang-with-bsd-accounting-on-frozen-filesystem.patch
ocfs2-add-freeze-protection-to-ocfs2_file_splice_write.patch
direct-io-fix-boundary-block-handling.patch

