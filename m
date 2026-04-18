Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C133214D719
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776499139; cv=none; b=Db6IXk1u1lslNeF9DoPaW4FuTumyanYJhd6in80zFso1p6fK86a/4s9KU1+XGUb4R1oqO9+cISA2d62IEz5DMQNI+POpPp/5PeSu9kML8DuRR9CYPzmqRVQ3VM6YsBY2WVgzcz1qo3DQk5gc0W7sF4fzGoNcLICz4JlfyRvgX+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776499139; c=relaxed/simple;
	bh=4+CHVfFaXUU4rz8TX3seJMMUDbyXK8dZMd8nhs6SOX0=;
	h=Date:To:From:Subject:Message-Id; b=uHtYuTInK6MEjz2UJG1J7j5pCIjskYQEOdSmiMO5JAyO/8iWZUy/OF9LkrYqk8jGBkdHLxI2a2jsaQXaKiRzMmC37vyCLA83qIC5nWCGzq8ta//ZFdC+qmALf4xn7T+YYN4jCpCgCFFzRd9moxnHkxGDzncw58ZvAeYWZ9SrsmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1JROI5eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1JROI5eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA650C2BCB0;
	Sat, 18 Apr 2026 07:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776499139;
	bh=4+CHVfFaXUU4rz8TX3seJMMUDbyXK8dZMd8nhs6SOX0=;
	h=Date:To:From:Subject:From;
	b=1JROI5eZ9csGwSYc3QYFhxqI2Tkg/sr6kZSqDae0IQRdhhSTRVbBXSPqQQsq+fsiU
	 JIK7blwGQsmoKhI1FYC1OktgD4hD6vXF1QlZnXXCN9Z7z/BsTdI1lCjbIO1e8eR5si
	 1pIz0j/nMGzBOLEUj/1N+Mc4gbrBg2SiB8ZBZZ9g=
Date: Sat, 18 Apr 2026 00:58:54 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,astellman@stellman-greene.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-reject-unrecognized-type=-values-in-recompress_store.patch removed from -mm tree
Message-Id: <20260418075858.BA650C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: reject unrecognized type= values in recompress_store()
has been removed from the -mm tree.  Its filename was
     zram-reject-unrecognized-type=-values-in-recompress_store.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Stellman <astellman@stellman-greene.com>
Subject: zram: reject unrecognized type= values in recompress_store()
Date: Tue, 7 Apr 2026 11:30:27 -0400

recompress_store() parses the type= parameter with three if statements
checking for "idle", "huge", and "huge_idle".  An unrecognized value
silently falls through with mode left at 0, causing the recompression pass
to run with no slot filter — processing all slots instead of the
intended subset.

Add a !mode check after the type parsing block to return -EINVAL for
unrecognized values, consistent with the function's other parameter
validation.

Link: https://lore.kernel.org/20260407153027.42425-1-astellman@stellman-greene.com
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-reject-unrecognized-type=-values-in-recompress_store
+++ a/drivers/block/zram/zram_drv.c
@@ -2546,6 +2546,8 @@ static ssize_t recompress_store(struct d
 				mode = RECOMPRESS_HUGE;
 			if (!strcmp(val, "huge_idle"))
 				mode = RECOMPRESS_IDLE | RECOMPRESS_HUGE;
+			if (!mode)
+				return -EINVAL;
 			continue;
 		}
 
_

Patches currently in -mm which might be from astellman@stellman-greene.com are


