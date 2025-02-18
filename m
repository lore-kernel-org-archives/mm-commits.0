Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A489118E1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739848589; cv=none; b=LHUz8B9Fj9Mvqg3qLZJKYiQUWIA1N/f/mFbrG8v5/8T2qBRxNZlbCQ6isBCkAt2cs1rPRlYzAH0Za+IZSC5ocffiUivfMPGfPQyqquViaq0i/EJASTAL7v+XeS4SmpjrJZW3l8GIvR0FIMPDyxYxknflutl6/2M5x1rOPNfkoIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739848589; c=relaxed/simple;
	bh=+uHSEUTY53STmFWAEWhjaezt1/gUkAkBCdk4iSyvf28=;
	h=Date:To:From:Subject:Message-Id; b=FpPGV67+YA7J93G2JR5EgkBGTzKy5zPdkm55yjKrdJeELzeTWXMiubGpzQeFhBQ2mRB16cI+AXVkCX7d9GlPnhwPL5qXMu1xqiOUJa1qVpWCfv5O85J04caoK6TmwFCa14hiT4VzAJfODoX8sr8IrZtmHwuh3TPpfgQUmcvQFWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQt27Yvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQt27Yvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D24C4CED1;
	Tue, 18 Feb 2025 03:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739848589;
	bh=+uHSEUTY53STmFWAEWhjaezt1/gUkAkBCdk4iSyvf28=;
	h=Date:To:From:Subject:From;
	b=VQt27YvrByj5tXv0Rfox4ZbnEZrWn7bDsWzAXFeOuoGJXbk7KKSSkFNr3kIVVh/fS
	 nODdLpGaS/5kQJdcnDQTLSewGo543kzqyzmr/MJ5wWf3J895ase30gZ9I1zO+ZaVIq
	 6cwHfNiPRGbVyo7BmFxsS8VVRT/CJZQaR9ncuk/0=
Date: Mon, 17 Feb 2025 19:16:28 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch added to mm-unstable branch
Message-Id: <20250218031629.06D24C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: fix title underlines in refcount-vs-atomic.rst
has been added to the -mm mm-unstable branch.  Its filename is
     refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: docs: fix title underlines in refcount-vs-atomic.rst
Date: Mon, 17 Feb 2025 08:16:45 -0800

Fix title underlines for newly updated refcount-vs-atomic.rst

Link: https://lkml.kernel.org/r/20250217161645.3137927-1-surenb@google.com
Fixes: 03b412c8b184 ("refcount: provide ops for cases when object's memory can be reused")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/refcount-vs-atomic.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/core-api/refcount-vs-atomic.rst~refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix
+++ a/Documentation/core-api/refcount-vs-atomic.rst
@@ -87,7 +87,7 @@ Memory ordering guarantee changes:
 
 
 case 2) - non-"Read/Modify/Write" (RMW) ops with release ordering
--------------------------------------------
+-----------------------------------------------------------------
 
 Function changes:
 
@@ -139,7 +139,7 @@ Memory ordering guarantees changes:
 
 
 case 6) - increment-based RMW ops with acquire ordering that return a value
------------------------------------------------------
+---------------------------------------------------------------------------
 
 Function changes:
 
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch
mm-avoid-extra-mem_alloc_profiling_enabled-checks.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-slab-allocator.patch
alloc_tag-uninline-code-gated-by-mem_alloc_profiling_key-in-page-allocator.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-introduce-vma_iter_store_attached-to-use-with-attached-vmas.patch
mm-mark-vmas-detached-upon-exit.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused.patch
refcount-provide-ops-for-cases-when-objects-memory-can-be-reused-fix.patch
refcount-introduce-__refcount_addinc_not_zero_limited_acquire.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-move-lesser-used-vma_area_struct-members-into-the-last-cacheline.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

