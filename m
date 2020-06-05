From: akpm@linux-foundation.org
Subject: [merged] zcomp-use-array_size-for-backends-list.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:18:52 -0700
Message-ID: <20200605201852.X-Bw1f7Zt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728140AbgFEUSx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:18:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, axboe@kernel.dk, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com


The patch titled
     Subject: zcomp: Use ARRAY_SIZE() for backends list
has been removed from the -mm tree.  Its filename was
     zcomp-use-array_size-for-backends-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: zcomp: Use ARRAY_SIZE() for backends list

Instead of keeping NULL terminated array switch to use ARRAY_SIZE()
which helps to further clean up.

Link: http://lkml.kernel.org/r/20200508100758.51644-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zcomp.c~zcomp-use-array_size-for-backends-list
+++ a/drivers/block/zram/zcomp.c
@@ -29,7 +29,6 @@ static const char * const backends[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_ZSTD)
 	"zstd",
 #endif
-	NULL
 };
 
 static void zcomp_strm_free(struct zcomp_strm *zstrm)
@@ -64,7 +63,7 @@ bool zcomp_available_algorithm(const cha
 {
 	int i;
 
-	i = __sysfs_match_string(backends, -1, comp);
+	i = sysfs_match_string(backends, comp);
 	if (i >= 0)
 		return true;
 
@@ -83,9 +82,9 @@ ssize_t zcomp_available_show(const char
 {
 	bool known_algorithm = false;
 	ssize_t sz = 0;
-	int i = 0;
+	int i;
 
-	for (; backends[i]; i++) {
+	for (i = 0; i < ARRAY_SIZE(backends); i++) {
 		if (!strcmp(comp, backends[i])) {
 			known_algorithm = true;
 			sz += scnprintf(buf + sz, PAGE_SIZE - sz - 2,
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are
