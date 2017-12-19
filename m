From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-simplify-shrinker-init-destroy.patch added to -mm
 tree
Date: Tue, 19 Dec 2017 15:27:47 -0800
Message-ID: <5a39a073.TCm7TNkEx6N01CZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753280AbdLSX1s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Dec 2017 18:27:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akaraliou.dev@gmail.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: simplify shrinker init/destroy
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-simplify-shrinker-init-destroy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-simplify-shrinker-init-destroy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-simplify-shrinker-init-destroy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: mm/zsmalloc: simplify shrinker init/destroy

Structure zs_pool has special flag to indicate success of shrinker
initialization.  unregister_shrinker() has improved and can detect by
itself whether actual deinitialization should be performed or not, so
extra flag becomes redundant.

Link: http://lkml.kernel.org/r/1513680552-9798-1-git-send-email-akaraliou.dev@gmail.com
Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-simplify-shrinker-init-destroy
+++ a/mm/zsmalloc.c
@@ -53,6 +53,7 @@
 #include <linux/mount.h>
 #include <linux/migrate.h>
 #include <linux/pagemap.h>
+#include <linux/shrinker.h>
 
 #define ZSPAGE_MAGIC	0x58
 
@@ -256,11 +257,7 @@ struct zs_pool {
 
 	/* Compact classes */
 	struct shrinker shrinker;
-	/*
-	 * To signify that register_shrinker() was successful
-	 * and unregister_shrinker() will not Oops.
-	 */
-	bool shrinker_enabled;
+
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -2323,10 +2320,7 @@ static unsigned long zs_shrinker_count(s
 
 static void zs_unregister_shrinker(struct zs_pool *pool)
 {
-	if (pool->shrinker_enabled) {
-		unregister_shrinker(&pool->shrinker);
-		pool->shrinker_enabled = false;
-	}
+	unregister_shrinker(&pool->shrinker);
 }
 
 static int zs_register_shrinker(struct zs_pool *pool)
@@ -2428,8 +2422,8 @@ struct zs_pool *zs_create_pool(const cha
 	 * Not critical, we still can use the pool
 	 * and user can trigger compaction manually.
 	 */
-	if (zs_register_shrinker(pool) == 0)
-		pool->shrinker_enabled = true;
+	(void) zs_register_shrinker(pool);
+
 	return pool;
 
 err:
_

Patches currently in -mm which might be from akaraliou.dev@gmail.com are

mm-zsmalloc-simplify-shrinker-init-destroy.patch

