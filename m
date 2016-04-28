From: akpm@linux-foundation.org
Subject: + mm-zsmalloc-dont-fail-if-cant-create-debugfs-info.patch added
 to -mm tree
Date: Thu, 28 Apr 2016 15:07:22 -0700
Message-ID: <5722899a.UKH7UT6GOKi3fsNq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48172 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbcD1WHX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Apr 2016 18:07:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ddstreet@ieee.org, dan.streetman@canonical.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zsmalloc: don't fail if can't create debugfs info
has been added to the -mm tree.  Its filename is
     mm-zsmalloc-dont-fail-if-cant-create-debugfs-info.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zsmalloc-dont-fail-if-cant-create-debugfs-info.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zsmalloc-dont-fail-if-cant-create-debugfs-info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: mm/zsmalloc: don't fail if can't create debugfs info

Change the return type of zs_pool_stat_create() to void, and
remove the logic to abort pool creation if the stat debugfs
dir/file could not be created.

The debugfs stat file is for debugging/information only, and doesn't
affect operation of zsmalloc; there is no reason to abort creating
the pool if the stat file can't be created.  This was seen with
zswap, which used the same name for all pool creations, which caused
zsmalloc to fail to create a second pool for zswap if
CONFIG_ZSMALLOC_STAT was enabled.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Dan Streetman <dan.streetman@canonical.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff -puN mm/zsmalloc.c~mm-zsmalloc-dont-fail-if-cant-create-debugfs-info mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-zsmalloc-dont-fail-if-cant-create-debugfs-info
+++ a/mm/zsmalloc.c
@@ -568,17 +568,17 @@ static const struct file_operations zs_s
 	.release        = single_release,
 };
 
-static int zs_pool_stat_create(struct zs_pool *pool, const char *name)
+static void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
 	struct dentry *entry;
 
 	if (!zs_stat_root)
-		return -ENODEV;
+		return;
 
 	entry = debugfs_create_dir(name, zs_stat_root);
 	if (!entry) {
 		pr_warn("debugfs dir <%s> creation failed\n", name);
-		return -ENOMEM;
+		return;
 	}
 	pool->stat_dentry = entry;
 
@@ -587,10 +587,8 @@ static int zs_pool_stat_create(struct zs
 	if (!entry) {
 		pr_warn("%s: debugfs file entry <%s> creation failed\n",
 				name, "classes");
-		return -ENOMEM;
+		return;
 	}
-
-	return 0;
 }
 
 static void zs_pool_stat_destroy(struct zs_pool *pool)
@@ -608,9 +606,8 @@ static void __exit zs_stat_exit(void)
 {
 }
 
-static inline int zs_pool_stat_create(struct zs_pool *pool, const char *name)
+static inline void zs_pool_stat_create(struct zs_pool *pool, const char *name)
 {
-	return 0;
 }
 
 static inline void zs_pool_stat_destroy(struct zs_pool *pool)
@@ -618,7 +615,6 @@ static inline void zs_pool_stat_destroy(
 }
 #endif
 
