From: akpm@linux-foundation.org
Subject: [merged] zram-propagate-error-to-user.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:10:53 -0700
Message-ID: <534465dd.Fwnb/pnrFy7fIU3c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56830 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbaDHVKy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:10:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, fengguang.wu@intel.com, minchan@kernel.org

Subject: [merged] zram-propagate-error-to-user.patch removed from -mm tree
To: minchan@kernel.org,fengguang.wu@intel.com,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:10:53 -0700


The patch titled
     Subject: zram: propagate error to user
has been removed from the -mm tree.  Its filename was
     zram-propagate-error-to-user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: propagate error to user

When we initialized zcomp with single, we couldn't change max_comp_streams
without zram reset but current interface doesn't show any error to user
and even it changes max_comp_streams's value without any effect so it
would make user very confusing.

This patch prevents max_comp_streams's change when zcomp was initialized
as single zcomp and emit the error to user(ex, echo).

[akpm@linux-foundation.org: don't return with the lock held, per Sergey]
[fengguang.wu@intel.com: fix coccinelle warnings]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    9 +++++----
 drivers/block/zram/zcomp.c      |   10 +++++-----
 drivers/block/zram/zcomp.h      |    4 ++--
 drivers/block/zram/zram_drv.c   |   17 +++++++++++++----
 4 files changed, 25 insertions(+), 15 deletions(-)

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
@@ -153,7 +153,7 @@ static void zcomp_strm_multi_release(str
 }
 
 /* change max_strm limit */
-static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
+static bool zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	struct zcomp_strm_multi *zs = comp->stream;
 	struct zcomp_strm *zstrm;
@@ -172,7 +172,7 @@ static int zcomp_strm_multi_set_max_stre
 		zs->avail_strm--;
 	}
 	spin_unlock(&zs->strm_lock);
-	return 0;
+	return true;
 }
 
 static void zcomp_strm_multi_destroy(struct zcomp *comp)
@@ -232,10 +232,10 @@ static void zcomp_strm_single_release(st
 	mutex_unlock(&zs->strm_lock);
 }
 
-static int zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
+static bool zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	/* zcomp_strm_single support only max_comp_streams == 1 */
-	return -ENOTSUPP;
+	return false;
 }
 
 static void zcomp_strm_single_destroy(struct zcomp *comp)
@@ -284,7 +284,7 @@ ssize_t zcomp_available_show(const char
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
@@ -127,19 +127,28 @@ static ssize_t max_comp_streams_store(st
 {
 	int num;
 	struct zram *zram = dev_to_zram(dev);
+	int ret;
 
-	if (kstrtoint(buf, 0, &num))
-		return -EINVAL;
+	ret = kstrtoint(buf, 0, &num);
+	if (ret < 0)
+		return ret;
 	if (num < 1)
 		return -EINVAL;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		if (zcomp_set_max_streams(zram->comp, num))
+		if (!zcomp_set_max_streams(zram->comp, num)) {
 			pr_info("Cannot change max compression streams\n");
+			ret = -EINVAL;
+			goto out;
+		}
 	}
+
 	zram->max_comp_streams = num;
+	ret = len;
+out:
 	up_write(&zram->init_lock);
-	return len;
+	return ret;
 }
 
 static ssize_t comp_algorithm_show(struct device *dev,
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch

