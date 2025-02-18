Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6435B1A5B8E
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 05:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739857760; cv=none; b=aCbCJGXDVQQ+SKzhhtw4qWsPyZ79O2pGPFccXK0nAx1LDSHgHRtrvKyJIa4QzSHIk3loLo3harOeuDg4gw0zNGbzIQL450L/HM3N5hOyFdbG/A14wwreumWowznCJC9RbtaSiomYVmON74Bil75MrAyIOmtAXvdkYv/v0VUMfUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739857760; c=relaxed/simple;
	bh=39k+XUWeKPsjevbForo3DKWqcZmSYoKr2bYgkkARwnk=;
	h=Date:To:From:Subject:Message-Id; b=YQYqCObeDKA1V1/QC7ordUbL9eUJlqeuX4wFWYdp3xPESEfLcR3bHb0ow4ZA7oqQEARD1fILCAbjGdSSIRLqXlydnYdk1reber8qleVnc6oS8Rixa0otJhr9KvIs2L57P1oo2VMlo+7eRW5dj7CmyGGTvVss1Q0k+EnEJhpumZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qs3XQsjh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qs3XQsjh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1893C4CEE2;
	Tue, 18 Feb 2025 05:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739857758;
	bh=39k+XUWeKPsjevbForo3DKWqcZmSYoKr2bYgkkARwnk=;
	h=Date:To:From:Subject:From;
	b=qs3XQsjhysDFJCISquQopfFGxa0V8nySRP7bfDSkyFzahKug6681X78rhCPT00Ko7
	 xxWdGNdT7xp27bqMIM1PtjRLQ+OcLJJpozicNNsEUNpG7raj0a2YOiz6YjCaUEPvAC
	 b70oVzM4ftt2AfbV5Ua7QhjcIad+8dA3e1zkefHM=
Date: Mon, 17 Feb 2025 21:49:18 -0800
To: mm-commits@vger.kernel.org,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,lkp@intel.com,kent.overstreet@linux.dev,justinstitt@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [alternative-merged] alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch removed from -mm tree
Message-Id: <20250218054918.C1893C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: work around clang-14 build issue with __builtin_object_size()
has been removed from the -mm tree.  Its filename was
     alloc_tag-work-around-clang-14-issue-with-__builtin_object_size.patch

This patch was dropped because an alternative patch was or shall be merged

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: work around clang-14 build issue with __builtin_object_size()
Date: Sat, 1 Feb 2025 12:05:03 -0800

Additional condition in the allocation hooks causes Clang version 14
(tested on 14.0.6) to treat the allocated object size as unknown at
compile-time (__builtin_object_size(obj, 1) returns -1) even though both
branches of that condition yield the same result.  Other versions of Clang
(tested with 13.0.1, 15.0.7, 16.0.6 and 17.0.6) compile the same code
without issues.  Add build-time Clang version check which removes this
condition and effectively restores the unconditional tag store/restore
flow when compiled with clang-14.

Link: https://lkml.kernel.org/r/20250201200503.2532357-1-surenb@google.com
Fixes: 07438779313c ("alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501310832.kiAeOt2z-lkp@intel.com/
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/include/linux/alloc_tag.h~alloc_tag-work-around-clang-14-issue-with-__builtin_object_size
+++ a/include/linux/alloc_tag.h
@@ -222,10 +222,23 @@ static inline void alloc_tag_sub(union c
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/* See https://lore.kernel.org/all/202501310832.kiAeOt2z-lkp@intel.com/ */
+#if defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION >= 140000 && CONFIG_CLANG_VERSION < 150000
+static inline bool store_current_tag(void)
+{
+	return true;
+}
+#else
+static inline bool store_current_tag(void)
+{
+	return mem_alloc_profiling_enabled();
+}
+#endif
+
 #define alloc_hooks_tag(_tag, _do_alloc)				\
 ({									\
 	typeof(_do_alloc) _res;						\
-	if (mem_alloc_profiling_enabled()) {				\
+	if (store_current_tag()) {					\
 		struct alloc_tag * __maybe_unused _old;			\
 		_old = alloc_tag_save(_tag);				\
 		_res = _do_alloc;					\
_

Patches currently in -mm which might be from surenb@google.com are

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

