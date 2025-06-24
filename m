Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1792586FE
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 23:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750806827; cv=none; b=HqdQqRUkkIyDeHL448HSjQxCad8cpJIB5N4eOf6AScEpyiHWVQtkVqA83GnwL/U6u+SraElYKado2DM9IQrIz09U5IDLn27KP7YSEtynt7rLcaF2aOB5L4UU0U1Rzwxw1X3dbhZ7AckaY5ftkMiyYpdaEMxXkBIPT/p/+2r7J/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750806827; c=relaxed/simple;
	bh=qOVwfqlrt1NU30CCeK4zEXYRLKfAgOUPCUZB1mQDtPs=;
	h=Date:To:From:Subject:Message-Id; b=ER6xxvnEDuuxsYobQOhLzeKSSGpgryB89FmX0xO20u5xXChQMF4DyVxBAVyi3gs34tz0GD6U27tqc/vcmsvY1AZt5VBXiQ//19TBqHMMJbghFC1EmoGcvv9NoA1Jpc0PVmdVt22I/g+6XA5x06Rl0BPGJOCnTSkBBYDCK3QbB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aFQtw4U8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aFQtw4U8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3976FC4CEE3;
	Tue, 24 Jun 2025 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750806826;
	bh=qOVwfqlrt1NU30CCeK4zEXYRLKfAgOUPCUZB1mQDtPs=;
	h=Date:To:From:Subject:From;
	b=aFQtw4U8aQxJHYH9RR/vd95eBXhe78dNbt+DQ9bPEJfF3C3lxJKZLnX32HnDloL3X
	 5BZqLa3lw+nCk5wCloWRHxU0/wPH/v948XtamOoYgyHzXJIgl8w+CJqo4Zigl1i0HR
	 DspayUy1KzLRGH3W7H3rG5Gpv4A+GhmOXRdvRvwY=
Date: Tue, 24 Jun 2025 16:13:45 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@redhat.com,ccross@google.com,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-simplify-anon_name-handling.patch added to mm-new branch
Message-Id: <20250624231346.3976FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, madvise: simplify anon_name handling
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-simplify-anon_name-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-simplify-anon_name-handling.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, madvise: simplify anon_name handling
Date: Tue, 24 Jun 2025 15:03:45 +0200

Patch series "madvise anon_name cleanups", v2.

While reviewing Lorenzo's madvise cleanups I've noticed that we can handle
anon_name in madvise code much better, so sending that as patch 1. 
Initially I wanted to do first move the existing logic from
madvise_vma_behavior() to madvise_update_vma() as a separate patch before
the actual simplification but that would require adding
anon_vma_name_put() in error handling paths only to be removed again, so
it's a single patch to avoid churn.

It's also an opportunity to move some mm code from prctl under mm, hence
patch 2.  After code moving preparation in patch 3, also unify madvise
lock handling for madvise_set_anon_name() in patch 4.


This patch (of 4):

Since the introduction in 9a10064f5625 ("mm: add a field to store names
for private anonymous memory") the code to set anon_name on a vma has been
using madvise_update_vma() to call replace_anon_vma_name().  Since the
former is called also by a number of other madvise behaviours that do not
set a new anon_name, they have been passing the existing anon_name of the
vma to make replace_anon_vma_name() a no-op.

This is rather wasteful as it needs anon_vma_name_eq() to determine the
no-op situations, and checks for when replace_anon_vma_name() is allowed
(the vma is anon/shmem) duplicate the checks already done earlier in
madvise_vma_behavior().  It has also lead to commit 942341dcc574 ("mm: fix
use-after-free when anon vma name is used after vma is freed") adding
anon_name refcount get/put operations exactly to the cases that actually
do not change anon_name - just so the replace_anon_vma_name() can keep
safely determining it has nothing to do.

The recent madvise cleanups made this suboptimal handling very obvious,
but happily also allow for an easy fix.  madvise_update_vma() now has the
complete information whether it's been called to set a new anon_name, so
stop passing it the existing vma's name and doing the refcount get/put in
its only caller madvise_vma_behavior().

In madvise_update_vma() itself, limit calling of replace_anon_vma_name()
only to cases where we are setting a new name, otherwise we know it's a
no-op.  We can rely solely on the __MADV_SET_ANON_VMA_NAME behaviour and
can remove the duplicate checks for vma being anon/shmem that were done
already in madvise_vma_behavior().

Additionally, by using vma_modify_flags() when not modifying the
anon_name, avoid explicitly passing the existing vma's anon_name and
storing a pointer to it in struct madv_behavior or a local variable.  This
prevents the danger of accessing a freed anon_name after vma merging,
previously fixed by commit 942341dcc574.

Link: https://lkml.kernel.org/r/20250624-anon_name_cleanup-v2-0-600075462a11@suse.cz
Link: https://lkml.kernel.org/r/20250624-anon_name_cleanup-v2-1-600075462a11@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Colin Cross <ccross@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

--- a/mm/madvise.c~mm-madvise-simplify-anon_name-handling
+++ a/mm/madvise.c
@@ -176,25 +176,29 @@ static int replace_anon_vma_name(struct
 }
 #endif /* CONFIG_ANON_VMA_NAME */
 /*
- * Update the vm_flags on region of a vma, splitting it or merging it as
- * necessary.  Must be called with mmap_lock held for writing;
- * Caller should ensure anon_name stability by raising its refcount even when
- * anon_name belongs to a valid vma because this function might free that vma.
+ * Update the vm_flags and/or anon_name on region of a vma, splitting it or
+ * merging it as necessary. Must be called with mmap_lock held for writing.
  */
 static int madvise_update_vma(vm_flags_t new_flags,
 		struct madvise_behavior *madv_behavior)
 {
-	int error;
 	struct vm_area_struct *vma = madv_behavior->vma;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	struct anon_vma_name *anon_name = madv_behavior->anon_name;
+	bool set_new_anon_name = madv_behavior->behavior == __MADV_SET_ANON_VMA_NAME;
 	VMA_ITERATOR(vmi, madv_behavior->mm, range->start);
 
-	if (new_flags == vma->vm_flags && anon_vma_name_eq(anon_vma_name(vma), anon_name))
+	if (new_flags == vma->vm_flags && (!set_new_anon_name ||
+			anon_vma_name_eq(anon_vma_name(vma), anon_name)))
 		return 0;
 
-	vma = vma_modify_flags_name(&vmi, madv_behavior->prev, vma,
+	if (set_new_anon_name)
+		vma = vma_modify_flags_name(&vmi, madv_behavior->prev, vma,
 			range->start, range->end, new_flags, anon_name);
+	else
+		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
+			range->start, range->end, new_flags);
+
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
@@ -203,11 +207,8 @@ static int madvise_update_vma(vm_flags_t
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vm_flags_reset(vma, new_flags);
-	if (!vma->vm_file || vma_is_anon_shmem(vma)) {
-		error = replace_anon_vma_name(vma, anon_name);
-		if (error)
-			return error;
-	}
+	if (set_new_anon_name)
+		return replace_anon_vma_name(vma, anon_name);
 
 	return 0;
 }
@@ -1313,7 +1314,6 @@ static int madvise_vma_behavior(struct m
 	int behavior = madv_behavior->behavior;
 	struct vm_area_struct *vma = madv_behavior->vma;
 	vm_flags_t new_flags = vma->vm_flags;
-	bool set_new_anon_name = behavior == __MADV_SET_ANON_VMA_NAME;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int error;
 
@@ -1403,18 +1403,7 @@ static int madvise_vma_behavior(struct m
 	/* This is a write operation.*/
 	VM_WARN_ON_ONCE(madv_behavior->lock_mode != MADVISE_MMAP_WRITE_LOCK);
 
-	/*
-	 * madvise_update_vma() might cause a VMA merge which could put an
-	 * anon_vma_name, so we must hold an additional reference on the
-	 * anon_vma_name so it doesn't disappear from under us.
-	 */
-	if (!set_new_anon_name) {
-		madv_behavior->anon_name = anon_vma_name(vma);
-		anon_vma_name_get(madv_behavior->anon_name);
-	}
 	error = madvise_update_vma(new_flags, madv_behavior);
-	if (!set_new_anon_name)
-		anon_vma_name_put(madv_behavior->anon_name);
 out:
 	/*
 	 * madvise() returns EAGAIN if kernel resources, such as
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-madvise-simplify-anon_name-handling.patch
mm-madvise-extract-mm-code-from-prctl_set_vma-to-mm-madvisec.patch
mm-madvise-move-madvise_set_anon_name-down-the-file.patch
mm-madvise-use-standard-madvise-locking-in-madvise_set_anon_name.patch

