Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E6F4F96D4
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 16:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789662176; cv=none; b=BPUinRrNQSYnZcniujezbuoXNNaz2TAlk3NOQA3MdHaQBQWc+ZnYsIGev87YxF5L7YS4AvO84NewNW+1oTAjkGlo7/Pyx/jNFT+6VgzqH3BDDIATk3JkUHz5ZEAn/qkpDJITNHmDsHFV8y4V0qOIMdLlSf01y5CB8mxWJqQhPRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789662176; c=relaxed/simple;
	bh=rDelclumyd824xM+4HyaiM4ko/Twdb3LnufxjFtNlVg=;
	h=Date:To:From:Subject:Message-Id; b=YS3PJe8/QGfLHNpsIoxaF+Sutl5tlhUqDEJ/BfjuGogTpyZkJGIBZOYrFwAeDiVY/stcs6AFBFmzctobHkw7hxYE722sl04ButHt2l7cAKbn+YZS9BElMW7NET/C1IwRzqRbrDayl+Ed7Lnivzf1qfPDmh1cngGFujYdyNj1lEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RE4b0N0g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RE4b0N0g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA0A1F00898;
	Thu, 17 Sep 2026 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789662174;
	bh=zZc0W6dFYRXFIJE7R6inSXK/kaHPjJp86VEt2R5pw2E=;
	h=Date:To:From:Subject;
	b=RE4b0N0gaepe8ZSBif9/c2LwcLxKPOOZRFuA1E4205Fv9FI9KtE/IIlD+STD3SHNm
	 ppB8sCAVZQpJRpblcwVBdTeP9csz/+CCKIJ6w5urPHVMDg7TqHPDbo7uehDZJVmbJd
	 VsHrwdwr1L/UX2RCBo40bnW2T9/XCFLKwE8ebERo=
Date: Thu, 17 Sep 2026 09:22:54 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch removed from -mm tree
Message-Id: <20260917162254.6FA0A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
has been removed from the -mm tree.  Its filename was
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
Date: Mon, 14 Sep 2026 12:06:31 -0700

Uninlined drop_rcu() and reacquire_rcu() functions are not used when
CONFIG_PROC_PAGE_MONITOR=n. Exclure them in this configuration.

Link: https://lore.kernel.org/20260914190631.3167420-1-surenb@google.com
Fixes: 7edb437cbbfc ("proc/task_mmu: remove unnecessary inlines in function definitions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609121422.hkKWuy7K-lkp@intel.com/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -194,6 +194,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
+#ifdef CONFIG_PROC_PAGE_MONITOR
 static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
@@ -211,6 +212,7 @@ static void reacquire_rcu(struct proc_ma
 	/* Reinitialize the iterator. */
 	vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
 }
+#endif
 
 static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 {
_

Patches currently in -mm which might be from surenb@google.com are

proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

