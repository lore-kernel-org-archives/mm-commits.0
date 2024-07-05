Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16B79F3
	for <mm-commits@vger.kernel.org>; Fri,  5 Jul 2024 21:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720213482; cv=none; b=O56M0toCZXKWZAKQBVmePQJecDjL3PRkcOP9T5iLCgTUsb71ZGmJsh+7m1ERsDbXM/kNu+oxGwP5//uWaUKPAxVHGYbwVBNxUVmtDWVhJ/DH8zBzNTdWG9AQK4/UPQwb1SidxIBeyuE8yDUFMeTLa/mjwqSgMsO1w57Z7DE3KXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720213482; c=relaxed/simple;
	bh=qaHbcyitKfKWYet3acyQlAArdC8R823U3A24hk0zp9E=;
	h=Date:To:From:Subject:Message-Id; b=Mu3ye6ZKHC6cFM7n1pSSGysbeumBg/Gk9hS6ya0Mv8nh+ZUgQN+bop6jp+VyQlWLD7SXx7V6Jr5LKeI5UJXvD3cToWAulKe10Bp3rU2s2gsfe5O32CuCqnTxKJLz5X6ANhxut+GmsRqxQ9B2CCigecfhX1ZnT71ezQHly4VOZnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GKo+GQxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GKo+GQxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506A7C116B1;
	Fri,  5 Jul 2024 21:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720213481;
	bh=qaHbcyitKfKWYet3acyQlAArdC8R823U3A24hk0zp9E=;
	h=Date:To:From:Subject:From;
	b=GKo+GQxo5PtD9CNZIh8sw7SA+uBZpcdmO/pgquxHt78Xv6PvwCuHseLwH0Vi6VFFN
	 rGMc/aTEBmvLEbfjCBz592bOiCClt5xOEV1+LZVL/4y8wxY1YOBuIAbZVoq586s0Pj
	 VSwRLrG6EqvYLkIMWeBZQWis5sa85Dfx88W3///s=
Date: Fri, 05 Jul 2024 14:04:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch added to mm-unstable branch
Message-Id: <20240705210441.506A7C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-shmem-fix-input-and-output-inconsistencies.patch
mm-thp-support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

