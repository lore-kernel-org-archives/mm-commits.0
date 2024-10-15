Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279FF1D63DE;
	Tue, 15 Oct 2024 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033192; cv=none; b=duZkU3v8O8jKGuUDyCjQaLfpL4vouSkjUtvXmyVQD/keQE6CYt3QGvqvuwT+9xMDHcTt9ULaxsE/p4dSSsFcEVR2Dj7X5sB3oOAE3Ani8xGPEYqlncUVh7ZC4A/4KrKY91LrM8RY2pk86lIX2ujyDJDNFegPpt8Sf35SMJUAr/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033192; c=relaxed/simple;
	bh=DSGM5Ue8l7Ao91BLjRnepZS5zD1GSoDK0biQ5pFmAH8=;
	h=Date:To:From:Subject:Message-Id; b=siPXk16ep5+JBadVEKgCOzHUDQPSv6yFZaG+OUhE0Iruz9he5e1t/wtGUnfqJuY9Ydo9McMyLbzCwc7fyNQjIk2HUWcTk0UdFaIdPL+R5Z2y/KFdlqzi9TlFwq43j9jEozpN5jcMOfyCPuX6S5ijvrLRiVaw5TYsqDYEw083WPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2JCollg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2JCollg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEBDC4CEC6;
	Tue, 15 Oct 2024 22:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033192;
	bh=DSGM5Ue8l7Ao91BLjRnepZS5zD1GSoDK0biQ5pFmAH8=;
	h=Date:To:From:Subject:From;
	b=2JCollg6aduq7xHlwGuUPLAoLYBJPOslnGXrm81IP1ryQg1trUsoCLjrWIW4OgAaE
	 epB6YA3zKaWqS/WNbD/Ke1OniYaURLaBaEOdpERXlMP720chYFMo4vTCK3a1Xy9bJv
	 ECN1epTEeggssXzo1CMvj0Mn4Poecp93pyFQ6ezs=
Date: Tue, 15 Oct 2024 15:59:51 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,torvalds@linuxfoundation.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch added to mm-hotfixes-unstable branch
Message-Id: <20241015225951.DCEBDC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: only invoke khugepaged, ksm hooks if no error
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fork: only invoke khugepaged, ksm hooks if no error
Date: Tue, 15 Oct 2024 18:56:06 +0100

There is no reason to invoke these hooks early against an mm that is in an
incomplete state.

The change in commit d24062914837 ("fork: use __mt_dup() to duplicate
maple tree in dup_mmap()") makes this more pertinent as we may be in a
state where entries in the maple tree are not yet consistent.

Their placement early in dup_mmap() only appears to have been meaningful
for early error checking, and since functionally it'd require a very small
allocation to fail (in practice 'too small to fail') that'd only occur in
the most dire circumstances, meaning the fork would fail or be OOM'd in
any case.

Since both khugepaged and KSM tracking are there to provide optimisations
to memory performance rather than critical functionality, it doesn't
really matter all that much if, under such dire memory pressure, we fail
to register an mm with these.

As a result, we follow the example of commit d2081b2bf819 ("mm:
khugepaged: make khugepaged_enter() void function") and make ksm_fork() a
void function also.

We only expose the mm to these functions once we are done with them and
only if no error occurred in the fork operation.

Link: https://lkml.kernel.org/r/e0cb8b840c9d1d5a6e84d4f8eff5f3f2022aa10c.1729014377.git.lorenzo.stoakes@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   10 ++++------
 kernel/fork.c       |    7 ++-----
 2 files changed, 6 insertions(+), 11 deletions(-)

--- a/include/linux/ksm.h~fork-only-invoke-khugepaged-ksm-hooks-if-no-error
+++ a/include/linux/ksm.h
@@ -54,12 +54,11 @@ static inline long mm_ksm_zero_pages(str
 	return atomic_long_read(&mm->ksm_zero_pages);
 }
 
-static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
+	/* Adding mm to ksm is best effort on fork. */
 	if (test_bit(MMF_VM_MERGEABLE, &oldmm->flags))
-		return __ksm_enter(mm);
-
-	return 0;
+		__ksm_enter(mm);
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
@@ -107,9 +106,8 @@ static inline int ksm_disable(struct mm_
 	return 0;
 }
 
-static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
+static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	return 0;
 }
 
 static inline int ksm_execve(struct mm_struct *mm)
--- a/kernel/fork.c~fork-only-invoke-khugepaged-ksm-hooks-if-no-error
+++ a/kernel/fork.c
@@ -653,11 +653,6 @@ static __latent_entropy int dup_mmap(str
 	mm->exec_vm = oldmm->exec_vm;
 	mm->stack_vm = oldmm->stack_vm;
 
-	retval = ksm_fork(mm, oldmm);
-	if (retval)
-		goto out;
-	khugepaged_fork(mm, oldmm);
-
 	/* Use __mt_dup() to efficiently build an identical maple tree. */
 	retval = __mt_dup(&oldmm->mm_mt, &mm->mm_mt, GFP_KERNEL);
 	if (unlikely(retval))
@@ -760,6 +755,8 @@ loop_out:
 	vma_iter_free(&vmi);
 	if (!retval) {
 		mt_set_in_rcu(vmi.mas.tree);
+		ksm_fork(mm, oldmm);
+		khugepaged_fork(mm, oldmm);
 	} else if (mpnt) {
 		/*
 		 * The entire maple tree has already been duplicated. If the
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mmap-correct-error-handling-in-mmap_region.patch
maple_tree-correct-tree-corruption-on-spanning-store.patch
maple_tree-add-regression-test-for-spanning-store-bug.patch
maintainers-add-memory-mapping-vma-co-maintainers.patch
fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch
fork-only-invoke-khugepaged-ksm-hooks-if-no-error.patch
selftests-mm-add-pkey_sighandler_xx-hugetlb_dio-to-gitignore.patch
mm-refactor-mm_access-to-not-return-null.patch
mm-refactor-mm_access-to-not-return-null-fix.patch
mm-madvise-unrestrict-process_madvise-for-current-process.patch
maple_tree-do-not-hash-pointers-on-dump-in-debug-mode.patch

