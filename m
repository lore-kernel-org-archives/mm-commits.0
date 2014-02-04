From: akpm@linux-foundation.org
Subject: + zram-remove-good-and-bad-compress-stats.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:19:12 -0800
Message-ID: <52f16760.BRmcIy1xGhC2/gCB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934996AbaBDWTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:19:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-remove-good-and-bad-compress-stats.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:19:12 -0800


The patch titled
     Subject: zram: remove good and bad compress stats
has been added to the -mm tree.  Its filename is
     zram-remove-good-and-bad-compress-stats.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-good-and-bad-compress-stats.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-good-and-bad-compress-stats.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove good and bad compress stats

Remove `good' and `bad' compressed sub-requests stats.  RW request may
cause a number of RW sub-requests.  zram used to account `good' compressed
sub-queries (with compressed size less than 50% of original size), `bad'
compressed sub-queries (with compressed size greater that 75% of original
size), leaving sub-requests with compression size between 50% and 75% of
original size not accounted and not reported.  zram already accounts each
sub-request's compression size so we can calculate real device compression
ratio.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 -----------
 drivers/block/zram/zram_drv.h |    2 --
 2 files changed, 13 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-good-and-bad-compress-stats drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-good-and-bad-compress-stats
+++ a/drivers/block/zram/zram_drv.c
@@ -293,7 +293,6 @@ static void zram_free_page(struct zram *
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
-	u16 size = meta->table[index].size;
 
 	if (unlikely(!handle)) {
 		/*
@@ -307,14 +306,8 @@ static void zram_free_page(struct zram *
 		return;
 	}
 
-	if (unlikely(size > max_zpage_size))
-		atomic_dec(&zram->stats.bad_compress);
-
 	zs_free(meta->mem_pool, handle);
 
-	if (size <= PAGE_SIZE / 2)
-		atomic_dec(&zram->stats.good_compress);
-
 	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
 	atomic_dec(&zram->stats.pages_stored);
 
@@ -478,7 +471,6 @@ static int zram_bvec_write(struct zram *
 	}
 
 	if (unlikely(clen > max_zpage_size)) {
-		atomic_inc(&zram->stats.bad_compress);
 		clen = PAGE_SIZE;
 		src = NULL;
 		if (is_partial_io(bvec))
@@ -518,9 +510,6 @@ static int zram_bvec_write(struct zram *
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
 	atomic_inc(&zram->stats.pages_stored);
-	if (clen <= PAGE_SIZE / 2)
-		atomic_inc(&zram->stats.good_compress);
-
 out:
 	if (locked)
 		mutex_unlock(&meta->buffer_lock);
diff -puN drivers/block/zram/zram_drv.h~zram-remove-good-and-bad-compress-stats drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-good-and-bad-compress-stats
+++ a/drivers/block/zram/zram_drv.h
@@ -78,8 +78,6 @@ struct zram_stats {
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic_t pages_zero;		/* no. of zero filled pages */
 	atomic_t pages_stored;	/* no. of pages currently stored */
-	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
-	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch

