Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA243B71B8
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068046; cv=none; b=TILsvKLdbbev+/BnLONGGLLWv82zFTTNL80eKF7cJ+A+DjOlzudO1lBVLcHhpnXQDaLcXXz0StB18RJ3OzVNbqC+nwqMORjm2efplLnqVXVbToEK0KynC6Ad/01U03+gv7iODXIOwkB0HIOtidT/D/pjWhaLHnI0bWSVWL+FztU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068046; c=relaxed/simple;
	bh=O+V8qOovDkepANzsIC/dfBnJj/jh3hhpfaQ/SkYG2sw=;
	h=Date:To:From:Subject:Message-Id; b=i34BHvih6X24OEEeolTlv1uaazm91hIhUm5BX7WJhwYT29KynvBJyqAkOEqSOqzna8HqkXOmUcBz6dTfZUj1BDpNbue8KBkuAopQNrEuA17i5nyMEqIWnStF3dKjWIoP/j4HDXNINdoRhLH1RCTncRNLqsgs2vu5ErfI2iGPRlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ytZY7tvH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ytZY7tvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C289D1F000E9;
	Fri,  7 Aug 2026 02:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068041;
	bh=AAE5/i/ftX9dmvI+QnZAXZVM5db0e4OFBf4/Q2qSagA=;
	h=Date:To:From:Subject;
	b=ytZY7tvHb+JbQmQhQ1XuTMLOOAOlZ+yPw6Ni6jGBBtPKPoLVZ7S9g1KqhCu8FzCAX
	 DKb3yH2zTwAm5PF9pw0i5b3PjuMpDQqcF3B7RrHaL8UZDsZL5VUpk3kysEy556Ioqc
	 UlSvsZKUrHd39fMAmpyU7iZsQTPYK2syKNfkD8jo=
Date: Thu, 06 Aug 2026 19:00:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,surenb@google.com,rppt@kernel.org,pfalcato@suse.de,osalvador@suse.de,npache@redhat.com,muchun.song@linux.dev,lance.yang@linux.dev,jannh@google.com,jani.nikula@intel.com,jack@suse.cz,dev.jain@arm.com,david@kernel.org,brauner@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,airlied@gmail.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch removed from -mm tree
Message-Id: <20260807020041.C289D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce vma_flags_can_grow() and vma_can_grow()
has been removed from the -mm tree.  Its filename was
     mm-introduce-vma_flags_can_grow-and-vma_can_grow.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: mm: introduce vma_flags_can_grow() and vma_can_grow()
Date: Sat, 11 Jul 2026 19:44:58 +0100

Patch series "mm: convert more vm_flags_t users to vma_flags_t", v2.

This series makes further progress in converting usage of the deprecated
vm_flags_t type to its replacement, vma_flags_t.

It focuses on mm, though updates some users of mm APIs also.

It updates:

* The core do_mmap() code path for VMA mapping.
* Unmapped area logic.
* The usage of mm->def_vma_flags.
* VMA page protection bit logic.
* General usage of VMA flags in core mm code, mlock, mprotect, mremap.


This patch (of 13):

These test whether the VMA has stack semantics, i.e.  is able to grow
upwards or downwards depending on the architecture.

In order to account for arches which do not support upward-growing stacks,
introduce VMA_GROWSUP whose definition depends on the architecture
supporting it, and use vma_flags_test_single_mask() in
vma_flags_can_grow() to account for this.

No functional change intended.

Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org
Link: https://lore.kernel.org/20260711-b4-vma-flags-mm-v2-1-0fa2357d5431@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nico Pache <npache@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-introduce-vma_flags_can_grow-and-vma_can_grow
+++ a/include/linux/mm.h
@@ -474,6 +474,7 @@ enum {
 #define VM_SAO		INIT_VM_FLAG(SAO)
 #elif defined(CONFIG_PARISC)
 #define VM_GROWSUP	INIT_VM_FLAG(GROWSUP)
+#define VMA_GROWSUP	mk_vma_flags(VMA_GROWSUP_BIT)
 #elif defined(CONFIG_SPARC64)
 #define VM_SPARC_ADI	INIT_VM_FLAG(SPARC_ADI)
 #define VM_ARCH_CLEAR	INIT_VM_FLAG(ARCH_CLEAR)
@@ -485,6 +486,7 @@ enum {
 #endif
 #ifndef VM_GROWSUP
 #define VM_GROWSUP	VM_NONE
+#define VMA_GROWSUP	EMPTY_VMA_FLAGS
 #endif
 #ifdef CONFIG_ARM64_MTE
 #define VM_MTE		INIT_VM_FLAG(MTE)
@@ -1578,11 +1580,24 @@ static inline bool vma_is_initial_stack(
 		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
-static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
+static inline bool vma_flags_can_grow(const vma_flags_t *flags)
 {
-	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
+	if (vma_flags_test_single_mask(flags, VMA_GROWSUP))
+		return true;
+	if (vma_flags_test(flags, VMA_GROWSDOWN_BIT))
+		return true;
 
-	if (!maybe_stack)
+	return false;
+}
+
+static inline bool vma_can_grow(const struct vm_area_struct *vma)
+{
+	return vma_flags_can_grow(&vma->flags);
+}
+
+static inline bool vma_is_temporary_stack(const struct vm_area_struct *vma)
+{
+	if (!vma_can_grow(vma))
 		return false;
 
 	if ((vma->vm_flags & VM_STACK_INCOMPLETE_SETUP) ==
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

