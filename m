From: akpm@linux-foundation.org
Subject: + zram-propagate-error-to-user.patch added to -mm tree
Date: Mon, 10 Mar 2014 12:17:46 -0700
Message-ID: <531e0fda.CpSj9xo9QqJUrC9o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaCJTRr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 15:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + zram-propagate-error-to-user.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 12:17:46 -0700


The patch titled
     Subject: zram: propagate error to user
has been added to the -mm tree.  Its filename is
     zram-propagate-error-to-user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-propagate-error-to-user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-propagate-error-to-user.patch

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
Subject: zram: propagate error to user

When we initialized zcomp with single, we couldn't change max_comp_streams
without zram reset but current interface doesn't show any error to user
and even it changes max_comp_streams's value without any effect so it
would make user very confusing.

This patch prevents max_comp_streams's change when zcomp was initialized
as single zcomp and emit the error to user(ex, echo).

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    9 +++++----
 drivers/block/zram/zcomp.c      |   10 +++++-----
 drivers/block/zram/zcomp.h      |    4 ++--
 drivers/block/zram/zram_drv.c   |   15 +++++++++++----
 4 files changed, 23 insertions(+), 15 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-propagate-error-to-user Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-propagate-error-to-user
+++ a/Documentation/blockdev/zram.txt
@@ -37,10 +37,11 @@ Note:
 In order to enable compression backend's multi stream support max_comp_streams
 must be initially set to desired concurrency level before ZRAM device
 initialisation. Once the device initialised as a single stream compression
-backend (max_comp_streams equals to 0) changing the value of max_comp_streams
-will not take any effect, because single stream compression backend implemented
-as a special case and does not support dynamic max_comp_streams. Only multi
-stream backend supports dynamic max_comp_streams adjustment.
+backend (max_comp_streams equals to 1), you will see error if you try to change
+the value of max_comp_streams because single stream compression backend
+implemented as a special case by lock overhead issue and does not support
+dynamic max_comp_streams. Only multi stream backend supports dynamic
+max_comp_streams adjustment.
 
 3) Select compression algorithm
 	Using comp_algorithm device attribute one can see available and
diff -puN drivers/block/zram/zcomp.c~zram-propagate-error-to-user drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-propagate-error-to-user
+++ a/drivers/block/zram/zcomp.c
@@ -152,7 +152,7 @@ static void zcomp_strm_multi_release(str
 }
 
 /* change max_strm limit */
-static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
+static bool zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	struct zcomp_strm_multi *zs = comp->stream;
 	struct zcomp_strm *zstrm;
@@ -171,7 +171,7 @@ static int zcomp_strm_multi_set_max_stre
 		zs->avail_strm--;
 	}
 	spin_unlock(&zs->strm_lock);
-	return 0;
+	return true;
 }
 
 static void zcomp_strm_multi_destroy(struct zcomp *comp)
@@ -231,10 +231,10 @@ static void zcomp_strm_single_release(st
 	mutex_unlock(&zs->strm_lock);
 }
 
-static int zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
+static bool zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	/* zcomp_strm_single support only max_comp_streams == 1 */
-	return -ENOTSUPP;
+	return 0;
 }
 
 static void zcomp_strm_single_destroy(struct zcomp *comp)
@@ -283,7 +283,7 @@ ssize_t zcomp_available_show(const char
 	return sz;
 }
 
-int zcomp_set_max_streams(struct zcomp *comp, int num_strm)
+bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	return comp->set_max_streams(comp, num_strm);
 }
diff -puN drivers/block/zram/zcomp.h~zram-propagate-error-to-user drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-propagate-error-to-user
+++ a/drivers/block/zram/zcomp.h
@@ -46,7 +46,7 @@ struct zcomp {
 
 	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
 	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
-	int (*set_max_streams)(struct zcomp *comp, int num_strm);
+	bool (*set_max_streams)(struct zcomp *comp, int num_strm);
 	void (*destroy)(struct zcomp *comp);
 };
 
@@ -64,5 +64,5 @@ int zcomp_compress(struct zcomp *comp, s
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
 
-int zcomp_set_max_streams(struct zcomp *comp, int num_strm);
+bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
diff -puN drivers/block/zram/zram_drv.c~zram-propagate-error-to-user drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-propagate-error-to-user
+++ a/drivers/block/zram/zram_drv.c
@@ -128,17 +128,24 @@ static ssize_t max_comp_streams_store(st
 	struct zram *zram = dev_to_zram(dev);
 
 	if (kstrtoint(buf, 0, &num))
-		return -EINVAL;
+		goto out;
 	if (num < 1)
-		return -EINVAL;
+		goto out;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		if (zcomp_set_max_streams(zram->comp, num))
+		if (!zcomp_set_max_streams(zram->comp, num)) {
 			pr_info("Cannot change max compression streams\n");
+			goto out_unlock;
+		}
 	}
+
 	zram->max_comp_streams = num;
-	up_write(&zram->init_lock);
 	return len;
+out_unlock:
+	up_write(&zram->init_lock);
+out:
+	return -EINVAL;
 }
 
 static ssize_t comp_algorithm_show(struct device *dev,
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch
mm-kconfig-fix-url-for-zsmalloc-benchmark.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees-fix.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch
zram-document-failed_reads-failed_writes-stats.patch
zram-delete-zram_init_device.patch
zram-delete-zram_init_device-fix.patch
zram-introduce-compressing-backend-abstraction.patch
zram-use-zcomp-compressing-backends.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-factor-out-single-stream-compression.patch
zram-add-multi-stream-functionality.patch
zram-add-set_max_streams-knob.patch
zram-make-compression-algorithm-selection-possible.patch
zram-add-lz4-algorithm-backend.patch
zram-move-comp-allocation-out-of-init_lock.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user.patch
mm-zswap-fix-trivial-typo-and-arrange-indentation.patch
mm-zswap-update-zsmalloc-in-comment-to-zbud.patch
mm-zswap-support-multiple-swap-devices.patch
debugging-keep-track-of-page-owners.patch

