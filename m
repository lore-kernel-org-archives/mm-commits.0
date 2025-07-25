Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2E020F063
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409666; cv=none; b=IZZYTgVegmSdvZYh1j15IB4Mt1z/wePl/6mhFBakQLmnMC8X3CKbSEPF8/WCeFjLXqCAWij7L8RVjeDyQfgpzCHPR6FogCxD+/pz7MwY0jOyqWM9OEJu/iG5pHE/KW/WbRZaPW1bSPE509lEVDZskUOrDhqIfJgy//n4BkgcGI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409666; c=relaxed/simple;
	bh=Gp7pfsY1N4xEbdpDMGC6ubz5f2MUUtDzCZ7ARkPqSpo=;
	h=Date:To:From:Subject:Message-Id; b=lqF82UkIbgmxdgEI2K51n1nDqKx12ftkcuttRkJ+vCJPg0MW1UUfu9AasU3F5LDgPccIewVDRhL5h0QiwWb995mWElkDDapT5qZccNcBjR2OqRJMso2Arw5GECTAcGfBw8VXx3GISpZ9u7tts01h6OuYepPdnisjL7032KZOlmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iV4YeVt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iV4YeVt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525B7C4CEED;
	Fri, 25 Jul 2025 02:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409665;
	bh=Gp7pfsY1N4xEbdpDMGC6ubz5f2MUUtDzCZ7ARkPqSpo=;
	h=Date:To:From:Subject:From;
	b=iV4YeVt/nXTIK3ScdTyAy+KWe7RxFMbgPzDes4lyEfQzWynzK3KSDzpwrpwz/LwfT
	 QThtZjeEd27MuEuIYd5CBty5feRt6QNlGK4i5VQd14ZFHager06rFoFwZNePZG4JC7
	 bfgbH5F3WuILKQc41Zh/Eps5FtWAZXgcwUWHtgfI=
Date: Thu, 24 Jul 2025 19:14:24 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,riel@surriel.com,peterx@redhat.com,liam.howlett@oracle.com,jannh@google.com,jack@suse.cz,brauner@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch removed from -mm tree
Message-Id: <20250725021425.525B7C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mremap: use an explicit uffd failure path for mremap
has been removed from the -mm tree.  Its filename was
     mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/mremap: use an explicit uffd failure path for mremap
Date: Thu, 17 Jul 2025 17:55:55 +0100

Right now it appears that the code is relying upon the returned
destination address having bits outside PAGE_MASK to indicate whether an
error value is specified, and decrementing the increased refcount on the
uffd ctx if so.

This is not a safe means of determining an error value, so instead, be
specific.  It makes far more sense to do so in a dedicated error path, so
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

We assume vrm->new_addr is always valid, which a prior change made the
case even for mremap() invocations which don't move the VMA, however given
no uffd context would be set up in this case it's immaterial to this
change anyway.

No functional change intended.

Link: https://lkml.kernel.org/r/a70e8a1f7bce9f43d1431065b414e0f212297297.1752770784.git.lorenzo.stoakes@oracle.com
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
@@ -1729,12 +1729,17 @@ static int check_prep_vma(struct vma_rem
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
 
@@ -1742,6 +1747,7 @@ static unsigned long do_mremap(struct vm
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long res;
+	bool failed;
 
 	vrm->old_len = PAGE_ALIGN(vrm->old_len);
 	vrm->new_len = PAGE_ALIGN(vrm->new_len);
@@ -1763,13 +1769,15 @@ static unsigned long do_mremap(struct vm
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

mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch
maintainers-add-missing-percpu-internalh-file-to-per-cpu-section.patch
maintainers-add-missing-interval_treec-to-memory-mapping-section.patch
maintainers-add-missing-mm_sloth-file-thp-section.patch
maintainers-add-missing-mm_sloth-file-thp-section-fix.patch
maintainers-move-memremap-to-hotplug-section.patch
maintainers-add-missing-shrinker-files.patch
maintainers-add-missing-files-to-page-alloc-section.patch
maintainers-add-missing-zsmalloc-file.patch
maintainers-add-mm-misc-section-add-missing-files-to-misc-and-core.patch
maintainers-add-missing-file-to-cgroup-section.patch

