From: akpm@linux-foundation.org
Subject: [merged] aio-dont-zero-out-the-pages-array-inside-struct-dio.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:37 -0800
Message-ID: <200912162039.nBGKdbQt013550@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964998AbZLPUj7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     dio: don't zero out the pages array inside struct dio
has been removed from the -mm tree.  Its filename was
     aio-dont-zero-out-the-pages-array-inside-struct-dio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dio: don't zero out the pages array inside struct dio
From: Jeff Moyer <jmoyer@redhat.com>

Intel reported a performance regression caused by the following commit:

commit 848c4dd5153c7a0de55470ce99a8e13a63b4703f
Author: Zach Brown <zach.brown@oracle.com>
Date:   Mon Aug 20 17:12:01 2007 -0700

    dio: zero struct dio with kzalloc instead of manually

    This patch uses kzalloc to zero all of struct dio rather than
    manually trying to track which fields we rely on being zero.  It
    passed aio+dio stress testing and some bug regression testing on
    ext3.

    This patch was introduced by Linus in the conversation that lead up
    to Badari's minimal fix to manually zero .map_bh.b_state in commit:

      6a648fa72161d1f6468dabd96c5d3c0db04f598a

    It makes the code a bit smaller.  Maybe a couple fewer cachelines to
    load, if we're lucky:

       text    data     bss     dec     hex filename
    3285925  568506 1304616 5159047  4eb887 vmlinux
    3285797  568506 1304616 5158919  4eb807 vmlinux.patched

    I was unable to measure a stable difference in the number of cpu
    cycles spent in blockdev_direct_IO() when pushing aio+dio 256K reads
    at ~340MB/s.

    So the resulting intent of the patch isn't a performance gain but to
    avoid exposing ourselves to the risk of finding another field like
    .map_bh.b_state where we rely on zeroing but don't enforce it in the
    code.

Zach surmised that zeroing out the page array was what caused most of
the problem, and suggested the approach taken in the attached patch for
resolving the issue.  Intel re-tested with this patch and saw a 0.6%
performance gain (the original regression was 0.5%).

[akpm@linux-foundation.org: add comment]
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff -puN fs/direct-io.c~aio-dont-zero-out-the-pages-array-inside-struct-dio fs/direct-io.c
--- a/fs/direct-io.c~aio-dont-zero-out-the-pages-array-inside-struct-dio
+++ a/fs/direct-io.c
@@ -104,6 +104,18 @@ struct dio {
 	unsigned cur_page_len;		/* Nr of bytes at cur_page_offset */
 	sector_t cur_page_block;	/* Where it starts */
 
+	/* BIO completion state */
+	spinlock_t bio_lock;		/* protects BIO fields below */
+	unsigned long refcount;		/* direct_io_worker() and bios */
+	struct bio *bio_list;		/* singly linked via bi_private */
+	struct task_struct *waiter;	/* waiting task (NULL if none) */
+
+	/* AIO related stuff */
+	struct kiocb *iocb;		/* kiocb */
+	int is_async;			/* is IO async ? */
+	int io_error;			/* IO error in completion path */
+	ssize_t result;                 /* IO result */
+
 	/*
 	 * Page fetching state. These variables belong to dio_refill_pages().
 	 */
@@ -115,22 +127,16 @@ struct dio {
 	 * Page queue.  These variables belong to dio_refill_pages() and
 	 * dio_get_page().
 	 */
-	struct page *pages[DIO_PAGES];	/* page buffer */
 	unsigned head;			/* next page to process */
 	unsigned tail;			/* last valid page + 1 */
 	int page_errors;		/* errno from get_user_pages() */
 
-	/* BIO completion state */
-	spinlock_t bio_lock;		/* protects BIO fields below */
-	unsigned long refcount;		/* direct_io_worker() and bios */
-	struct bio *bio_list;		/* singly linked via bi_private */
-	struct task_struct *waiter;	/* waiting task (NULL if none) */
-
-	/* AIO related stuff */
-	struct kiocb *iocb;		/* kiocb */
-	int is_async;			/* is IO async ? */
-	int io_error;			/* IO error in completion path */
-	ssize_t result;                 /* IO result */
+	/*
+	 * pages[] (and any fields placed after it) are not zeroed out at
+	 * allocation time.  Don't add new fields after pages[] unless you
+	 * wish that they not be zeroed.
+	 */
+	struct page *pages[DIO_PAGES];	/* page buffer */
 };
 
 /*
@@ -1151,10 +1157,16 @@ __blockdev_direct_IO(int rw, struct kioc
 		}
 	}
 
-	dio = kzalloc(sizeof(*dio), GFP_KERNEL);
+	dio = kmalloc(sizeof(*dio), GFP_KERNEL);
 	retval = -ENOMEM;
 	if (!dio)
 		goto out;
+	/*
+	 * Believe it or not, zeroing out the page array caused a .5%
+	 * performance regression in a database benchmark.  So, we take
+	 * care to only zero out what's needed.
+	 */
+	memset(dio, 0, offsetof(struct dio, pages));
 
 	/*
 	 * For block device access DIO_NO_LOCKING is used,
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch

