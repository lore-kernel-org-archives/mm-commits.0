Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10E379F2
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763598250; cv=none; b=aI+DOVC1sc1GR1JklU1oA/o45lBo0XwBnxICSz2BtcbHAuXfHvrUWLCsmlazkJ7GiRsKc/u2cyACUxIu9qI9uo6//SfvFxgepr5Bh5GZMxLNiVfZiFZE8RVB1IcRf0OsXe9Gbt6tuaKy6XoE7oWMyJBGkfx6RAvCOwVc860n7KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763598250; c=relaxed/simple;
	bh=fpdSyguQgL+S5WGfjR7zYWi8caHvll5WhoucEaoJ+eU=;
	h=Date:To:From:Subject:Message-Id; b=AhGidIjNxVadgS7Fki7rpt86DUfV1OQ8CeRD6V/HDqIOsJXwhQqPcwhyRinhql98X8gotSoQVsZEJUFU9+SJlUruIorSiHXyw4neYpv6wb0/PCmw5yqdE1P4gtHf9ZC4yOLf1WgmQu37nW3iEu2OxKXlnrnfsvwN6v/sebalojk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fNn3q0GJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fNn3q0GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557DFC4CEF5;
	Thu, 20 Nov 2025 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763598247;
	bh=fpdSyguQgL+S5WGfjR7zYWi8caHvll5WhoucEaoJ+eU=;
	h=Date:To:From:Subject:From;
	b=fNn3q0GJLeEVGgTPnhu5IG07p36v13NIfjteu5uHSXN91euVAKToP//6oV4Nbecye
	 W3uxOXZtTYNgbtH13xN1/olWPSrs2xZjmuaxLZPGFwUTlLv3AVAkX0kECIe7tMxkw4
	 /8gZLb4yEe/YMypNvzKUzisZw8sCh5OjlPHDMDXQ=
Date: Wed, 19 Nov 2025 16:24:06 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,richardycc@google.com,minchan@kernel.org,bgeffon@google.com,ywen.chen@foxmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch added to mm-new branch
Message-Id: <20251120002407.557DFC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: fix the issue that the write - back limits might overflow
has been added to the -mm mm-new branch.  Its filename is
     zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Fixes: 1d69a3f8ae77e ("zram: idle writeback fixes and cleanup")
Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-fix-the-issue-that-the-write-back-limits-might-overflow
+++ a/drivers/block/zram/zram_drv.c
@@ -564,6 +564,16 @@ static ssize_t writeback_limit_store(str
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

zram-introduce-writeback-bio-batching-support.patch
zram-fix-the-issue-that-the-write-back-limits-might-overflow.patch

