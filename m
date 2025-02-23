Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAAB17E;
	Sun, 23 Feb 2025 01:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740274126; cv=none; b=g/iXnb7YsPV7y8j+kNIzcTp7v8GW0XdNPtWHrz+GNKc2jRKlx1okRQvr6URnuRBwPkQxHx1MC8BC/J6kD6JTobwYv8t2/csQpTYgkofCTT7Fvtxly0A5SD+VHRs7Z+1yU+jy6HMiqzt5+PxuqzEKjlTkF8Ar7oVwZoMh/lDL0m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740274126; c=relaxed/simple;
	bh=iy96ZO+fnral8l+i76OLz1HnMPhU5OCWUJzFn2731QE=;
	h=Date:To:From:Subject:Message-Id; b=FWdpjjl2iOwKIIKIh1h79uJ7qLpD3ygry81TqP3jYPd4bfq/klFKkP454lSjZn71jFymC98rLm5sMkGc9/7DmdikSUOnn6yaTM1xiYtv8AimTUBwgeY2ktutQ57y/BzggpkwKx7V7Kr4MozBIuScpX/kzWV55TYZUWdwE6B2IAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Phcv7KxN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Phcv7KxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB89C4CED1;
	Sun, 23 Feb 2025 01:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740274125;
	bh=iy96ZO+fnral8l+i76OLz1HnMPhU5OCWUJzFn2731QE=;
	h=Date:To:From:Subject:From;
	b=Phcv7KxNgVHKdrT/E1v9wyMrwmX0ug3o+OteeEbTOSWJZTabm+QCGOyp7YFtN0Kym
	 qqt6jXhwnZCfJNd4rKihEZ9Nc0E/c/XlrLeVJFZTRkfpWokSPzDSJ3jKbYI+PrXy8M
	 6ux4DlhFLCtnjIqtp+2+U6pvpmrIfHyj6J4pLprg=
Date: Sat, 22 Feb 2025 17:28:44 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,liam.howlett@oracle.com,jannh@google.com,brad.spengler@opensrcsec.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abort-vma_modify-on-merge-out-of-memory-failure.patch added to mm-hotfixes-unstable branch
Message-Id: <20250223012845.7EB89C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: abort vma_modify() on merge out of memory failure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-abort-vma_modify-on-merge-out-of-memory-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abort-vma_modify-on-merge-out-of-memory-failure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: abort vma_modify() on merge out of memory failure
Date: Sat, 22 Feb 2025 16:19:52 +0000

The remainder of vma_modify() relies upon the vmg state remaining pristine
after a merge attempt.

Usually this is the case, however in the one edge case scenario of a merge
attempt failing not due to the specified range being unmergeable, but
rather due to an out of memory error arising when attempting to commit the
merge, this assumption becomes untrue.

This results in vmg->start, end being modified, and thus the proceeding
attempts to split the VMA will be done with invalid start/end values.

Thankfully, it is likely practically impossible for us to hit this in
reality, as it would require a maple tree node pre-allocation failure that
would likely never happen due to it being 'too small to fail', i.e.  the
kernel would simply keep retrying reclaim until it succeeded.

However, this scenario remains theoretically possible, and what we are
doing here is wrong so we must correct it.

The safest option is, when this scenario occurs, to simply give up the
operation.  If we cannot allocate memory to merge, then we cannot allocate
memory to split either (perhaps moreso!).

Any scenario where this would be happening would be under very extreme
(likely fatal) memory pressure, so it's best we give up early.

So there is no doubt it is appropriate to simply bail out in this
scenario.

However, in general we must if at all possible never assume VMG state is
stable after a merge attempt, since merge operations update VMG fields. 
As a result, additionally also make this clear by storing start, end in
local variables.

The issue was reported originally by syzkaller, and by Brad Spengler (via
an off-list discussion), and in both instances it manifested as a
triggering of the assert:

	VM_WARN_ON_VMG(start >= end, vmg);

In vma_merge_existing_range().

It seems at least one scenario in which this is occurring is one in which
the merge being attempted is due to an madvise() across multiple VMAs
which looks like this:

        start     end
          |<------>|
     |----------|------|
     |   vma    | next |
     |----------|------|

When madvise_walk_vmas() is invoked, we first find vma in the above
(determining prev to be equal to vma as we are offset into vma), and then
enter the loop.

We determine the end of vma that forms part of the range we are
madvise()'ing by setting 'tmp' to this value:

		/* Here vma->vm_start <= start < (end|vma->vm_end) */
		tmp = vma->vm_end;

We then invoke the madvise() operation via visit(), letting prev get
updated to point to vma as part of the operation:

		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
		error = visit(vma, &prev, start, tmp, arg);

Where the visit() function pointer in this instance is
madvise_vma_behavior().

As observed in syzkaller reports, it is ultimately madvise_update_vma()
that is invoked, calling vma_modify_flags_name() and vma_modify() in turn.

Then, in vma_modify(), we attempt the merge:

	merged = vma_merge_existing_range(vmg);
	if (merged)
		return merged;

We invoke this with vmg->start, end set to start, tmp as such:

        start  tmp
          |<--->|
     |----------|------|
     |   vma    | next |
     |----------|------|

We find ourselves in the merge right scenario, but the one in which we
cannot remove the middle (we are offset into vma).

Here we have a special case where vmg->start, end get set to perhaps
unintuitive values - we intended to shrink the middle VMA and expand the
next.

This means vmg->start, end are set to...  vma->vm_start, start.

Now the commit_merge() fails, and vmg->start, end are left like this. 
This means we return to the rest of vma_modify() with vmg->start, end
(here denoted as start', end') set as:

  start' end'
     |<-->|
     |----------|------|
     |   vma    | next |
     |----------|------|

So we now erroneously try to split accordingly.  This is where the
unfortunate stuff begins.

We start with:

	/* Split any preceding portion of the VMA. */
	if (vma->vm_start < vmg->start) {
		...
	}

This doesn't trigger as we are no longer offset into vma at the start.

But then we invoke:

	/* Split any trailing portion of the VMA. */
	if (vma->vm_end > vmg->end) {
		...
	}

Which does get invoked. This leaves us with:

  start' end'
     |<-->|
     |----|-----|------|
     | vma| new | next |
     |----|-----|------|

We then return ultimately to madvise_walk_vmas().  Here 'new' is unknown,
and putting back the values known in this function we are faced with:

        start tmp end
          |     |  |
     |----|-----|------|
     | vma| new | next |
     |----|-----|------|
      prev

Then:

		start = tmp;

So:

             start end
                |  |
     |----|-----|------|
     | vma| new | next |
     |----|-----|------|
      prev

The following code does not cause anything to happen:

		if (prev && start < prev->vm_end)
			start = prev->vm_end;
		if (start >= end)
			break;

And then we invoke:

		if (prev)
			vma = find_vma(mm, prev->vm_end);

Which is where a problem occurs - we don't know about 'new' so we
essentially look for the vma after prev, which is new, whereas we actually
intended to discover next!

So we end up with:

             start end
                |  |
     |----|-----|------|
     |prev| vma | next |
     |----|-----|------|

And we have successfully bypassed all of the checks madvise_walk_vmas()
has to ensure early exit should we end up moving out of range.

We loop around, and hit:

		/* Here vma->vm_start <= start < (end|vma->vm_end) */
		tmp = vma->vm_end;

Oh dear. Now we have:

              tmp
             start end
                |  |
     |----|-----|------|
     |prev| vma | next |
     |----|-----|------|

We then invoke:

		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
		error = visit(vma, &prev, start, tmp, arg);

Where start == tmp. That is, a zero range. This is not good.

We invoke visit() which is madvise_vma_behavior() which does not check the
range (for good reason, it assumes all checks have been done before it was
called), which in turn finally calls madvise_update_vma().

The madvise_update_vma() function calls vma_modify_flags_name() in turn,
which ultimately invokes vma_modify() with...  start == end.

vma_modify() calls vma_merge_existing_range() and finally we hit:

	VM_WARN_ON_VMG(start >= end, vmg);

Which triggers, as start == end.

While it might be useful to add some CONFIG_DEBUG_VM asserts in these
instances to catch this kind of error, since we have just eliminated any
possibility of that happening, we will add such asserts separately as to
reduce churn and aid backporting.

Link: https://lkml.kernel.org/r/20250222161952.41957-1-lorenzo.stoakes@oracle.com
Fixes: 2f1c6611b0a8 ("mm: introduce vma_merge_struct and abstract vma_merge(),vma_modify()")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Brad Spengler <brad.spengler@opensrcsec.com>
Reported-by: Brad Spengler <brad.spengler@opensrcsec.com>
Reported-by: syzbot+46423ed8fa1f1148c6e4@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/6774c98f.050a0220.25abdd.0991.GAE@google.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/vma.c~mm-abort-vma_modify-on-merge-out-of-memory-failure
+++ a/mm/vma.c
@@ -1509,24 +1509,28 @@ int do_vmi_munmap(struct vma_iterator *v
 static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *vma = vmg->vma;
+	unsigned long start = vmg->start;
+	unsigned long end = vmg->end;
 	struct vm_area_struct *merged;
 
 	/* First, try to merge. */
 	merged = vma_merge_existing_range(vmg);
 	if (merged)
 		return merged;
+	if (vmg_nomem(vmg))
+		return ERR_PTR(-ENOMEM);
 
 	/* Split any preceding portion of the VMA. */
-	if (vma->vm_start < vmg->start) {
-		int err = split_vma(vmg->vmi, vma, vmg->start, 1);
+	if (vma->vm_start < start) {
+		int err = split_vma(vmg->vmi, vma, start, 1);
 
 		if (err)
 			return ERR_PTR(err);
 	}
 
 	/* Split any trailing portion of the VMA. */
-	if (vma->vm_end > vmg->end) {
-		int err = split_vma(vmg->vmi, vma, vmg->end, 0);
+	if (vma->vm_end > end) {
+		int err = split_vma(vmg->vmi, vma, end, 0);
 
 		if (err)
 			return ERR_PTR(err);
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-abort-vma_modify-on-merge-out-of-memory-failure.patch
mm-simplify-vma-merge-structure-and-expand-comments.patch
mm-further-refactor-commit_merge.patch
mm-eliminate-adj_start-parameter-from-commit_merge.patch
mm-make-vmg-target-consistent-and-further-simplify-commit_merge.patch
mm-completely-abstract-unnecessary-adj_start-calculation.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise-fix.patch
mm-use-read-write_once-for-vma-vm_flags-on-migrate-mprotect.patch
mm-refactor-rmap_walk_file-to-separate-out-traversal-logic.patch
mm-provide-mapping_wrprotect_range-function.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields.patch
fb_defio-do-not-use-deprecated-page-mapping-index-fields-fix.patch
mm-allow-guard-regions-in-file-backed-and-read-only-mappings.patch
selftests-mm-rename-guard-pages-to-guard-regions.patch
tools-selftests-expand-all-guard-region-tests-to-file-backed.patch
tools-selftests-add-file-shmem-backed-mapping-guard-region-tests.patch

