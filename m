Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DDC33B6E8;
	Tue, 25 Aug 2026 01:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622321; cv=none; b=SxyiJLPVF6S1e9oNnlTd6wmQV6oiS+TVkMGl/ka0tx8UhPH9ZFNI0EpPpG4nMNrgYA97h7LxnuE7k4RXu+ABsRGet/zypnMM2T+obAI8PUgb/lWkDz/AztwxkJ3wA8EergSfSGccF0EHeGjDNv1/VLP/ga89xRtUU7Eep7yWiYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622321; c=relaxed/simple;
	bh=2q31nzcaZgjLs3a3VyRAVVx4OqQWwz0o0tX1BHI0BiA=;
	h=Date:To:From:Subject:Message-Id; b=udIc2R9b2xdN0Q+YcrxyqJz2bFjnYAA8NBC8r+AcMKwwrE9XBq8Ba/efQfW918a4atSxBRR9WX/9LNO4z+2nUwBYaLNjckjgCBSvi40MFBVE8bFGGbN6880N+PEaQJiCVN6KuSTmLhrrrVcnXNeKUsYijwLZTIYVcpuFavHll78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=me2tMgao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="me2tMgao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2A01F000E9;
	Tue, 25 Aug 2026 01:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622319;
	bh=DrlZG65MM8Br9V/2Am3HgGRCGHbDl1vwqAy6GkuQlcQ=;
	h=Date:To:From:Subject;
	b=me2tMgaoks1FdALhN7PLP4SAGOQqfcTS89D3iDcfo8TEoSapNDukJbpbR63gTK2ey
	 gDlSUKXl/gTTRvIPEN92KId0D2KmTBhnzU89i8AtaP7VR9+2c+kkMbTUAXWd0JUxvn
	 fBVqsiC+eCKFd4TgR7mhjeTFmmpZqodY7Aj2wbxU=
Date: Mon, 24 Aug 2026 18:45:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,minchan@kernel.org,haoqinhuang7@gmail.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-set-default-primary-compressor-in-zram_destroy_comps.patch removed from -mm tree
Message-Id: <20260825014519.9C2A01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: set default primary compressor in zram_destroy_comps()
has been removed from the -mm tree.  Its filename was
     zram-set-default-primary-compressor-in-zram_destroy_comps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: set default primary compressor in zram_destroy_comps()
Date: Wed, 29 Jul 2026 13:57:35 +0900

Patch series "zram: fix zram issues reported by sashiko".

Sashiko drove by and reported [1] a couple of zram issues:
a possible BUG_ON() in zlib code due to missing winbits range
validation and one possible NULL-ptr dereference in zcomp.
Both are low risk yet still worth fixing.


This patch (of 2):

zram_destroy_comps() resets all compressors and leaves them set to NULL,
including the primary one, which is invalid device state, as now
comp_algorithm_show()->strcmp() can be called on a NULL compressor.  Set
default primary compressor in zram_destroy_comps().

Link: https://lore.kernel.org/20260729045745.775973-2-senozhatsky@chromium.org
Fixes: 486fd58af7ac ("zram: don't free statically defined names")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com [1]
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-set-default-primary-compressor-in-zram_destroy_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2828,6 +2828,7 @@ static void zram_destroy_comps(struct zr
 		zram->comp_algs[prio] = NULL;
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2845,8 +2846,6 @@ static void zram_reset_device(struct zra
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


