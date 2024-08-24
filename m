Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FA22F2F
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 05:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724477847; cv=none; b=tcHkvkE69NkdZVEEa6k7+kVxWvwMlEevM3vqKHLhQYEAFk5zMbFOJjY0XEaIuWkMkGF9U8Y3WIjkSSyEL5h15ZxC6FOfnSgbUJBHInkYDv5ljt1AW5CXtvb69flK8K+jkh+66e7SuQeWqBukyiyEH8jznTlQ2+ov5WiP7Uy3uUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724477847; c=relaxed/simple;
	bh=A8XhD2cU0MiNpWnOrXggFza8jefEMce/qaeK7b9m6Ak=;
	h=Date:To:From:Subject:Message-Id; b=Ev4eni1cg7URzZrd1uhoD7jEMJ1O4QwL8Xecan/TWV2PivyRnfx+BHljN7d+2IAeTas4+IVeD3p2TiTx2RktgsMTxGNeLtXtLbW9bw9wOAI4BI/jUxQvYM4zwAjQtWKum5BbjSw8DyBoafpGtz8qAQKmbtxVGSBpKhRlQePHI+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IfxBlBwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IfxBlBwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC01C32781;
	Sat, 24 Aug 2024 05:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724477847;
	bh=A8XhD2cU0MiNpWnOrXggFza8jefEMce/qaeK7b9m6Ak=;
	h=Date:To:From:Subject:From;
	b=IfxBlBwzFuPMEgoc5/rl1KBTHNh4hgY962KOSSceJSMcupRAKiiwJyFFMVgat97W5
	 YUCh469oJYOqDk2Bj6kXTV2zIBvPPhUa7CRv+nmushUvo7TJw7zRBC3i/ToYH8ivSm
	 +mwWo7TmzVqrGqhpPiITGdrUrUtRiUeF3QQiJHk0=
Date: Fri, 23 Aug 2024 22:37:26 -0700
To: mm-commits@vger.kernel.org,justinjiang@vivo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + vma-remove-the-unneeded-avc-bound-with-non-cowed-folio.patch added to mm-unstable branch
Message-Id: <20240824053727.3DC01C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: vma remove the unneeded avc bound with non-CoWed folio
has been added to the -mm mm-unstable branch.  Its filename is
     vma-remove-the-unneeded-avc-bound-with-non-cowed-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vma-remove-the-unneeded-avc-bound-with-non-cowed-folio.patch

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
From: Zhiguo Jiang <justinjiang@vivo.com>
Subject: vma remove the unneeded avc bound with non-CoWed folio
Date: Fri, 23 Aug 2024 23:02:06 +0800

After CoWed by do_wp_page, the vma established a new mapping relationship
with the CoWed folio instead of the non-CoWed folio.  However, regarding
the situation where vma->anon_vma and the non-CoWed folio's anon_vma are
not same, the avc binding relationship between them will no longer be
needed, so it is issue for the avc binding relationship still existing
between them.

This patch will remove the avc binding relationship between vma and the
non-CoWed folio's anon_vma, which each has their own independent anon_vma.
It can also alleviates rmap overhead simultaneously.

Link: https://lkml.kernel.org/r/20240823150206.565-1-justinjiang@vivo.com
Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 
 mm/memory.c          |    8 ++++++
 mm/rmap.c            |   53 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+)

--- a/include/linux/rmap.h~vma-remove-the-unneeded-avc-bound-with-non-cowed-folio
+++ a/include/linux/rmap.h
@@ -257,6 +257,7 @@ void folio_remove_rmap_ptes(struct folio
 	folio_remove_rmap_ptes(folio, page, 1, vma)
 void folio_remove_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *);
+void folio_remove_anon_avc(struct folio *, struct vm_area_struct *);
 
 void hugetlb_add_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
--- a/mm/memory.c~vma-remove-the-unneeded-avc-bound-with-non-cowed-folio
+++ a/mm/memory.c
@@ -3428,6 +3428,14 @@ static vm_fault_t wp_page_copy(struct vm
 			 * old page will be flushed before it can be reused.
 			 */
 			folio_remove_rmap_pte(old_folio, vmf->page, vma);
+
+			/*
+			 * If the new_folio's anon_vma is different from the
+			 * old_folio's anon_vma, the avc binding relationship
+			 * between vma and the old_folio's anon_vma is removed,
+			 * avoiding rmap redundant overhead.
+			 */
+			folio_remove_anon_avc(old_folio, vma);
 		}
 
 		/* Free the old page.. */
--- a/mm/rmap.c~vma-remove-the-unneeded-avc-bound-with-non-cowed-folio
+++ a/mm/rmap.c
@@ -1522,6 +1522,59 @@ void folio_add_file_rmap_pmd(struct foli
 #endif
 }
 
+/**
+ * folio_remove_anon_avc - remove the avc binding relationship between
+ * folio and vma with different anon_vmas.
+ * @folio:	The folio with anon_vma to remove the binded avc from
+ * @vma:	The vm area to remove the binded avc with folio's anon_vma
+ *
+ * The caller is currently used for CoWed scene.
+ */
+void folio_remove_anon_avc(struct folio *folio,
+		struct vm_area_struct *vma)
+{
+	struct anon_vma *anon_vma = folio_anon_vma(folio);
+	pgoff_t pgoff_start, pgoff_end;
+	struct anon_vma_chain *avc;
+
+	/*
+	 * Ensure that the vma's anon_vma and the folio's
+	 * anon_vma exist and are not same.
+	 */
+	if (!folio_test_anon(folio) || unlikely(!anon_vma) ||
+	    anon_vma == vma->anon_vma)
+		return;
+
+	pgoff_start = folio_pgoff(folio);
+	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
+
+	if (!anon_vma_trylock_write(anon_vma))
+		return;
+
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
+			pgoff_start, pgoff_end) {
+		/*
+		 * Find the avc associated with vma from the folio's
+		 * anon_vma and remove it.
+		 */
+		if (avc->vma == vma) {
+			anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+			/*
+			 * When removing the avc with anon_vma that is
+			 * different from the parent anon_vma from parent
+			 * anon_vma->rb_root, the parent num_children
+			 * count value is needed to reduce one.
+			 */
+			anon_vma->num_children--;
+
+			list_del(&avc->same_vma);
+			anon_vma_chain_free(avc);
+			break;
+		}
+	}
+	anon_vma_unlock_write(anon_vma);
+}
+
 static __always_inline void __folio_remove_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *vma,
 		enum rmap_level level)
_

Patches currently in -mm which might be from justinjiang@vivo.com are

mm-shrink-skip-folio-mapped-by-an-exiting-process.patch
vma-remove-the-unneeded-avc-bound-with-non-cowed-folio.patch

