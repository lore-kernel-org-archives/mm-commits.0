Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6C73750B1
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773261700; cv=none; b=nnjWyMZTQko1PNq4XPGtH6Z/mK2iJP6zGew1Wk+WQuulAgKu8HX0RMyPMlWOgDoDRASaKc3nBEKkNAgxF3NQ3CYMbSXGia3tSIqEw6eoslLrFc9zQQlyLi2RlVaPH42wqWSxGPkLXmHkclIiPlmhEDKrdc1IKdVYHGXz7me9OLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773261700; c=relaxed/simple;
	bh=wEsdX94CQvMiEssD0+A2qZ7UswPQKOf2RAedxeiwnzk=;
	h=Date:To:From:Subject:Message-Id; b=KXH06HU2tndt1GltoJvHyUgd2bXb0PDskAky61zmvKII30C1E0LyJg4iRhYm0ZL+hi3xG/JZlY8lq501SIoDb2XJJcfXyzrkeAwZo7ngQiuXRQVuqefsofhMUtMEWvx6i7vqfaC/JQxW6i1xMIaDZ9fRyf51AT+YI9/p4VFxEEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ngb6zibS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ngb6zibS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9D8C4CEF7;
	Wed, 11 Mar 2026 20:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773261700;
	bh=wEsdX94CQvMiEssD0+A2qZ7UswPQKOf2RAedxeiwnzk=;
	h=Date:To:From:Subject:From;
	b=Ngb6zibSt2vZARLrgSt9OkdyMS3/oZe+2hrj/SScTZXUl2zoWEZCrTnEH5nRN011K
	 00jm5iUAMKAng8/7pPT4p3eABQjPTLuooxKFMm+Nr9WeubmzJu2pxpprEgSFDtwpIX
	 6al022xlPbXk62AsbrdbVJL+ninPvHHSHCI08bNE=
Date: Wed, 11 Mar 2026 13:41:39 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,mhocko@suse.com,luckd0g@163.com,liam.howlett@oracle.com,jannh@google.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch added to mm-new branch
Message-Id: <20260311204140.3F9D8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: check map count under mmap write lock and abstract
has been added to the -mm mm-new branch.  Its filename is
     mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/mremap: check map count under mmap write lock and abstract
Date: Wed, 11 Mar 2026 17:24:38 +0000

We are checking the mmap count in check_mremap_params(), prior to
obtaining an mmap write lock, which means that accesses to
current->mm->map_count might race with this field being updated.

Resolve this by only checking this field after the mmap write lock is held.

Additionally, abstract this check into a helper function with extensive
ASCII documentation of what's going on.

Link: https://lkml.kernel.org/r/18be0b48eaa8e8804eb745974ee729c3ade0c687.1773249037.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reported-by: Jianzhou Zhao <luckd0g@163.com>
Closes: https://lore.kernel.org/all/1a7d4c26.6b46.19cdbe7eaf0.Coremail.luckd0g@163.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   88 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 75 insertions(+), 13 deletions(-)

--- a/mm/mremap.c~mm-mremap-check-map-count-under-mmap-write-lock-and-abstract
+++ a/mm/mremap.c
@@ -1028,6 +1028,75 @@ static void vrm_stat_account(struct vma_
 		mm->locked_vm += pages;
 }
 
+static bool __check_map_count_against_split(struct mm_struct *mm,
+					    bool before_unmaps)
+{
+	const int sys_map_count = get_sysctl_max_map_count();
+	int map_count = mm->map_count;
+
+	mmap_assert_write_locked(mm);
+
+	/*
+	 * At the point of shrinking the VMA, if new_len < old_len, we unmap
+	 * thusly in the worst case:
+	 *
+	 *              old_addr+old_len                    old_addr+old_len
+	 * |---------------.----.---------|    |---------------|    |---------|
+	 * |               .    .         | -> |      +1       | -1 |   +1    |
+	 * |---------------.----.---------|    |---------------|    |---------|
+	 *        old_addr+new_len                     old_addr+new_len
+	 *
+	 * At the point of removing the portion of an existing VMA to make space
+	 * for the moved VMA if MREMAP_FIXED, we unmap thusly in the worst case:
+	 *
+	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
+	 * |----.---------------.---------|    |----|               |---------|
+	 * |    .               .         | -> | +1 |      -1       |   +1    |
+	 * |----.---------------.---------|    |----|               |---------|
+	 *
+	 * Therefore, before we consider the move anything, we have to account
+	 * for 2 additional VMAs possibly being created upon these unmappings.
+	 */
+	if (before_unmaps)
+		map_count += 2;
+
+	/*
+	 * At the point of MOVING the VMA:
+	 *
+	 * We start by copying a VMA, which creates an additional VMA if no
+	 * merge occurs, then if not MREMAP_DONTUNMAP, we unmap the source VMA.
+	 * In the worst case we might then observe:
+	 *
+	 *   new_addr   new_addr+new_len         new_addr   new_addr+new_len
+	 * |----|               |---------|    |----|---------------|---------|
+	 * |    |               |         | -> |    |      +1       |         |
+	 * |----|               |---------|    |----|---------------|---------|
+	 *
+	 *   old_addr   old_addr+old_len         old_addr   old_addr+old_len
+	 * |----.---------------.---------|    |----|               |---------|
+	 * |    .               .         | -> | +1 |      -1       |   +1    |
+	 * |----.---------------.---------|    |----|               |---------|
+	 *
+	 * Therefore we must check to ensure we have headroom of 2 additional
+	 * VMAs.
+	 */
+	return map_count + 2 <= sys_map_count;
+}
+
+/* Do we violate the map count limit if we split VMAs when moving the VMA? */
+static bool check_map_count_against_split(void)
+{
+	return __check_map_count_against_split(current->mm,
+					       /*before_unmaps=*/false);
+}
+
+/* Do we violate the map count limit if we split VMAs prior to early unmaps? */
+static bool check_map_count_against_split_early(void)
+{
+	return __check_map_count_against_split(current->mm,
+					       /*before_unmaps=*/true);
+}
+
 /*
  * Perform checks before attempting to write a VMA prior to it being
  * moved.
@@ -1045,7 +1114,7 @@ static unsigned long prep_move_vma(struc
 	 * which may not merge, then (if MREMAP_DONTUNMAP is not set) unmap the
 	 * source, which may split, causing a net increase of 2 mappings.
 	 */
-	if (current->mm->map_count + 2 > get_sysctl_max_map_count())
+	if (!check_map_count_against_split())
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1804,18 +1873,6 @@ static unsigned long check_mremap_params
 	if (vrm_overlaps(vrm))
 		return -EINVAL;
 
-	/*
-	 * We may unmap twice before invoking move_vma(), that is if new_len <
-	 * old_len (shrinking), and in the MREMAP_FIXED case, unmapping part of
-	 * a VMA located at the destination.
-	 *
-	 * In the worst case, both unmappings will cause splits, resulting in a
-	 * net increased map count of 2. In move_vma() we check for headroom of
-	 * 2 additional mappings, so check early to avoid bailing out then.
-	 */
-	if (current->mm->map_count + 4 > get_sysctl_max_map_count())
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -1925,6 +1982,11 @@ static unsigned long do_mremap(struct vm
 		return -EINTR;
 	vrm->mmap_locked = true;
 
+	if (!check_map_count_against_split_early()) {
+		mmap_write_unlock(mm);
+		return -ENOMEM;
+	}
+
 	if (vrm_move_only(vrm)) {
 		res = remap_move(vrm);
 	} else {
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-rename-vma-flag-helpers-to-be-more-readable.patch
mm-add-vma_desc_test_all-and-use-it.patch
mm-always-inline-__mk_vma_flags-and-invoked-functions.patch
mm-reintroduce-vma_flags_test-as-a-singular-flag-test.patch
mm-reintroduce-vma_desc_test-as-a-singular-flag-test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test.patch
tools-testing-vma-add-test-for-vma_flags_test-vma_desc_test-fix.patch
mm-mremap-correct-invalid-map-count-check.patch
mm-abstract-reading-sysctl_max_map_count-and-read_once.patch
mm-mremap-check-map-count-under-mmap-write-lock-and-abstract.patch

