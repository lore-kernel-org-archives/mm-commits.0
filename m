Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0A71D86FF
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 21:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752699683; cv=none; b=gDX9ifLx+j5hVRmreLNoFXDfNHSAwX5BTxk9ydeE9QOrUQXjM5zsQVa7XbAfq/2tSy0fMKOooo1xCmYHYtyODZCfB3wemFVbvhFdC06fCv6q5WPJoL6IzuCGprB/DCam489TSuSAiiso+gO2H0n4TkTb0cltVoIRswaoDjfbff0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752699683; c=relaxed/simple;
	bh=a451h+7kKtk8HwAnDOxpnk7SRYqK2xS3bAEv1H+lrBE=;
	h=Date:To:From:Subject:Message-Id; b=gXcy+zTEJBBYV/82Fm8YW1aH355kERo2pwd4986tJfaqgJm/nMU7GNdIxPq0Nk7wN0+XFa+jNPmjNjYy1twR/so+3I7XUJH96yKZi3zSTO/a1J9QhuIszefbOTtEMS+lOTYxD2BZtk6T/NtqAuwvia/WehXh8DWhrJPyAfK8UAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CT3MW42Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CT3MW42Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BC1C4CEF1;
	Wed, 16 Jul 2025 21:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752699682;
	bh=a451h+7kKtk8HwAnDOxpnk7SRYqK2xS3bAEv1H+lrBE=;
	h=Date:To:From:Subject:From;
	b=CT3MW42YWk1ifi01EibX1NpZgY7h3143ywVQyUGaTM80chIirjLboBez7Uf7EmVIL
	 Gi3xkfLKjJb8bJvyFRS+saEBzshLKP/UX2wCRVZVJmwlPM7L2TBzPnH42grzjNO7y3
	 TzXLrFZwOimDArsukD8SspVavBb8p9hjxumBHyX4=
Date: Wed, 16 Jul 2025 14:01:21 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,pfalcato@suse.de,Liam.Howlett@oracle.com,jeffxu@chromium.org,jannh@google.com,david@redhat.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mseal-update-madvise-logic.patch added to mm-new branch
Message-Id: <20250716210122.34BC1C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mseal: update madvise() logic
has been added to the -mm mm-new branch.  Its filename is
     mm-mseal-update-madvise-logic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mseal-update-madvise-logic.patch

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
Subject: mm/mseal: update madvise() logic
Date: Wed, 16 Jul 2025 18:38:03 +0100

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

Shared mappings are always backed, so no discard will actually truly
discard the data.  Read-only anonymous and MAP_PRIVATE file-backed
mappings are the ones we are interested in.

We make a change to the logic here to correct a mistake - we must disallow
discard of read-only MAP_PRIVATE file-backed mappings, which previously we
were not.

The justification for this change is to account for the case where:

1. A MAP_PRIVATE R/W file-backed mapping is established.
2. The mapping is written to, which backs it with anonymous memory.
3. The mapping is mprotect()'d read-only.
4. The mapping is mseal()'d.

If we were to now allow discard of this data, it would mean mseal() would
not prevent the unrecoverable discarding of data and it was thus violate
the semantics of sealed VMAs.

Finally, update the mseal tests, which were asserting previously that a
read-only MAP_PRIVATE file-backed mapping could be discarded.

Link: https://lkml.kernel.org/r/ec480dc1fd4ce04bb11c0acac6c6da78dc6f4156.1752687069.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c                            |   63 +++++++++++++++++++++-
 mm/mseal.c                              |   49 -----------------
 mm/vma.h                                |    7 --
 tools/testing/selftests/mm/mseal_test.c |    3 -
 4 files changed, 63 insertions(+), 59 deletions(-)

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
@@ -1255,6 +1256,66 @@ static long madvise_guard_remove(struct
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
+	 * But shared mappings are fine, as dirty pages will be written to a
+	 * backing store regardless of discard.
+	 */
+	if (vma->vm_flags & VM_SHARED)
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
@@ -1268,7 +1329,7 @@ static int madvise_vma_behavior(struct m
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
 
--- a/tools/testing/selftests/mm/mseal_test.c~mm-mseal-update-madvise-logic
+++ a/tools/testing/selftests/mm/mseal_test.c
@@ -1712,7 +1712,6 @@ static void test_seal_discard_ro_anon_on
 	unsigned long size = 4 * page_size;
 	int ret;
 	int fd;
-	unsigned long mapflags = MAP_PRIVATE;
 
 	fd = memfd_create("test", 0);
 	FAIL_TEST_IF_FALSE(fd > 0);
@@ -1720,7 +1719,7 @@ static void test_seal_discard_ro_anon_on
 	ret = fallocate(fd, 0, 0, size);
 	FAIL_TEST_IF_FALSE(!ret);
 
-	ptr = mmap(NULL, size, PROT_READ, mapflags, fd, 0);
+	ptr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, 0);
 	FAIL_TEST_IF_FALSE(ptr != MAP_FAILED);
 
 	if (seal) {
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-mremap-perform-some-simple-cleanups.patch
mm-mremap-refactor-initial-parameter-sanity-checks.patch
mm-mremap-put-vma-check-and-prep-logic-into-helper-function.patch
mm-mremap-cleanup-post-processing-stage-of-mremap.patch
mm-mremap-use-an-explicit-uffd-failure-path-for-mremap.patch
mm-mremap-check-remap-conditions-earlier.patch
mm-mremap-move-remap_is_valid-into-check_prep_vma.patch
mm-mremap-clean-up-mlock-populate-behaviour.patch
mm-mremap-permit-mremap-move-of-multiple-vmas.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix.patch
mm-mremap-permit-mremap-move-of-multiple-vmas-fix-2.patch
tools-testing-selftests-extend-mremap_test-to-test-multi-vma-mremap.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name.patch
mm-vma-refactor-vma_modify_flags_name-to-vma_modify_name-fix.patch
mm-mseal-always-define-vm_sealed.patch
mm-mseal-update-madvise-logic.patch
mm-mseal-small-cleanups.patch
mm-mseal-simplify-and-rename-vma-gap-check.patch
mm-mseal-rework-mseal-apply-logic.patch

