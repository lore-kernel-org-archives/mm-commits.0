From: akpm@linux-foundation.org
Subject: [merged] mm-zpool-use-prefixed-module-loading.patch removed from
 -mm tree
Date: Wed, 03 Sep 2014 10:57:29 -0700
Message-ID: <54075689.+Nx8NJS0vyhc4aC7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaICR5a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: use prefixed module loading
has been removed from the -mm tree.  Its filename was
     mm-zpool-use-prefixed-module-loading.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/zpool: use prefixed module loading

To avoid potential format string expansion via module parameters, do not
use the zpool type directly in request_module() without a format string. 
Additionally, to avoid arbitrary modules being loaded via zpool API (e.g. 
via the zswap_zpool_type module parameter) add a "zpool-" prefix to the
requested module, as well as module aliases for the existing zpool types
(zbud and zsmalloc).

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c     |    1 +
 mm/zpool.c    |    2 +-
 mm/zsmalloc.c |    1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/zbud.c~mm-zpool-use-prefixed-module-loading mm/zbud.c
--- a/mm/zbud.c~mm-zpool-use-prefixed-module-loading
+++ a/mm/zbud.c
@@ -195,6 +195,7 @@ static struct zpool_driver zbud_zpool_dr
 	.total_size =	zbud_zpool_total_size,
 };
 
+MODULE_ALIAS("zpool-zbud");
 #endif /* CONFIG_ZPOOL */
 
 /*****************
diff -puN mm/zpool.c~mm-zpool-use-prefixed-module-loading mm/zpool.c
--- a/mm/zpool.c~mm-zpool-use-prefixed-module-loading
+++ a/mm/zpool.c
@@ -150,7 +150,7 @@ struct zpool *zpool_create_pool(char *ty
 	driver = zpool_get_driver(type);
 
 	if (!driver) {
-		request_module(type);
+		request_module("zpool-%s", type);
 		driver = zpool_get_driver(type);
 	}
 
diff -puN mm/zsmalloc.c~mm-zpool-use-prefixed-module-loading mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zpool-use-prefixed-module-loading
+++ a/mm/zsmalloc.c
@@ -315,6 +315,7 @@ static struct zpool_driver zs_zpool_driv
 	.total_size =	zs_zpool_total_size,
 };
 
+MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-introduce-check_data_rlimit-helper-v2.patch
mm-use-may_adjust_brk-helper.patch
prctl-pr_set_mm-factor-out-mmap_sem-when-update-mm-exe_file.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

