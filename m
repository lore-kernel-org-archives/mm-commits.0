Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BE3375F62;
	Thu,  6 Aug 2026 04:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785989636; cv=none; b=XO+2Ma558GJ4dw3O6DYUTER8LQCQUXDMhRd9THo/40J6wWB/1inA/eMKUfXbIOxs7Qdy1gowUdcjuAvyxbmF4s/AsJr4vf0Q9BqP0WNZitx4abfsv+G4MZQWODz0ednnTSpQt57sEKfY/QUC4Em8Yfd3nxBuzUuz9KWwsg94R5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785989636; c=relaxed/simple;
	bh=QTmyYgwTlVGqAWDISsd2rVFpvLBu/1U1vjj5vIDrRmY=;
	h=Date:To:From:Subject:Message-Id; b=Gs6bo+KpdlTgRoSBBP8ytCNejE1ioYFCJQQ1oomQiLCgA5JwKXbSfJp2ZcZZYZMhuvmZLokizzadRooxiUtP4zsv/9vXfrVRUuKqfFKKQfggDl2bmjecrrGWiX9SeqaRRROCtSAYS58Tw3+uqJbeIebn4AHH1A7eHu+s4kWU6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Glpq/EGA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Glpq/EGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D521F000E9;
	Thu,  6 Aug 2026 04:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785989634;
	bh=O5D7Aic3XQ+q1wdDJHVzQZdUZ2OT26xR0U6vNCB3DMo=;
	h=Date:To:From:Subject;
	b=Glpq/EGAo9at/CGWvl+9rr7q8tQiyuwbPH33+948M6RnPhLb60B04KVBCPUkSjsmM
	 JJH+NTuHJ+wv2aOfYJtZ9+j159pa1Ewes/pTLjjju4UC17NNztWk8y5cBFvWHehy+u
	 hanu/sraUsyZTcKUXDB/x5X+e5kDdlz4iGRzM1yU=
Date: Wed, 05 Aug 2026 21:13:53 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,xialonglong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] zram-reject-disksizes-that-exceed-slot-index-range.patch removed from -mm tree
Message-Id: <20260806041354.60D521F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: reject disksizes that exceed slot index range
has been removed from the -mm tree.  Its filename was
     zram-reject-disksizes-that-exceed-slot-index-range.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Longlong Xia <xialonglong@kylinos.cn>
Subject: zram: reject disksizes that exceed slot index range
Date: Tue, 4 Aug 2026 22:38:32 +0800

zram uses u32 slot indexes, while disksize_store() accepts a u64 size.  On
32-bit systems, a disksize larger than U32_MAX pages is truncated when
zram_meta_alloc() assigns the page count to size_t.  array_size() then
sees only the truncated count, so a small table can be allocated while the
original capacity is published.  Valid I/O within that capacity can
subsequently access beyond zram->table.

The same oversized capacity also lets full-device scanners compare a u32
index with an upper bound larger than U32_MAX, so the index can wrap
instead of terminating.

Reject disksizes larger than U32_MAX pages before aligning and allocating
the table.  This keeps the table size, published capacity and slot index
range consistent.

Link: https://lore.kernel.org/20260804143832.146129-1-xialonglong2025@163.com
Fixes: 33863c21e69e ("Staging: zram: Replace ioctls with sysfs interface")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-reject-disksizes-that-exceed-slot-index-range
+++ a/drivers/block/zram/zram_drv.c
@@ -2881,6 +2881,9 @@ static ssize_t disksize_store(struct dev
 		return -EBUSY;
 	}
 
+	if (disksize > (u64)U32_MAX << PAGE_SHIFT)
+		return -EINVAL;
+
 	disksize = PAGE_ALIGN(disksize);
 	if (!zram_meta_alloc(zram, disksize))
 		return -ENOMEM;
_

Patches currently in -mm which might be from xialonglong@kylinos.cn are

mm-ksm-avoid-missing-ksmd-wakeups-in-ksm_enter.patch
zram-fix-out-of-bounds-access-in-writeback_store.patch
zram-fix-out-of-bounds-access-in-read_block_state.patch

