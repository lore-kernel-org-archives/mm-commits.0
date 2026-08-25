Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EEA34750B;
	Tue, 25 Aug 2026 01:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622844; cv=none; b=fb4XHroUbOsb5QR63VosURBHsDdedvM9TWUwj1TyoqQmG/J1LLRYuoUXsRtcLXgW1GmKCbGnixDfIdEV2zfCr5o9TDJa+3InAyWL8e1/5Y9s+8hZXYWRDdcWkVGF7+S8hgK84oWqKN2qMlDtqzFjFehQKoMv57vnjArvksrhsy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622844; c=relaxed/simple;
	bh=cedJOA8hGIcsm6DoP/sqrV+t/UHTH6k9/whO4iySTh4=;
	h=Date:To:From:Subject:Message-Id; b=oNNdNFLQBVYrizCryC0mp7scXsuicWcScaSugldwdactlnm62wslBOQnV82T1gpixPFVS3eLJ22oRq6xyPalC2kPM472BOSOefNnJZzXFw0uVJU1hGDfcdzR9CCHVokz82GzgiPyXPwieoy7KXBwQq++aODSqozOt0/d9ag2HoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sE9SLCJI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sE9SLCJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D4E1F00A3A;
	Tue, 25 Aug 2026 01:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622842;
	bh=Voa+3ELiotseOJj3TdxYHHK4uLaTr7LSnhh5NRMXkB8=;
	h=Date:To:From:Subject;
	b=sE9SLCJIDyVgFSxYVt/aNt0CAOfTxu84ySj6eTzVRETL7ltwdx5PI6yao93iK1VJY
	 e7A0o2NDxK4H6giaOxmi8Dg74Rv3QrEZPIb0LCL8GC2xD91uu7dCEXVh7oRz1X+BO0
	 oYCbvO6Qam5dEfyLt6REvuxdAN301HGkvqArDIZI=
Date: Mon, 24 Aug 2026 18:54:02 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-out-of-bounds-access-in-read_block_state.patch removed from -mm tree
Message-Id: <20260825015402.B5D4E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix out-of-bounds access in read_block_state()
has been removed from the -mm tree.  Its filename was
     zram-fix-out-of-bounds-access-in-read_block_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: zram: fix out-of-bounds access in read_block_state()
Date: Tue, 4 Aug 2026 14:59:19 +0800

read_block_state() calculates nr_pages before taking dev_lock.  If the
device is reset and reinitialized with a smaller disksize before lock
acquisition, nr_pages still describes the old table.  The subsequent loop
can then call slot_lock() past the end of the newly allocated table.

Read disksize after acquiring dev_lock and checking that the device is
initialized.  The read lock then keeps the table and its bound stable for
the duration of the scan.

Link: https://lore.kernel.org/20260804065919.3970386-3-xialonglong2025@163.com
Fixes: c0265342bff4 ("zram: introduce zram memory tracking")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-out-of-bounds-access-in-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -1543,7 +1543,7 @@ static ssize_t read_block_state(struct f
 	char *kbuf;
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
-	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
+	unsigned long nr_pages;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -1555,6 +1555,8 @@ static ssize_t read_block_state(struct f
 		return -EINVAL;
 	}
 
+	nr_pages = zram->disksize >> PAGE_SHIFT;
+
 	for (index = *ppos; index < nr_pages; index++) {
 		int copied;
 
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-hugetlb-keep-max_huge_pages-when-dissolving-surplus-folios.patch

