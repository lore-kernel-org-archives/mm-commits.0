Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2BF3438B5
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779744708; cv=none; b=U1gazSB0X8/DSfC7MCmiiCmFmb2hKV/P34B4F4h8z/NwNjjpxw7mss+/KDPJPbbp1lko7TbVki2E1HqDrzBG2Y9f8ptQ4BTBfc1gb9UB9Kmw0ng4jP+qWXFeERRyWsVpSFJJW4SITzoK/LWnFgFP2T0Oi6lJQ1IpAoiPpzIHQes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779744708; c=relaxed/simple;
	bh=s6gyq00fm1tWLUKtXa8CFp9UE5Szs1cIsDJUqMtlrgY=;
	h=Date:To:From:Subject:Message-Id; b=W4asg1FaEW0xxXOqyAhroptZ/vNe2Xtqkifbu6ubwFWguUZL/4eYqxFAXk5KpxUKH+t5x7BLyJacddls86dn9+2o+KC8tHYtkXnAlAC2t7jl4BEN6VeGzxsVbUDAIoqB5Vjqcb6ZnSndEQ0SjFG9QlS08wcqGRvV63+QZLbWdCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Pe21uZQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Pe21uZQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD75E1F000E9;
	Mon, 25 May 2026 21:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779744706;
	bh=PBHmWbq93eDlPM90hySfDtpx+Yd17ww4gEaPpTkApF4=;
	h=Date:To:From:Subject;
	b=Pe21uZQ22/AwWZIsx5ylk+lmIVXEs68xfz2xJ7j5/MTbs9+E1bDFfvdxNY2d5l4/J
	 UpcjqsNEVxqxSKqwF6tR3dp1DNH0Vu15Txxg72aP0bI2RaFyPbU8Q0+qWWxkJ5ZfhV
	 qf1c54yS8mRZQkF0EAQrkKaBmaPE3DzoE9U779S4=
Date: Mon, 25 May 2026 14:31:46 -0700
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-clear-trailing-bytes-of-compressed-writeback-pages.patch added to mm-new branch
Message-Id: <20260525213146.CD75E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: clear trailing bytes of compressed writeback pages
has been added to the -mm mm-new branch.  Its filename is
     zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clear trailing bytes of compressed writeback pages
Date: Mon, 25 May 2026 13:46:02 +0900

When compressed writeback is available writtenback pages contain garbage
PAGE_SIZE - obj_size trailing bytes.  Zero out those trailing bytes before
writeback to a backing device.

Link: https://lore.kernel.org/20260525044639.1888561-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-clear-trailing-bytes-of-compressed-writeback-pages
+++ a/drivers/block/zram/zram_drv.c
@@ -2134,6 +2134,8 @@ static int read_from_zspool_raw(struct z
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
+	memzero_page(page, size, PAGE_SIZE - size);
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-leak-blk-idx-at-the-end-of-writeback.patch
zram-clear-trailing-bytes-of-compressed-writeback-pages.patch

