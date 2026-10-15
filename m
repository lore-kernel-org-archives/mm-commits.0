Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5144F93C3;
	Thu, 15 Oct 2026 22:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105114; cv=none; b=XzHK0lbcBlpOKtgZrHQBYkzkY7h9J41hVmNKZTaU15jRvkHO6TA/KxO6JzPTuJIsdiZ+Tq9TmMtSvF7bs0PdzQcPTJ9JVTwDu7j7j3kEyLPQZEG9H1j2SO1QCHdjRUZlNs+1s88Gmaeoc26gYhBgZSVTH4lADVdO/wvHIAjF0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105114; c=relaxed/simple;
	bh=XYO1gm8DJbkIduUJMNyzFYYPta3HQVGGWNNAtbnGE08=;
	h=Date:To:From:Subject:Message-Id; b=DHEvThWxwN3lsfQd7gJLbZnqU9cYc/mQ3qrIOjQF7BLKGodjdMFDMGiLm+QIic0QOyM+Wu4cA12FPvF7RdhYh4FMNppZRTF9bgkAsOIzawZjOAUqBFMnltJYSqUueEXLoTbwAVf2ytwpCtO6CSYr8jtKlnZVkeYP4tzJBS7Y97w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mHBSvRg/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mHBSvRg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1C31F000C4;
	Thu, 15 Oct 2026 22:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105113;
	bh=wwThAY94RUtKWkRfFjZ6fc0bs+OsWOrfC37KzK9xd2w=;
	h=Date:To:From:Subject;
	b=mHBSvRg/haEgJvJB+Ak9SOdKtmxxACUlVpMiV48Nz/BElDVHWvKAPvrVzLVGhGcwk
	 3d9RA6CN+XAA6VfZNFJaDKACTbWSFYPSDdVhyRWonf4TlBd/xV74B39yYSq/UxjHza
	 h5dq7y+ePtMFkt7y85xmYeNGUsq6sic8Ruqn3Z8s=
Date: Thu, 15 Oct 2026 15:58:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225833.3D1C31F000C4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/mremap: fix calling fixup_hugetlb_reservations() on the wrong VMA
Date: Thu, 15 Oct 2026 18:07:16 +0200

In case we fail to move the page tables, for example, because we fail
to allocate a page table, we actually keep the old VMA.

Calling fixup_hugetlb_reservations() on the old VMA is wrong. Fix it
by just calling it on the VMA that will be removed.

The user-visible impact is that the VMA loses its reservations, meaning
that the existing reservations get stranded (leaked) and new hugetlb folios
that are getting allocated in the VMA cannot make use of the
reservations, failing these allocations.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-10-42796911043b@kernel.org
Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
---

 mm/mremap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma
+++ a/mm/mremap.c
@@ -1345,7 +1345,7 @@ static int copy_vma_and_data(struct vma_
 		mremap_userfaultfd_prep(new_vma, vrm->uf);
 	}
 
-	fixup_hugetlb_reservations(vma);
+	fixup_hugetlb_reservations(vrm->vma);
 
 	*new_vma_ptr = new_vma;
 	return err;
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-fix-use-after-free-in-hugetlb_mfill_atomic_pte.patch
mm-hugetlb-tolerate-uffd-bits-set-without-uffd-for-prot_none-ptes.patch
mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch
mm-mremap-fix-calling-fixup_hugetlb_reservations-on-the-wrong-vma.patch
arm64-mm-move-__check_safe_pte_update-fix.patch
mm-sparse-move-mem_section-init-to-sparse_extreme_init.patch
mm-sparse-refactor-sparse_sections_init.patch
mm-sparse-move-initialization-of-section-metadata-to-sparse_metadata_init.patch
mm-sparse-rename-and-cleanup-sparse_init_nid.patch
mm-sparse-cleanup-sparse_init_one_section.patch
mm-sparse-rename-__highest_present_section_nr-to-__highest_used_section_nr.patch
mm-sparse-remove-pfn_in_present_section.patch
mm-sparse-move-__highest_used_section_nr-handling.patch
scripts-gdb-mmpy-remove-fallbacks-for-section_has_mem_map-and-section_is_early.patch
mm-sparse-remove-section_marked_present.patch
mm-sparse-remove-flags-parameter-from-sparse_init_one_section.patch
fs-proc-page-clarify-comment-in-get_max_dump_pfn.patch
mm-memory_hotplug-drop-config_have_arch_pfn_valid-handling-from-pfn_to_online_page.patch
vmcoreinfo-export-section_has_mem_map.patch
mm-disallow-ioremaping-ordinary-ram-in-generic_access_phys.patch
mm-userfaultfd-only-allocate-anon_vma-in-cow-mappings.patch

