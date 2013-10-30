From: akpm@linux-foundation.org
Subject: [failures] mm-rearrange-madvise-code-to-allow-for-reuse.patch
 removed from -mm tree
Date: Wed, 30 Oct 2013 13:50:45 -0700
Message-ID: <52717125.BisxVg+wiXd/fpjj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab3J3Uuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 16:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, walken@google.com, viro@zeniv.linux.org.uk, tangchen@cn.fujitsu.com, shli@fusionio.com, serge.hallyn@ubuntu.com, sasha.levin@oracle.com, rob@landley.net, rientjes@google.com, riel@redhat.com, peterz@infradead.org, penberg@kernel.org, oleg@redhat.com, mingo@kernel.org, mgorman@suse.de, keescook@chromium.org, john.stultz@linaro.org, jan.glauber@gmail.com, hughd@google.com, holt@sgi.com, hannes@cmpxchg.org, gorcunov@openvz.org, ebiederm@xmission.com, dave.hansen@intel.com, ccross@android.com

Subject: [failures] mm-rearrange-madvise-code-to-allow-for-reuse.patch removed from -mm tree
To: ccross@android.com,dave.hansen@intel.com,ebiederm@xmission.com,gorcunov@openvz.org,hannes@cmpxchg.org,holt@sgi.com,hughd@google.com,jan.glauber@gmail.com,john.stultz@linaro.org,keescook@chromium.org,mgorman@suse.de,mingo@kernel.org,oleg@redhat.com,penberg@kernel.org,peterz@infradead.org,riel@redhat.com,rientjes@google.com,rob@landley.net,sasha.levin@oracle.com,serge.hallyn@ubuntu.com,shli@fusionio.com,tangchen@cn.fujitsu.com,viro@zeniv.linux.org.uk,walken@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 13:50:45 -0700


The patch titled
     Subject: mm: rearrange madvise code to allow for reuse
has been removed from the -mm tree.  Its filename was
     mm-rearrange-madvise-code-to-allow-for-reuse.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Colin Cross <ccross@android.com>
Subject: mm: rearrange madvise code to allow for reuse

Refactor the madvise syscall to allow for parts of it to be reused by a
prctl syscall that affects vmas.

Move the code that walks vmas in a virtual address range into a function
that takes a function pointer as a parameter.  The only caller for now is
sys_madvise, which uses it to call madvise_vma_behavior on each vma, but
the next patch will add an additional caller.

Move handling all vma behaviors inside madvise_behavior, and rename it to
madvise_vma_behavior.

Move the code that updates the flags on a vma, including splitting or
merging the vma as necessary, into a new function called
madvise_update_vma.  The next patch will add support for updating a new
anon_name field as well.

Signed-off-by: Colin Cross <ccross@android.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jan Glauber <jan.glauber@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Rob Landley <rob@landley.net>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |  272 +++++++++++++++++++++++++++----------------------
 1 file changed, 151 insertions(+), 121 deletions(-)

diff -puN mm/madvise.c~mm-rearrange-madvise-code-to-allow-for-reuse mm/madvise.c
--- a/mm/madvise.c~mm-rearrange-madvise-code-to-allow-for-reuse
+++ a/mm/madvise.c
@@ -39,65 +39,20 @@ static int madvise_need_mmap_write(int b
 }
 
 /*
- * We can potentially split a vm area into separate
- * areas, each area with its own behavior.
+ * Update the vm_flags on regiion of a vma, splitting it or merging it as
+ * necessary.  Must be called with mmap_sem held for writing;
  */
-static long madvise_behavior(struct vm_area_struct *vma,
-		     struct vm_area_struct **prev,
-		     unsigned long start, unsigned long end, int behavior)
+static int madvise_update_vma(struct vm_area_struct *vma,
+		     struct vm_area_struct **prev, unsigned long start,
+		     unsigned long end, unsigned long new_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	int error = 0;
 	pgoff_t pgoff;
-	unsigned long new_flags = vma->vm_flags;
-
-	switch (behavior) {
-	case MADV_NORMAL:
-		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
-		break;
-	case MADV_SEQUENTIAL:
-		new_flags = (new_flags & ~VM_RAND_READ) | VM_SEQ_READ;
-		break;
-	case MADV_RANDOM:
-		new_flags = (new_flags & ~VM_SEQ_READ) | VM_RAND_READ;
-		break;
-	case MADV_DONTFORK:
-		new_flags |= VM_DONTCOPY;
-		break;
-	case MADV_DOFORK:
-		if (vma->vm_flags & VM_IO) {
-			error = -EINVAL;
-			goto out;
-		}
-		new_flags &= ~VM_DONTCOPY;
-		break;
-	case MADV_DONTDUMP:
-		new_flags |= VM_DONTDUMP;
-		break;
-	case MADV_DODUMP:
-		if (new_flags & VM_SPECIAL) {
-			error = -EINVAL;
-			goto out;
-		}
-		new_flags &= ~VM_DONTDUMP;
-		break;
-	case MADV_MERGEABLE:
-	case MADV_UNMERGEABLE:
-		error = ksm_madvise(vma, start, end, behavior, &new_flags);
-		if (error)
-			goto out;
-		break;
-	case MADV_HUGEPAGE:
-	case MADV_NOHUGEPAGE:
-		error = hugepage_madvise(vma, &new_flags, behavior);
-		if (error)
-			goto out;
-		break;
-	}
+	int error;
 
 	if (new_flags == vma->vm_flags) {
 		*prev = vma;
-		goto out;
+		return 0;
 	}
 
 	pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
@@ -113,13 +68,13 @@ static long madvise_behavior(struct vm_a
 	if (start != vma->vm_start) {
 		error = split_vma(mm, vma, start, 1);
 		if (error)
-			goto out;
+			return error;
 	}
 
 	if (end != vma->vm_end) {
 		error = split_vma(mm, vma, end, 0);
 		if (error)
-			goto out;
+			return error;
 	}
 
 success:
@@ -128,10 +83,7 @@ success:
 	 */
 	vma->vm_flags = new_flags;
 
-out:
-	if (error == -ENOMEM)
-		error = -EAGAIN;
-	return error;
+	return 0;
 }
 
 #ifdef CONFIG_SWAP
@@ -337,6 +289,77 @@ static long madvise_remove(struct vm_are
 	return error;
 }
 
+/*
+ * Apply an madvise behavior to a region of a vma.  madvise_update_vma
+ * will handle splitting a vm area into separate areas, each area with its own
+ * behavior.
+ */
+static int madvise_vma_behavior(struct vm_area_struct *vma,
+		     struct vm_area_struct **prev,
+		     unsigned long start, unsigned long end,
+		     unsigned long behavior)
+{
+	int error = 0;
+	unsigned long new_flags = vma->vm_flags;
+
+	switch (behavior) {
+	case MADV_REMOVE:
+		return madvise_remove(vma, prev, start, end);
+	case MADV_WILLNEED:
+		return madvise_willneed(vma, prev, start, end);
+	case MADV_DONTNEED:
+		return madvise_dontneed(vma, prev, start, end);
+	case MADV_NORMAL:
+		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
+		break;
+	case MADV_SEQUENTIAL:
+		new_flags = (new_flags & ~VM_RAND_READ) | VM_SEQ_READ;
+		break;
+	case MADV_RANDOM:
+		new_flags = (new_flags & ~VM_SEQ_READ) | VM_RAND_READ;
+		break;
+	case MADV_DONTFORK:
+		new_flags |= VM_DONTCOPY;
+		break;
+	case MADV_DOFORK:
+		if (vma->vm_flags & VM_IO) {
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags &= ~VM_DONTCOPY;
+		break;
+	case MADV_DONTDUMP:
+		new_flags |= VM_DONTDUMP;
+		break;
+	case MADV_DODUMP:
+		if (new_flags & VM_SPECIAL) {
+			error = -EINVAL;
+			goto out;
+		}
+		new_flags &= ~VM_DONTDUMP;
+		break;
+	case MADV_MERGEABLE:
+	case MADV_UNMERGEABLE:
+		error = ksm_madvise(vma, start, end, behavior, &new_flags);
+		if (error)
+			goto out;
+		break;
+	case MADV_HUGEPAGE:
+	case MADV_NOHUGEPAGE:
+		error = hugepage_madvise(vma, &new_flags, behavior);
+		if (error)
+			goto out;
+		break;
+	}
+
+	error = madvise_update_vma(vma, prev, start, end, new_flags);
+
+out:
+	if (error == -ENOMEM)
+		error = -EAGAIN;
+	return error;
+}
+
 #ifdef CONFIG_MEMORY_FAILURE
 /*
  * Error injection support for memory error handling.
@@ -375,22 +398,6 @@ static int madvise_hwpoison(int bhv, uns
 }
 #endif
 
-static long
-madvise_vma(struct vm_area_struct *vma, struct vm_area_struct **prev,
-		unsigned long start, unsigned long end, int behavior)
-{
-	switch (behavior) {
-	case MADV_REMOVE:
-		return madvise_remove(vma, prev, start, end);
-	case MADV_WILLNEED:
-		return madvise_willneed(vma, prev, start, end);
-	case MADV_DONTNEED:
-		return madvise_dontneed(vma, prev, start, end);
-	default:
-		return madvise_behavior(vma, prev, start, end, behavior);
-	}
-}
-
 static int
 madvise_behavior_valid(int behavior)
 {
@@ -421,6 +428,73 @@ madvise_behavior_valid(int behavior)
 }
 
 /*
+ * Walk the vmas in range [start,end), and call the visit function on each one.
+ * The visit function will get start and end parameters that cover the overlap
+ * between the current vma and the original range.  Any unmapped regions in the
+ * original range will result in this function returning -ENOMEM while still
+ * calling the visit function on all of the existing vmas in the range.
+ * Must be called with the mmap_sem held for reading or writing.
+ */
+static
+int madvise_walk_vmas(unsigned long start, unsigned long end,
+		unsigned long arg,
+		int (*visit)(struct vm_area_struct *vma,
+			struct vm_area_struct **prev, unsigned long start,
+			unsigned long end, unsigned long arg))
+{
+	struct vm_area_struct *vma;
+	struct vm_area_struct *prev;
+	unsigned long tmp;
+	int unmapped_error = 0;
+
+	/*
+	 * If the interval [start,end) covers some unmapped address
+	 * ranges, just ignore them, but return -ENOMEM at the end.
+	 * - different from the way of handling in mlock etc.
+	 */
+	vma = find_vma_prev(current->mm, start, &prev);
+	if (vma && start > vma->vm_start)
+		prev = vma;
+
+	for (;;) {
+		int error;
+
+		/* Still start < end. */
+		if (!vma)
+			return -ENOMEM;
+
+		/* Here start < (end|vma->vm_end). */
+		if (start < vma->vm_start) {
+			unmapped_error = -ENOMEM;
+			start = vma->vm_start;
+			if (start >= end)
+				break;
+		}
+
+		/* Here vma->vm_start <= start < (end|vma->vm_end) */
+		tmp = vma->vm_end;
+		if (end < tmp)
+			tmp = end;
+
+		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
+		error = visit(vma, &prev, start, tmp, arg);
+		if (error)
+			return error;
+		start = tmp;
+		if (prev && start < prev->vm_end)
+			start = prev->vm_end;
+		if (start >= end)
+			break;
+		if (prev)
+			vma = prev->vm_next;
+		else	/* madvise_remove dropped mmap_sem */
+			vma = find_vma(current->mm, start);
+	}
+
+	return unmapped_error;
+}
+
+/*
  * The madvise(2) system call.
  *
  * Applications can use madvise() to advise the kernel how it should
@@ -464,9 +538,7 @@ madvise_behavior_valid(int behavior)
  */
 SYSCALL_DEFINE3(madvise, unsigned long, start, size_t, len_in, int, behavior)
 {
-	unsigned long end, tmp;
-	struct vm_area_struct *vma, *prev;
-	int unmapped_error = 0;
+	unsigned long end;
 	int error = -EINVAL;
 	int write;
 	size_t len;
@@ -501,52 +573,10 @@ SYSCALL_DEFINE3(madvise, unsigned long,
 	else
 		down_read(&current->mm->mmap_sem);
 
-	/*
-	 * If the interval [start,end) covers some unmapped address
-	 * ranges, just ignore them, but return -ENOMEM at the end.
-	 * - different from the way of handling in mlock etc.
-	 */
-	vma = find_vma_prev(current->mm, start, &prev);
-	if (vma && start > vma->vm_start)
-		prev = vma;
-
 	blk_start_plug(&plug);
-	for (;;) {
-		/* Still start < end. */
-		error = -ENOMEM;
-		if (!vma)
-			goto out;
-
-		/* Here start < (end|vma->vm_end). */
-		if (start < vma->vm_start) {
-			unmapped_error = -ENOMEM;
-			start = vma->vm_start;
-			if (start >= end)
-				goto out;
-		}
-
-		/* Here vma->vm_start <= start < (end|vma->vm_end) */
-		tmp = vma->vm_end;
-		if (end < tmp)
-			tmp = end;
-
-		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
-		error = madvise_vma(vma, &prev, start, tmp, behavior);
-		if (error)
-			goto out;
-		start = tmp;
-		if (prev && start < prev->vm_end)
-			start = prev->vm_end;
-		error = unmapped_error;
-		if (start >= end)
-			goto out;
-		if (prev)
-			vma = prev->vm_next;
-		else	/* madvise_remove dropped mmap_sem */
-			vma = find_vma(current->mm, start);
-	}
-out:
+	error = madvise_walk_vmas(start, end, behavior, madvise_vma_behavior);
 	blk_finish_plug(&plug);
+
 	if (write)
 		up_write(&current->mm->mmap_sem);
 	else
_

Patches currently in -mm which might be from ccross@android.com are

mm-add-a-field-to-store-names-for-private-anonymous-memory.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix.patch
mm-add-a-field-to-store-names-for-private-anonymous-memory-fix-fix-2.patch
linux-next.patch

