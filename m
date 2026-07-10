Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC7305057
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723547; cv=none; b=M36yWt8Xa0QN9Aw/effQSUSp6AOSTynPGaY/3R8eLYERXw4errnPrrfemrjfefh/lkhPaTIZwNSWZIEb54gOEGmerV/1WWl/erkbzIGQIp3+BEWzDU8DzdKu6FYhywAomb2vCeXnmZs6X2B9QPynSSezKCRmw6Q5MEDasoW9vJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723547; c=relaxed/simple;
	bh=k9q/XU96BoC7WZ+KLDIbrwROxw+ekkEmuf0X73mohNY=;
	h=Date:To:From:Subject:Message-Id; b=dn685Zwg3X3P4yUuohflAzScWXbM5TUyRRsPb8fq+tGnEfmXgq8G+hEc2qKVLbl4Ef/DhL6uK2iU0X/u4Xszcylvg1+YyRQZYd/yGVhjB59MO6J3bePs4M1d8jQsn4m+MJbnIbPFvKKP42L0ZFekfSg/Z4MYtO/ZNLJJQD3yRZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MSDgYOxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MSDgYOxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA4C1F000E9;
	Fri, 10 Jul 2026 22:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723545;
	bh=g+dZ7oPnL+Ci91V6HTqq0Tx2WTnmA/k21aHqWurw0w4=;
	h=Date:To:From:Subject;
	b=MSDgYOxwY1mVqNXFg/Fg+3c2JVe95VvGL4z5QkulojKpmWkpvpWxI8zw2yhvggaZH
	 SKYdI+QI/iVVPHUceKkKFjZF/PmywsN2DQJVT9ydziyM/dGHnP5cpHfxh8A+qf2TU5
	 yrS7WrYocnWvzlxbaZ7UQBLfyOEZeEGIi491jrUU=
Date: Fri, 10 Jul 2026 15:45:44 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-and-use-vma_end_pgoff.patch added to mm-new branch
Message-Id: <20260710224545.5FA4C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce and use vma_end_pgoff()
has been added to the -mm mm-new branch.  Its filename is
     mm-introduce-and-use-vma_end_pgoff.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-and-use-vma_end_pgoff.patch

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
Subject: mm: introduce and use vma_end_pgoff()
Date: Fri, 10 Jul 2026 21:16:45 +0100

We already have vma_last_pgoff() which retrieves the last page offset
within a VMA.

However, code often wishes to span a page offset range, which requires the
exclusive end of this range.

So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
function.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-4-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |   19 ++++++++++++++++++-
 tools/testing/vma/include/dup.h |    5 +++++
 2 files changed, 23 insertions(+), 1 deletion(-)

--- a/include/linux/mm.h~mm-introduce-and-use-vma_end_pgoff
+++ a/include/linux/mm.h
@@ -4336,6 +4336,23 @@ static inline pgoff_t vma_start_pgoff(co
 }
 
 /**
+ * vma_end_pgoff() - Get the page offset of the exclusive end of @vma
+ * @vma: The VMA whose end page offset is required.
+ *
+ * This returns the exclusive end page offset of @vma, which is useful for
+ * expressing page offset ranges.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The exclusive end page offset of @vma.
+ */
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
+/**
  * vma_last_pgoff() - Get the page offset of the last page in @vma
  * @vma: The VMA whose last page offset is required.
  *
@@ -4348,7 +4365,7 @@ static inline pgoff_t vma_start_pgoff(co
  */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
-	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
+	return vma_end_pgoff(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
--- a/tools/testing/vma/include/dup.h~mm-introduce-and-use-vma_end_pgoff
+++ a/tools/testing/vma/include/dup.h
@@ -1306,6 +1306,11 @@ static inline pgoff_t vma_start_pgoff(co
 	return vma->vm_pgoff;
 }
 
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);
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

