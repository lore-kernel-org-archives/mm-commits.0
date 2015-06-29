From: akpm@linux-foundation.org
Subject: [merged] zram-check-comp-algorithm-availability-earlier.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:35 -0700
Message-ID: <5591aeab.3QXE2aJ/Qh/DVwqJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbbF2Uqf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, m.jabrzyk@samsung.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: check comp algorithm availability earlier
has been removed from the -mm tree.  Its filename was
     zram-check-comp-algorithm-availability-earlier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: check comp algorithm availability earlier

Improvement idea by Marcin Jabrzyk.

comp_algorithm_store() silently accepts any supplied algorithm name,
because zram performs algorithm availability check later, during the
device configuration phase in disksize_store() and emits the following
error:

  "zram: Cannot initialise %s compressing backend"

this error line is somewhat generic and, besides, can indicate a failed
attempt to allocate compression backend's working buffers.

add algorithm availability check to comp_algorithm_store():

  echo lzz > /sys/block/zram0/comp_algorithm
  -bash: echo: write error: Invalid argument

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    5 +++++
 drivers/block/zram/zcomp.h    |    1 +
 drivers/block/zram/zram_drv.c |    3 +++
 3 files changed, 9 insertions(+)

diff -puN drivers/block/zram/zcomp.c~zram-check-comp-algorithm-availability-earlier drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-check-comp-algorithm-availability-earlier
+++ a/drivers/block/zram/zcomp.c
@@ -286,6 +286,11 @@ ssize_t zcomp_available_show(const char
 	return sz;
 }
 
+bool zcomp_available_algorithm(const char *comp)
+{
+	return find_backend(comp) != NULL;
+}
+
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
 {
 	return comp->set_max_streams(comp, num_strm);
diff -puN drivers/block/zram/zcomp.h~zram-check-comp-algorithm-availability-earlier drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-check-comp-algorithm-availability-earlier
+++ a/drivers/block/zram/zcomp.h
@@ -51,6 +51,7 @@ struct zcomp {
 };
 
 ssize_t zcomp_available_show(const char *comp, char *buf);
+bool zcomp_available_algorithm(const char *comp);
 
 struct zcomp *zcomp_create(const char *comp, int max_strm);
 void zcomp_destroy(struct zcomp *comp);
diff -puN drivers/block/zram/zram_drv.c~zram-check-comp-algorithm-availability-earlier drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-check-comp-algorithm-availability-earlier
+++ a/drivers/block/zram/zram_drv.c
@@ -378,6 +378,9 @@ static ssize_t comp_algorithm_store(stru
 	if (sz > 0 && zram->compressor[sz - 1] == '\n')
 		zram->compressor[sz - 1] = 0x00;
 
+	if (!zcomp_available_algorithm(zram->compressor))
+		len = -EINVAL;
+
 	up_write(&zram->init_lock);
 	return len;
 }
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

