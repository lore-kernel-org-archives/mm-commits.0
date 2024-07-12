Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D78D127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824895; cv=none; b=QAGN4SOVLVw9PAZe22eTHPhNA1eaYKIsI2E8RhZzLt2dk/GJkWQRlXueOjEwTepqSeRvoC48fUkRPdid993NXp9ZeGAwUpcCrOHRQN12s/AeeVsbEET/q2aff0luhJFlBY97txAKXU5D7NZm0baD3PNvSFGR72ZcCNk7lBKtkuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824895; c=relaxed/simple;
	bh=4jdTlRci0Zd2+PGDibUpuTwL29WZ9NE9Gt4XDZmMoEQ=;
	h=Date:To:From:Subject:Message-Id; b=J+QVyJzo0cTO2Swd90XmgQWIMl5d7xz9/i5QHHSjCWqnZc2y/O1EJkATW5j0IjDM2lTHBqRn/eCBxqVUMvbSF9b4O5Pb9Gbq3wd8YpRpaIMeDVt1OKnIPmYh205Lw1R/pWkQmohKoJMshvHhZjG4Gjcpb7mI5CI9u0uHFW1pT+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h6Qym0qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h6Qym0qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1286BC32782;
	Fri, 12 Jul 2024 22:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824895;
	bh=4jdTlRci0Zd2+PGDibUpuTwL29WZ9NE9Gt4XDZmMoEQ=;
	h=Date:To:From:Subject:From;
	b=h6Qym0qtWaoaf6JXEyST88P5Mn9lB6yFovNaNGGZfX1Qt4Lzq6u/cW38WmtzgwFeb
	 zg5Suc4lAfQFKolGmc0ihzNMjXtWSwCZoYiOdRIqeayGwRy9UrZHDD79ZKn/zDgtVr
	 /CM87Bce5JacpLLKV4778OqM+RfNMYUUv26jSpz4=
Date: Fri, 12 Jul 2024 15:54:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch removed from -mm tree
Message-Id: <20240712225455.1286BC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem
has been removed from the -mm tree.  Its filename was
     mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Bang Li" <libang.li@antgroup.com>
Subject: mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem
Date: Fri, 05 Jul 2024 11:23:09 +0800

After the commit 7fb1b252afb5 ("mm: shmem: add mTHP support for anonymous
shmem"), we can configure different policies through the multi-size THP
sysfs interface for anonymous shmem.  But currently "THPeligible"
indicates only whether the mapping is eligible for allocating THP-pages as
well as the THP is PMD mappable or not for anonymous shmem, we need to
support semantics for mTHP with anonymous shmem similar to those for mTHP
with anonymous memory.

Link: https://lkml.kernel.org/r/20240705032309.24933-1-libang.li@antgroup.com
Signed-off-by: Bang Li <libang.li@antgroup.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    9 +++++++++
 mm/huge_memory.c         |   13 +++++++++----
 mm/shmem.c               |    9 +--------
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/include/linux/shmem_fs.h~mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem
+++ a/include/linux/shmem_fs.h
@@ -113,12 +113,21 @@ int shmem_unuse(unsigned int type);
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
 			  struct mm_struct *mm, unsigned long vm_flags);
+unsigned long shmem_allowable_huge_orders(struct inode *inode,
+				struct vm_area_struct *vma, pgoff_t index,
+				bool global_huge);
 #else
 static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
 					  struct mm_struct *mm, unsigned long vm_flags)
 {
 	return false;
 }
+static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
+				struct vm_area_struct *vma, pgoff_t index,
+				bool global_huge)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_SHMEM
--- a/mm/huge_memory.c~mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem
+++ a/mm/huge_memory.c
@@ -151,10 +151,15 @@ unsigned long __thp_vma_allowable_orders
 	 * Must be done before hugepage flags check since shmem has its
 	 * own flags.
 	 */
-	if (!in_pf && shmem_file(vma->vm_file))
-		return shmem_is_huge(file_inode(vma->vm_file), vma->vm_pgoff,
-				     !enforce_sysfs, vma->vm_mm, vm_flags)
-			? orders : 0;
+	if (!in_pf && shmem_file(vma->vm_file)) {
+		bool global_huge = shmem_is_huge(file_inode(vma->vm_file), vma->vm_pgoff,
+							!enforce_sysfs, vma->vm_mm, vm_flags);
+
+		if (!vma_is_anon_shmem(vma))
+			return global_huge ? orders : 0;
+		return shmem_allowable_huge_orders(file_inode(vma->vm_file),
+							vma, vma->vm_pgoff, global_huge);
+	}
 
 	if (!vma_is_anonymous(vma)) {
 		/*
--- a/mm/shmem.c~mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem
+++ a/mm/shmem.c
@@ -1622,7 +1622,7 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static unsigned long shmem_allowable_huge_orders(struct inode *inode,
+unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				bool global_huge)
 {
@@ -1707,13 +1707,6 @@ static unsigned long shmem_suitable_orde
 	return orders;
 }
 #else
-static unsigned long shmem_allowable_huge_orders(struct inode *inode,
-				struct vm_area_struct *vma, pgoff_t index,
-				bool global_huge)
-{
-	return 0;
-}
-
 static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault *vmf,
 					   struct address_space *mapping, pgoff_t index,
 					   unsigned long orders)
_

Patches currently in -mm which might be from libang.li@antgroup.com are


