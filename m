Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999F418A93E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jul 2024 22:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722290895; cv=none; b=JlDgrbIjSjjH32icPN8xIlE++jCyQG1dLPqN4s4e6hOty/PiVwiIWEtZEhgvrxwU8/1Kog0JfHzNowHB1Xi7DNQfOaCWN+gzrq3E2Y2+GCtotaRTDuUyW2iAYQ/eM7zPWv1i9Fqh58dQMOyQPO4CNVXJfc2tvMxeN7nE7UcTDCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722290895; c=relaxed/simple;
	bh=wdBRYjBnafaLKi4LyhWmx7MSApntLVx3LVdqqqxz2rI=;
	h=Date:To:From:Subject:Message-Id; b=B/8yO5b/+N+KQXZMTucccBQ9/26JCe3UKg1DyRUFAN4AZc7OYYw4G7rIEOJnWwxkwHg16cOFzU39fwsQs6VWl3cbPEeNTQ+zgtRl39nsqwZAJw3HChJDyrvCM1bbx2aVipG61Fua2WRoYHPeF8Oc91dp7b81sSZdDQs4Fnxf1Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=17OHQNsw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="17OHQNsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221A4C32786;
	Mon, 29 Jul 2024 22:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722290895;
	bh=wdBRYjBnafaLKi4LyhWmx7MSApntLVx3LVdqqqxz2rI=;
	h=Date:To:From:Subject:From;
	b=17OHQNswrnSGd799qa1zeXoa0kUpsP/sF5MA8sSk4AkRmWXkoJ7F8nxkiR9XCt1Jb
	 fPAAuaiX3DN5Fm88x1FeJRl2irhMv2HVM59wMSHlr48LuBNGut+a8rnsiuEeR0iqdi
	 2p3t6O/IfHIvuTNsnJNYX6Ar5n9fAjzitDWK7ILY=
Date: Mon, 29 Jul 2024 15:08:14 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,surenb@google.com,sj@kernel.org,shuah@kernel.org,rmoar@google.com,Liam.Howlett@oracle.com,kees@kernel.org,jack@suse.cz,ebiederm@xmission.com,davidgow@google.com,brendanhiggins@google.com,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch added to mm-unstable branch
Message-Id: <20240729220815.221A4C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: move core VMA manipulation logic to mm/userfaultfd.c
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch

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
Subject: userfaultfd: move core VMA manipulation logic to mm/userfaultfd.c
Date: Mon, 29 Jul 2024 12:50:35 +0100

Patch series "Make core VMA operations internal and testable", v4.

There are a number of "core" VMA manipulation functions implemented in
mm/mmap.c, notably those concerning VMA merging, splitting, modifying,
expanding and shrinking, which logically don't belong there.

More importantly this functionality represents an internal implementation
detail of memory management and should not be exposed outside of mm/
itself.

This patch series isolates core VMA manipulation functionality into its
own file, mm/vma.c, and provides an API to the rest of the mm code in
mm/vma.h.

Importantly, it also carefully implements mm/vma_internal.h, which
specifies which headers need to be imported by vma.c, leading to the very
useful property that vma.c depends only on mm/vma.h and mm/vma_internal.h.

This means we can then re-implement vma_internal.h in userland, adding
shims for kernel mechanisms as required, allowing us to unit test internal
VMA functionality.

This testing is useful as opposed to an e.g.  kunit implementation as this
way we can avoid all external kernel side-effects while testing, run tests
VERY quickly, and iterate on and debug problems quickly.

Excitingly this opens the door to, in the future, recreating precise
problems observed in production in userland and very quickly debugging
problems that might otherwise be very difficult to reproduce.

This patch series takes advantage of existing shim logic and full userland
maple tree support contained in tools/testing/radix-tree/ and
tools/include/linux/, separating out shared components of the radix tree
implementation to provide this testing.

Kernel functionality is stubbed and shimmed as needed in
tools/testing/vma/ which contains a fully functional userland
vma_internal.h file and which imports mm/vma.c and mm/vma.h to be directly
tested from userland.

A simple, skeleton testing implementation is provided in
tools/testing/vma/vma.c as a proof-of-concept, asserting that simple VMA
merge, modify (testing split), expand and shrink functionality work
correctly.


This patch (of 4):

This patch forms part of a patch series intending to separate out VMA
logic and render it testable from userspace, which requires that core
manipulation functions be exposed in an mm/-internal header file.

In order to do this, we must abstract APIs we wish to test, in this
instance functions which ultimately invoke vma_modify().

This patch therefore moves all logic which ultimately invokes vma_modify()
to mm/userfaultfd.c, trying to transfer code at a functional granularity
where possible.

Link: https://lkml.kernel.org/r/cover.1722251717.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/50c3ed995fd81c45876c86304c8a00bf3e396cfd.1722251717.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Gow <davidgow@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rae Moar <rmoar@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |  160 ++----------------------------
 include/linux/userfaultfd_k.h |   19 +++
 mm/userfaultfd.c              |  168 ++++++++++++++++++++++++++++++++
 3 files changed, 198 insertions(+), 149 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc
+++ a/fs/userfaultfd.c
@@ -104,21 +104,6 @@ bool userfaultfd_wp_unpopulated(struct v
 	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
-static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
-				     vm_flags_t flags)
-{
-	const bool uffd_wp_changed = (vma->vm_flags ^ flags) & VM_UFFD_WP;
-
-	vm_flags_reset(vma, flags);
-	/*
-	 * For shared mappings, we want to enable writenotify while
-	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
-	 * recalculate vma->vm_page_prot whenever userfaultfd-wp changes.
-	 */
-	if ((vma->vm_flags & VM_SHARED) && uffd_wp_changed)
-		vma_set_page_prot(vma);
-}
-
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
 				     int wake_flags, void *key)
 {
@@ -615,22 +600,7 @@ static void userfaultfd_event_wait_compl
 	spin_unlock_irq(&ctx->event_wqh.lock);
 
 	if (release_new_ctx) {
-		struct vm_area_struct *vma;
-		struct mm_struct *mm = release_new_ctx->mm;
-		VMA_ITERATOR(vmi, mm, 0);
-
-		/* the various vma->vm_userfaultfd_ctx still points to it */
-		mmap_write_lock(mm);
-		for_each_vma(vmi, vma) {
-			if (vma->vm_userfaultfd_ctx.ctx == release_new_ctx) {
-				vma_start_write(vma);
-				vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-				userfaultfd_set_vm_flags(vma,
-							 vma->vm_flags & ~__VM_UFFD_FLAGS);
-			}
-		}
-		mmap_write_unlock(mm);
-
+		userfaultfd_release_new(release_new_ctx);
 		userfaultfd_ctx_put(release_new_ctx);
 	}
 
@@ -662,9 +632,7 @@ int dup_userfaultfd(struct vm_area_struc
 		return 0;
 
 	if (!(octx->features & UFFD_FEATURE_EVENT_FORK)) {
-		vma_start_write(vma);
-		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
+		userfaultfd_reset_ctx(vma);
 		return 0;
 	}
 
@@ -749,9 +717,7 @@ void mremap_userfaultfd_prep(struct vm_a
 		up_write(&ctx->map_changing_lock);
 	} else {
 		/* Drop uffd context if remap feature not enabled */
-		vma_start_write(vma);
-		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-		userfaultfd_set_vm_flags(vma, vma->vm_flags & ~__VM_UFFD_FLAGS);
+		userfaultfd_reset_ctx(vma);
 	}
 }
 
@@ -870,54 +836,14 @@ static int userfaultfd_release(struct in
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
 	struct mm_struct *mm = ctx->mm;
-	struct vm_area_struct *vma, *prev;
 	/* len == 0 means wake all */
 	struct userfaultfd_wake_range range = { .len = 0, };
-	unsigned long new_flags;
-	VMA_ITERATOR(vmi, mm, 0);
 
 	WRITE_ONCE(ctx->released, true);
 
-	if (!mmget_not_zero(mm))
-		goto wakeup;
+	userfaultfd_release_all(mm, ctx);
 
 	/*
-	 * Flush page faults out of all CPUs. NOTE: all page faults
-	 * must be retried without returning VM_FAULT_SIGBUS if
-	 * userfaultfd_ctx_get() succeeds but vma->vma_userfault_ctx
-	 * changes while handle_userfault released the mmap_lock. So
-	 * it's critical that released is set to true (above), before
-	 * taking the mmap_lock for writing.
-	 */
-	mmap_write_lock(mm);
-	prev = NULL;
-	for_each_vma(vmi, vma) {
-		cond_resched();
-		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
-		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
-		if (vma->vm_userfaultfd_ctx.ctx != ctx) {
-			prev = vma;
-			continue;
-		}
-		/* Reset ptes for the whole vma range if wr-protected */
-		if (userfaultfd_wp(vma))
-			uffd_wp_range(vma, vma->vm_start,
-				      vma->vm_end - vma->vm_start, false);
-		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		vma = vma_modify_flags_uffd(&vmi, prev, vma, vma->vm_start,
-					    vma->vm_end, new_flags,
-					    NULL_VM_UFFD_CTX);
-
-		vma_start_write(vma);
-		userfaultfd_set_vm_flags(vma, new_flags);
-		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-
-		prev = vma;
-	}
-	mmap_write_unlock(mm);
-	mmput(mm);
-wakeup:
-	/*
 	 * After no new page faults can wait on this fault_*wqh, flush
 	 * the last page faults that may have been already waiting on
 	 * the fault_*wqh.
@@ -1293,14 +1219,14 @@ static int userfaultfd_register(struct u
 				unsigned long arg)
 {
 	struct mm_struct *mm = ctx->mm;
-	struct vm_area_struct *vma, *prev, *cur;
+	struct vm_area_struct *vma, *cur;
 	int ret;
 	struct uffdio_register uffdio_register;
 	struct uffdio_register __user *user_uffdio_register;
-	unsigned long vm_flags, new_flags;
+	unsigned long vm_flags;
 	bool found;
 	bool basic_ioctls;
-	unsigned long start, end, vma_end;
+	unsigned long start, end;
 	struct vma_iterator vmi;
 	bool wp_async = userfaultfd_wp_async_ctx(ctx);
 
@@ -1428,57 +1354,8 @@ static int userfaultfd_register(struct u
 	} for_each_vma_range(vmi, cur, end);
 	BUG_ON(!found);
 
-	vma_iter_set(&vmi, start);
-	prev = vma_prev(&vmi);
-	if (vma->vm_start < start)
-		prev = vma;
-
-	ret = 0;
-	for_each_vma_range(vmi, vma, end) {
-		cond_resched();
-
-		BUG_ON(!vma_can_userfault(vma, vm_flags, wp_async));
-		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
-		       vma->vm_userfaultfd_ctx.ctx != ctx);
-		WARN_ON(!(vma->vm_flags & VM_MAYWRITE));
-
-		/*
-		 * Nothing to do: this vma is already registered into this
-		 * userfaultfd and with the right tracking mode too.
-		 */
-		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    (vma->vm_flags & vm_flags) == vm_flags)
-			goto skip;
-
-		if (vma->vm_start > start)
-			start = vma->vm_start;
-		vma_end = min(end, vma->vm_end);
-
-		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
-		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
-					    new_flags,
-					    (struct vm_userfaultfd_ctx){ctx});
-		if (IS_ERR(vma)) {
-			ret = PTR_ERR(vma);
-			break;
-		}
-
-		/*
-		 * In the vma_merge() successful mprotect-like case 8:
-		 * the next vma was merged into the current one and
-		 * the current one has not been updated yet.
-		 */
-		vma_start_write(vma);
-		userfaultfd_set_vm_flags(vma, new_flags);
-		vma->vm_userfaultfd_ctx.ctx = ctx;
-
-		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
-			hugetlb_unshare_all_pmds(vma);
-
-	skip:
-		prev = vma;
-		start = vma->vm_end;
-	}
+	ret = userfaultfd_register_range(ctx, vma, vm_flags, start, end,
+					 wp_async);
 
 out_unlock:
 	mmap_write_unlock(mm);
@@ -1519,7 +1396,6 @@ static int userfaultfd_unregister(struct
 	struct vm_area_struct *vma, *prev, *cur;
 	int ret;
 	struct uffdio_range uffdio_unregister;
-	unsigned long new_flags;
 	bool found;
 	unsigned long start, end, vma_end;
 	const void __user *buf = (void __user *)arg;
@@ -1622,27 +1498,13 @@ static int userfaultfd_unregister(struct
 			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
 		}
 
-		/* Reset ptes for the whole vma range if wr-protected */
-		if (userfaultfd_wp(vma))
-			uffd_wp_range(vma, start, vma_end - start, false);
-
-		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
-		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
-					    new_flags, NULL_VM_UFFD_CTX);
+		vma = userfaultfd_clear_vma(&vmi, prev, vma,
+					    start, vma_end);
 		if (IS_ERR(vma)) {
 			ret = PTR_ERR(vma);
 			break;
 		}
 
-		/*
-		 * In the vma_merge() successful mprotect-like case 8:
-		 * the next vma was merged into the current one and
-		 * the current one has not been updated yet.
-		 */
-		vma_start_write(vma);
-		userfaultfd_set_vm_flags(vma, new_flags);
-		vma->vm_userfaultfd_ctx = NULL_VM_UFFD_CTX;
-
 	skip:
 		prev = vma;
 		start = vma->vm_end;
--- a/include/linux/userfaultfd_k.h~userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc
+++ a/include/linux/userfaultfd_k.h
@@ -267,6 +267,25 @@ extern void userfaultfd_unmap_complete(s
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
 
+void userfaultfd_reset_ctx(struct vm_area_struct *vma);
+
+struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
+					     struct vm_area_struct *prev,
+					     struct vm_area_struct *vma,
+					     unsigned long start,
+					     unsigned long end);
+
+int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
+			       struct vm_area_struct *vma,
+			       unsigned long vm_flags,
+			       unsigned long start, unsigned long end,
+			       bool wp_async);
+
+void userfaultfd_release_new(struct userfaultfd_ctx *ctx);
+
+void userfaultfd_release_all(struct mm_struct *mm,
+			     struct userfaultfd_ctx *ctx);
+
 #else /* CONFIG_USERFAULTFD */
 
 /* mm helpers */
--- a/mm/userfaultfd.c~userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc
+++ a/mm/userfaultfd.c
@@ -1760,3 +1760,171 @@ out:
 	VM_WARN_ON(!moved && !err);
 	return moved ? moved : err;
 }
+
+static void userfaultfd_set_vm_flags(struct vm_area_struct *vma,
+				     vm_flags_t flags)
+{
+	const bool uffd_wp_changed = (vma->vm_flags ^ flags) & VM_UFFD_WP;
+
+	vm_flags_reset(vma, flags);
+	/*
+	 * For shared mappings, we want to enable writenotify while
+	 * userfaultfd-wp is enabled (see vma_wants_writenotify()). We'll simply
+	 * recalculate vma->vm_page_prot whenever userfaultfd-wp changes.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && uffd_wp_changed)
+		vma_set_page_prot(vma);
+}
+
+static void userfaultfd_set_ctx(struct vm_area_struct *vma,
+				struct userfaultfd_ctx *ctx,
+				unsigned long flags)
+{
+	vma_start_write(vma);
+	vma->vm_userfaultfd_ctx = (struct vm_userfaultfd_ctx){ctx};
+	userfaultfd_set_vm_flags(vma,
+				 (vma->vm_flags & ~__VM_UFFD_FLAGS) | flags);
+}
+
+void userfaultfd_reset_ctx(struct vm_area_struct *vma)
+{
+	userfaultfd_set_ctx(vma, NULL, 0);
+}
+
+struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
+					     struct vm_area_struct *prev,
+					     struct vm_area_struct *vma,
+					     unsigned long start,
+					     unsigned long end)
+{
+	struct vm_area_struct *ret;
+
+	/* Reset ptes for the whole vma range if wr-protected */
+	if (userfaultfd_wp(vma))
+		uffd_wp_range(vma, start, end - start, false);
+
+	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
+				    vma->vm_flags & ~__VM_UFFD_FLAGS,
+				    NULL_VM_UFFD_CTX);
+
+	/*
+	 * In the vma_merge() successful mprotect-like case 8:
+	 * the next vma was merged into the current one and
+	 * the current one has not been updated yet.
+	 */
+	if (!IS_ERR(ret))
+		userfaultfd_reset_ctx(vma);
+
+	return ret;
+}
+
+/* Assumes mmap write lock taken, and mm_struct pinned. */
+int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
+			       struct vm_area_struct *vma,
+			       unsigned long vm_flags,
+			       unsigned long start, unsigned long end,
+			       bool wp_async)
+{
+	VMA_ITERATOR(vmi, ctx->mm, start);
+	struct vm_area_struct *prev = vma_prev(&vmi);
+	unsigned long vma_end;
+	unsigned long new_flags;
+
+	if (vma->vm_start < start)
+		prev = vma;
+
+	for_each_vma_range(vmi, vma, end) {
+		cond_resched();
+
+		BUG_ON(!vma_can_userfault(vma, vm_flags, wp_async));
+		BUG_ON(vma->vm_userfaultfd_ctx.ctx &&
+		       vma->vm_userfaultfd_ctx.ctx != ctx);
+		WARN_ON(!(vma->vm_flags & VM_MAYWRITE));
+
+		/*
+		 * Nothing to do: this vma is already registered into this
+		 * userfaultfd and with the right tracking mode too.
+		 */
+		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
+		    (vma->vm_flags & vm_flags) == vm_flags)
+			goto skip;
+
+		if (vma->vm_start > start)
+			start = vma->vm_start;
+		vma_end = min(end, vma->vm_end);
+
+		new_flags = (vma->vm_flags & ~__VM_UFFD_FLAGS) | vm_flags;
+		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
+					    new_flags,
+					    (struct vm_userfaultfd_ctx){ctx});
+		if (IS_ERR(vma))
+			return PTR_ERR(vma);
+
+		/*
+		 * In the vma_merge() successful mprotect-like case 8:
+		 * the next vma was merged into the current one and
+		 * the current one has not been updated yet.
+		 */
+		userfaultfd_set_ctx(vma, ctx, vm_flags);
+
+		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
+			hugetlb_unshare_all_pmds(vma);
+
+skip:
+		prev = vma;
+		start = vma->vm_end;
+	}
+
+	return 0;
+}
+
+void userfaultfd_release_new(struct userfaultfd_ctx *ctx)
+{
+	struct mm_struct *mm = ctx->mm;
+	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
+
+	/* the various vma->vm_userfaultfd_ctx still points to it */
+	mmap_write_lock(mm);
+	for_each_vma(vmi, vma) {
+		if (vma->vm_userfaultfd_ctx.ctx == ctx)
+			userfaultfd_reset_ctx(vma);
+	}
+	mmap_write_unlock(mm);
+}
+
+void userfaultfd_release_all(struct mm_struct *mm,
+			     struct userfaultfd_ctx *ctx)
+{
+	struct vm_area_struct *vma, *prev;
+	VMA_ITERATOR(vmi, mm, 0);
+
+	if (!mmget_not_zero(mm))
+		return;
+
+	/*
+	 * Flush page faults out of all CPUs. NOTE: all page faults
+	 * must be retried without returning VM_FAULT_SIGBUS if
+	 * userfaultfd_ctx_get() succeeds but vma->vma_userfault_ctx
+	 * changes while handle_userfault released the mmap_lock. So
+	 * it's critical that released is set to true (above), before
+	 * taking the mmap_lock for writing.
+	 */
+	mmap_write_lock(mm);
+	prev = NULL;
+	for_each_vma(vmi, vma) {
+		cond_resched();
+		BUG_ON(!!vma->vm_userfaultfd_ctx.ctx ^
+		       !!(vma->vm_flags & __VM_UFFD_FLAGS));
+		if (vma->vm_userfaultfd_ctx.ctx != ctx) {
+			prev = vma;
+			continue;
+		}
+
+		vma = userfaultfd_clear_vma(&vmi, prev, vma,
+					    vma->vm_start, vma->vm_end);
+		prev = vma;
+	}
+	mmap_write_unlock(mm);
+	mmput(mm);
+}
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

userfaultfd-move-core-vma-manipulation-logic-to-mm-userfaultfdc.patch
mm-move-vma_modify-and-helpers-to-internal-header.patch
mm-move-vma_shrink-vma_expand-to-internal-header.patch
mm-move-internal-core-vma-manipulation-functions-to-own-file.patch
maintainers-add-entry-for-new-vma-files.patch
tools-separate-out-shared-radix-tree-components.patch
tools-add-skeleton-code-for-userland-testing-of-vma-logic.patch

