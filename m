Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482988BFD
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560203; cv=none; b=sGFo/zVS2ARrs6P9BuhyNdZ3eVofHf1l21Hj4vaAYJdLCJ3VC339Ktv/+dZ/oTIpO92qjSDgkL1Y7WTa/jtWcnOGOa7dy0uSPVqTA9JkXNikMWYRxxQQYa904Mg5F/xT7JvyX6Qk5cwRBYSudRSEc5XYVsKIfTYaf+tnTqrXROg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560203; c=relaxed/simple;
	bh=ij4qLlp6fyUAmg8ulIuNAYkg3MfWqZv/0v3WGofZYBY=;
	h=Date:To:From:Subject:Message-Id; b=Qwje6wRCUVRVg8K1BuUmyHw8SZw5qJjiWpescQFgXVM0sMZ08Ap6/kLy9DgZZ4jrn6xyiwb7kKL3Rh9JhYfk26+rNxZxYFdMRqMxUJO7tPz+0gYSqXIkYvczaLKnk7WROrssh/PKkcKWKEfQn+SafkNlFlBOmCrAaL1ejQOS6p8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fb/wzX2R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fb/wzX2R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BE9BC433F1;
	Thu, 22 Feb 2024 00:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560203;
	bh=ij4qLlp6fyUAmg8ulIuNAYkg3MfWqZv/0v3WGofZYBY=;
	h=Date:To:From:Subject:From;
	b=fb/wzX2RSx3kxcGhq4hJeZnJvqXrBHT2WcrBH5xvKKxBXK/TufeCnp9IN/P4mW9EF
	 qymomJOUUSUHJDWl4SJF29wbL9Lo9AnSRf0tjfKQPvSGKUfpniTyDWK2PlmHxm77v5
	 k0jqJV6XJhbodvz2kR+sepo+xAT/bV9uIYtannRA=
Date: Wed, 21 Feb 2024 16:03:22 -0800
To: mm-commits@vger.kernel.org,yj.chiang@mediatek.com,senozhatsky@chromium.org,minchan@kernel.org,matthias.bgg@gmail.com,axboe@kernel.dk,angelogioacchino.delregno@collabora.com,mark-pk.tsai@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-copy_page-for-full-page-copy.patch removed from -mm tree
Message-Id: <20240222000323.1BE9BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use copy_page for full page copy
has been removed from the -mm tree.  Its filename was
     zram-use-copy_page-for-full-page-copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: zram: use copy_page for full page copy
Date: Sat, 7 Oct 2023 15:05:53 +0800

Some architectures, such as arm, have implemented optimized copy_page for
full page copying.

Replace the full page memcpy with copy_page to take advantage of the
optimization.

Link: https://lkml.kernel.org/r/20231007070554.8657-1-mark-pk.tsai@mediatek.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: YJ Chiang <yj.chiang@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-copy_page-for-full-page-copy
+++ a/drivers/block/zram/zram_drv.c
@@ -1337,7 +1337,7 @@ static int zram_read_from_zspool(struct
 	src = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (size == PAGE_SIZE) {
 		dst = kmap_local_page(page);
-		memcpy(dst, src, PAGE_SIZE);
+		copy_page(dst, src);
 		kunmap_local(dst);
 		ret = 0;
 	} else {
_

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are


