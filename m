Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367261519B4
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 01:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772761764; cv=none; b=QoQmek7BA5YzzwXhsPreQVm+HDq6fvHXbcbD91IO6pCjMPsajnYi1aK0pDYKNAZcqWK71F9TTDPA9gvvhAoOanugeVusNuEXyO60WanClRe4+XXpl99MpZBFwiSJaEXfyP8KovVozvT4r86ypLbyc/1/6r2XEKFdIrCYTGYyoOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772761764; c=relaxed/simple;
	bh=YcR2j/wo21C2roIOljCnKyUmJZokKdI6qxtfFFRzZSM=;
	h=Date:To:From:Subject:Message-Id; b=cI+JBpNX3EIe9myjX6vMIXfqKB11lreAmK8RE+GSG/OSHP/SNghypBlmzY1IWZM4eEM1mCHdhaCMGJ6+S6zQ/ZW8aScvefPDvJMCxdx7q2tdnY6d4JCR/QoS7v567EI/CdmkWNchHKoLuQiXzuIXXkB/+OM7nLHJkTRjR8Gr2Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z0sQfKVT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z0sQfKVT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA31EC116C6;
	Fri,  6 Mar 2026 01:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772761763;
	bh=YcR2j/wo21C2roIOljCnKyUmJZokKdI6qxtfFFRzZSM=;
	h=Date:To:From:Subject:From;
	b=Z0sQfKVT39XfjRqzKEHGyiRRosBx5DO0ab4ZG2uhdRCwAhW2tx+ZkAVxQdNCG9UZB
	 Jnf4J39hXDuqd+Zg426fnvNxO0dZS4GgDH0YVaTLUK2a6j6unDsLvjQnz/CfTOCsrx
	 gOEwdu1UtxgFWrTKgGh+S100j7Whe/kkBcgYN0qw=
Date: Thu, 05 Mar 2026 17:49:23 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-gfp_kernel-for-post-processing-slot-allocation.patch added to mm-new branch
Message-Id: <20260306014923.BA31EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: use GFP_KERNEL for post-processing slot allocation
has been added to the -mm mm-new branch.  Its filename is
     zram-use-gfp_kernel-for-post-processing-slot-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-gfp_kernel-for-post-processing-slot-allocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
Subject: zram: use GFP_KERNEL for post-processing slot allocation
Date: Thu, 5 Mar 2026 11:16:03 +0900

Post-processing slot allocation used to be performed under slot bit-lock,
so gfp was restricted, then we switched to a sleepable slot lock but gpf
still remained restricted.  Drop that restriction and use GFP_KERNEL
instead.

Link: https://lkml.kernel.org/r/20260305021619.617481-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-gfp_kernel-for-post-processing-slot-allocation
+++ a/drivers/block/zram/zram_drv.c
@@ -297,7 +297,7 @@ static bool place_pp_slot(struct zram *z
 	struct zram_pp_slot *pps;
 	u32 bid;
 
-	pps = kmalloc_obj(*pps, GFP_NOIO | __GFP_NOWARN);
+	pps = kmalloc_obj(*pps, GFP_KERNEL | __GFP_NOWARN);
 	if (!pps)
 		return false;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch
zram-use-gfp_kernel-for-post-processing-slot-allocation.patch

