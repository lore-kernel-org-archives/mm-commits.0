Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5116AFB5
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712170922; cv=none; b=VqictH5BQqYpfpp9TSFOANpNIgIfshyBrQNmrohsawhhKhPPaqFWL0GkWA8mulSjyp9aJHVLdI15SOvfckngN9gO4KhyWw1J9qVO47PK50mifd6zZd0DloNuOeJ200G81AvALjJtqvoz9A1UheV19PQeXwly5772+mvr8DmgYew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712170922; c=relaxed/simple;
	bh=PXvX1r7ut9Mc8aBpE+n5XcNoagORqIPyyiyaz3Sa1Qg=;
	h=Date:To:From:Subject:Message-Id; b=YS4SFalPMt5rD2ZSzf86LuPrmIG+mSFt8CIr6tvIdyy5LrWuicj+3+ACTg/s3IgC61bkccuKGBzVekUPWmAadV7q0OvSviC74xd6My/O3HFWjzeR5e2is0eeue6okSkh1S7mxkkE3WYk3+GWZbFchGh5de1u4GC2LBn2sjIGPD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qZmsmZn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qZmsmZn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA267C433C7;
	Wed,  3 Apr 2024 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712170921;
	bh=PXvX1r7ut9Mc8aBpE+n5XcNoagORqIPyyiyaz3Sa1Qg=;
	h=Date:To:From:Subject:From;
	b=qZmsmZn0SGPQenrY4AsbhSxFfsv/yXNLxbcnsKne3ZTHg6qiXkSlaaIL2I54/OpOy
	 m7kk8o99E2w6cD5WGNdNwx2ib4Q1FoId1fFsqtsrmC8cT4tjCgqPqRi9iNVgFAH6DI
	 lq2N7tJd/WT8xnEzaGluy3+DAGemLnf7D5x7BW0Y=
Date: Wed, 03 Apr 2024 12:02:00 -0700
To: mm-commits@vger.kernel.org,dan.carpenter@linaro.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-rewrite-stable_page_flags-fix.patch added to mm-unstable branch
Message-Id: <20240403190201.CA267C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc-rewrite-stable_page_flags-fix
has been added to the -mm mm-unstable branch.  Its filename is
     proc-rewrite-stable_page_flags-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-rewrite-stable_page_flags-fix.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: proc-rewrite-stable_page_flags-fix
Date: Wed, 3 Apr 2024 18:31:11 +0100

Dan reported I'd messed up some bits vs masks here:
https://lore.kernel.org/linux-fsdevel/1a6dc6a5-b5b6-494c-b94b-f6655da51bb9@moroto.mountain/T/#u

Link: https://lkml.kernel.org/r/20240403173112.1450721-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/page.c~proc-rewrite-stable_page_flags-fix
+++ a/fs/proc/page.c
@@ -153,7 +153,7 @@ u64 stable_page_flags(const struct page
 	 * to make sure a given page is a thp, not a non-huge compound page.
 	 */
 	else if (folio_test_large(folio)) {
-		if ((k & PG_lru) || is_anon)
+		if ((k & (1 << PG_lru)) || is_anon)
 			u |= 1 << KPF_THP;
 		else if (is_huge_zero_page(&folio->page)) {
 			u |= 1 << KPF_ZERO_PAGE;
@@ -204,7 +204,7 @@ u64 stable_page_flags(const struct page
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
 #ifdef CONFIG_MEMORY_FAILURE
-	if (u & KPF_HUGE)
+	if (u & (1 << KPF_HUGE))
 		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
 	else
 		u |= kpf_copy_bit(page->flags, KPF_HWPOISON,	PG_hwpoison);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch

