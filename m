Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A9A42A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181382; cv=none; b=EJnD21cyL1wuWT886ECD2WI1jfWLqs4eK3r4NPlfUFGdl7CoT5UvUu0vayI4dJlqEXV6PPZKkkdHUF7zkUbyqTmoSWk6Mtq7L6J6wcalgp75uONZ4giIp48ocMIqS3qF4VHc2k5EoTqodopjId4c5nD9971BrHLwhbKDr6lVOro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181382; c=relaxed/simple;
	bh=h0JdBoffCVr3q+liVnlvEgau278anqZu/jq1Z52ss4g=;
	h=Date:To:From:Subject:Message-Id; b=fmeV21J3Ujj7IIuNdL0Lmw6jzhJtGvdtEDggqTYA+3SaQnN7rD8okjRigfEHmUeabV6OynVHDF2wh9EOV2kyyg2S+mk6j44QV9rGg2HPexOoZMbXSulT4yvd1jBn3FEjl6x8eEM3bJC/mLk4ZYFAFR8ecuag6L8nFR6hYY7Y1jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PXGjc98g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PXGjc98g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3021BC4CED6;
	Fri, 21 Feb 2025 23:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181382;
	bh=h0JdBoffCVr3q+liVnlvEgau278anqZu/jq1Z52ss4g=;
	h=Date:To:From:Subject:From;
	b=PXGjc98g0aUddDmQ4+LXCgVdrj+xwsjdQtjncI5SAj69Jfcj5nljZlxpBnZ+Fdd1H
	 Ga5pVUbZKng2UWvtJi91oYN8QiLV3H3I6SQE43F/lIsHH/dyzsuBYODCJvyuRnasjC
	 gbZdDqq8s/8CGprqYKJj9ElQfeIaOpOn+g6dkpf0=
Date: Fri, 21 Feb 2025 15:43:01 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-leak-page-on-writeback_store-error-path.patch added to mm-unstable branch
Message-Id: <20250221234302.3021BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not leak page on writeback_store error path
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-leak-page-on-writeback_store-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-leak-page-on-writeback_store-error-path.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not leak page on writeback_store error path
Date: Sat, 22 Feb 2025 07:25:47 +0900

Ensure the page used for local object data is freed on error out path.

Link: https://lkml.kernel.org/r/20250221222958.2225035-17-senozhatsky@chromium.org
Fixes: 330edc2bc059 (zram: rework writeback target selection strategy)
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-leak-page-on-writeback_store-error-path
+++ a/drivers/block/zram/zram_drv.c
@@ -792,7 +792,7 @@ static ssize_t writeback_store(struct de
 	unsigned long index = 0;
 	struct bio bio;
 	struct bio_vec bio_vec;
-	struct page *page;
+	struct page *page = NULL;
 	ssize_t ret = len;
 	int mode, err;
 	unsigned long blk_idx = 0;
@@ -934,8 +934,10 @@ next:
 
 	if (blk_idx)
 		free_block_bdev(zram, blk_idx);
-	__free_page(page);
+
 release_init_lock:
+	if (page)
+		__free_page(page);
 	release_pp_ctl(zram, ctl);
 	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

