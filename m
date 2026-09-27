Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40613B2FCA
	for <mm-commits@vger.kernel.org>; Sun, 27 Sep 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790532254; cv=none; b=kn84nlRAw89jGFPjuBIjXqw97eMb9xW/VdX5nuP1tKkEYdT2sd8FzOtuUFcl7Modf2m3p1iRyfQVHd87/Jgp5WUYsg9RLZbaceAtO64LWb1sDuXZmr8V7X4He/N1dkpwfuoCZ6THp4hZHHT8AvWz9jHdrjMEr4RHOfRnncmuuLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790532254; c=relaxed/simple;
	bh=we4SY6o/3H4cLaVr2yrplQzB260xFeMQViEpGsVwioU=;
	h=Date:To:From:Subject:Message-Id; b=pEf/UpqCdeV5U16Ko3RDBkq3JBFl0IcZPZbkohd2Bu2WV3bM37d+3VlotUOX8JsStS8XBLf+XTZrlkgTgWL7v5FJ8SQJ7q9a4eBO36hVE9wGeyMddYVTo/eY/QPlQu4mE3FMwoPfyt0yFrcZTKVhQDNHPNKd/U/U1K4lYBzzLh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iiv6twlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iiv6twlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672E51F000FF;
	Sun, 27 Sep 2026 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790532252;
	bh=j18pl0XW+oK8bxPvr5vPoOtmL8pfe+eISQWWYdtPQeg=;
	h=Date:To:From:Subject;
	b=Iiv6twlrQXK/OiNLIt9pUtKa7JZszxoJ6aUJtOXUEb+Nuoe1T+MtOoG87pwLhw9Bw
	 RkdMOlIw9aLRZrC4vpElDp3UQ4QvC3i7cAdzlHROjUHOLAIdA2qsqXh4aBEMv5dVf2
	 xtWPMJ4fQE74BksCHWXufoGTnGqH825N3QfWGwDk=
Date: Sun, 27 Sep 2026 11:04:12 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch added to mm-unstable branch
Message-Id: <20260927180412.672E51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
has been added to the -mm mm-unstable branch.  Its filename is
     proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
Date: Sun Sep 27 10:59:53 AM PDT 2026

fix CONFIG_NUMA=y && CONFIG_PROC_PAGE_MONITOR=n build

show_numa_map() uses drop_rcu() and reacquire_rcu(), but those helpers are
currently built only when CONFIG_PROC_PAGE_MONITOR is enabled.  A kernel
with CONFIG_NUMA=y and CONFIG_PROC_PAGE_MONITOR=n therefore fails to build
with implicit declarations for both helpers.

Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix
+++ a/fs/proc/task_mmu.c
@@ -196,7 +196,7 @@ static bool fallback_to_mmap_lock(struct
 	return true;
 }
 
-#ifdef CONFIG_PROC_PAGE_MONITOR
+#if defined(CONFIG_PROC_PAGE_MONITOR) || defined(CONFIG_NUMA)
 static void drop_rcu(struct proc_maps_private *priv)
 {
 	if (priv->lock_ctx.mmap_locked)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memory_hotplug-factor-out-node_is_memoryless-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

