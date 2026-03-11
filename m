Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F2B238D54
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 18:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252767; cv=none; b=bTT71oSeUvwas7dYDamPHCIBQug4cpw+HOnlEoeREkIwHq0VxQIty2iDwddDOYMdwnUr0Rb5QqFYkKVMbgMXpSqrqjJXZUczpuhr/kyAZ2g3RwuODQdL58vgozWOydi1HV/jS49xR/csjJ9qVPsxkXbxjYnHEMCtEqmbcm7TRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252767; c=relaxed/simple;
	bh=jMFTmp1cTYW/Gbzn7+dGRsGiv8PZ6ZWPT9apTgNTeP8=;
	h=Date:To:From:Subject:Message-Id; b=Wc72xonCFjeG2C2Fi3+wxkDihUS7q6GOZtcMgusLGQSGBRYsUAKdCueuVAyayTEn0jxk6As7yd3LPeQ8JsE7QWudStJTVDwJbKxJkERwnnXiw/tp1XjqMcFzZPz+fa7aRMNbQH22Z4dUYXjvRsojta+zDJZtdWrLjr0eBYVG8jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=exwB28Cx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="exwB28Cx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19E9C4CEF7;
	Wed, 11 Mar 2026 18:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773252767;
	bh=jMFTmp1cTYW/Gbzn7+dGRsGiv8PZ6ZWPT9apTgNTeP8=;
	h=Date:To:From:Subject:From;
	b=exwB28CxNC10QgFUyIkEbd8vWCfUQDmmNDhK229ShZKjUoOLTiB0uKu77S1wol7kK
	 mB+YaUW355TmkQW82UmbDKWxDm4j6QTJ/BxUIglkguC13iRZUIF0gaD2fcEXod06QG
	 T95MPpppUMYGwdaGk1j0AmKpALCwJ0df+R69aA2A=
Date: Wed, 11 Mar 2026 11:12:46 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-permit-params-change-after-init.patch added to mm-unstable branch
Message-Id: <20260311181246.F19E9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not permit params change after init
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-permit-params-change-after-init.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-permit-params-change-after-init.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Wed, 11 Mar 2026 17:42:44 +0900

Patch series "zram: recompression cleanups and tweaks", v2.

This series is a somewhat random mix of fixups, recompression cleanups and
improvements partly based on internal conversations.  A few patches in the
series remove unexpected or confusing behaviour, e.g.  auto correction of
bad priority= param for recompression, which should have always been just
an error.  Then it also removes "chain recompression" which has a tricky,
unexpected and confusing behaviour at times.  We also unify and harden the
handling of algo/priority params.  There is also an addition of missing
device lock in algorithm_params_store() which previously permitted
modification of algo params while the device is active.


This patch (of 6):

First, algorithm_params_store(), like any sysfs handler, should grab
device lock.

Second, like any write() sysfs handler, it should grab device lock in
exclusive mode.

Third, it should not permit change of algos' parameters after device init,
as this doesn't make sense - we cannot compress with one C/D dict and then
just change C/D dict to a different one, for example.

Another thing to notice is that algorithm_params_store() accesses device's
->comp_algs for algo priority lookup, which should be protected by device
lock in exclusive mode in general.

Link: https://lkml.kernel.org/r/20260311084312.1766036-1-senozhatsky@chromium.org
Link: https://lkml.kernel.org/r/20260311084312.1766036-2-senozhatsky@chromium.org
Fixes: 4eac932103a5d ("zram: introduce algorithm_params device attribute")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-permit-params-change-after-init
+++ a/drivers/block/zram/zram_drv.c
@@ -1750,6 +1750,10 @@ static ssize_t algorithm_params_store(st
 		}
 	}
 
+	guard(rwsem_write)(&zram->dev_lock);
+	if (init_done(zram))
+		return -EBUSY;
+
 	/* Lookup priority by algorithm name */
 	if (algo) {
 		s32 p;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-permit-params-change-after-init.patch
zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-unify-and-harden-algo-priority-params-handling.patch

