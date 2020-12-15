Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E18FC2BBD4
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10C6922CF7
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgLPAAc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726557AbgLOX2M (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:28:12 -0500
Date:   Tue, 15 Dec 2020 15:24:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074666;
        bh=2F2gTQcDiWfdTB1EwsI2u0Pr+rfQVNJpx8Z9p4Qb+kI=;
        h=From:To:Subject:From;
        b=Tg1BobuipQkx2QUoOR2toe2m5Q0q186SbmcbroRXwhKiiqSMrnclrT9g5zt41m536
         HvszX3H5d8Ebg5fkQ+AZ35BMniDHDRCKcX+9YSLC7w171PqI0MIK6kzw6IM9tZ/UVl
         i0JOBpc9/0v/xpmDDZ/wzyDiu08thWDF71PR5UwI=
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky@gmail.com
Subject:  [merged] zram-support-a-page-writeback.patch removed from
 -mm tree
Message-ID: <20201215232426.sKiD50wUY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: support page writeback
has been removed from the -mm tree.  Its filename was
     zram-support-a-page-writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: support page writeback

There is demand to writeback specific process pages to backing store
instead of all idles pages in the system due to storage wear out concerns
and to launching latency of apps which are most of the time idle but are
critical for resume latency.

This patch extends the writeback knob to support a specific page
writeback.

Link: https://lkml.kernel.org/r/20201020190506.3758660-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    5 ++++
 drivers/block/zram/zram_drv.c               |   21 ++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-support-a-page-writeback
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -334,6 +334,11 @@ Admin can request writeback of those idl
 
 With the command, zram writeback idle pages from memory to the storage.
 
+If admin want to write a specific page in zram device to backing device,
+they could write a page index into the interface.
+
+	echo "page_index=1251" > /sys/block/zramX/writeback
+
 If there are lots of write IO with flash device, potentially, it has
 flash wearout problem so that admin needs to design write limitation
 to guarantee storage health for entire product life.
--- a/drivers/block/zram/zram_drv.c~zram-support-a-page-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -620,15 +620,19 @@ static int read_from_bdev_async(struct z
 	return 1;
 }
 
+#define PAGE_WB_SIG "page_index="
+
+#define PAGE_WRITEBACK 0
 #define HUGE_WRITEBACK 1
 #define IDLE_WRITEBACK 2
 
+
 static ssize_t writeback_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	unsigned long index;
+	unsigned long index = 0;
 	struct bio bio;
 	struct bio_vec bio_vec;
 	struct page *page;
@@ -640,8 +644,17 @@ static ssize_t writeback_store(struct de
 		mode = IDLE_WRITEBACK;
 	else if (sysfs_streq(buf, "huge"))
 		mode = HUGE_WRITEBACK;
-	else
-		return -EINVAL;
+	else {
+		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
+			return -EINVAL;
+
+		ret = kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index);
+		if (ret || index >= nr_pages)
+			return -EINVAL;
+
+		nr_pages = 1;
+		mode = PAGE_WRITEBACK;
+	}
 
 	down_read(&zram->init_lock);
 	if (!init_done(zram)) {
@@ -660,7 +673,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	for (index = 0; index < nr_pages; index++) {
+	while (nr_pages--) {
 		struct bio_vec bvec;
 
 		bvec.bv_page = page;
_

Patches currently in -mm which might be from minchan@kernel.org are


