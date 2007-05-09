From: akpm@linux-foundation.org
Subject: - splice-and-readahead-interaction.patch removed from -mm tree
Date: Tue, 08 May 2007 20:04:03 -0700
Message-ID: <200705090304.l49343db011009@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033089AbXEIDEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:04:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@gmail.com, dada1@cosmosbay.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     splice(): fix interaction with readahead
has been removed from the -mm tree.  Its filename was
     splice-and-readahead-interaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: splice(): fix interaction with readahead
From: "Fengguang Wu" <fengguang.wu@gmail.com>

Eric Dumazet, thank you for disclosing this bug.

Readahead logic somehow fails to populate the page range with data.
It can be because

1) the readahead routine is not always called in the following lines of

fs/splice.c:
        if (!loff || nr_pages > 1)
                page_cache_readahead(mapping, &in->f_ra, in, index, nr_pages);

2) even called, page_cache_readahead() wont guarantee the pages are there.
It wont submit readahead I/O for pages already in the radix tree, or when
(ra_pages == 0), or after 256 cache hits.

In your case, it should be because of the retried reads, which lead to
excessive cache hits, and disables readahead at some time.

And that _one_ failure of readahead blocks the whole read process.
The application receives EAGAIN and retries the read, but
__generic_file_splice_read() refuse to make progress:

- in the previous invocation, it has allocated a blank page and inserted it
  into the radix tree, but never has the chance to start I/O for it: the test
  of SPLICE_F_NONBLOCK goes before that.

- in the retried invocation, the readahead code will neither get out of the
  cache hit mode, nor will it submit I/O for an already existing page.

Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN fs/splice.c~splice-and-readahead-interaction fs/splice.c
--- a/fs/splice.c~splice-and-readahead-interaction
+++ a/fs/splice.c
@@ -378,10 +378,11 @@ __generic_file_splice_read(struct file *
 			 * If in nonblock mode then dont block on waiting
 			 * for an in-flight io page
 			 */
-			if (flags & SPLICE_F_NONBLOCK)
-				break;
-
-			lock_page(page);
+			if (flags & SPLICE_F_NONBLOCK) {
+				if (TestSetPageLocked(page))
+					break;
+			} else
+				lock_page(page);
 
 			/*
 			 * page was truncated, stop here. if this isn't the
_

Patches currently in -mm which might be from fengguang.wu@gmail.com are

origin.patch
