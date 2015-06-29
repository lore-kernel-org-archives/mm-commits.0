From: akpm@linux-foundation.org
Subject: [merged] zram-cut-trailing-newline-in-algorithm-name.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:33 -0700
Message-ID: <5591aea9.JQ2LNFvnwgJh/njo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbbF2Uqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cut trailing newline in algorithm name
has been removed from the -mm tree.  Its filename was
     zram-cut-trailing-newline-in-algorithm-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zram: cut trailing newline in algorithm name

Supplied sysfs values sometimes contain new-line symbols (echo vs.  echo
-n), which we also copy as a compression algorithm name.  it works fine
when we lookup for compression algorithm, because we use sysfs_streq()
which takes care of new line symbols.  however, it doesn't look nice when
we print compression algorithm name if zcomp_create() failed:

 zram: Cannot initialise LXZ
            compressing backend

cut trailing new-line, so the error string will look like

  zram: Cannot initialise LXZ compressing backend

we also now can replace sysfs_streq() in zcomp_available_show() with
strcmp().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    2 +-
 drivers/block/zram/zram_drv.c |    8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zcomp.c~zram-cut-trailing-newline-in-algorithm-name drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-cut-trailing-newline-in-algorithm-name
+++ a/drivers/block/zram/zcomp.c
@@ -274,7 +274,7 @@ ssize_t zcomp_available_show(const char
 	int i = 0;
 
 	while (backends[i]) {
-		if (sysfs_streq(comp, backends[i]->name))
+		if (!strcmp(comp, backends[i]->name))
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
 					"[%s] ", backends[i]->name);
 		else
diff -puN drivers/block/zram/zram_drv.c~zram-cut-trailing-newline-in-algorithm-name drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-cut-trailing-newline-in-algorithm-name
+++ a/drivers/block/zram/zram_drv.c
@@ -363,6 +363,8 @@ static ssize_t comp_algorithm_store(stru
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	struct zram *zram = dev_to_zram(dev);
+	size_t sz;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
@@ -370,6 +372,12 @@ static ssize_t comp_algorithm_store(stru
 		return -EBUSY;
 	}
 	strlcpy(zram->compressor, buf, sizeof(zram->compressor));
+
+	/* ignore trailing newline */
+	sz = strlen(zram->compressor);
+	if (sz > 0 && zram->compressor[sz - 1] == '\n')
+		zram->compressor[sz - 1] = 0x00;
+
 	up_write(&zram->init_lock);
 	return len;
 }
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

origin.patch

