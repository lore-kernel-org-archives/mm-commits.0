Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB4C2609D6
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 23:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753486019; cv=none; b=lTuMNxda5BZKg/vJozpN1I4UrAKIv4j+7U7K7y95xQdXoV6U6VsArUbX7xDqbBBdevHemafNMjkeHBHjH1J+N1vsMKI+zZgcjDnO9V9DLUhauMYnS2vxb/DNiKkSuJ3spyffH7pxclvS/N9wkuIgFiIfWH+DXtkNF5/Pn348g7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753486019; c=relaxed/simple;
	bh=9LJpzrv1iN7bXizNlZHxiPj8ShEMXJ2ew0ddgilyICY=;
	h=Date:To:From:Subject:Message-Id; b=t37sCkdwLSnsuLI1X4lpiNFtYekotD/6F0uynSRAj1ov/aHCAJUVy8zRr8/unGPSXQURA6ak2TEfF7gHnPrJswaYdrthPwQFadMTu0uNeX86Gt2MPs04w4CeasAsZ1bEkDkeOhSGIYwz5Jxo5188c4a84gB70tMBF+v1orjDBw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1R1eYriX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1R1eYriX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C9D9C4CEE7;
	Fri, 25 Jul 2025 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753486019;
	bh=9LJpzrv1iN7bXizNlZHxiPj8ShEMXJ2ew0ddgilyICY=;
	h=Date:To:From:Subject:From;
	b=1R1eYriXKa3Y43jl1s0v/Ac5vVGXbNEgl77JffbdSfBOTs7gslcvxW3Fd1cL35k1p
	 pR3ijjmqv66LtRkdazoPIm0zc38i9xaydQQncoWwpD6wilcvc8VVVf6rzq/sM7yp9a
	 OIgtBTf+mW+6Y3kGn3UvHvNAQlYeAWp2nEzUZb7w=
Date: Fri, 25 Jul 2025 16:26:59 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-update-madvise-logic.patch added to mm-unstable branch
Message-Id: <20250725232659.9C9D9C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: update madvise() logic
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mseal-update-madvise-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-update-madvise-logic.patch

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
Subject: mm/mseal: update madvise() logic
Date: Fri, 25 Jul 2025 09:29:42 +0100

The madvise() logic is inexplicably performed in mm/mseal.c - this ought
to be located in mm/madvise.c.

Additionally can_modify_vma_madv() is inconsistently named and, in
combination with is_ro_anon(), is very confusing logic.

Put a static function in mm/madvise.c instead - can_madvise_modify() -
that spells out exactly what's happening.  Also explicitly check for an
anon VMA.

Also add commentary to explain what's going on.

Essentially - we disallow discarding of data in mseal()'d mappings in
instances where the user couldn't otherwise write to that data.

We retain the existing behaviour here regarding MAP_PRIVATE mappings of
file-backed mappings, which entails some complexity - while this, strictly
speaking - appears to violate mseal() semantics, it may interact badly
with users which expect to be able to madvise(MADV_DONTNEED) .text
mappings for instance.

We may revisit this at a later date.

No functional change intended.

Link: https://lkml.kernel.org/r/492a98d9189646e92c8f23f4cce41ed323fe01df.1753431105.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++++-
 mm/mseal.c   |   49 ---------------------------------
 mm/vma.h     |    7 ----
 3 files changed, 70 insertions(+), 57 deletions(-)

--- a/mm/madvise.c~mm-mseal-update-madvise-logic
+++ a/mm/madvise.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/mm_inline.h>
+#include <linux/mmu_context.h>
 #include <linux/string.h>
 #include <linux/uio.h>
 #include <linux/ksm.h>
@@ -1256,6 +1257,74 @@ static long madvise_guard_remove(struct
 			       &guard_remove_walk_ops, NULL);
 }
 
+#ifdef CONFIG_64BIT
+/* Does the madvise operation result in discarding of mapped data? */
+static bool is_discard(int behavior)
+{
+	switch (behavior) {
+	case MADV_FREE:
+	case MADV_DONTNEED:
+	case MADV_DONTNEED_LOCKED:
+	case MADV_REMOVE:
+	case MADV_DONTFORK:
+	case MADV_WIPEONFORK:
+	case MADV_GUARD_INSTALL:
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * We are restricted from madvise()'ing mseal()'d VMAs only in very particular
+ * circumstances - discarding of data from read-only anonymous SEALED mappings.
+ *
+ * This is because users cannot trivally discard data from these VMAs, and may
+ * only do so via an appropriate madvise() call.
+ */
+static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
+{
+	struct vm_area_struct *vma = madv_behavior->vma;
+
+	/* If the VMA isn't sealed we're good. */
+	if (can_modify_vma(vma))
+		return true;
+
+	/* For a sealed VMA, we only care about discard operations. */
+	if (!is_discard(madv_behavior->behavior))
+		return true;
+
+	/*
+	 * We explicitly permit all file-backed mappings, whether MAP_SHARED or
+	 * MAP_PRIVATE.
+	 *
+	 * The latter causes some complications. Because now, one can mmap()
+	 * read/write a MAP_PRIVATE mapping, write to it, then mprotect()
+	 * read-only, mseal() and a discard will be permitted.
+	 *
+	 * However, in order to avoid issues with potential use of madvise(...,
+	 * MADV_DONTNEED) of mseal()'d .text mappings we, for the time being,
+	 * permit this.
+	 */
+	if (!vma_is_anonymous(vma))
+		return true;
+
+	/* If the user could write to the mapping anyway, then this is fine. */
+	if ((vma->vm_flags & VM_WRITE) &&
+	    arch_vma_access_permitted(vma, /* write= */ true,
+			/* execute= */ false, /* foreign= */ false))
+		return true;
+
+	/* Otherwise, we are not permitted to perform this operation. */
+	return false;
+}
+#else
+static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
+{
+	return true;
+}
+#endif
+
 /*
  * Apply an madvise behavior to a region of a vma.  madvise_update_vma
  * will handle splitting a vm area into separate areas, each area with its own
@@ -1269,7 +1338,7 @@ static int madvise_vma_behavior(struct m
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int error;
 
-	if (unlikely(!can_modify_vma_madv(madv_behavior->vma, behavior)))
+	if (unlikely(!can_madvise_modify(madv_behavior)))
 		return -EPERM;
 
 	switch (behavior) {
--- a/mm/mseal.c~mm-mseal-update-madvise-logic
+++ a/mm/mseal.c
@@ -11,7 +11,6 @@
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
-#include <linux/mmu_context.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
 #include "internal.h"
@@ -21,54 +20,6 @@ static inline void set_vma_sealed(struct
 	vm_flags_set(vma, VM_SEALED);
 }
 
-static bool is_madv_discard(int behavior)
-{
-	switch (behavior) {
-	case MADV_FREE:
-	case MADV_DONTNEED:
-	case MADV_DONTNEED_LOCKED:
-	case MADV_REMOVE:
-	case MADV_DONTFORK:
-	case MADV_WIPEONFORK:
-	case MADV_GUARD_INSTALL:
-		return true;
-	}
-
-	return false;
-}
-
-static bool is_ro_anon(struct vm_area_struct *vma)
-{
-	/* check anonymous mapping. */
-	if (vma->vm_file || vma->vm_flags & VM_SHARED)
-		return false;
-
-	/*
-	 * check for non-writable:
-	 * PROT=RO or PKRU is not writeable.
-	 */
-	if (!(vma->vm_flags & VM_WRITE) ||
-		!arch_vma_access_permitted(vma, true, false, false))
-		return true;
-
-	return false;
-}
-
-/*
- * Check if a vma is allowed to be modified by madvise.
- */
-bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
-{
-	if (!is_madv_discard(behavior))
-		return true;
-
-	if (unlikely(!can_modify_vma(vma) && is_ro_anon(vma)))
-		return false;
-
-	/* Allow by default. */
-	return true;
-}
-
 static int mseal_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		struct vm_area_struct **prev, unsigned long start,
 		unsigned long end, vm_flags_t newflags)
--- a/mm/vma.h~mm-mseal-update-madvise-logic
+++ a/mm/vma.h
@@ -577,19 +577,12 @@ static inline bool can_modify_vma(struct
 	return true;
 }
 
-bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior);
-
 #else
 
 static inline bool can_modify_vma(struct vm_area_struct *vma)
 {
 	return true;
 }
-
-static inline bool can_modify_vma_madv(struct vm_area_struct *vma, int behavior)
-{
-	return true;
-}
 
 #endif
 
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

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
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-simplify-and-rename-vma-gap-check-fix.patch
mm-mseal-rework-mseal-apply-logic.patch
mm-remove-mm-io-mappingc.patch

