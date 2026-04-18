Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84AC036EAA4
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498979; cv=none; b=nPy1VD9gHyIiVdxuaqDEb2fiq9+RQshfJD+Ugw7koDzIIQwW4O440XiZzesc8lIiHn8lqMQ7hFrJHUZlWZ7eQnEgdXTKIuokb1oeDNFvVLzlHiiIvBKenR0yYu6WqxXj1zNinH8ZK+kdDoNRmiwTVYFqmXfOTCxg7GkxF2T6BKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498979; c=relaxed/simple;
	bh=3Z/zkjQUWBmtyOvL5FHnad5MiW/V1tZNrXsL2FqE184=;
	h=Date:To:From:Subject:Message-Id; b=E/cfZnp183WgsKE7dLYRYxT5mc7QACrxGMlOrybGCPb1qGJLM2xF0WIBYwCHHZQYvqzNgULJFMGBZeLWReVomAAbqBK4H19SSqh5N7f2vfGBnjyL9N7vi0s3YJclMuOhvvmSQX2hwvYyN8fIbRuqnOfGQpQMLzW+JP0UvtN4rKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12hi2V3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12hi2V3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5C6C19424;
	Sat, 18 Apr 2026 07:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498979;
	bh=3Z/zkjQUWBmtyOvL5FHnad5MiW/V1tZNrXsL2FqE184=;
	h=Date:To:From:Subject:From;
	b=12hi2V3hUV3Z2z9OH05be9oBLf8C49tdp10D5Ql02WpNtgiBu595drdppUQqBfY8N
	 x8tQ+n3U4ekSPDDCFakNXPAlAreUHa45Rzb0AUXiaDlr+QwuH4TY2iMAlbof2NTsRU
	 CMIPw0eJJATZrSowOJb6o2rJxKyMSYLOm43eC3Xg=
Date: Sat, 18 Apr 2026 00:56:13 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,jianghaoran@kylinos.cn,duanchenghao@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch removed from -mm tree
Message-Id: <20260418075618.1C5C6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memfd_luo: use i_size_write() to set inode size during retrieve
has been removed from the -mm tree.  Its filename was
     mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Chenghao Duan <duanchenghao@kylinos.cn>
Subject: mm/memfd_luo: use i_size_write() to set inode size during retrieve
Date: Thu, 26 Mar 2026 16:47:24 +0800

Use i_size_write() instead of directly assigning to inode->i_size when
restoring the memfd size in memfd_luo_retrieve(), to keep code
consistency.

No functional change intended.

Link: https://lore.kernel.org/20260326084727.118437-5-duanchenghao@kylinos.cn
Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Haoran Jiang <jianghaoran@kylinos.cn>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-memfd_luo-use-i_size_write-to-set-inode-size-during-retrieve
+++ a/mm/memfd_luo.c
@@ -530,7 +530,7 @@ static int memfd_luo_retrieve(struct liv
 	}
 
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
-	file->f_inode->i_size = ser->size;
+	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
_

Patches currently in -mm which might be from duanchenghao@kylinos.cn are


