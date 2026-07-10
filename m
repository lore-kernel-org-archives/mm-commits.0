Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BED73CF021
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723579; cv=none; b=mPg/HsPwGNUr8yWM7VHQpKrsu9TluxYZv0c4AbtfEcQm1UuNQdwEEhsza+L+LMv5lbFbHQx2KPGwj93QN+NzsjckwVcueOnNoj+0lqqAST9wi6E6aDnIocVAqSP6rXLQdoWkUUfgOErKtV73ognhNm3Sp9nfPxDsf6G/KIPz2rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723579; c=relaxed/simple;
	bh=dhwyUAEkrA9eU2Wbfgfy1YZwpDRG42i96vwJ3u3/EDk=;
	h=Date:To:From:Subject:Message-Id; b=P5IvPpxFQYloXLhlGrqg1c0yhZuPdzzS91IOre0hSp3Px51cDKtBPG+Nrml3e0XjMFBCKimWOpLDfii++8W+l37rdpaMgRvRstw/ZsD8RqzsP/XYU6iUeKLPSazU8i8w50TfQCm7s5MwfAiXCg9u1AouzzZN/pHao812udJfo70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rE4bjD89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rE4bjD89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E0D1F000E9;
	Fri, 10 Jul 2026 22:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723578;
	bh=Bl2UTIQtmQ6Chb8nplxx7SNr7+DUBLU2cDD6ZcjzYL8=;
	h=Date:To:From:Subject;
	b=rE4bjD89hUxCv5noHNAeH0k0JyunHH8K2fqUE5+DT4vgoMr4XRH2SChxLHc1ZLm9F
	 hGEkp2aR6jQF1IUUvas8RCMUxTTiUQBA0/7DEN7Owmsz1dnfku7sW3KIPF3WJt4kkg
	 PusHj3fcQkjHCaGksqK2PBf94niPpqOLy3IhlgnI=
Date: Fri, 10 Jul 2026 15:46:17 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch added to mm-new branch
Message-Id: <20260710224618.04E0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: rename anon_vma_interval_tree_*() params and use pgoff_t
has been added to the -mm mm-new branch.  Its filename is
     mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch

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
Subject: mm/rmap: rename anon_vma_interval_tree_*() params and use pgoff_t
Date: Fri, 10 Jul 2026 21:16:51 +0100

Rename parameters used by anon_vma_interval_tree_*() functions: 'node' to
'avc', 'start/first' to 'pgoff_start', and 'last' to 'pgoff_last' to make
clear what is being passed.

Also, express page offsets in terms of pgoff_t to be consistent.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-10-2a5aa403d977@kernel.org
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

 include/linux/mm.h |   19 +++++++++++--------
 mm/interval_tree.c |   34 +++++++++++++++++-----------------
 2 files changed, 28 insertions(+), 25 deletions(-)

--- a/include/linux/mm.h~mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t
+++ a/include/linux/mm.h
@@ -4114,23 +4114,26 @@ mapping_rmap_tree_iter_next(struct vm_ar
 	     vma; vma = mapping_rmap_tree_iter_next(vma, pgoff_start,	 \
 						    pgoff_last))
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma);
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma);
+
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  unsigned long start, unsigned long last);
+				  pgoff_t pgoff_start, pgoff_t pgoff_last);
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
-				 unsigned long start, unsigned long last);
+				 pgoff_t pgoff_start, pgoff_t pgoff_last);
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc);
 #endif
 
-#define anon_vma_interval_tree_foreach(avc, root, start, last)		 \
-	for (avc = anon_vma_interval_tree_iter_first(root, start, last); \
-	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
+#define anon_vma_interval_tree_foreach(avc, anon_vma, pgoff_start, pgoff_last) \
+	for (avc = anon_vma_interval_tree_iter_first(anon_vma, pgoff_start,    \
+						     pgoff_last);	       \
+	     avc; avc = anon_vma_interval_tree_iter_next(avc, pgoff_start,     \
+							 pgoff_last))
 
 /* mmap.c */
 extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
--- a/mm/interval_tree.c~mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t
+++ a/mm/interval_tree.c
@@ -81,55 +81,55 @@ mapping_rmap_tree_iter_next(struct vm_ar
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static pgoff_t avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
-INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
+INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, pgoff_t, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
 		     static, __anon_vma_interval_tree)
 
-void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
+void anon_vma_interval_tree_insert(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma)
 {
 #ifdef CONFIG_DEBUG_VM_RB
-	node->cached_vma_start = avc_start_pgoff(node);
-	node->cached_vma_last = avc_last_pgoff(node);
+	avc->cached_vma_start = avc_start_pgoff(avc);
+	avc->cached_vma_last = avc_last_pgoff(avc);
 #endif
-	__anon_vma_interval_tree_insert(node, &anon_vma->rb_root);
+	__anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
-void anon_vma_interval_tree_remove(struct anon_vma_chain *node,
+void anon_vma_interval_tree_remove(struct anon_vma_chain *avc,
 				   struct anon_vma *anon_vma)
 {
-	__anon_vma_interval_tree_remove(node, &anon_vma->rb_root);
+	__anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 }
 
 struct anon_vma_chain *
 anon_vma_interval_tree_iter_first(struct anon_vma *anon_vma,
-				  unsigned long first, unsigned long last)
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
 	return __anon_vma_interval_tree_iter_first(&anon_vma->rb_root,
-						   first, last);
+						   pgoff_start, pgoff_last);
 }
 
 struct anon_vma_chain *
-anon_vma_interval_tree_iter_next(struct anon_vma_chain *node,
-				 unsigned long first, unsigned long last)
+anon_vma_interval_tree_iter_next(struct anon_vma_chain *avc,
+				  pgoff_t pgoff_start, pgoff_t pgoff_last)
 {
-	return __anon_vma_interval_tree_iter_next(node, first, last);
+	return __anon_vma_interval_tree_iter_next(avc, pgoff_start, pgoff_last);
 }
 
 #ifdef CONFIG_DEBUG_VM_RB
-void anon_vma_interval_tree_verify(struct anon_vma_chain *node)
+void anon_vma_interval_tree_verify(struct anon_vma_chain *avc)
 {
-	WARN_ON_ONCE(node->cached_vma_start != avc_start_pgoff(node));
-	WARN_ON_ONCE(node->cached_vma_last != avc_last_pgoff(node));
+	WARN_ON_ONCE(avc->cached_vma_start != avc_start_pgoff(avc));
+	WARN_ON_ONCE(avc->cached_vma_last != avc_last_pgoff(avc));
 }
 #endif
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

