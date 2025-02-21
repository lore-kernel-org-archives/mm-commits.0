Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9E6250BF3
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181380; cv=none; b=agukZnot6Gf69/yxjSz7H7/rLKhbA7X9I4aRFdHoTHOxwd1XyrjNneRaPJGR4vcxoi97f0BneGJicaqHSDiZ+dOeO/AaT5a3sh0gvlPLRBaT273z4J6plFLh8wnOwp2rOCSoHbmwMC21vMpIGixqp/XSdK00a+OhEj8C3n9Fhbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181380; c=relaxed/simple;
	bh=Dk15PKxSA0e8zvHFt62J03C+wppww+NPd46e5Ff5PhA=;
	h=Date:To:From:Subject:Message-Id; b=ryRIEu1wJEwbisnb/H6vcB3ZahiirazxVMEG7fq3uOlw3wSLbx+iJJTv1q9IwrRKfstfDhPZc/7RvuMni1b4b61EpQUXgn9Nv62oHvTB57/mUsU+Y0jxFlyePRhg0Sq0H5kRHl5wDO8YG2IBw3tPEjKVJXh3x3iRiDxa9NaRXQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vlxJKHN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vlxJKHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C6EC4CED6;
	Fri, 21 Feb 2025 23:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181380;
	bh=Dk15PKxSA0e8zvHFt62J03C+wppww+NPd46e5Ff5PhA=;
	h=Date:To:From:Subject:From;
	b=1vlxJKHNkDN8axyHRBx04NZuyxRO3b/XtJkpQPcOdkp3IKaBp20JmZnqCo/cMFsAz
	 VSj5JQigU7VPNbvT0yNEtfeEIVqqH0VUl+xMeMbQYw4t1Et+qxYG5ypslYhDxIY8tM
	 1/Nlr9/03ZTZtcj0mpp+CfDQvenoEJHV2rB7bHHs=
Date: Fri, 21 Feb 2025 15:42:59 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-leak-page-on-recompress_store-error-path.patch added to mm-unstable branch
Message-Id: <20250221234300.30C6EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not leak page on recompress_store error path
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-leak-page-on-recompress_store-error-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-leak-page-on-recompress_store-error-path.patch

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
Subject: zram: do not leak page on recompress_store error path
Date: Sat, 22 Feb 2025 07:25:46 +0900

Ensure the page used for local object data is freed on error out path.

Link: https://lkml.kernel.org/r/20250221222958.2225035-16-senozhatsky@chromium.org
Fixes: 3f909a60cec1 ("zram: rework recompress target selection strategy")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-leak-page-on-recompress_store-error-path
+++ a/drivers/block/zram/zram_drv.c
@@ -2022,7 +2022,7 @@ static ssize_t recompress_store(struct d
 	struct zram_pp_slot *pps;
 	u32 mode = 0, threshold = 0;
 	u32 prio, prio_max;
-	struct page *page;
+	struct page *page = NULL;
 	ssize_t ret;
 
 	prio = ZRAM_SECONDARY_COMP;
@@ -2166,9 +2166,9 @@ next:
 		cond_resched();
 	}
 
-	__free_page(page);
-
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

