From: akpm@linux-foundation.org
Subject: [merged] zram-remove-obsolete-zram_debug-option.patch removed
 from -mm tree
Date: Mon, 29 Jun 2015 13:39:50 -0700
Message-ID: <5591ad16.FjL9xVp7hM1IXGYd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbbF2Ujv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.jabrzyk@samsung.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove obsolete ZRAM_DEBUG option
has been removed from the -mm tree.  Its filename was
     zram-remove-obsolete-zram_debug-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Subject: zram: remove obsolete ZRAM_DEBUG option

This config option doesn't provide any usage for zram.

Signed-off-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |   10 +---------
 drivers/block/zram/zram_drv.c |    4 ----
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/block/zram/Kconfig~zram-remove-obsolete-zram_debug-option drivers/block/zram/Kconfig
--- a/drivers/block/zram/Kconfig~zram-remove-obsolete-zram_debug-option
+++ a/drivers/block/zram/Kconfig
@@ -23,12 +23,4 @@ config ZRAM_LZ4_COMPRESS
 	default n
 	help
 	  This option enables LZ4 compression algorithm support. Compression
-	  algorithm can be changed using `comp_algorithm' device attribute.
-
-config ZRAM_DEBUG
-	bool "Compressed RAM block device debug support"
-	depends on ZRAM
-	default n
-	help
-	  This option adds additional debugging code to the compressed
-	  RAM block device driver.
+	  algorithm can be changed using `comp_algorithm' device attribute.
\ No newline at end of file
diff -puN drivers/block/zram/zram_drv.c~zram-remove-obsolete-zram_debug-option drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-obsolete-zram_debug-option
+++ a/drivers/block/zram/zram_drv.c
@@ -15,10 +15,6 @@
 #define KMSG_COMPONENT "zram"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
-#ifdef CONFIG_ZRAM_DEBUG
-#define DEBUG
-#endif
