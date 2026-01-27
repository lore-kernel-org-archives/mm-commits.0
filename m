Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3446F31619E
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486661; cv=none; b=KCgpvxut6pqQ2QybWJWlwX/VwLlH3Z2e2ntgzPVugJ3fNR/BmOTzgh6M4smrfLcELdluu1Jah5wb0EhIPtL+kidL5eXXNgY36v+EKQ8jYyI5+Aow35shFioIVZLt4NUFi98Fg5uLEesaMtA9UuO5hTvMLdrmmAZ8xMdL3hBwVgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486661; c=relaxed/simple;
	bh=17UYQ5IUs2Iz9HR4Zfz5ET0Oi+Gf2sZwJE+xdZXuTHs=;
	h=Date:To:From:Subject:Message-Id; b=J5AIGyYQqwr5qOcQVnUZK5BSbb7NGd2IUHQVioU/7jiM4Fabw7G86kBokqAfC3Cmh/HwzR/A7FcQLwXMl9Ah9uXYkeGgaRVd1ldBbR860QyeuuxJLgbXaOnyKMglBMGQnAx1JDcQRBvnZCiRz26QaWD18K5y0s4sJhDhBkZfELg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bE46tpKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bE46tpKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3C0C116C6;
	Tue, 27 Jan 2026 04:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486661;
	bh=17UYQ5IUs2Iz9HR4Zfz5ET0Oi+Gf2sZwJE+xdZXuTHs=;
	h=Date:To:From:Subject:From;
	b=bE46tpKnJ2jLVYq3Y8K/ix2Ra1buy1OmdxYo62IXIC9cFwsSUAXhPa071pUwv6F9T
	 4VMrqflqotpvqNMhC+bOlC5Sg+g+H3RO2O3YqA7cODv9RErqETqXEycHmYqdSyajDO
	 /fw4POdxGNF/2RHPiHYPNZPWqZ3+/yFgNAvqNqCk=
Date: Mon, 26 Jan 2026 20:04:20 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,pfalcato@suse.de,mhocko@suse.com,Liam.Howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,chriscli@google.com,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-remove-anon_vma_merge-function.patch removed from -mm tree
Message-Id: <20260127040421.0A3C0C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: remove anon_vma_merge() function
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-anon_vma_merge-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm/rmap: remove anon_vma_merge() function
Date: Sun, 18 Jan 2026 14:50:41 +0000

This function is confusing, we already have the concept of anon_vma merge
to adjacent VMA's anon_vma's to increase probability of anon_vma
compatibility and therefore VMA merge (see is_mergeable_anon_vma() etc.),
as well as anon_vma reuse, along side the usual VMA merge logic.

We can remove the anon_vma check as it is redundant - a merge would not
have been permitted with removal if the anon_vma's were not the same (and
in the case of an unfaulted/faulted merge, we would have already set the
unfaulted VMA's anon_vma to vp->remove->anon_vma in dup_anon_vma()).

Avoid overloading this term when we're very simply unlinking anon_vma
state from a removed VMA upon merge.

Link: https://lkml.kernel.org/r/56bbe45e309f7af197b1c4f94a9a0c8931ff2d29.1768746221.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chriscli@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h             |    7 -------
 mm/vma.c                         |    2 +-
 tools/testing/vma/vma_internal.h |    5 -----
 3 files changed, 1 insertion(+), 13 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-anon_vma_merge-function
+++ a/include/linux/rmap.h
@@ -165,13 +165,6 @@ static inline int anon_vma_prepare(struc
 	return __anon_vma_prepare(vma);
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-	VM_BUG_ON_VMA(vma->anon_vma != next->anon_vma, vma);
-	unlink_anon_vmas(next);
-}
-
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
 #ifdef CONFIG_MM_ID
--- a/mm/vma.c~mm-rmap-remove-anon_vma_merge-function
+++ a/mm/vma.c
@@ -381,7 +381,7 @@ again:
 			fput(vp->file);
 		}
 		if (vp->remove->anon_vma)
-			anon_vma_merge(vp->vma, vp->remove);
+			unlink_anon_vmas(vp->remove);
 		mm->map_count--;
 		mpol_put(vma_policy(vp->remove));
 		if (!vp->remove2)
--- a/tools/testing/vma/vma_internal.h~mm-rmap-remove-anon_vma_merge-function
+++ a/tools/testing/vma/vma_internal.h
@@ -1265,11 +1265,6 @@ static inline void i_mmap_unlock_write(s
 {
 }
 
-static inline void anon_vma_merge(struct vm_area_struct *vma,
-				  struct vm_area_struct *next)
-{
-}
-
 static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 					 unsigned long start,
 					 unsigned long end,
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

selftests-mm-remove-virtual_address_range-test.patch
mm-vma-rename-vma_lock_offset-to-vm_refcnt_exclude_readers_flag.patch
mm-vma-document-possible-vma-vm_refcnt-values-and-reference-comment.patch
mm-vma-rename-is_vma_write_only-separate-out-shared-refcount-put.patch
mm-vma-adduse-vma-lockdep-acquire-release-defines.patch
mm-vma-de-duplicate-__vma_enter_locked-error-path.patch
mm-vma-clean-up-__vma_enter-exit_locked.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-vma-improve-and-document-__is_vma_write_locked.patch
mm-vma-improve-and-document-__is_vma_write_locked-fix.patch
mm-vma-update-vma_assert_locked-to-use-lockdep.patch
mm-vma-update-vma_assert_locked-to-use-lockdep-fix.patch
mm-vma-add-and-use-vma_assert_stabilised.patch
mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

