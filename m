Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B1140756D
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723656; cv=none; b=CejUjYgq+Y/6aiqY3lveuWeBhuIydV5AW1EAIRm+N0sNAAl1vcP16qt7cd4bbK7OL/ztADGRaudOEDPmua0IlhVHn0nRuoNFIXbpa2u0Nk+mq0/GdRK7rg6lJxauTFIqv7i0l5CUuRNwYOOkSWVOhYnWOIiBls+CXP82Q73YbG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723656; c=relaxed/simple;
	bh=RGH3V4JC/fbhgutkHOxQM/fEpSmh9gSb37scHD2W3Uw=;
	h=Date:To:From:Subject:Message-Id; b=D7f93nobNnXdU/WiKjfMnZYVKL0lOWxkYDaPFFq8R+4iy1Iy5vOZeOXMOFGSlXZV/ONjUsX3UeBfIzOnhuMUYtVM8XeoLu8GQjZabrIwmHOh66ufCms4aVE1z1uoQFCBTc39WiXrxnUAAOkc4UU2rXeRQkGQgWvjxBF3NuBvYp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tolsmCyP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tolsmCyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13281F000E9;
	Fri, 10 Jul 2026 22:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723654;
	bh=s/ou2lFnyKg1uDqNCmawXkZg2BPSP9C0NSQSZ6Zx4+A=;
	h=Date:To:From:Subject;
	b=tolsmCyPSFEgnhB4dZWG/CWS0RAqNMnV05DvxdTXd/NwkQ+NtGZdBcXtQAKxx/QnJ
	 /STnkiu3Va6Rwg7EVr53ewIhDG4DdQCv3a5pSgwFyVYVAvF7O8H+CWOQ+rgFtKKgl5
	 tQgvpvBjJXuqtTieFnzAJ5wsrw1NWmRqCvyRN7BA=
Date: Fri, 10 Jul 2026 15:47:34 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-use-guard-clauses-in-can_vma_merge_.patch added to mm-new branch
Message-Id: <20260710224734.A13281F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: use guard clauses in can_vma_merge_[before, after]()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-use-guard-clauses-in-can_vma_merge_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-use-guard-clauses-in-can_vma_merge_.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: use guard clauses in can_vma_merge_[before, after]()
Date: Fri, 10 Jul 2026 21:17:12 +0100

Rather than combining a bunch of conditionals in a single expression,
simplify by inverting the mergeability requirements into guard clauses.

that is - instead of checking what must be true for the conditions to be
met, instead check the inverse of the requirements and return false if any
are true, defaulting to true.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-31-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/mm/vma.c~mm-vma-use-guard-clauses-in-can_vma_merge_
+++ a/mm/vma.c
@@ -215,13 +215,13 @@ static void init_multi_vma_prep(struct v
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
-			return true;
-	}
-
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
+		return false;
+	return true;
 }
 
 /*
@@ -235,12 +235,13 @@ static bool can_vma_merge_before(struct
  */
 static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
-			return true;
-	}
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
+		return false;
+	return true;
 }
 
 static void __vma_link_file(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

