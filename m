Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D7A3B05BC
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068064; cv=none; b=nWFxWom3yJhzMoYeVYct522lzH4FF+DMmGnD5FUl13M51k9FLBTvkURTnZ/80da1FqZRnrIYBjNWDzX1WnB4b6fGKV+Y7J17rgE1N3ZIRJWc5KxnX1hy40V7pXXXE8aIr+UJzI6kMnYg9+cd4VSm7Z4uhI61hJMqSvQeFIouPQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068064; c=relaxed/simple;
	bh=Y29lC1Q+Gtt+z+LLClxsYgcCqT9RFzNsf0KM+KwQsV0=;
	h=Date:To:From:Subject:Message-Id; b=gKoY9V9ClmD/d0daYUVJlLeMGvo9xYKHa2mKF6pw2b7Lo3PF8xvpPTBMjoj9vpOp4rO6AuzcTzgL4C6lSK+xmLAf6F+KioFufZknS36wZ5veZM5oqDKBAqb7mCHMq9cRv/tFodz275cjswU0nscoSyzcf081vp/K9ZmRz3mPFOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pT/QJL2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pT/QJL2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B89E1F00A3E;
	Fri,  7 Aug 2026 02:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068057;
	bh=NkTrmtyx3ok0A1EOiq6Lw0oPrdS/Kr7lFIN0QpXrxXY=;
	h=Date:To:From:Subject;
	b=pT/QJL2hfoPMvVAUNIiFQ+6HlMJvLX9OnbNdBjbYxhJ2gAFXzqlUSI2trAYiXVPUg
	 IzxTFuGN6NMI5NCUbOZ91bf9z0VMbpUHfJcRt+0/F3GDQRB15Qd7rx6eqeUvHGqjni
	 /PY4xt/XFWyVpK0hRcVNazGtIMBWMGxFP/z1u2k4=
Date: Thu, 06 Aug 2026 19:00:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20260807020057.5B89E1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mprotect: convert mprotect code to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-mprotect-convert-mprotect-code-to-use-vma_flags_t.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/mprotect: convert mprotect code to use vma_flags_t
Date: Sat, 11 Jul 2026 19:45:09 +0100

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the mprotect logic.

Note that we retain the legacy vm_flags_t bit shifting code in
do_mprotect_pkey(), deferring a vma_flags_t approach to this for the time
being.

Additionally update comments to reflect the changes to be consistent.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-12-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-convert-mprotect-code-to-use-vma_flags_t
+++ a/mm/mprotect.c
@@ -40,7 +40,7 @@
 
 static bool maybe_change_pte_writable(struct vm_area_struct *vma, pte_t pte)
 {
-	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+	if (WARN_ON_ONCE(!vma_test(vma, VMA_WRITE_BIT)))
 		return false;
 
 	/* Don't touch entries that are not even readable. */
@@ -97,7 +97,7 @@ static bool can_change_shared_pte_writab
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte)
 {
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!vma_test(vma, VMA_SHARED_BIT))
 		return can_change_private_pte_writable(vma, addr, pte);
 
 	return can_change_shared_pte_writable(vma, pte);
@@ -194,7 +194,7 @@ static __always_inline void set_write_pr
 {
 	bool set_write;
 
-	if (vma->vm_flags & VM_SHARED) {
+	if (vma_test(vma, VMA_SHARED_BIT)) {
 		set_write = can_change_shared_pte_writable(vma, ptent);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, nr_ptes,
 				       /* idx = */ 0, set_write, tlb);
@@ -846,8 +846,8 @@ mprotect_fixup(struct vma_iterator *vmi,
 		vm_unacct_memory(nrpages);
 
 	/*
-	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
-	 * fault on access.
+	 * Private VMA_LOCKED_BIT VMA becoming writable: trigger COW to avoid
+	 * major fault on access.
 	 */
 	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT) &&
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT) &&
@@ -921,7 +921,7 @@ static int do_mprotect_pkey(unsigned lon
 			goto out;
 		start = vma->vm_start;
 		error = -EINVAL;
-		if (!(vma->vm_flags & VM_GROWSDOWN))
+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 			goto out;
 	} else {
 		if (vma->vm_start > start)
@@ -929,7 +929,7 @@ static int do_mprotect_pkey(unsigned lon
 		if (unlikely(grows & PROT_GROWSUP)) {
 			end = vma->vm_end;
 			error = -EINVAL;
-			if (!(vma->vm_flags & VM_GROWSUP))
+			if (!vma_test_single_mask(vma, VMA_GROWSUP))
 				goto out;
 		}
 	}
@@ -953,7 +953,7 @@ static int do_mprotect_pkey(unsigned lon
 		}
 
 		/* Does the application expect PROT_READ to imply PROT_EXEC */
-		if (rier && (vma->vm_flags & VM_MAYEXEC))
+		if (rier && vma_test(vma, VMA_MAYEXEC_BIT))
 			prot |= PROT_EXEC;
 
 		/*
_

Patches currently in -mm which might be from ljs@kernel.org are

x86-mm-pat-acquire-init_mm-write-lock-on-collapse-to-avoid-uaf.patch
x86-mm-pat-acquire-init_mm-read-lock-on-attribute-change-to-avoid-uaf.patch
x86-mm-pat-allocate-split-page-tables-as-kernel-page-tables.patch
mm-vma-introduce-vma-anon-page-offset-field-and-add-helpers.patch
mm-provide-vma_is_cow_mapping-and-remove-is_cow_mapping.patch
mm-introduce-linear_anon_page_index.patch
mm-abstract-vma_address-and-introduce-vma_anon_address.patch
mm-update-print_bad_page_map-to-show-anon-index-if-appropriate.patch
mm-introduce-and-use-vma_filebacked_address.patch
mm-vma-fix-self-merge-check-in-copy_vma.patch
tools-testing-vma-add-tests-for-copy_vma-self-merge.patch
mm-propagate-vma-anonymous-page-offset-on-map-remap-split-merge.patch
mm-rmap-track-whether-the-page-vma-mapped-pgoff-is-anonymous.patch
mm-clean-up-vma_address_end.patch
mm-huge_memory-update-remove_migration_pmd-to-accept-a-folio.patch
mm-migrate-calculate-large-folio-page-index-using-pfn.patch
mm-rmap-use-anon-pgoff-to-track-map_private-file-backed-anon-folios.patch
tools-testing-vma-expand-vma-merge-tests-to-assert-anon-pgoff.patch
tools-testing-selftests-mm-test-anonymous-page-offset-merge-behaviour.patch
mm-vma-only-permit-map_private-dev-zero-to-be-mapped-anonymous.patch
mm-vma-make-map_private-mapped-dev-zero-mappings-truly-anonymous.patch
tools-testing-vma-add-test-to-assert-map_private-dev-zero-is-anon.patch
tools-testing-selftests-mm-add-map_private-dev-zero-merge-tests.patch
mm-add-some-missing-includes-to-mm-local-headers.patch

