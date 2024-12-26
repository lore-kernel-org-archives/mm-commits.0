Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6875176ADE;
	Thu, 26 Dec 2024 23:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735254170; cv=none; b=Pu/CCniKoFGOFePbtAxeMBby49ORX9E/CGzWU8U6Knqke3MosrtJQZZ6liJr83QnMI6yYbQLv1Uh6papZqbKSoncJ43IwNWnAawIDtfuAz8KIaB96RfUsVsqPPS/g8fQRWEt1x//LC4Htb3Ml5UDW8hRRz7yxkMk9NtQfxQkDH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735254170; c=relaxed/simple;
	bh=ZHHujwMgvmWZpSVoHPn9u0V6Z6LYoAe8/J64unar7Vg=;
	h=Date:To:From:Subject:Message-Id; b=bxpEP07Eq17fU4PWFQTF2zcNad6n7EsZggDX97Gi3DSindpvA+joRyglt+r9z+DZgaIHtMqPVGu1j7NuDpL1GNTuBgk4k2xRAALjHCyM1HdoMAwl7atOzCgq6n9dgm9b8hXQTmbpFoE6yXIrdeSr8FxKgR/oJEq/YMiCP6u4g00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hfyblgN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hfyblgN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15775C4CED1;
	Thu, 26 Dec 2024 23:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735254170;
	bh=ZHHujwMgvmWZpSVoHPn9u0V6Z6LYoAe8/J64unar7Vg=;
	h=Date:To:From:Subject:From;
	b=hfyblgN4xf0xzqMiVFM1HD3m9ItP0YICKpsdZ/QvM6veKRUOB7TBJUo38Y+cOfU+L
	 Dk6F0IbHA631xUJf7X1T/guxw8C4+kknFBAMZQfjgOinTv9LAujF2oVbpJIiv+0zYC
	 mwttXYXB2AkeEp2RcPL5b/INk2AZLawtlf928Tzk=
Date: Thu, 26 Dec 2024 15:02:49 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,stable@vger.kernel.org,quic_zhenhuah@quicinc.com,kent.overstreet@linux.dev,00107082@163.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch added to mm-hotfixes-unstable branch
Message-Id: <20241226230250.15775C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: alloc_tag: avoid current->alloc_tag manipulations when profiling is disabled
Date: Thu, 26 Dec 2024 13:16:38 -0800

When memory allocation profiling is disabled there is no need to update
current->alloc_tag and these manipulations add unnecessary overhead.  Fix
the overhead by skipping these extra updates.

Link: https://lkml.kernel.org/r/20241226211639.1357704-1-surenb@google.com
Fixes: b951aaff5035 ("mm: enable page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Wang <00107082@163.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/alloc_tag.h |   11 ++++++++---
 lib/alloc_tag.c           |    2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/alloc_tag.h~alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled
+++ a/include/linux/alloc_tag.h
@@ -224,9 +224,14 @@ static inline void alloc_tag_sub(union c
 
 #define alloc_hooks_tag(_tag, _do_alloc)				\
 ({									\
-	struct alloc_tag * __maybe_unused _old = alloc_tag_save(_tag);	\
-	typeof(_do_alloc) _res = _do_alloc;				\
-	alloc_tag_restore(_tag, _old);					\
+	typeof(_do_alloc) _res;						\
+	if (mem_alloc_profiling_enabled()) {				\
+		struct alloc_tag * __maybe_unused _old;			\
+		_old = alloc_tag_save(_tag);				\
+		_res = _do_alloc;					\
+		alloc_tag_restore(_tag, _old);				\
+	} else								\
+		_res = _do_alloc;					\
 	_res;								\
 })
 
--- a/lib/alloc_tag.c~alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled
+++ a/lib/alloc_tag.c
@@ -29,6 +29,8 @@ EXPORT_SYMBOL(_shared_alloc_tag);
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
 			mem_alloc_profiling_key);
+EXPORT_SYMBOL(mem_alloc_profiling_key);
+
 DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
 
 struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
_

Patches currently in -mm which might be from surenb@google.com are

alloc_tag-avoid-current-alloc_tag-manipulations-when-profiling-is-disabled.patch
alloc_tag-skip-pgalloc_tag_swap-if-profiling-is-disabled.patch
seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

