From: akpm@linux-foundation.org
Subject: + fs-fat-fix-two-checkpatch-issues-in-cachec.patch added to -mm tree
Date: Mon, 20 Aug 2012 13:23:33 -0700
Message-ID: <20120820202334.5C31520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:59762 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104Ab2HTUXg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2012 16:23:36 -0400
Received: by lagw12 with SMTP id w12so310891lag.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 13:23:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cruzjbishop@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fs/fat: fix two checkpatch issues in cache.c
has been added to the -mm tree.  Its filename is
     fs-fat-fix-two-checkpatch-issues-in-cachec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
fs-fat-fix-a-checkpatch-issue-in-namei_msdosc.patch
fs-fat-fix-some-checkpatch-issues-in-fath.patch
fs-fat-changed-indentation-of-some-comments-in-fath.patch
fs-fat-fix-two-checkpatch-issues-in-cachec.patch
fs-fat-fixes-some-small-checkpatch-issues-in-dirc.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fs-fat-fix-checkpatch-issues-in-fatentc.patch

