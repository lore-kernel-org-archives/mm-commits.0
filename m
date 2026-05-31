Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6201A3029
	for <mm-commits@vger.kernel.org>; Sun, 31 May 2026 22:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780265070; cv=none; b=nWzmfobcw5OgEdUmKvDl9Avx5cyOUP4UlZceyfOH4iq2ddaKJE2Z/sYi1ME2UZgFebW2PHyW1L7uBGwKSnncuQ380v1kfa33x6jfHkW79FzSQ9iDU051troSgSkhLTRgoWZ9VfGHYXkanajLDSn1njW/u0skFUTdC9RBMB74rUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780265070; c=relaxed/simple;
	bh=4S3/LdnjBUrKWDcCEtAhxQa6bvFMwbXLw0Dlz7LyYBU=;
	h=Date:To:From:Subject:Message-Id; b=opc2QndV7TjaJPxXqZVJWai5GJrt/8dDt1gP8GBmV3BHIsLgMvUh1+27z9S+fyfQdT7p1zGjM76xz8iI4LcGXK49EMLhPSuKG6ehNwESLqWAdptNbOyTbH75K3Qsn4W/lgZBdYg4nELGj9UlULw0vmrAGx2CBZvtessynIbsvCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iwQz7qNN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iwQz7qNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CCA1F00893;
	Sun, 31 May 2026 22:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780265069;
	bh=IvVN4eMHqW5CQY26FYunbBAGc9xq/NundCie3f4hHXs=;
	h=Date:To:From:Subject;
	b=iwQz7qNN7EqE/ovj0pWbTmKKN5hS/2/Vbrl1rsJWF3nQEYpfJ1TiE1MRK6UxLKzhf
	 uBSi7qLfeCgY7G//ukLvWkwQC+mltVlb6jD/ssLJ4gu8yKIM90UJq8/kB/RHR4OgYW
	 eHI5GlYAyOcrp+s+jxOJsNxTQyNM4mBG6v8d3iBo=
Date: Sun, 31 May 2026 15:04:28 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,kasong@tencent.com,hch@lst.de,chrisl@kernel.org,baoquan.he@linux.dev,baohua@kernel.org,axboe@kernel.dk,wujianyue000@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-fix-partial-i-o-config-check.patch removed from -mm tree
Message-Id: <20260531220429.41CCA1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix partial I/O config check
has been removed from the -mm tree.  Its filename was
     zram-fix-partial-i-o-config-check.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: zram: fix partial I/O config check
Date: Sun, 31 May 2026 20:35:16 +0800

IS_ENABLED() expects a CONFIG_* symbol.  Use the real Kconfig symbol so
this warning reflects whether synchronous partial I/O is built in.

Link: https://lore.kernel.org/20260531-zram-fix-partial-io-config-check-on-akpm-v1-1-eb085d98faea@gmail.com
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kairui Song <kasong@tencent.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-partial-i-o-config-check
+++ a/drivers/block/zram/zram_drv.c
@@ -1510,7 +1510,7 @@ static int read_from_bdev(struct zram *z
 {
 	atomic64_inc(&zram->stats.bd_reads);
 	if (!parent) {
-		if (WARN_ON_ONCE(!IS_ENABLED(ZRAM_PARTIAL_IO)))
+		if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_ZRAM_PARTIAL_IO)))
 			return -EIO;
 		return read_from_bdev_sync(zram, page, index, blk_idx);
 	}
_

Patches currently in -mm which might be from wujianyue000@gmail.com are


