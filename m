From: akpm@linux-foundation.org
Subject: + dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch added to -mm tree
Date: Tue, 30 Aug 2011 16:47:43 -0700
Message-ID: <201108302347.p7UNlhi8026211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab1H3XsW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Aug 2011 19:48:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, axboe@kernel.dk, hch@lst.de, jmoyer@redhat.com


The patch titled
     dio: rearrange fields in dio/dio_submit to avoid holes
has been added to the -mm tree.  Its filename is
     dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes.patch

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
Subject: dio: rearrange fields in dio/dio_submit to avoid holes
From: Andi Kleen <ak@linux.intel.com>

Fix most problems reported by pahole.

There is still a weird 104 byte hole after map_bh. I'm not sure what
causes this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN fs/direct-io.c~dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes fs/direct-io.c
--- a/fs/direct-io.c~dio-rearrange-fields-in-dio-dio_submit-to-avoid-holes
+++ a/fs/direct-io.c
@@ -73,10 +73,10 @@ struct dio_submit {
 	sector_t block_in_file;		/* Current offset into the underlying
 					   file in dio_block units. */
 	unsigned blocks_available;	/* At block_in_file.  changes */
+	int reap_counter;		/* rate limit reaping */
 	sector_t final_block_in_request;/* doesn't change */
 	unsigned first_block_in_page;	/* doesn't change, Used only once */
 	int boundary;			/* prev block is at a boundary */
-	int reap_counter;		/* rate limit reaping */
 	get_block_t *get_block;		/* block mapping function */
 	dio_submit_t *submit_io;	/* IO submition function */
 
@@ -114,27 +114,26 @@ struct dio_submit {
 /* dio_state communicated between submission path and end_io */
 struct dio {
 	int flags;			/* doesn't change */
-	struct inode *inode;
 	int rw;
+	struct inode *inode;
 	loff_t i_size;			/* i_size when submitted */
 	dio_iodone_t *end_io;		/* IO completion function */
-	struct buffer_head map_bh;	/* last get_block() result */
 
 
 	/* BIO completion state */
 	spinlock_t bio_lock;		/* protects BIO fields below */
+	int page_errors;		/* errno from get_user_pages() */
+	int is_async;			/* is IO async ? */
+	int io_error;			/* IO error in completion path */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
 	struct task_struct *waiter;	/* waiting task (NULL if none) */
 
 	/* AIO related stuff */
 	struct kiocb *iocb;		/* kiocb */
-	int is_async;			/* is IO async ? */
-	int io_error;			/* IO error in completion path */
 	ssize_t result;                 /* IO result */
 
-	int page_errors;		/* errno from get_user_pages() */
