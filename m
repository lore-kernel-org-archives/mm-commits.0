Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E931B815
	for <mm-commits@vger.kernel.org>; Tue,  6 Feb 2024 20:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707252579; cv=none; b=NZDrAGggbLDhNIidz7me0W/61zO4AgGgOJ8LXiC58FlYqkhScz1hUqQnV64qQdhqG8t3/pgH1fMrrObSO71+j1+HLXckREGOXVGLrMVdzCf07ryA1BBh4pcR0YFenCjluWhczJgkdZoy7Oy1vQ2xPj79JddBeRKdaM45u+xz3U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707252579; c=relaxed/simple;
	bh=hNznT7k0xJ0wvY4OCR/w0Oq8GRyenFwCnHqfvZf7U6A=;
	h=Date:To:From:Subject:Message-Id; b=gaCm78pmVai1T63gA1pNCirG7oPLdHSByWCcBuodGCipLHZ/upy3Vdq9ki5BH+ew1KPhkJD/gx08nHXEoTbZIEpFyhIsmzCPxjMyOh29F8N5uP3Pw6sLuUxzCzAqE4YeOqr+O2a6H/HxOAIsWhf8J0DcvnheCmN/gj1VNfc4SGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YGOADbVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YGOADbVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDEBC433F1;
	Tue,  6 Feb 2024 20:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707252578;
	bh=hNznT7k0xJ0wvY4OCR/w0Oq8GRyenFwCnHqfvZf7U6A=;
	h=Date:To:From:Subject:From;
	b=YGOADbVRWI5dLsItAmXWas7opS2+US/ZffTdbX4bzcV29mwWdDjjdTlqewFLeGOe+
	 CTQ2NuTpw7yOXzixGC4xnU9fR1qed8kLHTiDgpk20HwKwz0Q+4DspWmyA5vebenYML
	 90GXGfyvc4fR6IUXDgzcTuK72WwV3cDq1hyYWeCY=
Date: Tue, 06 Feb 2024 12:49:38 -0800
To: mm-commits@vger.kernel.org,yj.chiang@mediatek.com,senozhatsky@chromium.org,minchan@kernel.org,matthias.bgg@gmail.com,axboe@kernel.dk,angelogioacchino.delregno@collabora.com,mark-pk.tsai@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-copy_page-for-full-page-copy.patch added to mm-unstable branch
Message-Id: <20240206204938.9DDEBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: use copy_page for full page copy
has been added to the -mm mm-unstable branch.  Its filename is
     zram-use-copy_page-for-full-page-copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-copy_page-for-full-page-copy.patch

This patch will later appear in the mm-unstable branch at
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

zram-use-copy_page-for-full-page-copy.patch

