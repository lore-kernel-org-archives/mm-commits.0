From: akpm@linux-foundation.org
Subject: [merged] fs-fat-fix-two-checkpatch-issues-in-cachec.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:30 -0700
Message-ID: <20121005201831.25FB95C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51688 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab2JEUSg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:36 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138460fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/fat: fix two checkpatch issues in cache.c
has been removed from the -mm tree.  Its filename was
     fs-fat-fix-two-checkpatch-issues-in-cachec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cruz Julian Bishop <cruzjbishop@gmail.com>
Subject: fs/fat: fix two checkpatch issues in cache.c

This does the following:
	1: Splits the arguments of a function call to stop it
		from exceeding 80 characters
	2: Re-indents the arguments of another function call
		to prevent the splitting of a quoted string.

Signed-off-by: Cruz Julian Bishop <cruzjbishop@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/fat/cache.c~fs-fat-fix-two-checkpatch-issues-in-cachec fs/fat/cache.c
--- a/fs/fat/cache.c~fs-fat-fix-two-checkpatch-issues-in-cachec
+++ a/fs/fat/cache.c
@@ -190,7 +190,8 @@ static void __fat_cache_inval_inode(stru
 	struct fat_cache *cache;
 
 	while (!list_empty(&i->cache_lru)) {
-		cache = list_entry(i->cache_lru.next, struct fat_cache, cache_list);
+		cache = list_entry(i->cache_lru.next,
+				   struct fat_cache, cache_list);
 		list_del_init(&cache->cache_list);
 		i->nr_caches--;
 		fat_cache_free(cache);
@@ -261,9 +262,10 @@ int fat_get_cluster(struct inode *inode,
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
-			fat_fs_error_ratelimit(sb, "%s: invalid cluster chain"
-					       " (i_pos %lld)", __func__,
-					       MSDOS_I(inode)->i_pos);
+			fat_fs_error_ratelimit(sb,
+				       "%s: invalid cluster chain (i_pos %lld)",
+				       __func__,
+				       MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		} else if (nr == FAT_ENT_EOF) {
_

Patches currently in -mm which might be from cruzjbishop@gmail.com are

origin.patch

