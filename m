Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D534EEF9
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773159582; cv=none; b=PD0ivqh089Ul4QsomekdpUyq2P4LkCngGXxN2pkqisFemvNmqzF55ycRGIhktuBUIhL41bK28cempX8RQNRKfBfHqA1dyqgXU19UdTZpWFYK4Bzx90JsiQMTZp32Xl5uY10Gsg92P8mdUV0foze/QatHky9fRWxkgBr/PrVhXCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773159582; c=relaxed/simple;
	bh=pBFVnelM5S3atwW36A5N/z0vqtG+fLN1mCWGD2nD2lM=;
	h=Date:To:From:Subject:Message-Id; b=rsc1L5GnDbD6+9emPDtlZ5EsTH0JGlDr7owBnSv2lU+EhNu+xcuvTDPZriBM6YthR1TB7IuV0IbSKoQL1uaRJc7knhsmMOkFxCxlA48MI7iikjHrIPOzC9t67n+XV1d1rmA71hS8elooIkUl9yKFeSS8PXY6rRhYrsbyZZ6HiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s6jP64zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6jP64zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B737C19425;
	Tue, 10 Mar 2026 16:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773159582;
	bh=pBFVnelM5S3atwW36A5N/z0vqtG+fLN1mCWGD2nD2lM=;
	h=Date:To:From:Subject:From;
	b=s6jP64zxHHmfpPlSfE8HYYnC+hOvHCYAAFFRzpPcH0lycr8z6CZ+aLxGkJqVIi+fu
	 WPXiRVRgrq9wzjU+BRGrC6JOdGw2jEJo2dclUf5In1gx1Yq1qL88mROeHAvGC3Kont
	 98mEsQv+URKMq+bwHrgVawcbLr2uWfB0EcuF2hHU=
Date: Tue, 10 Mar 2026 09:19:41 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-permit-params-change-after-init.patch added to mm-new branch
Message-Id: <20260310161942.4B737C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not permit params change after init
has been added to the -mm mm-new branch.  Its filename is
     zram-do-not-permit-params-change-after-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-permit-params-change-after-init.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not permit params change after init
Date: Tue, 10 Mar 2026 15:01:41 +0900

First, algorithm_params_store(), like any sysfs handler, should grab
device init lock.

Second, like any write() sysfs handler, it should grab device init lock in
exclusive mode.

Third, it should not permit change of algos' parameters after device init,
as this doesn't make sense - we cannot compress with one C/D dict and then
just change C/D dict to a different one, for example.

Link: https://lkml.kernel.org/r/20260310060407.1133800-1-senozhatsky@chromium.org
Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribute")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: gao xu <gaoxu2@honor.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-permit-params-change-after-init
+++ a/drivers/block/zram/zram_drv.c
@@ -1769,6 +1769,10 @@ static ssize_t algorithm_params_store(st
 	if (prio < ZRAM_PRIMARY_COMP || prio >= ZRAM_MAX_COMPS)
 		return -EINVAL;
 
+	guard(rwsem_write)(&zram->dev_lock);
+	if (init_done(zram))
+		return -EBUSY;
+
 	ret = comp_params_store(zram, prio, level, dict_path, &deflate_params);
 	return ret ? ret : len;
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-do-not-permit-params-change-after-init.patch

