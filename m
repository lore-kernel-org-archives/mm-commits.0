Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D15493D49
	for <mm-commits@vger.kernel.org>; Mon, 14 Sep 2026 20:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789419371; cv=none; b=BeSsiZfH40M9TICz3AjnEmMr8uuiWJggNgMxGqdt3xpTVN3tD1l1SuWcVFbiokBjJFDvbd/JK96WLly8ZKihwMV8dOoB5rUY4YAlwEk4dZjOpcmch+52R8MYOshAa+ac9OgVPSehvbUrwoHLLOWe8ueXifPjBiLLy538qiSx/cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789419371; c=relaxed/simple;
	bh=dYnRkq2UR2WQbdN16LQisAyKHENmiQFHXW4y8BmAJB8=;
	h=Date:To:From:Subject:Message-Id; b=Ay2aZFljysh3YHTkceaOYoTrGBUQExudilYFdV+WLzd4XTVIxe0atqeVOFBYiZesTrmDcRy4hMoFIWT9o+/a391bK1yihZooTkpRa/gRt38kZIcxmF6eKGKFGPcLhCEBy6f0+QbSt9cftHUmuYnUXRxAxVnhBFYXN095R8BKp7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrBLEDXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrBLEDXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E63B1F000FF;
	Mon, 14 Sep 2026 20:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789419370;
	bh=pMx+MvvJRVMcMPFErG1H0ldrVOqzp75fjty+8Xgs48c=;
	h=Date:To:From:Subject;
	b=lrBLEDXIFxQOBSEBm2QKM5/XNAYOFW1YQbu10I/LSdaYGnrUImRYXcwc5jy2uhewC
	 B2VlGaj52TUjOqpHfS5L6pkoHqw9uGVAbs6VUjssyMLnqmJt2Req38MIZuW4RlNtL9
	 2UstXHM4r9k6YM4LArWtI957Al+oDIbbLGNy9zps=
Date: Mon, 14 Sep 2026 13:56:09 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch added to mm-new branch
Message-Id: <20260914205610.3E63B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
has been added to the -mm mm-new branch.  Its filename is
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

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

proc-task_mmu-remove-unnecessary-helpers.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
proc-task_mmu-clarify-shmem-mapping-walk-conditions-in-smap_gather_stats.patch
proc-task_mmu-remove-special-casing-of-smap_gather_stats-start-parameter.patch
proc-task_mmu-change-proc_get_vma-to-stop-returning-gate-vma-at-the-end.patch
proc-task_mmu-read-proc-pid-smaps_rollup-under-per-vma-lock.patch
selftests-proc-add-proc-pid-smaps_rollup-tearing-tests.patch

