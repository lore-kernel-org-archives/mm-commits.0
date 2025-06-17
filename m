Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8382F5328
	for <mm-commits@vger.kernel.org>; Tue, 17 Jun 2025 22:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750199574; cv=none; b=SNHsRDEn6D2RJX+gEo2Q5IjrS9vbqKvfxmAwk5eJZXr9htfRj2PXsYq0XMsMX3Efj1oTirdi5BNbnT7wdat8Vhv+towkY6F6IXTju2q5Nm/cbL0K3TN64XxVN6Mxm9llQzC6ghR0cOP4Pyg25gZuFz/S/nV2n6cdvRTsc44qxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750199574; c=relaxed/simple;
	bh=IDASyVQk2oV6BDSCEiI87ZI7H7lcUS0I9T+0TG/Ekqg=;
	h=Date:To:From:Subject:Message-Id; b=l9sZ2zSMKbqPV9BaP+W6lGgeCN+nlpRhLSk5tNQxZlnj9DPYlZB6FtS/COtA7z2o/NmaoT4lJoZ1wbpAXgZtSOaDWVClSj36Aq1oMF6hUNPcQnJOqcrLr7VAhgHP3wUtxm9obOp6rqz56iNgLXrL6+5Ooz1/aRjSVTBE4fNz6qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VrCdiK1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VrCdiK1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716D8C4CEE3;
	Tue, 17 Jun 2025 22:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750199573;
	bh=IDASyVQk2oV6BDSCEiI87ZI7H7lcUS0I9T+0TG/Ekqg=;
	h=Date:To:From:Subject:From;
	b=VrCdiK1fug+7G4x/VbjkV2ts7u2wthSe1/4qdmWs/EuNKZKpH3k7ljdQoUyK1M23N
	 MQK/7JagjFj5vN3LaVbw6dGmIxGBeyDASjFIkvw/m7TZymEmaGSZsbKFWtFhGixP1i
	 zLgkXqwfYCxGASRGJsaWT/pjowgbY/L110e19Hvw=
Date: Tue, 17 Jun 2025 15:32:52 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,riel@surriel.com,richard.weiyang@gmail.com,npache@redhat.com,matenajakub@gmail.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch added to mm-unstable branch
Message-Id: <20250617223253.716D8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix syzbot reports
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch

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
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: fix syzbot reports
Date: Tue, 17 Jun 2025 20:56:25 +0100

Use folio_trylock() to resolve
https://lore.kernel.org/all/aFEAPOozHsR1/PLI@ly-workstation/ and balance
lock/unlock in move_pgt_entry() to fix
https://lore.kernel.org/all/68512333.a70a0220.395abc.0205.GAE@google.com/

Link: https://lkml.kernel.org/r/46f4db0a-4b84-45b9-8b23-bb81493f776d@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jakub Matěna <matenajakub@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mremap.c~mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix
+++ a/mm/mremap.c
@@ -601,12 +601,12 @@ static bool move_pgt_entry(struct pageta
 
 	if (!pmc->need_rmap_locks && should_take_rmap_locks(entry)) {
 		override_locks = true;
-
 		pmc->need_rmap_locks = true;
-		/* See comment in move_ptes() */
-		maybe_take_rmap_locks(pmc);
 	}
 
+	/* See comment in move_ptes() */
+	maybe_take_rmap_locks(pmc);
+
 	switch (entry) {
 	case NORMAL_PMD:
 		moved = move_normal_pmd(pmc, old_entry, new_entry);
@@ -824,7 +824,8 @@ static unsigned long relocate_anon_pte(s
 	if (!folio)
 		return ret;
 
-	folio_lock(folio);
+	if (!folio_trylock(folio))
+		return 0;
 
 	/* No-op. */
 	if (!folio_test_anon(folio) || folio_test_ksm(folio))
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

maintainers-add-missing-mm-workingsetc-file-to-mm-reclaim-section.patch
maintainers-add-missing-test-files-to-mm-gup-section.patch
docs-mm-expand-vma-doc-to-highlight-pte-freeing-non-vma-traversal.patch
mm-ksm-have-ksm-vma-checks-not-require-a-vma-pointer.patch
mm-ksm-refer-to-special-vmas-via-vm_special-in-ksm_compatible.patch
mm-prevent-ksm-from-breaking-vma-merging-for-new-vmas.patch
tools-testing-selftests-add-vma-merge-tests-for-ksm-merge.patch
mm-pagewalk-split-walk_page_range_novma-into-kernel-user-parts.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon.patch
mm-mremap-introduce-more-mergeable-mremap-via-mremap_relocate_anon-fix.patch
mm-mremap-add-mremap_must_relocate_anon.patch
mm-mremap-add-mremap_relocate_anon-support-for-large-folios.patch
tools-uapi-update-copy-of-linux-mmanh-from-the-kernel-sources.patch
tools-testing-selftests-add-sys_mremap-helper-to-vm_utilh.patch
tools-testing-selftests-add-mremap-cases-that-merge-normally.patch
tools-testing-selftests-add-mremap_relocate_anon-merge-test-cases.patch
tools-testing-selftests-expand-mremap-tests-for-mremap_relocate_anon.patch
tools-testing-selftests-have-cow-self-test-use-mremap_relocate_anon.patch
tools-testing-selftests-test-relocate-anon-in-split-huge-page-test.patch
tools-testing-selftests-add-mremap_relocate_anon-fork-tests.patch
secretmem-remove-uses-of-struct-page-fix.patch
mm-vma-use-vmg-target-to-specify-target-vma-for-new-vma-merge.patch
mm-rename-call_mmap-mmap_prepare-to-vfs_mmap-mmap_prepare.patch
mm-nommu-use-file_has_valid_mmap_hooks-helper.patch
fs-consistently-use-file_has_valid_mmap_hooks-helper.patch
fs-dax-make-it-possible-to-check-dev-dax-support-without-a-vma.patch
fs-ext4-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
fs-xfs-transition-from-deprecated-mmap-hook-to-mmap_prepare.patch
mm-filemap-introduce-generic_file__mmap_prepare-helpers.patch
fs-convert-simple-use-of-generic_file__mmap-to-mmap_prepare.patch
fs-convert-most-other-generic_file_mmap-users-to-mmap_prepare.patch
fs-replace-mmap-hook-with-mmap_prepare-for-simple-mappings.patch

