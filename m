Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066F408631
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723628; cv=none; b=ouLIjueUYXofSOoqLO+/jP27fdH9ePcvH3uQqIkuRjlYHul3jhaAD/oxV62UM78yAQUBsHIfqKVo49rrT+AH5o830rLME8eY+KDt+45xdznuFiSjvevz+qOSsqAeVdqPpO7AiNgCAJI5p6VZ30TkYf4Kku8L6cerMhzLoZQFPXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723628; c=relaxed/simple;
	bh=QSvzUu8AQeRr4FkhNSJkQvKGLv02jNOisauG4G9Fy00=;
	h=Date:To:From:Subject:Message-Id; b=L1VSYdgHoYFYl8DOjlDtjiT2ERGtdLCt5K5u3TlPTeYuc4UD4F1pxczL/hbl9hv7CRAgd08Y8MYJa5YgxkrfWPjU/YHvtM1zIVnCWp8/Qt0mLo/5tmARFhHHivGQ1d/BNzp1Tv9gGPhz+wwC9XRFDahD9FeZHRK92W3noi+Yr/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lcA0jn8f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lcA0jn8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8485E1F00A3A;
	Fri, 10 Jul 2026 22:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723626;
	bh=UwVCrva/MpnEA2Gpi3sZk8Z4LgtBcJ0NFBzsiEHS98U=;
	h=Date:To:From:Subject;
	b=lcA0jn8fCK57XY2yLWmGodCHSkIydRdSQgzA5x1lHGesMfEHi5cn7+G9Sk3nsIplY
	 Q3ZzNR5VvwOve2dN+HHMHqE7wOZSEhUvRUs5Xn8qUzU0UYy9cONQU+Nid7gaqMHgws
	 bUT6JdS+yAflXJLVmR21ho+u/r9JVymLYxURjOkU=
Date: Fri, 10 Jul 2026 15:47:06 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-vma_assert_can_modify.patch added to mm-new branch
Message-Id: <20260710224706.8485E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: introduce vma_assert_can_modify()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-introduce-vma_assert_can_modify.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-vma_assert_can_modify.patch

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
Subject: mm/vma: introduce vma_assert_can_modify()
Date: Fri, 10 Jul 2026 21:17:03 +0100

vma_assert_write_locked() and vma_assert_attached() are useful for their
own purposes, however VMA code absolutely does allow the modification of
non-write locked VMAs if they are at that point detached (i.e. unreachable
from anywhere).

It's therefore useful to be able to assert that a VMA is either
detached (modification doesn't matter) or write locked (you're explicitly
locked for modification).

Therefore introduce vma_assert_can_modify() for this purpose.

While we're here, make vma_is_attached() available generally - if
!CONFIG_PER_VMA_LOCK, then there's no sense in which a VMA is
detached (vma_mark_detached() is a noop), so have this default to true in
this case.

Also update VMA userland tests to reflect this change, correcting the
previously open-coded vma_assert_[attached,detached]() there.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h       |    8 ++++++++
 tools/testing/vma/include/dup.h |   15 +++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/include/linux/mmap_lock.h~mm-vma-introduce-vma_assert_can_modify
+++ a/include/linux/mmap_lock.h
@@ -506,6 +506,8 @@ static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
 static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
@@ -530,6 +532,12 @@ static inline void vma_assert_stabilised
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}
+
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
--- a/tools/testing/vma/include/dup.h~mm-vma-introduce-vma_assert_can_modify
+++ a/tools/testing/vma/include/dup.h
@@ -1163,6 +1163,11 @@ static inline struct vm_area_struct *vma
 	return mas_find(&vmi->mas, ULONG_MAX);
 }
 
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+{
+	return refcount_read(&vma->vm_refcnt);
+}
+
 /*
  * WARNING: to avoid racing with vma_mark_attached()/vma_mark_detached(), these
  * assertions should be made either under mmap_write_lock or when the object
@@ -1170,12 +1175,12 @@ static inline struct vm_area_struct *vma
  */
 static inline void vma_assert_attached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(!refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(!vma_is_attached(vma));
 }
 
 static inline void vma_assert_detached(struct vm_area_struct *vma)
 {
-	WARN_ON_ONCE(refcount_read(&vma->vm_refcnt));
+	WARN_ON_ONCE(vma_is_attached(vma));
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *);
@@ -1564,3 +1569,9 @@ static inline pgoff_t linear_page_index(
 	pgoff += vma_start_pgoff(vma);
 	return pgoff;
 }
+
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}
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

