Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7DDC8E6
	for <mm-commits@vger.kernel.org>; Sat, 21 Feb 2026 00:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771634329; cv=none; b=qMWFaRQhiRR9uh5B91wF5nVZlN9GxV/2qgKgHNJgpUZYLC+p5Z1KLZxPYToO56L5wSWTnARPWBO9MKWHR0m2K2ZHp5XZMPK7K0qdZOL+VCwBBrWAui1dDWP9F4Q9xPqJ0J2YTjXIsPuwMGttdVLbaSijn1OtN1eeSEX0RxXlyFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771634329; c=relaxed/simple;
	bh=G2QsuBurny2RIda0Rl9pownWazhVSipKnnGFKLzJ65o=;
	h=Date:To:From:Subject:Message-Id; b=XqC7rHRrAWMVjd/HAZREP/f8r/nnkYJb+F64iEVOwDxAz+1lTFXuhEbuUEMdFRxMIiDcAraf5UH/az3qlWV+sxiiYLCmg2ODfNjJtfJdfYBo8FFVsAUmrIs7KdNzDvhGHGCoqvgRrnKDjDiCWF0l8ftP4GHKVfmDFs87gRjnnfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzVCe+gp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzVCe+gp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A16C116C6;
	Sat, 21 Feb 2026 00:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771634328;
	bh=G2QsuBurny2RIda0Rl9pownWazhVSipKnnGFKLzJ65o=;
	h=Date:To:From:Subject:From;
	b=QzVCe+gpFV5QkvSqfAHC7s7rQ7MeuuE4bBrA0SS4r8E8bNd6kFwJTow7p4VaGkWD4
	 sKKO6L+P8ecJzQIPphi5Hej1D0uE6JWOko2BVJLIxekAoEPbqM4n/64rKgbj/TuKNy
	 YCgrxY8QvBkGtnF4zpvoiGP8sOWWx6o9ePnUkid0=
Date: Fri, 20 Feb 2026 16:38:48 -0800
To: mm-commits@vger.kernel.org,catalin.marinas@arm.com,zhongqiu.han@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch added to mm-new branch
Message-Id: <20260221003848.B9A16C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kmemleak: use PF_KTHREAD flag to detect kernel threads
has been added to the -mm mm-new branch.  Its filename is
     mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch

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
From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Subject: mm/kmemleak: use PF_KTHREAD flag to detect kernel threads
Date: Fri, 30 Jan 2026 17:37:29 +0800

Replace the current->mm check with PF_KTHREAD flag for more reliable
kernel thread detection in scan_should_stop().  The PF_KTHREAD flag is the
standard way to identify kernel threads and is not affected by temporary
mm borrowing via kthread_use_mm() (although kmemleak does not currently
encounter such cases, this makes the code more robust).

No functional change.

Link: https://lkml.kernel.org/r/20260130093729.2045858-3-zhongqiu.han@oss.qualcomm.com
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/kmemleak.c~mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads
+++ a/mm/kmemleak.c
@@ -1505,10 +1505,10 @@ static int scan_should_stop(void)
 	 * This function may be called from either process or kthread context,
 	 * hence the need to check for both stop conditions.
 	 */
-	if (current->mm)
-		return signal_pending(current);
+	if (current->flags & PF_KTHREAD)
+		return kthread_should_stop();
 
-	return kthread_should_stop();
+	return signal_pending(current);
 }
 
 /*
_

Patches currently in -mm which might be from zhongqiu.han@oss.qualcomm.com are

mm-kmemleak-remove-unreachable-return-statement-in-scan_should_stop.patch
mm-kmemleak-use-pf_kthread-flag-to-detect-kernel-threads.patch

