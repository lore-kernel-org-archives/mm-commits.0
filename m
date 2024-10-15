Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929451B0F0D;
	Tue, 15 Oct 2024 22:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033189; cv=none; b=euI1TxKVHC/VcULSWKy4EUxllTQDGSVGh1FShpe8RxmDTBedhtGxdSvQ8iXqlULMfHDy+3CW6/gXjHHBgXVk6qyVjsLn1Ficr6pmjNU5jMT9fMpkBGEz5lJ53w5OKCyKmLbSc1nVqt6w+FqPToRCpDfQCgtCjxCZ7qenNNoK4pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033189; c=relaxed/simple;
	bh=aWrAW6XA7gkLdQOfRr3T9asp3a+HqzNI+CTDB8yhGYQ=;
	h=Date:To:From:Subject:Message-Id; b=leX+q1mca1BP3J3kjAcvhuXVsQlMg2rZ7kViyvT3XEy2P1Rk7D5fHN1oh7c5f+8Chr9z+LWK1AKQfn/LTvvfD7Y9R2r/Qin+dvdl1v2UokJG+t9avP5TOlxoyHMzwLmbbfSieEugc952LxhNyp07S+G1gz8RPzmQC4jISMtBg3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0ifoouVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0ifoouVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8888C4CEC6;
	Tue, 15 Oct 2024 22:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729033189;
	bh=aWrAW6XA7gkLdQOfRr3T9asp3a+HqzNI+CTDB8yhGYQ=;
	h=Date:To:From:Subject:From;
	b=0ifoouVxt22vzdFdvgWo1evkjiwp7YBbRlkZ0VPaYrqKvyVstQP4c0MXG8a6Ak6tF
	 e9hHRnQwipBFRuKf+i8tAmdMpJSFP4YqXq9j5mh3g3dhJ9NBemupTax2Qc0iLT6pZ/
	 RsO4Q0DONgS5PHBeDzobOq/52BVzha5cyMq1coxQ=
Date: Tue, 15 Oct 2024 15:59:48 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,torvalds@linuxfoundation.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch added to mm-hotfixes-unstable branch
Message-Id: <20241015225948.E8888C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fork: do not invoke uffd on fork if error occurs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-do-not-invoke-uffd-on-fork-if-error-occurs.patch

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
Subject: fork: do not invoke uffd on fork if error occurs
Date: Tue, 15 Oct 2024 18:56:05 +0100

Patch series "fork: do not expose incomplete mm on fork".

During fork we may place the virtual memory address space into an
inconsistent state before the fork operation is complete.

In addition, we may encounter an error during the fork operation that
indicates that the virtual memory address space is invalidated.

As a result, we should not be exposing it in any way to external machinery
that might interact with the mm or VMAs, machinery that is not designed to
deal with incomplete state.

We specifically update the fork logic to defer khugepaged and ksm to the
end of the operation and only to be invoked if no error arose, and
disallow uffd from observing fork events should an error have occurred.


This patch (of 2):

Currently on fork we expose the virtual address space of a process to
userland unconditionally if uffd is registered in VMAs, regardless of
whether an error arose in the fork.

This is performed in dup_userfaultfd_complete() which is invoked
unconditionally, and performs two duties - invoking registered handlers
for the UFFD_EVENT_FORK event via dup_fctx(), and clearing down
userfaultfd_fork_ctx objects established in dup_userfaultfd().

This is problematic, because the virtual address space may not yet be
correctly initialised if an error arose.

The change in commit d24062914837 ("fork: use __mt_dup() to duplicate
maple tree in dup_mmap()") makes this more pertinent as we may be in a
state where entries in the maple tree are not yet consistent.

We address this by, on fork error, ensuring that we roll back state that
we would otherwise expect to clean up through the event being handled by
userland and perform the memory freeing duty otherwise performed by
dup_userfaultfd_complete().

We do this by implementing a new function, dup_userfaultfd_fail(), which
performs the same loop, only decrementing reference counts.

Note that we perform mmgrab() on the parent and child mm's, however
userfaultfd_ctx_put() will mmdrop() this once the reference count drops to
zero, so we will avoid memory leaks correctly here.

Link: https://lkml.kernel.org/r/cover.1729014377.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/d3691d58bb58712b6fb3df2be441d175bd3cdf07.1729014377.git.lorenzo.stoakes@oracle.com
Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   28 ++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h |    5 +++++
 kernel/fork.c                 |    5 ++++-
 3 files changed, 37 insertions(+), 1 deletion(-)

--- a/fs/userfaultfd.c~fork-do-not-invoke-uffd-on-fork-if-error-occurs
+++ a/fs/userfaultfd.c
@@ -692,6 +692,34 @@ void dup_userfaultfd_complete(struct lis
 	}
 }
 
+void dup_userfaultfd_fail(struct list_head *fcs)
+{
+	struct userfaultfd_fork_ctx *fctx, *n;
+
+	/*
+	 * An error has occurred on fork, we will tear memory down, but have
+	 * allocated memory for fctx's and raised reference counts for both the
+	 * original and child contexts (and on the mm for each as a result).
+	 *
+	 * These would ordinarily be taken care of by a user handling the event,
+	 * but we are no longer doing so, so manually clean up here.
+	 *
+	 * mm tear down will take care of cleaning up VMA contexts.
+	 */
+	list_for_each_entry_safe(fctx, n, fcs, list) {
+		struct userfaultfd_ctx *octx = fctx->orig;
+		struct userfaultfd_ctx *ctx = fctx->new;
+
+		atomic_dec(&octx->mmap_changing);
+		VM_BUG_ON(atomic_read(&octx->mmap_changing) < 0);
+		userfaultfd_ctx_put(octx);
+		userfaultfd_ctx_put(ctx);
+
+		list_del(&fctx->list);
+		kfree(fctx);
+	}
+}
+
 void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 			     struct vm_userfaultfd_ctx *vm_ctx)
 {
--- a/include/linux/userfaultfd_k.h~fork-do-not-invoke-uffd-on-fork-if-error-occurs
+++ a/include/linux/userfaultfd_k.h
@@ -249,6 +249,7 @@ static inline bool vma_can_userfault(str
 
 extern int dup_userfaultfd(struct vm_area_struct *, struct list_head *);
 extern void dup_userfaultfd_complete(struct list_head *);
+void dup_userfaultfd_fail(struct list_head *);
 
 extern void mremap_userfaultfd_prep(struct vm_area_struct *,
 				    struct vm_userfaultfd_ctx *);
@@ -351,6 +352,10 @@ static inline void dup_userfaultfd_compl
 {
 }
 
+static inline void dup_userfaultfd_fail(struct list_head *l)
+{
+}
+
 static inline void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 					   struct vm_userfaultfd_ctx *ctx)
 {
--- a/kernel/fork.c~fork-do-not-invoke-uffd-on-fork-if-error-occurs
+++ a/kernel/fork.c
@@ -775,7 +775,10 @@ out:
 	mmap_write_unlock(mm);
 	flush_tlb_mm(oldmm);
 	mmap_write_unlock(oldmm);
-	dup_userfaultfd_complete(&uf);
+	if (!retval)
+		dup_userfaultfd_complete(&uf);
+	else
+		dup_userfaultfd_fail(&uf);
 fail_uprobe_end:
 	uprobe_end_dup_mmap();
 	return retval;
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

