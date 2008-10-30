From: akpm@linux-foundation.org
Subject: + do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch added to -mm tree
Date: Thu, 30 Oct 2008 14:24:29 -0700
Message-ID: <200810302124.m9ULOTXl015826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434AbYJ3VYw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Oct 2008 17:24:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mikevs@xs4all.net, jens.axboe@oracle.com, nickpiggin@yahoo.com.au


The patch titled
     do_mpage_readpage(): don't submit lots of small bios on boundary
has been added to the -mm tree.  Its filename is
     do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch

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
Subject: do_mpage_readpage(): don't submit lots of small bios on boundary
From: Miquel van Smoorenburg <mikevs@xs4all.net>

While tracing I/O patterns with blktrace (a great tool) a few weeks ago I
identified a minor issue in fs/mpage.c

As the comment above mpage_readpages() says, a fs's get_block function
will set BH_Boundary when it maps a block just before a block for which
extra I/O is required.

Since get_block() can map a range of pages, for all these pages the
BH_Boundary flag will be set.  But we only need to push what I/O we have
accumulated at the last block of this range.

This makes do_mpage_readpage() send out the largest possible bio instead
of a bunch of page-sized ones in the BH_Boundary case.

Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/mpage.c~do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary fs/mpage.c
--- a/fs/mpage.c~do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary
+++ a/fs/mpage.c
@@ -308,7 +308,10 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	if (buffer_boundary(map_bh) || (first_hole != blocks_per_page))
+	relative_block = block_in_file - *first_logical_block;
+	nblocks = map_bh->b_size >> blkbits;
+	if ((buffer_boundary(map_bh) && relative_block == nblocks) ||
+	    (first_hole != blocks_per_page))
 		bio = mpage_bio_submit(READ, bio);
 	else
 		*last_block_in_bio = blocks[blocks_per_page - 1];
_

Patches currently in -mm which might be from mikevs@xs4all.net are

elevatorc-prevent-flushing-small-requests-to-device.patch
do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch

