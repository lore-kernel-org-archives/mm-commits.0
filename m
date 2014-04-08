From: akpm@linux-foundation.org
Subject: [merged] zram-add-set_max_streams-knob.patch removed from -mm
 tree
Date: Tue, 08 Apr 2014 14:08:13 -0700
Message-ID: <5344653d.5OEhpU+ssPX4iawZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbaDHVIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:08:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-add-set_max_streams-knob.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:08:13 -0700


The patch titled
     Subject: zram: add set_max_streams knob
has been removed from the -mm tree.  Its filename was
     zram-add-set_max_streams-knob.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: add set_max_streams knob

This patch allows to change max_comp_streams on initialised zcomp.

Introduce zcomp set_max_streams() knob, zcomp_strm_multi_set_max_streams()
and zcomp_strm_single_set_max_streams() callbacks to change streams limit
for zcomp_strm_multi and zcomp_strm_single, accordingly.  set_max_streams
for single steam zcomp does nothing.

If user has lowered the limit, then zcomp_strm_multi_set_max_streams()
attempts to immediately free extra streams (as much as it can, depending
on idle streams availability).

Note, this patch does not allow to change stream 'policy' from single to
multi stream (or vice versa) on already initialised compression backend.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |   36 ++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h    |    3 ++
 drivers/block/zram/zram_drv.c |    5 +---
 3 files changed, 41 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-add-set_max_streams-knob drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-add-set_max_streams-knob
+++ a/drivers/block/zram/zcomp.c
@@ -136,6 +136,29 @@ static void zcomp_strm_multi_release(str
 	zcomp_strm_free(comp, zstrm);
 }
 
+/* change max_strm limit */
+static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	struct zcomp_strm_multi *zs = comp->stream;
+	struct zcomp_strm *zstrm;
+
+	spin_lock(&zs->strm_lock);
+	zs->max_strm = num_strm;
+	/*
+	 * if user has lowered the limit and there are idle streams,
+	 * immediately free as much streams (and memory) as we can.
+	 */
+	while (zs->avail_strm > num_strm && !list_empty(&zs->idle_strm)) {
+		zstrm = list_entry(zs->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+		zs->avail_strm--;
+	}
+	spin_unlock(&zs->strm_lock);
+	return 0;
+}
+
 static void zcomp_strm_multi_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_multi *zs = comp->stream;
@@ -158,6 +181,7 @@ static int zcomp_strm_multi_create(struc
 	comp->destroy = zcomp_strm_multi_destroy;
 	comp->strm_find = zcomp_strm_multi_find;
 	comp->strm_release = zcomp_strm_multi_release;
+	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -192,6 +216,12 @@ static void zcomp_strm_single_release(st
 	mutex_unlock(&zs->strm_lock);
 }
 
+static int zcomp_strm_single_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	/* zcomp_strm_single support only max_comp_streams == 1 */
+	return -ENOTSUPP;
+}
+
 static void zcomp_strm_single_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zs = comp->stream;
@@ -206,6 +236,7 @@ static int zcomp_strm_single_create(stru
 	comp->destroy = zcomp_strm_single_destroy;
 	comp->strm_find = zcomp_strm_single_find;
 	comp->strm_release = zcomp_strm_single_release;
+	comp->set_max_streams = zcomp_strm_single_set_max_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -220,6 +251,11 @@ static int zcomp_strm_single_create(stru
 	return 0;
 }
 
+int zcomp_set_max_streams(struct zcomp *comp, int num_strm)
+{
+	return comp->set_max_streams(comp, num_strm);
+}
+
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
 	return comp->strm_find(comp);
diff -puN drivers/block/zram/zcomp.h~zram-add-set_max_streams-knob drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-add-set_max_streams-knob
+++ a/drivers/block/zram/zcomp.h
@@ -46,6 +46,7 @@ struct zcomp {
 
 	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
 	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
+	int (*set_max_streams)(struct zcomp *comp, int num_strm);
 	void (*destroy)(struct zcomp *comp);
 };
 
@@ -60,4 +61,6 @@ int zcomp_compress(struct zcomp *comp, s
 
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
+
+int zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
diff -puN drivers/block/zram/zram_drv.c~zram-add-set_max_streams-knob drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-set_max_streams-knob
+++ a/drivers/block/zram/zram_drv.c
@@ -133,9 +133,8 @@ static ssize_t max_comp_streams_store(st
 		return -EINVAL;
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
-		pr_info("Can't set max_comp_streams for initialized device\n");
-		return -EBUSY;
+		if (zcomp_set_max_streams(zram->comp, num))
+			pr_info("Cannot change max compression streams\n");
 	}
 	zram->max_comp_streams = num;
 	up_write(&zram->init_lock);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

