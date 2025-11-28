Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BD7212560
	for <mm-commits@vger.kernel.org>; Fri, 28 Nov 2025 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764355175; cv=none; b=HZgGCv7dAp7FaZ318ihAGkyBBPl9D981WhD81Lo8g1CHMZ+DJNgfe4exvZ0ZIsw8237Pe++GitXp6l5Y0HKV1KyQVACw2ElnONb/cfhaKxAmHo4ZD9/4Kr3CtKiG3a66Yzf/LpH9vj+8uDNd5e16OYT2THpZeThBg+ZvUSHxSWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764355175; c=relaxed/simple;
	bh=3vxDjojc9BzLh0LjWgm94Bmz9ywLOfe7LqIyK1nWVIo=;
	h=Date:To:From:Subject:Message-Id; b=j/8BRuUN3x5X2DzaQH5SSveG4szl2whnQLmA8YBGcojkbPflf5Ng8VNULYei4IDa17M1nPkH8IbhItpGkAChJ2J1GPJowCFKBVE9tlcxpyAJlxs+4keTlw8ALGTt1+9aPBQnUOtNbYAtRVJDl0I/BVkdE1qlkhIb2wfpA1jSmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IYQaUnwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IYQaUnwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09B7C4CEF1;
	Fri, 28 Nov 2025 18:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764355175;
	bh=3vxDjojc9BzLh0LjWgm94Bmz9ywLOfe7LqIyK1nWVIo=;
	h=Date:To:From:Subject:From;
	b=IYQaUnwLzZRVhdtgcw5w6b2LoxATMiOc3t7kU5E7/LkziEir57HMlaQYLFSIzKQnY
	 tI/gv2rAkeC3Z/ZLj9ct2FNf2YBOA9RD3KmatMECGNJgaRa/VURyocNBfAa+vYuODz
	 9gqCUAk/ibgH05cf6rqfD930W1RwCYNaKOjWU+tU=
Date: Fri, 28 Nov 2025 10:39:34 -0800
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,lalitshankarch@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-fat-remove-unnecessary-wrapper-fat_max_cache.patch added to mm-nonmm-unstable branch
Message-Id: <20251128183934.F09B7C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/fat: remove unnecessary wrapper fat_max_cache()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fs-fat-remove-unnecessary-wrapper-fat_max_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-fat-remove-unnecessary-wrapper-fat_max_cache.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Subject: fs/fat: remove unnecessary wrapper fat_max_cache()
Date: Thu, 27 Nov 2025 17:54:31 +0000

fat_max_cache() always returned FAT_MAX_CACHE and did not use the inode
parameter. So, use the FAT_MAX_CACHE constant directly.

Link: https://lkml.kernel.org/r/20251127175431.126516-1-lalitshankarch@gmail.com
Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/fs/fat/cache.c~fs-fat-remove-unnecessary-wrapper-fat_max_cache
+++ a/fs/fat/cache.c
@@ -29,11 +29,6 @@ struct fat_cache_id {
 	int dcluster;
 };
 
-static inline int fat_max_cache(struct inode *inode)
-{
-	return FAT_MAX_CACHE;
-}
-
 static struct kmem_cache *fat_cache_cachep;
 
 static void init_once(void *foo)
@@ -145,7 +140,7 @@ static void fat_cache_add(struct inode *
 
 	cache = fat_cache_merge(inode, new);
 	if (cache == NULL) {
-		if (MSDOS_I(inode)->nr_caches < fat_max_cache(inode)) {
+		if (MSDOS_I(inode)->nr_caches < FAT_MAX_CACHE) {
 			MSDOS_I(inode)->nr_caches++;
 			spin_unlock(&MSDOS_I(inode)->cache_lru_lock);
 
_

Patches currently in -mm which might be from lalitshankarch@gmail.com are

fs-fat-remove-unnecessary-wrapper-fat_max_cache.patch

