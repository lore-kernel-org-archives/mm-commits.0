Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A75B36921C
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 19:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769888654; cv=none; b=RaJRjsSi50IqG4drmlehtYsSf5O1peB8yTE2+9a93KBNsUo8miDbOy37sz2a3k4JwCue5mK3aCA57saCjt0RMVC3XmWorIVC/3FzyPm6onT9/5tdXDcWpwp1xmHdeuBx3az6rECD8JqIwiYR4BsOyxtqP5/+hbf1jnCOya2zuSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769888654; c=relaxed/simple;
	bh=Xf2OHb5XglYe4xx5JwSjJ0xuaHYEUNncfiJERKnfINg=;
	h=Date:To:From:Subject:Message-Id; b=l8Rz+ZcKqqk+5E9nyQ/0a2I313NTOcUbuWClkG62xwIpwRqRJZvUisIYS46SSu5vKj6vCjy5iJ8SXUy9mbNEmQrXNb1JYgh0qdqoJsJIwXE5n/uWCntFT728J1ty57nxqkM0qJo+obGFyk1RC1OwTslD5dHwEOOJYZAg5gPnw7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggxVz4KY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggxVz4KY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AFDC4CEF1;
	Sat, 31 Jan 2026 19:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769888654;
	bh=Xf2OHb5XglYe4xx5JwSjJ0xuaHYEUNncfiJERKnfINg=;
	h=Date:To:From:Subject:From;
	b=ggxVz4KYr0U5KUIFZ4ER6NLF7Z1oXKNlK0mpcxLEpgwoz687NWU+OsnY6Zszokb4T
	 wURUmIyn6tfBK8FrTfGD7FNfI4YJMdqRTgZAJuJe5IczJO08gT017jOnu61w2TGLSy
	 vS2HOQgy1WEcvId8lAQHdVLiW1AoYR4of3Ld+3Qk=
Date: Sat, 31 Jan 2026 11:44:13 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-luo_file-remember-retrieve-status-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260131194414.20AFDC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate-luo_file-remember-retrieve-status-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-luo_file-remember-retrieve-status-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-luo_file-remember-retrieve-status-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: liveupdate-luo_file-remember-retrieve-status-fix
Date: Sat Jan 31 11:43:34 AM PST 2026

fix kerneldoc, per Pasha

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: "Pratyush Yadav (Google)" <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/liveupdate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/liveupdate.h~liveupdate-luo_file-remember-retrieve-status-fix
+++ a/include/linux/liveupdate.h
@@ -20,7 +20,7 @@ struct file;
 /**
  * struct liveupdate_file_op_args - Arguments for file operation callbacks.
  * @handler:          The file handler being called.
- * @retrieved:        The retrieve status for the 'can_finish / finish'
+ * @retrieve_sts:     The retrieve status for the 'can_finish / finish'
  *                    operation. A value of 0 means the retrieve has not been
  *                    attempted, a positive value means the retrieve was
  *                    successful, and a negative value means the retrieve failed,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

