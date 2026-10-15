Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060B349CF27;
	Thu, 15 Oct 2026 22:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792105112; cv=none; b=lfHVv/L06QhSePkn8K2PAcRGEEdk+wHTDzok8eR0pAF+czXgU1GfnmIH0j5T3FiktgSZTveiCr7uDRGtzA7K2NgcBVl0jev/viZtctaYWcayoJFcglLFUIjV9WPY9DMmM6dma25yGfYs5IobfLCbuqDfyrtuXCLU6XRnG/8piT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792105112; c=relaxed/simple;
	bh=1Cc3FNrWCWXXH4f11d/FCkixEutefev1mNSMhm4b3Lk=;
	h=Date:To:From:Subject:Message-Id; b=GbXIV+1deZah04UW1BQgsOzhgZ/bXMz6iK9+HOz51nsQ1sX0GJxvU8MB7a35q2oZi/nnZ0edxkKT53GZvTL+r1J7DHEq5L1ePVu1BXqNJCJlREyaziVVnvcV6cMqnAKh0diTgeFYZ7CEOfWYVlRSeyOtEUMllbYi+LcHjjPnjGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=e5eUBNTX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="e5eUBNTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E721F000C5;
	Thu, 15 Oct 2026 22:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792105109;
	bh=0HDIYpCBzi5gTs9PhE/juRRu1ahxPehNnrmTol8REzI=;
	h=Date:To:From:Subject;
	b=e5eUBNTXjkgSZeDaqq6AWSuHbfal07v5sjS1qlFDlRALJl8aQmRudhISbyxhT/c69
	 xwexW/YJEztldXBOzoxNSes6nZBRV14KJkyPaukT0R+yAAjzVSIoRoFwVjql7HR7/v
	 DuJBD/mmOog9knQJuLF1bGuMk3enl2/IvjuSo+t4=
Date: Thu, 15 Oct 2026 15:58:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,stable@vger.kernel.org,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,peterx@redhat.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,mel@csn.ul.ie,ljs@kernel.org,linmiaohe@huawei.com,liam@infradead.org,kas@kernel.org,josef@toxicpanda.com,jannh@google.com,agl@us.ibm.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch added to mm-hotfixes-unstable branch
Message-Id: <20261015225829.96E721F000C5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas.patch

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
Subject: mm/hugetlb: tolerate UFFD_WP markers outside uffd-wp VMAs
Date: Thu, 15 Oct 2026 18:07:14 +0200

UFFD PTE bit handling is a bit like swiss cheese, in particular with
recently added RWP mode. Having uffd-wp markers outside uffd-wp VMAs
already confused this code in the past and resulted in uffd-pte bits
confusing other code later.

Let's play safe and just ignore these markers in hugetlb_no_page(), not
silently propagating the uffd-wp PTE bit.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-8-42796911043b@kernel.org
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
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

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-tolerate-uffd_wp-markers-outside-uffd-wp-vmas
+++ a/mm/hugetlb.c
@@ -5950,8 +5950,11 @@ static vm_fault_t hugetlb_no_page(struct
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
+	 *
+	 * TODO: fix all cases where uffd-wp markers remain in VMAs that are no
+	 * longer registered with uffd.
 	 */
-	if (unlikely(pte_is_uffd_wp_marker(vmf->orig_pte)))
+	if (unlikely(userfaultfd_wp(vma) && pte_is_uffd_wp_marker(vmf->orig_pte)))
 		new_pte = huge_pte_mkuffd(new_pte);
 	set_huge_pte_at(mm, vmf->address, vmf->pte, new_pte, huge_page_size(h));
 
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

