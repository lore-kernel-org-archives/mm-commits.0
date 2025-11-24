Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B073335082
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025873; cv=none; b=EyuCB/VDWNB0HCzFjpKUOiHxNmm87mzAKs+4qg5av1fce0koJzS01xAxwYUrJr5HnHh2Mx0TwzlbwOn7hHdPaFWR2N5KWfNtxbXmW2OgDf8OIKrlApr9A4fUh0tx/MyZxqu6U+WbBVRCukWpDaQVpaj4htGowTTpijSrzgSJa1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025873; c=relaxed/simple;
	bh=Ex/5vu3AzqiFfcnkOtAw/mI9ixoU4spHCt9u9S5W7fk=;
	h=Date:To:From:Subject:Message-Id; b=IJvUHLCJNbJsSafqWLNTf/IMUpUVJtGk3eXgOJ+Xt0KYZ/KrAB0LqC4GkSVGIHQUN27Pf68+vuFVnYVZuNZdLpexIgF56ptUTyAE+Hwz0qtRkPn1QC8txn1o3kY2eI5Gg40k9HrDcyZtAXqGLlZtAB1uAfWEmOCZAA5axpn7ur4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IzDLDLBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IzDLDLBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4497C4CEF1;
	Mon, 24 Nov 2025 23:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025873;
	bh=Ex/5vu3AzqiFfcnkOtAw/mI9ixoU4spHCt9u9S5W7fk=;
	h=Date:To:From:Subject:From;
	b=IzDLDLBHqAvAxK8LAObP367lfVduTJJqSIq1QiIwEyTAKTa81OpukF6T3f7SbpzyA
	 N6rsM1NUu+2p9DltIWNN7V627wCBxxAThmUN1Opl1by75mBZziEhgRIrGkmo3CPPEX
	 hjtDp4LVDB1s9C/8Z9b1j5CFcZd+tHQR1TlC5jpE=
Date: Mon, 24 Nov 2025 15:11:12 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,ywen.chen@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch removed from -mm tree
Message-Id: <20251124231112.E4497C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fix the issue that the write - back limits might overflow
has been removed from the -mm tree.  Its filename was
     zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yuwen Chen <ywen.chen@foxmail.com>
Subject: zram: fix the issue that the write - back limits might overflow
Date: Wed, 19 Nov 2025 12:13:45 +0800

When the page size exceeds 4KB, if bd_wb_limit is set to a value that is
not aligned with the page size, it will cause a numerical wrap-around
issue for bd_wb_limit.  For example, when the page size is set to 16KB and
bd_wb_limit is set to 3, after one write-back operation, the value of
bd_wb_limit will become -1.  More seriously, since bd_wb_limit is an
unsigned number, its value may become as large as 2^64 - 1.

The core reason for this problem is that the unit of bd_wb_limit is 4KB. 
For example, when a write-back occurs on a system with a page size of
16KB, 4 needs to be subtracted from bd_wb_limit.  This operation takes
place in the zram_account_writeback_submit function.

This patch fixes the issue by limiting bd_wb_limit to be an integer
multiple of PAGE_SIZE / 4096.

Link: https://lkml.kernel.org/r/tencent_5936CFE72BAB2BA76887BB69DCC1B5E67C05@qq.com
Fixes: 1d69a3f8ae77 ("zram: idle writeback fixes and cleanup")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-fix-the-issue-that-the-write-back-limits-might-overflow
+++ a/drivers/block/zram/zram_drv.c
@@ -566,6 +566,16 @@ static ssize_t writeback_limit_store(str
 	if (kstrtoull(buf, 10, &val))
 		return ret;
 
+	/*
+	 * When the page size is greater than 4KB, if bd_wb_limit is set to
+	 * a value that is not page - size aligned, it will cause value
+	 * wrapping. For example, when the page size is set to 16KB and
+	 * bd_wb_limit is set to 3, a single write - back operation will
+	 * cause bd_wb_limit to become -1. Even more terrifying is that
+	 * bd_wb_limit is an unsigned number.
+	 */
+	val = rounddown(val, PAGE_SIZE / 4096);
+
 	down_write(&zram->init_lock);
 	zram->bd_wb_limit = val;
 	up_write(&zram->init_lock);
_

Patches currently in -mm which might be from ywen.chen@foxmail.com are


