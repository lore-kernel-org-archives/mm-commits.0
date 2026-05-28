Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E641D35E1B6;
	Thu, 28 May 2026 22:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007195; cv=none; b=bTLXcJEdYgd69QUMwpqQihsdCoDHg3jn8nOK5GYxSNau5wSl5ZirTOM5v0femOYiW8c5xK/IxlIpXCC34mXiaK58YTORPjnaXG/jBP21e/cdT3zJ6lJIh2CcDe8PfiMnxLk94nG/B3cUN9FSiFlJlZW1harJm12DXEl2ypgRVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007195; c=relaxed/simple;
	bh=f6a4kzZvcF4CSpD8ZPTHpcWH7pBLrQ7tM9yMXCvBV+c=;
	h=Date:To:From:Subject:Message-Id; b=Qr0G0C3spBH1VNxSvhpy8KtmAR50crbhudx9du9gE1LJAHYviYLa/xCH1V4W5sXGxFk2geVe1LdevigKa4s07VFnAWNXANjMt9+CCyT1dvdtDTpYEHsZy3JkCWsYQ2cdGu4cdMaLkFQHrjglLjIKmzQhLrCvbhaP2JwUZy0ry5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g4Vx9SxO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g4Vx9SxO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 926401F000E9;
	Thu, 28 May 2026 22:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780007193;
	bh=RMne29sfpRPQPscGqixHcT1sc+5mjoH8asYJW3GMRQY=;
	h=Date:To:From:Subject;
	b=g4Vx9SxOVILJAvlcXuLVjldey0U1SYzmK6uB6CXeL/3tyYtNsxkf9S8ssp6x9ECv8
	 M9ifN+t2ONSrsk+rYU81TTTNw1JwIBwo3uzpQQJl29alE33ixeeGpvgR1rD42oz6Md
	 aoxPiDgymrIDhW1D4KwFqdGzEQdzFVM4Oo/rnOvg=
Date: Thu, 28 May 2026 15:26:33 -0700
To: mm-commits@vger.kernel.org,xieyisheng1@huawei.com,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,hch@lst.de,axboe@kernel.dk,shenxiaogll@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-use-after-free-in-zram_bvec_write_partial.patch added to mm-hotfixes-unstable branch
Message-Id: <20260528222633.926401F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix use-after-free in zram_bvec_write_partial()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     zram-fix-use-after-free-in-zram_bvec_write_partial.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-use-after-free-in-zram_bvec_write_partial.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Cunlong Li <shenxiaogll@gmail.com>
Subject: zram: fix use-after-free in zram_bvec_write_partial()
Date: Thu, 28 May 2026 10:48:44 +0800

zram_read_page() picks the sync or async backing device read path based on
whether the parent bio is NULL.  zram_bvec_write_partial() passes its
parent bio down, so for ZRAM_WB slots the read is dispatched
asynchronously and zram_read_page() returns 0 while the bio is still in
flight.  The caller then runs memcpy_from_bvec(), zram_write_page() and
__free_page() on the buffer, leaving the async read to write into a freed
page.

zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
("zram: fix synchronous reads") for the same reason; the write_partial
counterpart was missed.

Link: https://lore.kernel.org/20260528-zram-v3-1-cab86eef8764@gmail.com
Fixes: 8e654f8fbff5 ("zram: read page from backing device")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-use-after-free-in-zram_bvec_write_partial
+++ a/drivers/block/zram/zram_drv.c
@@ -2337,7 +2337,7 @@ static int zram_bvec_write_partial(struc
 	if (!page)
 		return -ENOMEM;
 
-	ret = zram_read_page(zram, page, index, bio);
+	ret = zram_read_page(zram, page, index, NULL);
 	if (!ret) {
 		memcpy_from_bvec(page_address(page) + offset, bvec);
 		ret = zram_write_page(zram, page, index);
_

Patches currently in -mm which might be from shenxiaogll@gmail.com are

zram-fix-use-after-free-in-zram_bvec_write_partial.patch
zram-drop-unused-bio-parameter-from-write-helpers.patch

