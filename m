Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78DA33E363
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768967336; cv=none; b=jzrsyr8o82fRkdVLFyUkNP4/Fwm3sZywlWdTdQfFxyMWIGWfulskq2dGAq+fVIqSDMrvRwSlu65W52UUVMbMinSbCHS5Trq/M4qyl+RdXOr5O4JKLnVerrecDwRV2dtrV2agCFIblwLV42X8k5Sp/K0BH29YN+CEFUbjwCjHB5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768967336; c=relaxed/simple;
	bh=hDdWnVkTmk+/85fMsrmXfWmQJDh0UEwbPKs599uv9x0=;
	h=Date:To:From:Subject:Message-Id; b=d8sHsSbnyKf2v/rpcxt7d98btcpiB1kq/gdQgu/Pbj32MNPAYzKFkM8wnHt+kbu9e7tNDcC5j6lh3ZspQ0bT8D6jnTyLFxz5/s1zHBfJjO1pej+afi+R/TbRCjfqmAXLD0odFzpzLkxuxLO9C1NOBvJDBzW0lxbiUE6AT6Wzpao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qpenn1Ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qpenn1Ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06A7C16AAE;
	Wed, 21 Jan 2026 03:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768967336;
	bh=hDdWnVkTmk+/85fMsrmXfWmQJDh0UEwbPKs599uv9x0=;
	h=Date:To:From:Subject:From;
	b=Qpenn1LdugQIHUFAPkXXFAKnP9MczhO52tQiWs30YRDlIJNLdAgyGS/j/TQdrZs3c
	 h01AqxItGz4u4dELJDSLIpiYuy5xKnF1RBVT2Nl6pDMAT8DJzFg7XU6mkeH0rOJ6fP
	 djgFZXNPeEhgubdBDaLBGHzOSI+q+OQQZM+3nbO8=
Date: Tue, 20 Jan 2026 19:48:55 -0800
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,lalitshankarch@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fat-remove-unused-parameter.patch removed from -mm tree
Message-Id: <20260121034855.E06A7C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: remove unused parameter
has been removed from the -mm tree.  Its filename was
     fat-remove-unused-parameter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Subject: fat: remove unused parameter
Date: Tue, 2 Dec 2025 03:14:04 +0530

Remove unused inode parameter from fat_cache_alloc().

Link: https://lkml.kernel.org/r/20251201214403.90604-2-lalitshankarch@gmail.com
Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/fat/cache.c~fat-remove-unused-parameter
+++ a/fs/fat/cache.c
@@ -54,7 +54,7 @@ void fat_cache_destroy(void)
 	kmem_cache_destroy(fat_cache_cachep);
 }
 
-static inline struct fat_cache *fat_cache_alloc(struct inode *inode)
+static inline struct fat_cache *fat_cache_alloc(void)
 {
 	return kmem_cache_alloc(fat_cache_cachep, GFP_NOFS);
 }
@@ -144,7 +144,7 @@ static void fat_cache_add(struct inode *
 			MSDOS_I(inode)->nr_caches++;
 			spin_unlock(&MSDOS_I(inode)->cache_lru_lock);
 
-			tmp = fat_cache_alloc(inode);
+			tmp = fat_cache_alloc();
 			if (!tmp) {
 				spin_lock(&MSDOS_I(inode)->cache_lru_lock);
 				MSDOS_I(inode)->nr_caches--;
_

Patches currently in -mm which might be from lalitshankarch@gmail.com are


