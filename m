Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A871EA6F
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 03:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739849467; cv=none; b=UTZpzfuBfEr/r1WqIfCYWAxsbAi+OLkd63erW+6h+Mdl6ZGjYmpl/KdQkaroAE2ZIHfdJl4ksF9To1UDY5YE7GCPwfQJo3mm3FLO77TURbsrTTzGWKshmoqUMgAfiFT0MDrwWDl2utLwvoeiD21NLdMs8zgsMdYFEhKcxW/A36s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739849467; c=relaxed/simple;
	bh=Tcf7rP6DSoqpl8HK5cobEw/qaD0qk6jALobaOsFka2o=;
	h=Date:To:From:Subject:Message-Id; b=Xi6uyz5cWQ5y6PVIYmIpQVyT2eFsi14Nroz99gky430rIQc/RP+0byUULnpT3qM3jZhWnfA5HOK9HgryIh63oW7Np4AhjlTUUCLBKT1hr7jNHEnHl8gr8w+LVNaY+SPKeljn29uYLWYUUPBzrvAMwCOu5NoHMkoo1Au2aM+0Eds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FuVccZ4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FuVccZ4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AA3C4CEE6;
	Tue, 18 Feb 2025 03:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739849465;
	bh=Tcf7rP6DSoqpl8HK5cobEw/qaD0qk6jALobaOsFka2o=;
	h=Date:To:From:Subject:From;
	b=FuVccZ4vQiYttW+1hzgz78uhT+Rcmoj6Mg/khJ2wtk9I5aEs1mchqljUHuG8K2xVf
	 ZOiqHEekuxnFZXvwbhGT2A5lEUSAUBN3kdNZhD8x3HDuyoqasw1tIaLFe8G33RQpot
	 ZaR/sRezm4wAbEvx+gcvx/roFZQ5c5RV5BtVYgug=
Date: Mon, 17 Feb 2025 19:31:05 -0800
To: mm-commits@vger.kernel.org,lkp@intel.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch added to mm-unstable branch
Message-Id: <20250218033105.C3AA3C4CEE6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools: remove atomic_set_release() usage in tools/
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch

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
Subject: tools: remove atomic_set_release() usage in tools/
Date: Sun, 16 Feb 2025 21:43:51 -0800

Userspace versions of both atomic_set_release() and atomic_set() get
translated into uatomic_set().  To avoid extra definitions of
atomic_set_release(), replace its usage inside refcount_set_release() with
atomic_set().  This results in no functional changes.

Link: https://lkml.kernel.org/r/20250217054351.2973666-1-surenb@google.com
Fixes: 1465347e498f ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202502170049.sHfzQwpv-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/linux/refcount.h   |    2 +-
 tools/testing/vma/linux/atomic.h |    1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

--- a/tools/include/linux/refcount.h~mm-make-vma-cache-slab_typesafe_by_rcu-fix
+++ a/tools/include/linux/refcount.h
@@ -62,7 +62,7 @@ static inline void refcount_set(refcount
 
 static inline void refcount_set_release(refcount_t *r, unsigned int n)
 {
-	atomic_set_release(&r->refs, n);
+	atomic_set(&r->refs, n);
 }
 
 static inline unsigned int refcount_read(const refcount_t *r)
--- a/tools/testing/vma/linux/atomic.h~mm-make-vma-cache-slab_typesafe_by_rcu-fix
+++ a/tools/testing/vma/linux/atomic.h
@@ -7,7 +7,6 @@
 #define atomic_inc(x) uatomic_inc(x)
 #define atomic_read(x) uatomic_read(x)
 #define atomic_set(x, y) uatomic_set(x, y)
-#define atomic_set_release(x, y) uatomic_set(x, y)
 #define U8_MAX UCHAR_MAX
 
 #ifndef atomic_cmpxchg_relaxed
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
mm-make-vma-cache-slab_typesafe_by_rcu-fix.patch
docs-mm-document-latest-changes-to-vm_lock.patch

