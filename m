Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3515E24293C
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896623; cv=none; b=bIT41FbuxT1Sd9cwt+cXnNb2i5vs9s2a5xM2Fa8DoA/OvMuXYg/EDlcxd5gkLzhBcyQ0Ygd/GhCYwlUTxXE6skDYJ0BorCt86psfBuI6bqJ6hMPaMxFEZ7J4KId7V3Z9gN8p0UvvwyEK24+xTQnOMUO0x6DFLsEZ9tPuU9K0F8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896623; c=relaxed/simple;
	bh=6EPLFFi1lXo4FBbWj7nFk6CU4utCAhOA0GGa1iv2rMs=;
	h=Date:To:From:Subject:Message-Id; b=eKBFwvCkVXX+HfeXObVmEoghzE7hOTYqRO9vCFRyAvPuO6xFqKlG9fGuNxvuOUHIqz06vKf3/dNDl7oyohZIHefzncdWyIU3ZAJOu+Wn4Uewi9bwWrvJfgyTkShtZnTnQAzaTJgxxeFeqDAOCT6CRoqpXwfBN2VdeGcvUAOCmSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UEAXxTzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UEAXxTzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B871F00A3A;
	Wed,  5 Aug 2026 02:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896622;
	bh=x1ZY538xCPAdinDPRf6Tb/7BNiAxCDpKlqB00u81dE8=;
	h=Date:To:From:Subject;
	b=UEAXxTzlCIw8Fk1onoDsX8coJ1vVcGmBNCQoxN82v/oux0mbppBmwUbwdPv/wECHt
	 Nxyj4/caNhO3aQSY9le1oitZnQ/iNqZaSPrhQxPzUQCjwIEMDOLO7PJe04/FJpRG6M
	 NbWqfhIvvhUA1IA8btHe1KRkpUdmzLQCzWgq7XGY=
Date: Tue, 04 Aug 2026 19:23:41 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,seanjc@google.com,rppt@kernel.org,peterx@redhat.com,pbonzini@redhat.com,ljs@kernel.org,liam@infradead.org,jthoughton@google.com,david@kernel.org,corbet@lwn.net,aarcange@redhat.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch removed from -mm tree
Message-Id: <20260805022341.F2B871F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: test uffd VMA flags through the vma_flags_t API
has been removed from the -mm tree.  Its filename was
     userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: userfaultfd: test uffd VMA flags through the vma_flags_t API
Date: Wed, 8 Jul 2026 12:14:05 +0100

The uffd VMA-flag helpers read vma->vm_flags directly.  Now that
config-gated per-mode masks exist, switch them to the vma_flags_t accessor
vma_test_any_mask(), which is the going-forward API and keeps a single
place (the VMA_UFFD_* masks) that knows which modes are available on the
current build.

No functional change: vma_flags_t is in union with vm_flags, so the same
bits are read, and the masks fold to the same code the open-coded vm_flags
tests produced -- verified identical on gcc and clang, 32- and 64-bit.

Link: https://lore.kernel.org/20260708111417.173443-5-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Assisted-by: Claude:claude-opus-4-8
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: James Houghton <jthoughton@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/userfaultfd_k.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/userfaultfd_k.h~userfaultfd-test-uffd-vma-flags-through-the-vma_flags_t-api
+++ a/include/linux/userfaultfd_k.h
@@ -178,7 +178,8 @@ static inline bool is_mergeable_vm_userf
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma_test_any_mask(vma,
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
 }
 
 /*
@@ -190,22 +191,23 @@ static inline bool uffd_disable_huge_pmd
  */
 static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma_test_any_mask(vma,
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
 }
 
 static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_UFFD_MISSING;
+	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
 }
 
 static inline bool userfaultfd_wp(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_UFFD_WP;
+	return vma_test_any_mask(vma, VMA_UFFD_WP);
 }
 
 static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & VM_UFFD_MINOR;
+	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
 }
 
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
@@ -222,7 +224,7 @@ static inline bool userfaultfd_huge_pmd_
 
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & __VM_UFFD_FLAGS;
+	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
 }
 
 static inline bool vma_has_uffd_without_event_remap(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from kas@kernel.org are

selftests-mm-add-pagemap_scan-test-for-thp-pmd-holes.patch
mm-huge_memory-remove-unused-can_split_folio.patch
mm-huge_memory-fold-split_folio_to_list_to_order-into-split_folio_to_order.patch
mm-fold-userfaultfd_rwp-to-false-without-config_arch_has_pte_protnone.patch

