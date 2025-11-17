Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC19313544
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 17:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763399582; cv=none; b=S9u21KotBa09f1KkXSjNl58lvrK8Q+0lMHisgMOle+yB3iWg/GD0l26IKNawOFDf7XD5JIFWJtfm+TrkBuN9bxphUHW6PbMwVenoTxIZu38+JpnuAYxtjK+2Qvkr6gJyl9yNXv3kI7b423Y8gZMywhR6RXt4WXFSoX+LYMz+qtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763399582; c=relaxed/simple;
	bh=axxCwj3+EHKHSd7fXLRRbJu7vWLmwIVpFdNLEWT76BU=;
	h=Date:To:From:Subject:Message-Id; b=AqkoQjwZJKpmwLwFAN9Xw/t6RAJH4Yne+jIRLN2Bwvrn4Qfe5trSQ7PUtmth+GACD25Wnhp/cFi22SO/Y5ulKQln9KtnRCCkfmEoR9G9J/bjpiT0hfM8fXo2l18aXws31AI7uEeA8w2F2sbrcofXeK9mPZpKLy42/qaQRkvDMIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XwbMh+5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XwbMh+5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10432C19422;
	Mon, 17 Nov 2025 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763399581;
	bh=axxCwj3+EHKHSd7fXLRRbJu7vWLmwIVpFdNLEWT76BU=;
	h=Date:To:From:Subject:From;
	b=XwbMh+5IAGfvy2WLlgvKZihK/JWbd6oBiirS74/u4eT93gGCL3tkfYEupGq1ccR1K
	 QZ5K5E2vzsaX6EAyUoJa6ijy7xizEkbkevEkyPTcc0dmIW8y9oCAY8Ds6Xd0LpNc3R
	 kbve+OLOoLh1ondDSJCWT2FZR7KXAddXv01YiSKY=
Date: Mon, 17 Nov 2025 09:13:00 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,pfalcato@suse.de,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,jannh@google.com,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,avagin@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-implement-sticky-vma-flags-fix.patch added to mm-unstable branch
Message-Id: <20251117171301.10432C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-implement-sticky-vma-flags-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-implement-sticky-vma-flags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-implement-sticky-vma-flags-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm-implement-sticky-vma-flags-fix
Date: Mon, 17 Nov 2025 13:24:37 +0000

account for sticky flags

Link: https://lkml.kernel.org/r/13ae542f-5c47-4511-b0ad-6d1e9dcbdc9d@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c  |    3 +++
 mm/mlock.c    |    3 +++
 mm/mprotect.c |    3 +++
 3 files changed, 9 insertions(+)

--- a/mm/madvise.c~mm-implement-sticky-vma-flags-fix
+++ a/mm/madvise.c
@@ -172,6 +172,9 @@ static int madvise_update_vma(vm_flags_t
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
+	/* Account for sticky flags. */
+	new_flags |= vma->vm_flags;
+
 	madv_behavior->vma = vma;
 
 	/* vm_flags is protected by the mmap_lock held in write mode. */
--- a/mm/mlock.c~mm-implement-sticky-vma-flags-fix
+++ a/mm/mlock.c
@@ -484,6 +484,9 @@ static int mlock_fixup(struct vma_iterat
 		goto out;
 	}
 
+	/* Account for sticky flags. */
+	newflags |= vma->vm_flags;
+
 	/*
 	 * Keep track of amount of locked VM.
 	 */
--- a/mm/mprotect.c~mm-implement-sticky-vma-flags-fix
+++ a/mm/mprotect.c
@@ -762,6 +762,9 @@ mprotect_fixup(struct vma_iterator *vmi,
 		goto fail;
 	}
 
+	/* Account for sticky flags. */
+	newflags |= vma->vm_flags;
+
 	*pprev = vma;
 
 	/*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such-fix.patch
mm-implement-sticky-vma-flags.patch
mm-implement-sticky-vma-flags-fix.patch
mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
mm-set-the-vm_maybe_guard-flag-on-guard-region-install-fix.patch
tools-testing-vma-add-vma-sticky-userland-tests.patch
tools-testing-selftests-mm-add-madv_collapse-test-case.patch
tools-testing-selftests-mm-add-smaps-visibility-guard-region-test.patch
mm-correctly-handle-uffd-pte-markers.patch
mm-introduce-leaf-entry-type-and-use-to-simplify-leaf-entry-logic.patch
mm-avoid-unnecessary-uses-of-is_swap_pte.patch
mm-eliminate-is_swap_pte-when-softleaf_from_pte-suffices.patch
mm-use-leaf-entries-in-debug-pgtable-remove-is_swap_pte.patch
fs-proc-task_mmu-refactor-pagemap_pmd_range.patch
mm-avoid-unnecessary-use-of-is_swap_pmd.patch
mm-huge_memory-refactor-copy_huge_pmd-non-present-logic.patch
mm-huge_memory-refactor-change_huge_pmd-non-present-logic.patch
mm-replace-pmd_to_swp_entry-with-softleaf_from_pmd.patch
mm-introduce-pmd_is_huge-and-use-where-appropriate.patch
mm-remove-remaining-is_swap_pmd-users-and-is_swap_pmd.patch
mm-remove-non_swap_entry-and-use-softleaf-helpers-instead.patch
mm-remove-is_hugetlb_entry_.patch
mm-eliminate-further-swapops-predicates.patch
mm-replace-remaining-pte_to_swp_entry-with-softleaf_from_pte.patch
mm-rename-walk_page_range_mm.patch
mm-madvise-allow-guard-page-install-remove-under-vma-lock.patch
mm-propagate-vm_softdirty-on-merge.patch
testing-selftests-mm-add-soft-dirty-merge-self-test.patch
mm-declare-vma-flags-by-bit.patch
mm-declare-vma-flags-by-bit-fix.patch
mm-declare-vma-flags-by-bit-fix-2.patch
mm-simplify-and-rename-mm-flags-function-for-clarity.patch
tools-testing-vma-eliminate-dependency-on-vma-__vm_flags.patch
mm-introduce-vma-flags-bitmap-type.patch

