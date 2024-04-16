Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825501E511;
	Tue, 16 Apr 2024 22:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307232; cv=none; b=iFGd0XHPvfZ6STCyr35q0C4On6g13TBU3lJaVvjRTb7+ZhoW8Cq8Gw2+b7AKIBabmHRlXe0PanNd9ND9x7DtA0EEgDS9BnrDEzIBgZ17vzcRPkR+gkCQbd2NWOV0pofLlqeGC+3t7mDj7mDyLZqqsQrbwTZ5FpQ17mKuVMiGQHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307232; c=relaxed/simple;
	bh=VtQaT92+h5NU00NbXIcDDTIGbVFXs+hkLJGgyKuQ7vo=;
	h=Date:To:From:Subject:Message-Id; b=jf+udVzj9OLBa24oHuFckEFTyKwbWpmrLIhLl2z1SPObwwdjpqGIreciFWMHveSSl/J5bROjt3K4mX6aeGlLQEfjBuVJmcSNQs7/r7V4VSDPu/93Qnbppeburux/vYYM2MokbX1kouPss2hNG1r4ovO1aV4G5/C7H6Rg6iSpXFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kXGR7Q5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kXGR7Q5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A228C113CE;
	Tue, 16 Apr 2024 22:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713307232;
	bh=VtQaT92+h5NU00NbXIcDDTIGbVFXs+hkLJGgyKuQ7vo=;
	h=Date:To:From:Subject:From;
	b=kXGR7Q5GA3YJePsHAS8SzneAYX5X9xiW3Nu756/e5mTokLWOOTYr9OLIvthtHGLox
	 FJwYKmFaDHsulhKLRra7Y55443IiKccOooesjO1Amerd+8tVc2jutWYMYcCWq6IOJd
	 dlelYDiVcap8yW++AS2lNxCcsYjy2GX/+CkGyKQ8=
Date: Tue, 16 Apr 2024 15:40:31 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,iii@linux.ibm.com,hughd@google.com,hca@linux.ibm.com,gor@linux.ibm.com,david@redhat.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages.patch removed from -mm tree
Message-Id: <20240416224032.3A228C113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/shmem: inline shmem_is_huge() for disabled transparent hugepages
has been removed from the -mm tree.  Its filename was
     mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm/shmem: inline shmem_is_huge() for disabled transparent hugepages
Date: Tue, 9 Apr 2024 17:54:07 +0200

In order to  minimize code size (CONFIG_CC_OPTIMIZE_FOR_SIZE=y),
compiler might choose to make a regular function call (out-of-line) for
shmem_is_huge() instead of inlining it. When transparent hugepages are
disabled (CONFIG_TRANSPARENT_HUGEPAGE=n), it can cause compilation
error.

mm/shmem.c: In function `shmem_getattr':
./include/linux/huge_mm.h:383:27: note: in expansion of macro `BUILD_BUG'
  383 | #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
      |                           ^~~~~~~~~
mm/shmem.c:1148:33: note: in expansion of macro `HPAGE_PMD_SIZE'
 1148 |                 stat->blksize = HPAGE_PMD_SIZE;

To prevent the possible error, always inline shmem_is_huge() when
transparent hugepages are disabled.

Link: https://lkml.kernel.org/r/20240409155407.2322714-1-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    9 +++++++++
 mm/shmem.c               |    6 ------
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages
+++ a/include/linux/shmem_fs.h
@@ -110,8 +110,17 @@ extern struct page *shmem_read_mapping_p
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
 			  struct mm_struct *mm, unsigned long vm_flags);
+#else
+static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+					  struct mm_struct *mm, unsigned long vm_flags)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SHMEM
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 #else
--- a/mm/shmem.c~mm-shmem-inline-shmem_is_huge-for-disabled-transparent-hugepages
+++ a/mm/shmem.c
@@ -748,12 +748,6 @@ static long shmem_unused_huge_count(stru
 
 #define shmem_huge SHMEM_HUGE_DENY
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-		   struct mm_struct *mm, unsigned long vm_flags)
-{
-	return false;
-}
-
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_split)
 {
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are


