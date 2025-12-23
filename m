Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DFF221DB9
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 02:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766455295; cv=none; b=bBRMNyn930/4BB+J2i8Q0aX255h4c8G6pkOQiJuYQBprThzAenP/9VgUrwNxSlfvbm4l/n8Kd9COEyM4NX3Ykqq3TAdVdkvAGyTO2oHPZQT9LfnkPmQScit4wBUeyN5wNuSsZp59SiDwuzKKWOcUZiY/AF5HTQ04UzA6bUdWwWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766455295; c=relaxed/simple;
	bh=oYYSq85yNH1Zj9jqMLDOqjpX2chzwyh+tSDgOKSaiys=;
	h=Date:To:From:Subject:Message-Id; b=pSiLcUTmWjv3nIY9NgEW5/h6tQaaqH94BoKNcYKlgP2NQuJHQahW6fUDmzV1q6TvirDZBG2HBacBkgw+JJILRcLLvi2K+6X0BqPv/jDX2MLLyMtbss3TU3Q1Izy31CRSAQWEAVupkaezuPIbWBHi15M0zE/76znMQXDDqJ9uXh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iXxYTFoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iXxYTFoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6D9C4CEF1;
	Tue, 23 Dec 2025 02:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766455295;
	bh=oYYSq85yNH1Zj9jqMLDOqjpX2chzwyh+tSDgOKSaiys=;
	h=Date:To:From:Subject:From;
	b=iXxYTFoRDD4m2/YvF8RVkaTxsUCXFyelIn715opQ8A4kcY5hq/0Hmld6Xx7KcF405
	 h3S2NbaoE6DYsU/enNcuePBTngX6kJny0DBHUN+jjYhwZ0pd7TyugouwAJvWYHkawA
	 fdC6L1cl71TCrpw9U4k1xk3xE23toPEQdsYBdsok=
Date: Mon, 22 Dec 2025 18:01:34 -0800
To: mm-commits@vger.kernel.org,tglx@linutronix.de,broonie@kernel.org,mathieu.desnoyers@efficios.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tsacct-skip-all-kernel-threads.patch added to mm-new branch
Message-Id: <20251223020135.6C6D9C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tsacct: skip all kernel threads
has been added to the -mm mm-new branch.  Its filename is
     tsacct-skip-all-kernel-threads.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tsacct-skip-all-kernel-threads.patch

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
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: tsacct: skip all kernel threads
Date: Sun, 21 Dec 2025 18:29:26 -0500

When we hit acct_account_cputime within a irq handler over a kthread that
happens to use a userspace mm, we end up summing up the mm's RSS into the
tsk acct_rss_mem1, which eventually decays.

I don't see a good rationale behind tracking the mm's rss in that way when
a kthread use a userspace mm temporarily through use_mm.

It causes issues with init_mm and efi_mm which only partially initialize
their mm_struct.

Skip all kernel threads in acct_account_cputime(), not just those that
happen to have a NULL mm.

Link: https://lkml.kernel.org/r/20251221232926.450602-6-mathieu.desnoyers@efficios.com
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/tsacct.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/tsacct.c~tsacct-skip-all-kernel-threads
+++ a/kernel/tsacct.c
@@ -125,7 +125,7 @@ static void __acct_update_integrals(stru
 {
 	u64 time, delta;
 
-	if (!likely(tsk->mm))
+	if (!tsk->mm || (tsk->flags & PF_KTHREAD))
 		return;
 
 	time = stime + utime;
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are

lib-introduce-hierarchical-per-cpu-counters.patch
mm-fix-oom-killer-inaccuracy-on-large-many-core-systems.patch
mm-implement-precise-oom-killer-task-selection.patch
mm-add-missing-static-initializer-for-init_mm-mm_cidlock.patch
mm-rename-cpu_bitmap-field-to-flexible_array.patch
mm-take-into-account-mm_cid-size-for-mm_struct-static-definitions.patch
mm-take-into-account-hierarchical-percpu-tree-items-for-static-mm_struct-definitions.patch
tsacct-skip-all-kernel-threads.patch

