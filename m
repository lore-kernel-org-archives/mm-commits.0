Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52369243326
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837101; cv=none; b=fVlyDdRX/Y5/vd+Zz/AFP962720at+ieDJIRx/NM9yzKOFHiEArvQE9QDd/27lhGa2LcbBhMsgRw0FiCHf6lFm4bCDFrmHH0VLGh2OBBmXHWSfkXqc6GAdCaGcYw1dIV6vm/cN0BwUzDsdCcCe7zbG3Z27NzHBL6BeEwUWkTOSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837101; c=relaxed/simple;
	bh=9dILUg052pUrlesdI7aTHZGvOIxjYgS1t8UrfvdSRx8=;
	h=Date:To:From:Subject:Message-Id; b=Pvngk3LANwZ1Ynyiw/Fp9MYQhIorzrK25b7zv6hKlGINUzFXOYrrv9Ca5zEjIRVaSWyj2sgYdK2FXV43SXbgLmS27giG4IMEvsEb2TfRGRgdh7ZCDJKN4Z3v4CxAMlHup9LgsiMyRIVP6znHjh9j8AatPvSR17Ign+RfKOycIjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R3bI6+Ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R3bI6+Ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C943CC4CEDD;
	Tue, 14 Jan 2025 06:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837100;
	bh=9dILUg052pUrlesdI7aTHZGvOIxjYgS1t8UrfvdSRx8=;
	h=Date:To:From:Subject:From;
	b=R3bI6+KecIjb6FrQB4jlVnCUCxSMT2B1yHzAAqH34HZOwUt3iyKDfi2eVdWDQ6BHq
	 GRV/xio04QuDxb3W3eUc8aQCBuP8uLgOSJYRI/Gmxhi7+dzeCMulI3+Hgbiu3WWUyA
	 zwYy8oFykEPaPYZ/D56cdsSuEdKWB/6j6DCt0bUU=
Date: Mon, 13 Jan 2025 22:45:00 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-zram_read_from_zspool-in-writeback.patch removed from -mm tree
Message-Id: <20250114064500.C943CC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: use zram_read_from_zspool() in writeback
has been removed from the -mm tree.  Its filename was
     zram-use-zram_read_from_zspool-in-writeback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use zram_read_from_zspool() in writeback
Date: Wed, 18 Dec 2024 15:34:23 +0900

We only can read pages from zspool in writeback, zram_read_page() is not
really right in that context not only because it's a more generic function
that handles ZRAM_WB pages, but also because it requires us to unlock slot
between slot flag check and actual page read.  Use zram_read_from_zspool()
instead and do slot flags check and page read under the same slot lock.

Link: https://lkml.kernel.org/r/20241218063513.297475-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-zram_read_from_zspool-in-writeback
+++ a/drivers/block/zram/zram_drv.c
@@ -55,8 +55,8 @@ static size_t huge_class_size;
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
-static int zram_read_page(struct zram *zram, struct page *page, u32 index,
-			  struct bio *parent);
+static int zram_read_from_zspool(struct zram *zram, struct page *page,
+				 u32 index);
 
 static int zram_slot_trylock(struct zram *zram, u32 index)
 {
@@ -831,13 +831,10 @@ static ssize_t writeback_store(struct de
 		 */
 		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
+		if (zram_read_from_zspool(zram, page, index))
+			goto next;
 		zram_slot_unlock(zram, index);
 
-		if (zram_read_page(zram, page, index, NULL)) {
-			release_pp_slot(zram, pps);
-			continue;
-		}
-
 		bio_init(&bio, zram->bdev, &bio_vec, 1,
 			 REQ_OP_WRITE | REQ_SYNC);
 		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


