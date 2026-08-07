Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF703B71B0
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068053; cv=none; b=gnVsTZXK+1Ul1AM6CNh7airk4q1oxtzqwolqi2vMSOuAdTM2sfN+hKgvIl47IJmffppvl24USeeZjUfdVaR3HYd4PJHtQ+EPcwlOQ3xTMhaJOjqPL/mkWUm6t26BYw6dvnCRHONi1suA4lYsai1g/4LgT6OQ43VJWEhAkHHzO+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068053; c=relaxed/simple;
	bh=7gEIx4VefZkEvwH13+TjAOZYIVHvGoCQ2xODZoLhqAY=;
	h=Date:To:From:Subject:Message-Id; b=ip2aLJoh1lq0yHXHG6U2GaBlahOSLweHfzonPUc9UtYCprgGw0gKpGFWomVFJ1fk842wL8x3RcGuoDtB+Hf+Tio7WsCkUbUZHMGg1tHv/5OVNbBhvollvUrLNLAgoW2TqSgh4brPzjnpmmZJVZTCHl5BzZ/sEANax9Lyj+r/gqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P5Y+k8a1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P5Y+k8a1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30EA1F00A3F;
	Fri,  7 Aug 2026 02:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068050;
	bh=Pd+KH57agoRGt4m3nherx1DnIBM9AWm6HEXTKsRYy/A=;
	h=Date:To:From:Subject;
	b=P5Y+k8a1u9S9qUG9hWpJdq8Fn8XIR43l7twxmCe8rVNgzR3707mclKqzKU/RX5VTy
	 lyFA0y373nuFTMgPATXU/59u2T4AAvfoeAqozirf5ng0faCXvN8jzkPHNK5WMinox7
	 SMBYTgj7RUjRnuteHdqfPXevxXkJG+nj3LEuBAIs=
Date: Thu, 06 Aug 2026 19:00:50 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch removed from -mm tree
Message-Id: <20260807020050.D30EA1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
has been removed from the -mm tree.  Its filename was
     mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
Date: Sat, 11 Jul 2026 19:45:04 +0100

Having vma_get_page_prot() refer to VMA flags and vma_set_page_prot()
refer to a VMA is confusing.

Rename vma_get_page_prot() to vma_flags_to_page_prot() to resolve this
confusion.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-7-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h              |    4 ++--
 mm/vma.c                        |    2 +-
 mm/vma.h                        |    2 +-
 tools/testing/vma/include/dup.h |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/include/linux/mm.h~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/include/linux/mm.h
@@ -4603,7 +4603,7 @@ static inline bool range_in_vma_desc(con
 #ifdef CONFIG_MMU
 pgprot_t vm_get_page_prot(vm_flags_t vm_flags);
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
@@ -4616,7 +4616,7 @@ static inline pgprot_t vm_get_page_prot(
 {
 	return __pgprot(0);
 }
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	return __pgprot(0);
 }
--- a/mm/vma.c~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/mm/vma.c
@@ -56,7 +56,7 @@ struct mmap_state {
 		.pglen = PHYS_PFN(len_),				\
 		.vma_flags = vma_flags_,				\
 		.file = file_,						\
-		.page_prot = vma_get_page_prot(vma_flags_),		\
+		.page_prot = vma_flags_to_page_prot(vma_flags_),	\
 	}
 
 #define VMG_MMAP_STATE(name, map_, vma_)				\
--- a/mm/vma.h~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/mm/vma.h
@@ -543,7 +543,7 @@ static inline bool vma_wants_manual_pte_
 #ifdef CONFIG_MMU
 static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
 {
-	const pgprot_t prot = vma_get_page_prot(vma_flags);
+	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
 
 	return pgprot_modify(oldprot, prot);
 }
--- a/tools/testing/vma/include/dup.h~mm-vma-rename-vma_get_page_prot-to-vma_flags_to_page_prot
+++ a/tools/testing/vma/include/dup.h
@@ -1547,7 +1547,7 @@ static inline int get_sysctl_max_map_cou
 #define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
 #endif
 
-static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
+static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	const vm_flags_t vm_flags = vma_flags_to_legacy(vma_flags);
 
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

