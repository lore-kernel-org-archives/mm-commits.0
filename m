Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C82204C07
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160845; cv=none; b=VnuYJmxlQ9bsHFd7K6nwmW7caThauFAdH5CzXbv0wVMne3e2+m12hZstEPqq60cIBUezBWiOa2yd7Gj+HcbhBnPRod8fDjC8bAi+gFso++t4ZMer8iZSFXZha1nmdx640wxSHX3NUh3Mh/73RXXJmIO2z9XS3YvwWAT7CrzhzTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160845; c=relaxed/simple;
	bh=0YFgitd4fj7sgsSfUsouKot+K7b3/YnMQNEYOhKZEzU=;
	h=Date:To:From:Subject:Message-Id; b=IYBwhCR6FVSDNAP/QXobCEqqhMjQ2gs7k+dso4PQfcS1/NAiq2ENFwqaEaOmMZAvwzOSWC3nWtx3hQm/fcQe0U5jxs06+F79hal4+9EQii95Ds9GeYoAFjetOLNY0isbuqxQbggnbVKIINsoeBv+czdh52B48VyDJA4NvDTxbPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nFtPDxbf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nFtPDxbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661CBC4CEEF;
	Sat,  2 Aug 2025 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160844;
	bh=0YFgitd4fj7sgsSfUsouKot+K7b3/YnMQNEYOhKZEzU=;
	h=Date:To:From:Subject:From;
	b=nFtPDxbfiua11miZcJgPEQU0Ec4arKMe1uMT52tP54hl9FnL6zLUVVqpH2RJ4PgH8
	 J9dDRXUj1nVR6Bsm1BnOEzibcF90XdKAz+GuDrxeOmu1b95zWvjFO6Ctv6StZZZbFj
	 tVF+SKa1gF0+d6Gem4EJ45gtU+NB8UObg1mAzqOA=
Date: Sat, 02 Aug 2025 11:54:03 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,kees@kernel.org,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mseal-update-madvise-logic.patch removed from -mm tree
Message-Id: <20250802185404.661CBC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mseal: update madvise() logic
has been removed from the -mm tree.  Its filename was
     mm-mseal-update-madvise-logic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


