From: akpm@linux-foundation.org
Subject: + splice-and-readahead-interaction.patch added to -mm tree
Date: Mon, 07 May 2007 14:53:10 -0700
Message-ID: <200705072153.l47LrBQf006306@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44814 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966975AbXEGV5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 17:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@gmail.com, dada1@cosmosbay.com, jens.axboe@oracle.com


The patch titled
     splice(): fix interaction with readahead
has been added to the -mm tree.  Its filename is
     splice-and-readahead-interaction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

splice-and-readahead-interaction.patch
readahead-partial-sendfile-fix.patch
