From: akpm@linux-foundation.org
Subject: + o_direct-fix-the-splitting-up-of-contiguous-i-o.patch added to -mm tree
Date: Thu, 12 Aug 2010 14:04:51 -0700
Message-ID: <201008122104.o7CL4qAQ012632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754904Ab0HLVFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 17:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jmoyer@redhat.com, chris.mason@oracle.com, jbacik@redhat.com, stable@kernel.org


The patch titled
     O_DIRECT: fix the splitting up of contiguous I/O
has been added to the -mm tree.  Its filename is
     o_direct-fix-the-splitting-up-of-contiguous-i-o.patch

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
Subject: O_DIRECT: fix the splitting up of contiguous I/O
From: Jeff Moyer <jmoyer@redhat.com>

commit c2c6ca4 (direct-io: do not merge logically non-contiguous requests)
introduced a bug whereby all O_DIRECT I/Os were submitted a page at a time
to the block layer.  The problem is that the code expected
dio->block_in_file to correspond to the current page in the dio.  In fact,
it corresponds to the previous page submitted via submit_page_section. 
This was purely an oversight, as the dio->cur_page_fs_offset field was
introduced for just this purpose.  This patch simply uses the correct
variable when calculating whether there is a mismatch between contiguous
logical blocks and contiguous physical blocks (as described in the
comments).

I also switched the if conditional following this check to an else if, to
ensure that we never call dio_bio_submit twice for the same dio (in
theory, this should not happen, anyway).

I've tested this by running blktrace and verifying that a 64KB I/O was
submitted as a single I/O.  I also ran the patched kernel through
xfstests' aio tests using xfs, ext4 (with 1k and 4k block sizes) and btrfs
and verified that there were no regressions as compared to an unpatched
kernel.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Josef Bacik <jbacik@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: <stable@kernel.org>		[2.6.35.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/direct-io.c~o_direct-fix-the-splitting-up-of-contiguous-i-o fs/direct-io.c
--- a/fs/direct-io.c~o_direct-fix-the-splitting-up-of-contiguous-i-o
+++ a/fs/direct-io.c
@@ -634,7 +634,7 @@ static int dio_send_cur_page(struct dio 
 	int ret = 0;
 
 	if (dio->bio) {
-		loff_t cur_offset = dio->block_in_file << dio->blkbits;
+		loff_t cur_offset = dio->cur_page_fs_offset;
 		loff_t bio_next_offset = dio->logical_offset_in_bio +
 			dio->bio->bi_size;
 
@@ -659,7 +659,7 @@ static int dio_send_cur_page(struct dio 
 		 * Submit now if the underlying fs is about to perform a
 		 * metadata read
 		 */
-		if (dio->boundary)
+		else if (dio->boundary)
 			dio_bio_submit(dio);
 	}
 
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch
o_direct-fix-the-splitting-up-of-contiguous-i-o.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch

