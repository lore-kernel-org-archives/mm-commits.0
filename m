From: akpm@linux-foundation.org
Subject: + zram-do-not-count-duplicated-pages-as-compressed.patch added to -mm tree
Date: Mon, 15 May 2017 14:56:22 -0700
Message-ID: <591a2406.HQKVAbGhwvU138wA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdEOV42 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 17:56:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, iamjoonsoo.kim@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: do not count duplicated pages as compressed
has been added to the -mm tree.  Its filename is
     zram-do-not-count-duplicated-pages-as-compressed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-do-not-count-duplicated-pages-as-compressed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-do-not-count-duplicated-pages-as-compressed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: do not count duplicated pages as compressed

It's not the same compressed pages and deduplicated pages so we shouldn't
count duplicated pages as compressed pages.

Link: http://lkml.kernel.org/r/1494834068-27004-2-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_dedup.c |    4 ----
 drivers/block/zram/zram_drv.c   |   24 +++++++++++++++++++-----
 drivers/block/zram/zram_drv.h   |    1 +
 3 files changed, 20 insertions(+), 9 deletions(-)

diff -puN drivers/block/zram/zram_dedup.c~zram-do-not-count-duplicated-pages-as-compressed drivers/block/zram/zram_dedup.c
--- a/drivers/block/zram/zram_dedup.c~zram-do-not-count-duplicated-pages-as-compressed
+++ a/drivers/block/zram/zram_dedup.c
@@ -101,9 +101,6 @@ static unsigned long zram_dedup_put(stru
 	entry->refcount--;
 	if (!entry->refcount)
 		rb_erase(&entry->rb_node, &hash->rb_root);
-	else
-		atomic64_sub(entry->len, &zram->stats.dup_data_size);
-
 	spin_unlock(&hash->lock);
 
 	return entry->refcount;
@@ -127,7 +124,6 @@ static struct zram_entry *__zram_dedup_g
 
 again:
 	entry->refcount++;
-	atomic64_add(entry->len, &zram->stats.dup_data_size);
 	spin_unlock(&hash->lock);
 
 	if (prev)
diff -puN drivers/block/zram/zram_drv.c~zram-do-not-count-duplicated-pages-as-compressed drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-do-not-count-duplicated-pages-as-compressed
+++ a/drivers/block/zram/zram_drv.c
@@ -624,15 +624,22 @@ static void zram_free_page(struct zram *
 		return;
 	}
 
+	if (zram_dedup_enabled(zram) &&
+			zram_test_flag(zram, index, ZRAM_DUP)) {
+		zram_clear_flag(zram, index, ZRAM_DUP);
+		atomic64_sub(entry->len, &zram->stats.dup_data_size);
+		goto out;
+	}
+
 	if (!entry)
 		return;
 
-	zram_entry_free(zram, entry);
-
 	atomic64_sub(zram_get_obj_size(zram, index),
 			&zram->stats.compr_data_size);
-	atomic64_dec(&zram->stats.pages_stored);
+out:
+	zram_entry_free(zram, entry);
 
+	atomic64_dec(&zram->stats.pages_stored);
 	zram_set_entry(zram, index, NULL);
 	zram_set_obj_size(zram, index, 0);
 }
@@ -794,7 +801,15 @@ static int __zram_bvec_write(struct zram
 	entry = zram_dedup_find(zram, page, &checksum);
 	if (entry) {
 		comp_len = entry->len;
-		goto found_dup;
+		zram_slot_lock(zram, index);
+		zram_free_page(zram, index);
+		zram_set_flag(zram, index, ZRAM_DUP);
+		zram_set_entry(zram, index, entry);
+		zram_set_obj_size(zram, index, comp_len);
+		zram_slot_unlock(zram, index);
+		atomic64_add(comp_len, &zram->stats.dup_data_size);
+		atomic64_inc(&zram->stats.pages_stored);
+		return 0;
 	}
 
 	zstrm = zcomp_stream_get(zram->comp);
@@ -818,7 +833,6 @@ static int __zram_bvec_write(struct zram
 	zs_unmap_object(zram->mem_pool, zram_entry_handle(zram, entry));
 	zram_dedup_insert(zram, entry, checksum);
 
-found_dup:
 	/*
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
diff -puN drivers/block/zram/zram_drv.h~zram-do-not-count-duplicated-pages-as-compressed drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-do-not-count-duplicated-pages-as-compressed
+++ a/drivers/block/zram/zram_drv.h
@@ -64,6 +64,7 @@ static const size_t max_zpage_size = PAG
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
 	ZRAM_SAME = ZRAM_FLAG_SHIFT,
+	ZRAM_DUP,
 	ZRAM_ACCESS,	/* page is now accessed */
 
 	__NR_ZRAM_PAGEFLAGS,
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-count-same-page-write-as-page_stored.patch
zram-do-not-count-duplicated-pages-as-compressed.patch
mm-thp-swap-unify-swap-slot-free-functions-to-put_swap_page.patch
mm-thp-swap-move-anonymous-thp-split-logic-to-vmscan.patch

