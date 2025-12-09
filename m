Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D566023C4F4
	for <mm-commits@vger.kernel.org>; Tue,  9 Dec 2025 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765308799; cv=none; b=Xv3BAhLHBYDXMOLWYXJlCu810uCvfiZWjV006xMfmvGYH33HaEH01ZYNrLkue5lgH1UfUkEMwf7NzLbgXxJOtw51gn/QJDNW1bqU/hzzD6yo6j5cTATuH2aWl7GgDm7aKObh+0IMYu48GKKjThmkbagRBMIDk0cwpoXrDopEAOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765308799; c=relaxed/simple;
	bh=54ljxkgI8EkZTdJUvQEqJiHupOdOjZP6kICNTM+PyHQ=;
	h=Date:To:From:Subject:Message-Id; b=WiJjDShfhHjDGwvznL98yvIj17EmCbVYSanC4LDueExu/O1AOqCr7dcy3R+pnzQq6iVX1uYbvddnLj2bSLx7PX/hBx1whyHCuq0NpGc32VimPoI3TtSN4WDVBxPsXmnrg+92Z34GtriTZRgIsc2XSLtvy5gdUtH3fbeOPL1vlp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fKsdgL41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fKsdgL41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98F2C4CEF5;
	Tue,  9 Dec 2025 19:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765308799;
	bh=54ljxkgI8EkZTdJUvQEqJiHupOdOjZP6kICNTM+PyHQ=;
	h=Date:To:From:Subject:From;
	b=fKsdgL41G1l6Opz6J4G2PMSU4XylXsnABaLYYtcBIpdTYkM2msVUYe3+MP09qjARH
	 ARjbSSArzBbv4/7oIKP/RvAXqhCOkw4DNrt+o2hWQ1Zjw2PLK8If6HBEsZGzwwf4bH
	 bFlHiwdwNKCvTDN/1+rtUVzxLqAwGWZBG/zwongY=
Date: Tue, 09 Dec 2025 11:33:19 -0800
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,lalitshankarch@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fs-fat-remove-unnecessary-wrapper-fat_max_cache.patch removed from -mm tree
Message-Id: <20251209193319.A98F2C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/fat: remove unnecessary wrapper fat_max_cache()
has been removed from the -mm tree.  Its filename was
     fs-fat-remove-unnecessary-wrapper-fat_max_cache.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


