Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEADC2E2F14
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939837; cv=none; b=nzM3BTiDmU8kMOgVPmvj21aQyLNzTk1LYjN/84+WGiLIEAt+uf0dNWGrQ09TYYUnlyXJYxIAhQH5m6LxfV4RbCd7dIJGRqVPikzlQLaBrn/0ELhk+GnK7WkEbbLULIPlCjSB4riXAo7tw+sKjj9k6wTKiGVC29wkUaKpn5gVf8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939837; c=relaxed/simple;
	bh=UPrWe3vw90YTM25dGwy9PpBlpL8+CcOkZlVVWLj4Bes=;
	h=Date:To:From:Subject:Message-Id; b=Pvtr2e5VpcMFCdvEPimfwrD3NCX+hO5KSbg01lINj6LFg/zM0+jp74RPcDvlJVfEjzEBaENHWoEMPRIftGFFOecRmUc+R75INGYDpInw8+/A4aDsyjfjGke9u+vu0wh0iQGaCjdY/QwMuuH7YkXSBQ4tgSwySi6CuKHx96/UFKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=n3DC2HKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="n3DC2HKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8C3C4CEF7;
	Thu, 12 Feb 2026 23:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939837;
	bh=UPrWe3vw90YTM25dGwy9PpBlpL8+CcOkZlVVWLj4Bes=;
	h=Date:To:From:Subject:From;
	b=n3DC2HKnPQyjezkKSJu+in9FBf+w3kbAvsMxXgo5NDKE2Ba5IHx2oaTJ1CjxU7k10
	 dDiHtsHwLiRS9shvTKled6t6i3Yy3xij+okbCz55duWnciTHBhHKIK1NjQxZO8YCab
	 v6wfDS3lqKRl2Y7WALX4hkcParf6TWYOGB/Z9XsY=
Date: Thu, 12 Feb 2026 15:43:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,Liam.Howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch removed from -mm tree
Message-Id: <20260212234357.AF8C3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: rename vma_flag_test/set_atomic() to vma_test/set_atomic_flag()
has been removed from the -mm tree.  Its filename was
     mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: mm: rename vma_flag_test/set_atomic() to vma_test/set_atomic_flag()
Date: Thu, 22 Jan 2026 16:06:11 +0000

In order to stay consistent between functions which manipulate a
vm_flags_t argument of the form of vma_flags_...() and those which
manipulate a VMA (in this case the flags field of a VMA), rename
vma_flag_[test/set]_atomic() to vma_[test/set]_atomic_flag().

This lays the groundwork for adding VMA flag manipulation functions in a
subsequent commit.

Link: https://lkml.kernel.org/r/033dcf12e819dee5064582bced9b12ea346d1607.1769097829.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Chris Mason <clm@fb.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++--------
 mm/khugepaged.c    |    2 +-
 mm/madvise.c       |    2 +-
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/include/linux/mm.h~mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag
+++ a/include/linux/mm.h
@@ -987,8 +987,7 @@ static inline void vm_flags_mod(struct v
 	__vm_flags_mod(vma, set, clear);
 }
 
-static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
-					   vma_flag_t bit)
+static inline bool __vma_atomic_valid_flag(struct vm_area_struct *vma, vma_flag_t bit)
 {
 	const vm_flags_t mask = BIT((__force int)bit);
 
@@ -1003,13 +1002,12 @@ static inline bool __vma_flag_atomic_val
  * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
  * valid flags are allowed to do this.
  */
-static inline void vma_flag_set_atomic(struct vm_area_struct *vma,
-				       vma_flag_t bit)
+static inline void vma_set_atomic_flag(struct vm_area_struct *vma, vma_flag_t bit)
 {
 	unsigned long *bitmap = vma->flags.__vma_flags;
 
 	vma_assert_stabilised(vma);
-	if (__vma_flag_atomic_valid(vma, bit))
+	if (__vma_atomic_valid_flag(vma, bit))
 		set_bit((__force int)bit, bitmap);
 }
 
@@ -1020,10 +1018,9 @@ static inline void vma_flag_set_atomic(s
  * This is necessarily racey, so callers must ensure that serialisation is
  * achieved through some other means, or that races are permissible.
  */
-static inline bool vma_flag_test_atomic(struct vm_area_struct *vma,
-					vma_flag_t bit)
+static inline bool vma_test_atomic_flag(struct vm_area_struct *vma, vma_flag_t bit)
 {
-	if (__vma_flag_atomic_valid(vma, bit))
+	if (__vma_atomic_valid_flag(vma, bit))
 		return test_bit((__force int)bit, &vma->vm_flags);
 
 	return false;
--- a/mm/khugepaged.c~mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag
+++ a/mm/khugepaged.c
@@ -1741,7 +1741,7 @@ static bool file_backed_vma_is_retractab
 	 * obtained on guard region installation after the flag is set, so this
 	 * check being performed under this lock excludes races.
 	 */
-	if (vma_flag_test_atomic(vma, VMA_MAYBE_GUARD_BIT))
+	if (vma_test_atomic_flag(vma, VMA_MAYBE_GUARD_BIT))
 		return false;
 
 	return true;
--- a/mm/madvise.c~mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag
+++ a/mm/madvise.c
@@ -1140,7 +1140,7 @@ static long madvise_guard_install(struct
 	 * acquire an mmap/VMA write lock to read it. All remaining readers may
 	 * or may not see the flag set, but we don't care.
 	 */
-	vma_flag_set_atomic(vma, VMA_MAYBE_GUARD_BIT);
+	vma_set_atomic_flag(vma, VMA_MAYBE_GUARD_BIT);
 
 	/*
 	 * If anonymous and we are establishing page tables the VMA ought to
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are


