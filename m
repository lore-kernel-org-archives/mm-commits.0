Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686811;
	b=jmtHG5Q4Qh+N7IwYHTk/nEd2YLD/UUT/LPHH0P+iCRsktjAom9P8aTWXw1fh2GBmhGAR
	 JIOmA05utB+hReFi7ZZuBwe7gS6HABy76P5z+0ODIsz6rZF+KdQdlD8qeG8MHf5DDPeDe
	 SiMPC57q1PXlcImoLae6eWRH+r9ChMHpmi8Mh+6NXyOZvbf1KiTMdRSKdXIpe3EJ2Ou+1
	 uNAZK5I6uRTpVqcqm+SCc1ePWfHQC8GouNYuNUrZeTzULsID11mZYuRjh8cIKWpD3ejw+
	 mwY0cgid6AWhPBeM2joT0TYOEXezoGykLLXhsPkHbocoVX3mi+Dm0n/lPQ3V4XekooA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686811;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=sa1YR4Bsvm1xPvoPMXMEBtdYzU82xdtXMhUMCbStUBQ=;
	b=piAgCYIOEHjTmMvnXFIZ7Zt3oJDgNMlyQTXL07kWugbgjVvi0M22HFGJqIPpTclZ8ukR
	 JXM7/4jyPmY38ZE/X9852VZNDXOzqlRrgUiGk3gCyI1c6/0DlVrxMRWDT6clcD1UcBNxT
	 9Yo2mPPtpFiMtvspMIhUge/oB1lricUOwGlOc5EzIxTC7gmv7Ym1ML8FGk7a0xzLadkf7
	 09VFN+WXhB/Ga1o+ln10YwV2yGxO7Lmv7kvnVRiG5rPsfwaugPJQlBUahf86OWu+qSMVH
	 9ITygj+BD6e2YzZuhca296+un3BTE3o2QAqjBItCFAh08NbKY6sElE6Ad4+pMu8cFRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x3O8Biji;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FC5606A319
	for <mm-commits@vger.kernel.org>; Thu, 22 Oct 2026 16:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=x3O8Biji
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED6C1F01829;
	Thu, 22 Oct 2026 16:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792686810;
	bh=sa1YR4Bsvm1xPvoPMXMEBtdYzU82xdtXMhUMCbStUBQ=;
	h=Date:To:From:Subject;
	b=x3O8BijiXaHefVr1a3R5HH+qOui72NQdznmkuiZOaNn4I6Sc4Jy7InN9okMkFWRWE
	 KL0wmIwDs+zhnJgovOFeNkalDOyAfRqdDdjk0WmG4m77pOukQeAv2TH5Kmitdh+ElS
	 ZMYUVyw0JMg4SuH1sSgv0jS+1i3Of37Zk21o+rNc=
Date: Thu, 22 Oct 2026 09:33:29 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,lizhe.67@bytedance.com,azpijr@gmail.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch added to mm-unstable branch
Message-Id: <20261022163330.3ED6C1F01829@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: disable PMD sharing for UFFD missing mode
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/hugetlb: disable PMD sharing for UFFD missing mode
Date: Thu, 22 Oct 2026 11:45:42 +0800

For UFFDIO_POISON to install a poison marker in a hugetlb mapping, it is
sufficient to have the VMA registered for missing mode.

However, UFFD missing mode does currently not block PMD table sharing, so
installing the marker will be visible to everyone using the shared PMD
table, which is wrong as UFFDIO_POISON must stay local to the process.

To fix it, make uffd_disable_huge_pmd_share() cover VM_UFFD_MISSING as
well. With missing mode covered, hugetlb PMD sharing is disabled for all
userfaultfd registered VMAs, so the helper can simply return whether the
VMA has a userfaultfd context instead of testing individual UFFD mode
flags. Add a debug check on the marker installation path.

The existing registration path will then unshare PMD tables, and
subsequent faults will not share them while the mapping remains
registered.

The alternative would be to unshare PMD tables selectively when
installing poison markers, which results in way more complexity. Or
alternatively, simply failing the marker installation, which might break
some use cases.

This also disables PMD sharing for userfaultfd registrations that never
use UFFDIO_POISON.

Link: https://lore.kernel.org/20261022034543.51226-3-lizhe.67@bytedance.com
Fixes: 8a13897fb0da ("mm: userfaultfd: support UFFDIO_POISON for hugetlbfs")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Li Zhe <lizhe.67@bytedance.com>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---

 include/linux/userfaultfd_k.h |   16 +++-------------
 mm/hugetlb.c                  |    1 +
 2 files changed, 4 insertions(+), 13 deletions(-)

--- a/include/linux/userfaultfd_k.h~mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode
+++ a/include/linux/userfaultfd_k.h
@@ -168,22 +168,12 @@ static inline bool is_mergeable_vm_userf
 }
 
 /*
- * Never enable huge pmd sharing on some uffd registered vmas:
- *
- * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
- *   tracking information is per pgtable entry.
- *
- * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
- *   VMAs which share huge pmds. (If you have two mappings to the same
- *   underlying pages, and fault in the non-UFFD-registered one with a write,
- *   with huge pmd sharing this would *also* setup the second UFFD-registered
- *   mapping, and we'd not get minor faults.)
+ * Never enable huge pmd sharing on userfaultfd registered VMAs, because
+ * userfaultfd state can be tracked per VMA or per page table entry.
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
-					VMA_UFFD_MINOR));
+	return vma->vm_userfaultfd_ctx.ctx;
 }
 
 /*
--- a/mm/hugetlb.c~mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode
+++ a/mm/hugetlb.c
@@ -6399,6 +6399,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 			return -EEXIST;
 		}
 
+		VM_WARN_ON_ONCE(size == PMD_SIZE && hugetlb_pmd_shared(dst_pte));
 		_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
 		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
 
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
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch

