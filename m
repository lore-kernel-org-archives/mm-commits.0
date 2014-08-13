From: akpm@linux-foundation.org
Subject: + mm-zpool-use-prefixed-module-loading.patch added to -mm tree
Date: Wed, 13 Aug 2014 14:01:01 -0700
Message-ID: <53ebd20d./mClML02zYsgsrnj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:52579 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaHMVBC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 17:01:02 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so43177qgd.4
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 14:01:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, ddstreet@ieee.org, minchan@kernel.org, ngupta@vflare.org, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zpool: use prefixed module loading
has been added to the -mm tree.  Its filename is
     mm-zpool-use-prefixed-module-loading.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-use-prefixed-module-loading.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-use-prefixed-module-loading.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
mm-zpool-use-prefixed-module-loading.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

