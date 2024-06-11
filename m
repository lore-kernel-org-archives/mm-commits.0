Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE92249E5
	for <mm-commits@vger.kernel.org>; Tue, 11 Jun 2024 18:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718130418; cv=none; b=Q/J6SpeDpeLZDTekP2xjG+fgz02tOBhZYk1Cil3yh8uPgtpv27c+UyhmWSiTdvBHwQTs95LG1eumbKO/EpvyvlvyBBmwMVv52oJqgUWzmefkr+q/YatpyrMeETBpcX5PCJ3OUDmPdZ00hYGsm/Aj3UyQ5VNBRbHGcqu2hvGiHOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718130418; c=relaxed/simple;
	bh=u8rmX2vcneBvDf/ad11SAFsLUwvfYHg0DkVcM+1198Y=;
	h=Date:To:From:Subject:Message-Id; b=IOCWtb24ZgqAaIP7mCksMqEbeWJO4RV5Tearu+lEOJjNJzuGlREV76UYGEyqL79zDZCOHNt9Wk5G1JtJiTNbq+sPE5QhyPwqDI2F0YvnBXEhkZMEhNgC5JSj2nzI7RNo7vlZaOaOPo7EsUKeIGk1XC60W3spFpSxLMJS6wvQptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WAIrqhds; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WAIrqhds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B32C2BD10;
	Tue, 11 Jun 2024 18:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718130418;
	bh=u8rmX2vcneBvDf/ad11SAFsLUwvfYHg0DkVcM+1198Y=;
	h=Date:To:From:Subject:From;
	b=WAIrqhdsCWtSYKA+u6GK5RFiY3SSa6zjSJtbEwXH8Ui7KHoC5rrtA+6A8ZvGhWNWC
	 QmcRSKo4rOhbOilIHSZEvH08LhEoL24kKn23A3VTWw5VzY+3QAc3fednNjgm1i1IU9
	 uFqSIF5hrYcIu5A/C918/OuuPWlM5dndM7D0u9tw=
Date: Tue, 11 Jun 2024 11:26:57 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,lstoakes@gmail.com,Liam.Howlett@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch added to mm-unstable branch
Message-Id: <20240611182658.32B32C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmap: correctly position vma_iterator in __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch

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
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: mm/mmap: correctly position vma_iterator in __split_vma()
Date: Tue, 11 Jun 2024 14:01:53 -0400

Patch series "Avoid MAP_FIXED gap exposure".

It is now possible to walk the vma tree using the rcu read locks and is
beneficial to do so to reduce lock contention.  Doing so while a MAP_FIXED
mapping is executing means that a reader may see a gap in the vma tree
that should never logically exist - and does not when using the mmap lock
in read mode.  The temporal gap exists because mmap_region() calls
munmap() prior to installing the new mapping.

This patchset stops rcu readers from seeing the temporal gap by splitting
up the munmap() function into two parts.  The first part prepares the vma
tree for modifications by doing the necessary splits and tracks the vmas
marked for removal in a side tree.  The second part completes the
munmapping of the vmas after the vma tree has been overwritten (either by
a MAP_FIXED replacement vma or by a NULL in the munmap() case).

Please note that rcu walkers will still be able to see a temporary state
of split vmas that may be in the process of being removed, but the
temporal gap will not be exposed.  vma_start_write() are called on both
parts of the split vma, so this state is detectable.


This patch (of 8):

The vma iterator may be left pointing to the newly created vma.  This
happens when inserting the new vma at the end of the old vma (!new_below).

The incorrect position in the vma iterator is not exposed currently since
the vma iterator is repositioned in the munmap path and is not reused in
any of the other paths.

This has limited impact in the current code, but is required for future
changes.

Link: https://lkml.kernel.org/r/20240611180200.711239-1-Liam.Howlett@oracle.com
Link: https://lkml.kernel.org/r/20240611180200.711239-2-Liam.Howlett@oracle.com
Fixes: b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mmap.c~mm-mmap-correctly-position-vma_iterator-in-__split_vma
+++ a/mm/mmap.c
@@ -2414,7 +2414,7 @@ static void unmap_region(struct mm_struc
 /*
  * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
  * has already been checked or doesn't make sense to fail.
- * VMA Iterator will point to the end VMA.
+ * VMA Iterator will point to the original vma.
  */
 static int __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		       unsigned long addr, int new_below)
@@ -2483,6 +2483,9 @@ static int __split_vma(struct vma_iterat
 	/* Success. */
 	if (new_below)
 		vma_next(vmi);
+	else
+		vma_prev(vmi);
+
 	return 0;
 
 out_free_mpol:
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are

mm-mmap-correctly-position-vma_iterator-in-__split_vma.patch
mm-mmap-introduce-abort_munmap_vmas.patch
mm-mmap-introduce-vmi_complete_munmap_vmas.patch
mm-mmap-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-mmap-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-mmap-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-mmap-extract-validate_mm-from-vma_complete.patch
mm-mmap-use-split-munmap-calls-for-map_fixed.patch

