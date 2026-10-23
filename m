Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792781043;
	b=4PQvR9IMVaSbjUcT3YHY70Tt/Y3fP5mjGhBk8T9hjmgJz1HKOuyy1Fp3eBLy9V6Oo18I
	 cP9YD33u+JuMjIPOJC+Jz+FQRuFOL8LbmUfk2yrWaQyMTNKY8HP7Dk2bhZ1TlEazFuMa/
	 PIW+zwhFjIidTH/uanc8SRS+JHU6ymhcH9xvDPwyw8MV6/r58GZLzvDQLzZdMSJMTQg9i
	 2A7x8ZTE7ILVigoiZ6ylWGg0NL6/gh/5skeVDJsF0WvOFE62833i8PloHG8jI5E+0bU/u
	 WpONGxwOQY2m1z9wblSr3dAru0umx3N/v/LEvR85RuLzg5EdL4KoDmHYeYXMQ/tx1ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792781043;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=f7SIdAcSMRweSpYrexIMtsWHLMDj3RGiMR9uTp07++g=;
	b=Ly/sVwPwsbBbZwtuBf3d9sX9skFYog5d6GtLRoBjQKvjMP3GMg9xE/5Eo5y6gmH1DFdZ
	 NXjpMcSu1bG2ZYhnO7W6cyUCguqeUaTgLQbjqNBgutEwm/iTfNF81NTVQFceqKFRC3akx
	 wUn/6Kq0thRNuWS5MyoOIPgUSS1ViHK7hrHb2Mc8HPeDcHcWUtyrKL1PP2PSfWarbDS7E
	 WkF3ouTp+eb2httRU9Afxry+9qLv1IPDLH8OFVa1nUQT/0FYch6wnGWBcRXXJMbsPJCdB
	 0z4yxJE+KyAXiwBXqPW4SswAqGWVbbVP0bjt60B+Loa137UVTUZddRPMt7TwnfzmO4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vDpD2Pd2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054E9606A320;
	Fri, 23 Oct 2026 18:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vDpD2Pd2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826B41F01825;
	Fri, 23 Oct 2026 18:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792781042;
	bh=f7SIdAcSMRweSpYrexIMtsWHLMDj3RGiMR9uTp07++g=;
	h=Date:To:From:Subject;
	b=vDpD2Pd20U9uweogw/D4z1VFU3aCX9s3ceWML5Kjf60rxFWR4yf5H+oCJSbp9Ecy9
	 KlJeozv6Zu6zMUU9CART2Xta02lc3GqTGUrzuaCVcnuf+H9uf/aRl6LzAPAHkWo53o
	 cYClQD7rThU6LDhmbe2/0zdfF1ZWQjn75xfmC1Pc=
Date: Fri, 23 Oct 2026 11:44:02 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sj@kernel.org,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,kees@kernel.org,jannh@google.com,dave@stgolabs.net,ccross@google.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch added to mm-unstable branch
Message-Id: <20261023184402.826B41F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: write lock source VMA before duplicating it in __split_vma()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch

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
Subject: mm/vma: write lock source VMA before duplicating it in __split_vma()
Date: Fri, 23 Oct 2026 14:47:28 +0100

__split_vma() duplicates the source VMA before taking its VMA write lock,
and until the VMA is write-locked, a concurrent thread might set
VMA_MAYBE_GUARD_BIT, resulting in the duplication missing the flag.

If this happens, then fork may fail to duplicate guard markers and, if a
file-backed mapping, THP collapse may also discard the markers.

Resolve this by taking the VMA write lock before vm_area_dup() and, since
all callers of vm_area_dup() now hold the VMA write lock, assert that this
is the case there, and add a comment to explain why it's needed.

[ljs@kernel.org: add VMA write assert in vm_area_dup(), commit message touchup]
Link: https://lore.kernel.org/20261023-fix-vma-atomic-v1-2-8ff4fae1fc85@kernel.org
Fixes: 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove under VMA lock")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: SJ Park <sj@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Colin Cross <ccross@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/vma.c      |    2 +-
 mm/vma_init.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma
+++ a/mm/vma.c
@@ -538,6 +538,7 @@ __split_vma(struct vma_iterator *vmi, st
 			return err;
 	}
 
+	vma_start_write(vma);
 	new = vm_area_dup(vma);
 	if (!new)
 		return -ENOMEM;
@@ -568,7 +569,6 @@ __split_vma(struct vma_iterator *vmi, st
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
 	vma_start_write(new);
 
 	init_vma_prep(&vp, vma);
--- a/mm/vma_init.c~mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma
+++ a/mm/vma_init.c
@@ -127,6 +127,9 @@ struct vm_area_struct *vm_area_dup(struc
 {
 	struct vm_area_struct *new = kmem_cache_alloc(vm_area_cachep, GFP_KERNEL);
 
+	/* Must hold a write lock to stabilise atomic VMA flags. */
+	vma_assert_write_locked(orig);
+
 	if (!new)
 		return NULL;
 
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
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch

