Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F124233942
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622838; cv=none; b=pIVVMpiIP6gdcyzJcjjylT5AFdmhCW30MLUZ/DhPRwmla98rB8PaXvH4QrSYbl32iO+B8IV4XFbaWXYlYPn3qq1npn/b76yqtxt/Ib5jpsyBGgQkfqNCIQI8+BL5rVERsWqXDv4YyrSN08HvajuXqkIpB5ZyOVWBl43cDxmpoxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622838; c=relaxed/simple;
	bh=CAZT4XHVZUD0zJu+yadVs6mywUqQMScWMXIBBWwdLeo=;
	h=Date:To:From:Subject:Message-Id; b=ZHqikgYPzbr+0b1Zi6WLY244o5h4Yi8IeFcX1IOhRJ4K7CQibGQ+lk2x/GykLKjSczew3Xu1EO2VM5zUTpvoizvVDQ8r1PnS6BB2vnskhSqTxsQztjLbRco8wpvkla/fe85Kr1/iMRdrcf6mkduooCStIRcOeBv4+zw2kiY8E8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1bH2buX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1bH2buX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D417C1F000E9;
	Tue, 25 Aug 2026 01:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622836;
	bh=g8YE+Tyi+k9YWXac4xits8JgVl9d14MgeICede9WxZM=;
	h=Date:To:From:Subject;
	b=1bH2buX3G6d4z4afFmR0SB89mUCP+yO4QTEer0ZwsnRDg4W+hmXbbtvQCf0BWSWzH
	 x2TK5afyW5xM+x4+To+2sb27S8BiujP2tl3NRoTQ7+mj+708u4Jb7Cjai9i8c/+FAw
	 fBYvYNIckPXZKOle63CMnEiio+3vXp6amI+JJsuY=
Date: Mon, 24 Aug 2026 18:53:56 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-reject-zero-size-dictionary.patch removed from -mm tree
Message-Id: <20260825015356.D417C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: reject zero-size dictionary
has been removed from the -mm tree.  Its filename was
     zram-reject-zero-size-dictionary.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haoqin Huang <haoqinhuang@tencent.com>
Subject: zram: reject zero-size dictionary
Date: Tue, 4 Aug 2026 17:38:38 +0800

kernel_read_file_from_path() already rejects empty files (i_size <= 0) and
returns -EINVAL, but the current implementation only checks for sz < 0
without logging any information.  Use sz == 0 to reject the zero-size case
and print distinct error messages for each failure type.

Link: https://lore.kernel.org/20260804093841.67920-3-haoqinhuang7@gmail.com
Signed-off-by: Haoqin Huang <haoqinhuang@tencent.com>
Signed-off-by: Rongwei Wang <zigiwang@tencent.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-reject-zero-size-dictionary
+++ a/drivers/block/zram/zram_drv.c
@@ -1700,8 +1700,16 @@ static int comp_params_store(struct zram
 						INT_MAX,
 						NULL,
 						READING_POLICY);
-		if (sz < 0)
+		if (sz < 0) {
+			pr_err("failed to load dictionary %s (err=%zd)\n",
+			       dict_path, sz);
+			return sz;
+		}
+		if (sz == 0) {
+			pr_err("failed to load dictionary %s (empty file)\n",
+			       dict_path);
 			return -EINVAL;
+		}
 	}
 
 	zram->params[prio].dict_sz = sz;
_

Patches currently in -mm which might be from haoqinhuang@tencent.com are


