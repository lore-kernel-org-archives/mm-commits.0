Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F642DC35C;
	Mon,  5 Jan 2026 21:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767647502; cv=none; b=WuAwVtXFmaHlJRqYS1D1WjHc2GPkwfOET6YLH7a2+HUFA8zcDy6ge/Zpzq/2llgMZUkfFAj8p/D0pftaHlZriw5p7GsEsU2Gcqga/KMXbhxaJpwzh/wBcvN4lrhOZkXeFAJtXpw8mm8952Wv38EnlAe5j+iDeCfJQdiEpUwH0xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767647502; c=relaxed/simple;
	bh=jscY5jfkxeEUq7lhGXGaPsNM8XwW3Py0Rn3+vBDWrEQ=;
	h=Date:To:From:Subject:Message-Id; b=rRrDGr4JutAn1Qus+8ITET19mJpjRp/U4UHwq8xsoVYC9w2bhmTBZlgSf9TBhL9MDkMrkmd4ubBAY7t7f7PCk1Lzx1pO/f7be7Wqr3kQ2lwM8lPazp68LWX59ACHr8kzvPxF4AODfqUaLD0LpOwQW58z9Y91a9HklbwsWiRgN0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=njELRIH6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="njELRIH6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF099C116D0;
	Mon,  5 Jan 2026 21:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767647501;
	bh=jscY5jfkxeEUq7lhGXGaPsNM8XwW3Py0Rn3+vBDWrEQ=;
	h=Date:To:From:Subject:From;
	b=njELRIH6X88wpK3qH+cchXOSNsjZZv/DKB2L3L8YTSqqDvIgaZceS8hhhgy9yzRZm
	 xxdokA9iFfq94UQhv/3i5IcN4gWt5iggF7z3RjZbIE3eggHbW6e2V5fbYTyeWURQir
	 kSkXmAHqZeipsHeLzH4SMzXi/IoH45nYC44SunVQ=
Date: Mon, 05 Jan 2026 13:11:41 -0800
To: mm-commits@vger.kernel.org,yeoreum.yun@arm.com,vbabka@suse.cz,stable@vger.kernel.org,riel@surriel.com,pfalcato@suse.de,Liam.Howlett@oracle.com,liam.howlett@oracle.com,jannh@google.com,david@kernel.org,aha310510@gmail.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch added to mm-hotfixes-unstable branch
Message-Id: <20260105211141.BF099C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
Date: Mon, 5 Jan 2026 20:11:47 +0000

Patch series "mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
merge", v2.

Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
merges") introduced the ability to merge previously unavailable VMA merge
scenarios.

However, it is handling merges incorrectly when it comes to mremap() of a
faulted VMA adjacent to an unfaulted VMA.  The issues arise in three
cases:

1. Previous VMA unfaulted:

              copied -----|
                          v
	|-----------|.............|
	| unfaulted |(faulted VMA)|
	|-----------|.............|
	     prev

2. Next VMA unfaulted:

              copied -----|
                          v
	            |.............|-----------|
	            |(faulted VMA)| unfaulted |
                    |.............|-----------|
		                      next

3. Both adjacent VMAs unfaulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)| unfaulted |
	|-----------|.............|-----------|
	     prev                      next

This series fixes each of these cases, and introduces self tests to assert
that the issues are corrected.

I also test a further case which was already handled, to assert that my
changes continues to correctly handle it:

4. prev unfaulted, next faulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)|  faulted  |
	|-----------|.............|-----------|
	     prev                      next

This bug was discovered via a syzbot report, linked to in the first patch
in the series, I confirmed that this series fixes the bug.

I also discovered that we are failing to check that the faulted VMA was
not forked when merging a copied VMA in cases 1-3 above, an issue this
series also addresses.

I also added self tests to assert that this is resolved (and confirmed
that the tests failed prior to this).

I also cleaned up vma_expand() as part of this work, renamed
vma_had_uncowed_parents() to vma_is_fork_child() as the previous name was
unduly confusing, and simplified the comments around this function.


This patch (of 4):

Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
merges") introduced the ability to merge previously unavailable VMA merge
scenarios.

The key piece of logic introduced was the ability to merge a faulted VMA
immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
correctly handle anon_vma state.

In the case of the merge of an existing VMA (that is changing properties
of a VMA and then merging if those properties are shared by adjacent
VMAs), dup_anon_vma() is invoked correctly.

However in the case of the merge of a new VMA, a corner case peculiar to
mremap() was missed.

The issue is that vma_expand() only performs dup_anon_vma() if the target
(the VMA that will ultimately become the merged VMA): is not the next VMA,
i.e.  the one that appears after the range in which the new VMA is to be
established.

A key insight here is that in all other cases other than mremap(), a new
VMA merge either expands an existing VMA, meaning that the target VMA will
be that VMA, or would have anon_vma be NULL.

Specifically:

* __mmap_region() - no anon_vma in place, initial mapping.
* do_brk_flags() - expanding an existing VMA.
* vma_merge_extend() - expanding an existing VMA.
* relocate_vma_down() - no anon_vma in place, initial mapping.

In addition, we are in the unique situation of needing to duplicate
anon_vma state from a VMA that is neither the previous or next VMA being
merged with.

dup_anon_vma() deals exclusively with the target=unfaulted, src=faulted
case.  This leaves four possibilities, in each case where the copied VMA
is faulted:

1. Previous VMA unfaulted:

              copied -----|
                          v
	|-----------|.............|
	| unfaulted |(faulted VMA)|
	|-----------|.............|
	     prev

target = prev, expand prev to cover.

2. Next VMA unfaulted:

              copied -----|
                          v
	            |.............|-----------|
	            |(faulted VMA)| unfaulted |
                    |.............|-----------|
		                      next

target = next, expand next to cover.

3. Both adjacent VMAs unfaulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)| unfaulted |
	|-----------|.............|-----------|
	     prev                      next

target = prev, expand prev to cover.

4. prev unfaulted, next faulted:

              copied -----|
                          v
	|-----------|.............|-----------|
	| unfaulted |(faulted VMA)|  faulted  |
	|-----------|.............|-----------|
	     prev                      next

target = prev, expand prev to cover.  Essentially equivalent to 3, but
with additional requirement that next's anon_vma is the same as the copied
VMA's.  This is covered by the existing logic.

To account for this very explicitly, we introduce
vma_merge_copied_range(), which sets a newly introduced vmg->copied_from
field, then invokes vma_merge_new_range() which handles the rest of the
logic.

We then update the key vma_expand() function to clean up the logic and
make what's going on clearer, making the 'remove next' case less special,
before invoking dup_anon_vma() unconditionally should we be copying from a
VMA.

Note that in case 3, the if (remove_next) ...  branch will be a no-op, as
next=src in this instance and src is unfaulted.

In case 4, it won't be, but since in this instance next=src and it is
faulted, this will have required tgt=faulted, src=faulted to be
compatible, meaning that next->anon_vma == vmg->copied_from->anon_vma, and
thus a single dup_anon_vma() of next suffices to copy anon_vma state for
the copied-from VMA also.

If we are copying from a VMA in a successful merge we must _always_
propagate anon_vma state.

This issue can be observed most directly by invoked mremap() to move
around a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
specified.

This will result in unlink_anon_vmas() being called after failing to
duplicate anon_vma state to the target VMA, which results in the anon_vma
itself being freed with folios still possessing dangling pointers to the
anon_vma and thus a use-after-free bug.

This bug was discovered via a syzbot report, which this patch resolves.

We further make a change to update the mergeable anon_vma check to assert
the copied-from anon_vma did not have CoW parents, as otherwise
dup_anon_vma() might incorrectly propagate CoW ancestors from the next VMA
in case 4 despite the anon_vma's being identical for both VMAs.

Link: https://lkml.kernel.org/r/cover.1767638272.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jeongjun Park <aha310510@gmail.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   84 +++++++++++++++++++++++++++++++++++++----------------
 mm/vma.h |    3 +
 2 files changed, 62 insertions(+), 25 deletions(-)

--- a/mm/vma.c~mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge
+++ a/mm/vma.c
@@ -829,6 +829,8 @@ static __must_check struct vm_area_struc
 	VM_WARN_ON_VMG(middle &&
 		       !(vma_iter_addr(vmg->vmi) >= middle->vm_start &&
 			 vma_iter_addr(vmg->vmi) < middle->vm_end), vmg);
+	/* An existing merge can never be used by the mremap() logic. */
+	VM_WARN_ON_VMG(vmg->copied_from, vmg);
 
 	vmg->state = VMA_MERGE_NOMERGE;
 
@@ -1099,6 +1101,33 @@ struct vm_area_struct *vma_merge_new_ran
 }
 
 /*
+ * vma_merge_copied_range - Attempt to merge a VMA that is being copied by
+ * mremap()
+ *
+ * @vmg: Describes the VMA we are adding, in the copied-to range @vmg->start to
+ *       @vmg->end (exclusive), which we try to merge with any adjacent VMAs if
+ *       possible.
+ *
+ * vmg->prev, next, start, end, pgoff should all be relative to the COPIED TO
+ * range, i.e. the target range for the VMA.
+ *
+ * Returns: In instances where no merge was possible, NULL. Otherwise, a pointer
+ *          to the VMA we expanded.
+ *
+ * ASSUMPTIONS: Same as vma_merge_new_range(), except vmg->middle must contain
+ *              the copied-from VMA.
+ */
+static struct vm_area_struct *vma_merge_copied_range(struct vma_merge_struct *vmg)
+{
+	/* We must have a copied-from VMA. */
+	VM_WARN_ON_VMG(!vmg->middle, vmg);
+
+	vmg->copied_from = vmg->middle;
+	vmg->middle = NULL;
+	return vma_merge_new_range(vmg);
+}
+
+/*
  * vma_expand - Expand an existing VMA
  *
  * @vmg: Describes a VMA expansion operation.
@@ -1117,46 +1146,52 @@ struct vm_area_struct *vma_merge_new_ran
 int vma_expand(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *anon_dup = NULL;
-	bool remove_next = false;
 	struct vm_area_struct *target = vmg->target;
 	struct vm_area_struct *next = vmg->next;
+	bool remove_next = false;
 	vm_flags_t sticky_flags;
-
-	sticky_flags = vmg->vm_flags & VM_STICKY;
-	sticky_flags |= target->vm_flags & VM_STICKY;
-
-	VM_WARN_ON_VMG(!target, vmg);
+	int ret = 0;
 
 	mmap_assert_write_locked(vmg->mm);
-
 	vma_start_write(target);
-	if (next && (target != next) && (vmg->end == next->vm_end)) {
-		int ret;
 
-		sticky_flags |= next->vm_flags & VM_STICKY;
+	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
-		/* This should already have been checked by this point. */
-		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
-		vma_start_write(next);
-		/*
-		 * In this case we don't report OOM, so vmg->give_up_on_mm is
-		 * safe.
-		 */
-		ret = dup_anon_vma(target, next, &anon_dup);
-		if (ret)
-			return ret;
-	}
 
+	/* We must have a target. */
+	VM_WARN_ON_VMG(!target, vmg);
+	/* This should have already been checked by this point. */
+	VM_WARN_ON_VMG(remove_next && !can_merge_remove_vma(next), vmg);
 	/* Not merging but overwriting any part of next is not handled. */
 	VM_WARN_ON_VMG(next && !remove_next &&
 		       next != target && vmg->end > next->vm_start, vmg);
-	/* Only handles expanding */
+	/* Only handles expanding. */
 	VM_WARN_ON_VMG(target->vm_start < vmg->start ||
 		       target->vm_end > vmg->end, vmg);
 
+	sticky_flags = vmg->vm_flags & VM_STICKY;
+	sticky_flags |= target->vm_flags & VM_STICKY;
 	if (remove_next)
-		vmg->__remove_next = true;
+		sticky_flags |= next->vm_flags & VM_STICKY;
+
+	/*
+	 * If we are removing the next VMA or copying from a VMA
+	 * (e.g. mremap()'ing), we must propagate anon_vma state.
+	 *
+	 * Note that, by convention, callers ignore OOM for this case, so
+	 * we don't need to account for vmg->give_up_on_mm here.
+	 */
+	if (remove_next)
+		ret = dup_anon_vma(target, next, &anon_dup);
+	if (!ret && vmg->copied_from)
+		ret = dup_anon_vma(target, vmg->copied_from, &anon_dup);
+	if (ret)
+		return ret;
 
+	if (remove_next) {
+		vma_start_write(next);
+		vmg->__remove_next = true;
+	}
 	if (commit_merge(vmg))
 		goto nomem;
 
@@ -1828,10 +1863,9 @@ struct vm_area_struct *copy_vma(struct v
 	if (new_vma && new_vma->vm_start < addr + len)
 		return NULL;	/* should never get here */
 
-	vmg.middle = NULL; /* New VMA range. */
 	vmg.pgoff = pgoff;
 	vmg.next = vma_iter_next_rewind(&vmi, NULL);
-	new_vma = vma_merge_new_range(&vmg);
+	new_vma = vma_merge_copied_range(&vmg);
 
 	if (new_vma) {
 		/*
--- a/mm/vma.h~mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge
+++ a/mm/vma.h
@@ -106,6 +106,9 @@ struct vma_merge_struct {
 	struct anon_vma_name *anon_name;
 	enum vma_merge_state state;
 
+	/* If copied from (i.e. mremap()'d) the VMA from which we are copying. */
+	struct vm_area_struct *copied_from;
+
 	/* Flags which callers can use to modify merge behaviour: */
 
 	/*
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-fix-anon_vma-uaf-on-mremap-faulted-unfaulted-merge.patch
tools-testing-selftests-add-tests-for-tgt-src-mremap-merges.patch
mm-vma-enforce-vma-fork-limit-on-unfaultedfaulted-mremap-merge-too.patch
tools-testing-selftests-add-forked-un-faulted-vma-merge-tests.patch

