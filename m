Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6131028C2CB
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 21:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752183984; cv=none; b=eEmHa/D/UJTPScZ82f69GPyYYpSGkUTMZU6ojwpLfmSjbqqeTDW+J1NBJMJ1GEg2rOS4QoUnkbLsZVFmpTkGFbf0rG7e2P29rUH5qZGk+HWg2Ft9lS1Px01/TNkeQaD7SbqEmL4XDVq3y7tZUpB0Rf4OUMi0UwxFU/U8h1itZgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752183984; c=relaxed/simple;
	bh=EbH+uCcMtJjJTu6yv+DHYYWLNJd1axzF54mlvAR34PU=;
	h=Date:To:From:Subject:Message-Id; b=ptEJ7WscniBdDLIhvx06o4uAA+k8wznmYkFIHOs93W4P0NJqeGfggrLXAS+epBE182xvghFjt0MtAjHCrcHmvZwtpLLGyO4psX2N2F+N/942vZGaF5+2KUhZzE7h1MsehZNs9mJxK2ud0y2u0F1HvRabmIPSN9bPfzFs/Jb4zEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QoLMc7zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QoLMc7zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2004C4CEE3;
	Thu, 10 Jul 2025 21:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752183983;
	bh=EbH+uCcMtJjJTu6yv+DHYYWLNJd1axzF54mlvAR34PU=;
	h=Date:To:From:Subject:From;
	b=QoLMc7zf6nlAnI3FJSwFefd/ALRTnHKLGR/NI9V79ISv8MBYqy+r+0O000A1TuTKs
	 J/rEQCWz73pXX5JlYCYzH7xrO1BTYsB3Gbhc8ShDqVMMw6uDiR0vZLm6ll6E9Bcnis
	 F0DIA/8wWO0s31CburL7HYucF1dSHWAKE51C7o6A=
Date: Thu, 10 Jul 2025 14:46:23 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch added to mm-new branch
Message-Id: <20250710214623.C2004C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: use an explicit uffd failure path for mremap
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/mremap: use an explicit uffd failure path for mremap
Date: Thu, 10 Jul 2025 16:50:29 +0100

Right now it appears that the code is relying upon the returned destination
address having bits outside PAGE_MASK to indicate whether an error value is
specified, and decrementing the increased refcount on the uffd ctx if so.

This is not a safe means of determining an error value, so instead, be
specific. It makes far more sense to do so in a dedicated error path, so
add mremap_userfaultfd_fail() for this purpose and use this when an error
arises.

A vm_userfaultfd_ctx is not established until we are at the point where
mremap_userfaultfd_prep() is invoked in copy_vma_and_data(), so this is a
no-op until this happens.

That is - uffd remap notification only occurs if the VMA is actually moved
- at which point a UFFD_EVENT_REMAP event is raised.

No errors can occur after this point currently, though it's certainly not
guaranteed this will always remain the case, and we mustn't rely on this.

However, the reason for needing to handle this case is that, when an error
arises on a VMA move at the point of adjusting page tables, we revert this
operation, and propagate the error.

At this point, it is not correct to raise a uffd remap event, and we must
handle it.

This refactoring makes it abundantly clear what we are doing.

We assume vrm->new_addr is always valid, which a prior change made the case
even for mremap() invocations which don't move the VMA, however given no
uffd context would be set up in this case it's immaterial to this change
anyway.

No functional change intended.

Link: https://lkml.kernel.org/r/587d14070be9dbd935616749768b0c31f969f838.1752162066.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   15 ++++++++++-----
 include/linux/userfaultfd_k.h |    5 +++++
 mm/mremap.c                   |   16 ++++++++++++----
 3 files changed, 27 insertions(+), 9 deletions(-)

--- a/fs/userfaultfd.c~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap
+++ a/fs/userfaultfd.c
@@ -750,11 +750,6 @@ void mremap_userfaultfd_complete(struct
 	if (!ctx)
 		return;
 
-	if (to & ~PAGE_MASK) {
-		userfaultfd_ctx_put(ctx);
-		return;
-	}
-
 	msg_init(&ewq.msg);
 
 	ewq.msg.event = UFFD_EVENT_REMAP;
@@ -765,6 +760,16 @@ void mremap_userfaultfd_complete(struct
 	userfaultfd_event_wait_completion(ctx, &ewq);
 }
 
+void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
+{
+	struct userfaultfd_ctx *ctx = vm_ctx->ctx;
+
+	if (!ctx)
+		return;
+
+	userfaultfd_ctx_put(ctx);
+}
+
 bool userfaultfd_remove(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end)
 {
--- a/include/linux/userfaultfd_k.h~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap
+++ a/include/linux/userfaultfd_k.h
@@ -259,6 +259,7 @@ extern void mremap_userfaultfd_prep(stru
 extern void mremap_userfaultfd_complete(struct vm_userfaultfd_ctx *,
 					unsigned long from, unsigned long to,
 					unsigned long len);
+void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *);
 
 extern bool userfaultfd_remove(struct vm_area_struct *vma,
 			       unsigned long start,
@@ -371,6 +372,10 @@ static inline void mremap_userfaultfd_co
 {
 }
 
+static inline void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *ctx)
+{
+}
+
 static inline bool userfaultfd_remove(struct vm_area_struct *vma,
 				      unsigned long start,
 				      unsigned long end)
--- a/mm/mremap.c~mm-mremap-use-an-explicit-uffd-failure-path-for-mremap
+++ a/mm/mremap.c
@@ -1731,12 +1731,17 @@ static int check_prep_vma(struct vma_rem
 	return 0;
 }
 
-static void notify_uffd(struct vma_remap_struct *vrm, unsigned long to)
+static void notify_uffd(struct vma_remap_struct *vrm, bool failed)
 {
 	struct mm_struct *mm = current->mm;
 
+	/* Regardless of success/failure, we always notify of any unmaps. */
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap_early);
-	mremap_userfaultfd_complete(vrm->uf, vrm->addr, to, vrm->old_len);
+	if (failed)
+		mremap_userfaultfd_fail(vrm->uf);
+	else
+		mremap_userfaultfd_complete(vrm->uf, vrm->addr,
+			vrm->new_addr, vrm->old_len);
 	userfaultfd_unmap_complete(mm, vrm->uf_unmap);
 }
 
@@ -1744,6 +1749,7 @@ static unsigned long do_mremap(struct vm
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long res;
+	bool failed;
 
 	vrm->old_len = PAGE_ALIGN(vrm->old_len);
 	vrm->new_len = PAGE_ALIGN(vrm->new_len);
@@ -1765,13 +1771,15 @@ static unsigned long do_mremap(struct vm
 	res = vrm_implies_new_addr(vrm) ? mremap_to(vrm) : mremap_at(vrm);
 
 out:
+	failed = IS_ERR_VALUE(res);
+
 	if (vrm->mmap_locked)
 		mmap_write_unlock(mm);
 
-	if (!IS_ERR_VALUE(res) && vrm->mlocked && vrm->new_len > vrm->old_len)
+	if (!failed && vrm->mlocked && vrm->new_len > vrm->old_len)
 		mm_populate(vrm->new_addr + vrm->old_len, vrm->delta);
 
-	notify_uffd(vrm, res);
+	notify_uffd(vrm, failed);
 	return res;
 }
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma-fix.patch
tools-testing-selftests-add-mremap-unfaulted-faulted-test-cases.patch
mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch

