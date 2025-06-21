Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD90121FF2C
	for <mm-commits@vger.kernel.org>; Sat, 21 Jun 2025 19:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750532720; cv=none; b=pBMvE1lCRWn+1xZh+3TFF+Y9x2rScX1+fQSGxxa2CHv6rDRtJWLFmMXXsswKH4jm9SZIrE5tZFFRthV92r5NqWmjkhpfvpdEwJTBxakv6zXV3iQfFM0U2OxDkmV3nm33PZU8D542KQ8FFD3AivaNiKkiU4DNq8PmrzPNu7Hyiug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750532720; c=relaxed/simple;
	bh=EtLYZX9E28iU5cn//+6sjh4UCQ41eBtqLRktlwT3bmI=;
	h=Date:To:From:Subject:Message-Id; b=OfjjokeWukU7L2PtP9F6NrmdDBQq+62vLyK5edB02ss3i7P4GtimzwHHegM6fKv29dvfM3MnuiwHp4ARc4oWFlnVVw7RPBNt1V2+9yvSknj2qITQUeeyGkrd0AcJr0n/7jr7LemXkSOfyGT3KE53eDJ/pKMZ5KSUMYVoFh+O58E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xxVRNSV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xxVRNSV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32C8C4CEE7;
	Sat, 21 Jun 2025 19:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750532717;
	bh=EtLYZX9E28iU5cn//+6sjh4UCQ41eBtqLRktlwT3bmI=;
	h=Date:To:From:Subject:From;
	b=xxVRNSV+QmrRDTBMZAWsEd5DebU3y66Pwn05x/y/vEVUNLGLrC1VU0Y9bj0uA8ZHs
	 dlUtA122tmL3ZJq/NxRtYSrryfew40WG1ACBml56PTzZwhAG4vnG5LryfadEAC9omv
	 ymx14JMnHhZ3jvWiOb2JVicBz+dUJH4EgI6mlBfc=
Date: Sat, 21 Jun 2025 12:05:16 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,sj@kernel.org,ryan.roberts@arm.com,npache@redhat.com,liam.howlett@oracle.com,jannh@google.com,ioworker0@gmail.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch added to mm-new branch
Message-Id: <20250621190516.E32C8C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: remove the visitor pattern and thread anon_vma state
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch

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
Subject: mm/madvise: remove the visitor pattern and thread anon_vma state
Date: Fri, 20 Jun 2025 16:33:01 +0100

Patch series "madvise cleanup", v2.

This is a series of patches that helps address a number of historic
problems in the madvise() implementation:

* Eliminate the visitor pattern and having the code which is implemented
  for both the anon_vma_name implementation and ordinary madvise()
  operations use the same madvise_vma_behavior() implementation.

* Thread state through the madvise_behavior state object - this object,
  very usefully introduced by SJ, is already used to transmit state
  through operations.  This series extends this by having all madvise()
  operations use this, including anon_vma_name.

* Thread range, VMA state through madvise_behavior - This helps avoid a
  lot of the confusing code around range and VMA state and again keeps
  things consistent and with a single 'source of truth'.

* Addressing the very strange behaviour around the passed around struct
  vm_area_struct **prev pointer - all read-only users do absolutely
  nothing with the prev pointer.  The only function that uses it is
  madvise_update_vma(), and in all cases prev is always reset to VMA.

  Fix this by no longer having aything but madvise_update_vma()
  reference prev, and having madvise_walk_vmas() update prev in each
  instance.  Additionally make it clear that the meaningful change in vma
  state is when madvise_update_vma() potentially merges a VMA, so
  explicitly retrieve the VMA in this case.

* Update and clarify the madvise_walk_vmas() function - this is a source
  of a great deal of confusion, so simplify, stop using prev = NULL to
  signify that the mmap lock has been dropped (!) and make that explicit,
  and add some comments to explain what's going on.


This patch (of 5):

Now we have the madvise_behavior helper struct we no longer need to mess
around with void* pointers in order to propagate anon_vma_name, and this
means we can get rid of the confusing and inconsistent visitor pattern
implementation in madvise_vma_anon_name().

This means we now have a single state object that threads through most of
madvise()'s logic and a single code path which executes the majority of
madvise() behaviour (we maintain separate logic for failure injection and
memory population for the time being).

We are able to remove the visitor pattern by handling the anon_vma_name
setting logic via an internal madvise flag - __MADV_SET_ANON_VMA_NAME. 
This uses a negative value so it isn't reasonable that we will ever add
this as a UAPI flag.

Additionally, the madvise_behavior_valid() check ensures that
user-specified behaviours are strictly only those we permit which, of
course, this flag will be excluded from.

We are able to propagate the anon_vma_name object through use of the
madvise_behavior helper struct.

Doing this results in a can_modify_vma_madv() check for anonymous VMA name
changes, however this will cause no issues as this operation is not
prohibited.

We can also then reuse more code and drop the redundant
madvise_vma_anon_name() function altogether.

Additionally separate out behaviours that update VMAs from those that do
not.

Link: https://lkml.kernel.org/r/cover.1750433500.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/c5094bfccb41ecd19d4e9bcaa1c4a11e00158bba.1750433500.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |  166 ++++++++++++++++++++++++-------------------------
 1 file changed, 83 insertions(+), 83 deletions(-)

--- a/mm/madvise.c~mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state
+++ a/mm/madvise.c
@@ -37,6 +37,8 @@
 #include "internal.h"
 #include "swap.h"
 
+#define __MADV_SET_ANON_VMA_NAME (-1)
+
 /*
  * Maximum number of attempts we make to install guard pages before we give up
  * and return -ERESTARTNOINTR to have userspace try again.
@@ -59,9 +61,13 @@ struct madvise_behavior {
 	int behavior;
 	struct mmu_gather *tlb;
 	enum madvise_lock_mode lock_mode;
+	struct anon_vma_name *anon_name;
 };
 
 #ifdef CONFIG_ANON_VMA_NAME
+static int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
+		unsigned long end, struct madvise_behavior *madv_behavior);
+
 struct anon_vma_name *anon_vma_name_alloc(const char *name)
 {
 	struct anon_vma_name *anon_name;
@@ -112,6 +118,35 @@ static int replace_anon_vma_name(struct
 
 	return 0;
 }
+
+int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
+			  unsigned long len_in, struct anon_vma_name *anon_name)
+{
+	unsigned long end;
+	unsigned long len;
+	struct madvise_behavior madv_behavior = {
+		.behavior = __MADV_SET_ANON_VMA_NAME,
+		.lock_mode = MADVISE_MMAP_WRITE_LOCK,
+		.anon_name = anon_name,
+	};
+
+	if (start & ~PAGE_MASK)
+		return -EINVAL;
+	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
+
+	/* Check to see whether len was rounded up from small -ve to zero */
+	if (len_in && !len)
+		return -EINVAL;
+
+	end = start + len;
+	if (end < start)
+		return -EINVAL;
+
+	if (end == start)
+		return 0;
+
+	return madvise_walk_vmas(mm, start, end, &madv_behavior);
+}
 #else /* CONFIG_ANON_VMA_NAME */
 static int replace_anon_vma_name(struct vm_area_struct *vma,
 				 struct anon_vma_name *anon_name)
@@ -1252,13 +1287,13 @@ static long madvise_guard_remove(struct
 static int madvise_vma_behavior(struct vm_area_struct *vma,
 				struct vm_area_struct **prev,
 				unsigned long start, unsigned long end,
-				void *behavior_arg)
+				struct madvise_behavior *madv_behavior)
 {
-	struct madvise_behavior *arg = behavior_arg;
-	int behavior = arg->behavior;
-	int error;
-	struct anon_vma_name *anon_name;
+	int behavior = madv_behavior->behavior;
+	struct anon_vma_name *anon_name = madv_behavior->anon_name;
 	vm_flags_t new_flags = vma->vm_flags;
+	bool set_new_anon_name = behavior == __MADV_SET_ANON_VMA_NAME;
+	int error;
 
 	if (unlikely(!can_modify_vma_madv(vma, behavior)))
 		return -EPERM;
@@ -1275,7 +1310,17 @@ static int madvise_vma_behavior(struct v
 	case MADV_FREE:
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
-		return madvise_dontneed_free(vma, prev, start, end, arg);
+		return madvise_dontneed_free(vma, prev, start, end,
+					     madv_behavior);
+	case MADV_COLLAPSE:
+		return madvise_collapse(vma, prev, start, end);
+	case MADV_GUARD_INSTALL:
+		return madvise_guard_install(vma, prev, start, end);
+	case MADV_GUARD_REMOVE:
+		return madvise_guard_remove(vma, prev, start, end);
+
+	/* The below behaviours update VMAs via madvise_update_vma(). */
+
 	case MADV_NORMAL:
 		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
 		break;
@@ -1325,21 +1370,29 @@ static int madvise_vma_behavior(struct v
 		if (error)
 			goto out;
 		break;
-	case MADV_COLLAPSE:
-		return madvise_collapse(vma, prev, start, end);
-	case MADV_GUARD_INSTALL:
-		return madvise_guard_install(vma, prev, start, end);
-	case MADV_GUARD_REMOVE:
-		return madvise_guard_remove(vma, prev, start, end);
+	case __MADV_SET_ANON_VMA_NAME:
+		/* Only anonymous mappings can be named */
+		if (vma->vm_file && !vma_is_anon_shmem(vma))
+			return -EBADF;
+		break;
 	}
 
 	/* We cannot provide prev in this lock mode. */
-	VM_WARN_ON_ONCE(arg->lock_mode == MADVISE_VMA_READ_LOCK);
-	anon_name = anon_vma_name(vma);
-	anon_vma_name_get(anon_name);
+	VM_WARN_ON_ONCE(madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK);
+
+	/*
+	 * madvise_update_vma() might cause a VMA merge which could put an
+	 * anon_vma_name, so we must hold an additional reference on the
+	 * anon_vma_name so it doesn't disappear from under us.
+	 */
+	if (!set_new_anon_name) {
+		anon_name = anon_vma_name(vma);
+		anon_vma_name_get(anon_name);
+	}
 	error = madvise_update_vma(vma, prev, start, end, new_flags,
 				   anon_name);
-	anon_vma_name_put(anon_name);
+	if (!set_new_anon_name)
+		anon_vma_name_put(anon_name);
 
 out:
 	/*
@@ -1523,20 +1576,17 @@ take_mmap_read_lock:
 }
 
 /*
- * Walk the vmas in range [start,end), and call the visit function on each one.
- * The visit function will get start and end parameters that cover the overlap
- * between the current vma and the original range.  Any unmapped regions in the
- * original range will result in this function returning -ENOMEM while still
- * calling the visit function on all of the existing vmas in the range.
- * Must be called with the mmap_lock held for reading or writing.
+ * Walk the vmas in range [start,end), and call the madvise_vma_behavior
+ * function on each one.  The function will get start and end parameters that
+ * cover the overlap between the current vma and the original range.  Any
+ * unmapped regions in the original range will result in this function returning
+ * -ENOMEM while still calling the madvise_vma_behavior function on all of the
+ * existing vmas in the range.  Must be called with the mmap_lock held for
+ * reading or writing.
  */
 static
 int madvise_walk_vmas(struct mm_struct *mm, unsigned long start,
-		      unsigned long end, struct madvise_behavior *madv_behavior,
-		      void *arg,
-		      int (*visit)(struct vm_area_struct *vma,
-				   struct vm_area_struct **prev, unsigned long start,
-				   unsigned long end, void *arg))
+		      unsigned long end, struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma;
 	struct vm_area_struct *prev;
@@ -1548,11 +1598,12 @@ int madvise_walk_vmas(struct mm_struct *
 	 * If VMA read lock is supported, apply madvise to a single VMA
 	 * tentatively, avoiding walking VMAs.
 	 */
-	if (madv_behavior && madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
+	if (madv_behavior->lock_mode == MADVISE_VMA_READ_LOCK) {
 		vma = try_vma_read_lock(mm, madv_behavior, start, end);
 		if (vma) {
 			prev = vma;
-			error = visit(vma, &prev, start, end, arg);
+			error = madvise_vma_behavior(vma, &prev, start, end,
+						     madv_behavior);
 			vma_end_read(vma);
 			return error;
 		}
@@ -1586,7 +1637,8 @@ int madvise_walk_vmas(struct mm_struct *
 			tmp = end;
 
 		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
-		error = visit(vma, &prev, start, tmp, arg);
+		error = madvise_vma_behavior(vma, &prev, start, tmp,
+					     madv_behavior);
 		if (error)
 			return error;
 		start = tmp;
@@ -1603,57 +1655,6 @@ int madvise_walk_vmas(struct mm_struct *
 	return unmapped_error;
 }
 
-#ifdef CONFIG_ANON_VMA_NAME
-static int madvise_vma_anon_name(struct vm_area_struct *vma,
-				 struct vm_area_struct **prev,
-				 unsigned long start, unsigned long end,
-				 void *anon_name)
-{
-	int error;
-
-	/* Only anonymous mappings can be named */
-	if (vma->vm_file && !vma_is_anon_shmem(vma))
-		return -EBADF;
-
-	error = madvise_update_vma(vma, prev, start, end, vma->vm_flags,
-				   anon_name);
-
-	/*
-	 * madvise() returns EAGAIN if kernel resources, such as
-	 * slab, are temporarily unavailable.
-	 */
-	if (error == -ENOMEM)
-		error = -EAGAIN;
-	return error;
-}
-
-int madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
-			  unsigned long len_in, struct anon_vma_name *anon_name)
-{
-	unsigned long end;
-	unsigned long len;
-
-	if (start & ~PAGE_MASK)
-		return -EINVAL;
-	len = (len_in + ~PAGE_MASK) & PAGE_MASK;
-
-	/* Check to see whether len was rounded up from small -ve to zero */
-	if (len_in && !len)
-		return -EINVAL;
-
-	end = start + len;
-	if (end < start)
-		return -EINVAL;
-
-	if (end == start)
-		return 0;
-
-	return madvise_walk_vmas(mm, start, end, NULL, anon_name,
-				 madvise_vma_anon_name);
-}
-#endif /* CONFIG_ANON_VMA_NAME */
-
-
 /*
  * Any behaviour which results in changes to the vma->vm_flags needs to
  * take mmap_lock for writing. Others, which simply traverse vmas, need
@@ -1845,8 +1846,7 @@ static int madvise_do_behavior(struct mm
 	if (is_madvise_populate(behavior))
 		error = madvise_populate(mm, start, end, behavior);
 	else
-		error = madvise_walk_vmas(mm, start, end, madv_behavior,
-				madv_behavior, madvise_vma_behavior);
+		error = madvise_walk_vmas(mm, start, end, madv_behavior);
 	blk_finish_plug(&plug);
 	return error;
 }
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-files-to-mm-page-alloc-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-use-per_vma-lock-for-madv_dontneed-fix.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge-fix.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument.patch
mm-change-vm_get_page_prot-to-accept-vm_flags_t-argument-fix.patch
mm-update-core-kernel-code-to-use-vm_flags_t-consistently.patch
mm-update-architecture-and-driver-code-to-use-vm_flags_t.patch
mm-madvise-remove-the-visitor-pattern-and-thread-anon_vma-state.patch
mm-madvise-thread-mm_struct-through-madvise_behavior.patch
mm-madvise-thread-vma-range-state-through-madvise_behavior.patch
mm-madvise-thread-all-madvise-state-through-madv_behavior.patch
mm-madvise-eliminate-very-confusing-manipulation-of-prev-vma.patch

