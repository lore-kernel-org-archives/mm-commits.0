Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892AFEC2
	for <mm-commits@vger.kernel.org>; Tue, 23 Jul 2024 02:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721700840; cv=none; b=EjkLwITsd5rXckfoqMIkejaU814aQ7mmlJqFVsQYhO27z/wSsWdQ7ZWyB/3bUumLZq/InInkyxt3/0EF0gIJYNJQTB7HTXNQXbXxCx0x6NgUNcNfZAXPQw0b6+JJVdraaQchFaeqpN/nvDBDNdhQ/hfIjLo1mc2x6N6sf5Nl0uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721700840; c=relaxed/simple;
	bh=cZzLcpO3bKnWGh+CmyUulEzgDv/J7aKrvs3qf6kmAqA=;
	h=Date:To:From:Subject:Message-Id; b=J1dGa66tzeLDuOe53L8RS0hUVIvQFoTuQzah+siVd9nDecE1MtQb3MHLTfPBh6uhD4xFzwFEqlWk6KgieAvz49MdaDr7zUrx98umUNNatuXwOcpE8ybDKHH54pibgYa9BLlspxv71MrIgSiAK36f7B39Etp8J++nm28D8beepNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qzBRCGXG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qzBRCGXG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2279C116B1;
	Tue, 23 Jul 2024 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1721700840;
	bh=cZzLcpO3bKnWGh+CmyUulEzgDv/J7aKrvs3qf6kmAqA=;
	h=Date:To:From:Subject:From;
	b=qzBRCGXGLa/+HeFVVqQzHJKwLref3+7ZUBF9Mea6KjgmBcEOZ989M3v4iMi/ioWmX
	 iYncIc5mAMgjoD8vUhDFBP8U2XzT7pVa3wpiKxXW90fll9QvfqskDalL2WuIYktIhU
	 +xDPNCWmq8bd6k6fw5T8dAKz72V0yFjtbWgTmb3Y=
Date: Mon, 22 Jul 2024 19:13:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch added to mm-unstable branch
Message-Id: <20240723021359.F2279C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: rename shmem_is_huge() to shmem_huge_global_enabled()
Date: Mon, 22 Jul 2024 13:43:18 +0800

shmem_is_huge() is now used to check if the top-level huge page is
enabled, thus rename it to reflect its usage.

Link: https://lkml.kernel.org/r/da53296e0ab6359aa083561d9dc01e4223d60fbe.1721626645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    9 +++++----
 mm/huge_memory.c         |    5 +++--
 mm/shmem.c               |   15 ++++++++-------
 3 files changed, 16 insertions(+), 13 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled
+++ a/include/linux/shmem_fs.h
@@ -111,14 +111,15 @@ extern void shmem_truncate_range(struct
 int shmem_unuse(unsigned int type);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-			  struct mm_struct *mm, unsigned long vm_flags);
+extern bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+				      struct mm_struct *mm, unsigned long vm_flags);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				bool global_huge);
 #else
-static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-					  struct mm_struct *mm, unsigned long vm_flags)
+static __always_inline bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+						      bool shmem_huge_force, struct mm_struct *mm,
+						      unsigned long vm_flags)
 {
 	return false;
 }
--- a/mm/huge_memory.c~mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled
+++ a/mm/huge_memory.c
@@ -160,8 +160,9 @@ unsigned long __thp_vma_allowable_orders
 	 * own flags.
 	 */
 	if (!in_pf && shmem_file(vma->vm_file)) {
-		bool global_huge = shmem_is_huge(file_inode(vma->vm_file), vma->vm_pgoff,
-							!enforce_sysfs, vma->vm_mm, vm_flags);
+		bool global_huge = shmem_huge_global_enabled(file_inode(vma->vm_file),
+							     vma->vm_pgoff, !enforce_sysfs,
+							     vma->vm_mm, vm_flags);
 
 		if (!vma_is_anon_shmem(vma))
 			return global_huge ? orders : 0;
--- a/mm/shmem.c~mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled
+++ a/mm/shmem.c
@@ -548,9 +548,9 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool __shmem_is_huge(struct inode *inode, pgoff_t index,
-			    bool shmem_huge_force, struct mm_struct *mm,
-			    unsigned long vm_flags)
+static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+					bool shmem_huge_force, struct mm_struct *mm,
+					unsigned long vm_flags)
 {
 	loff_t i_size;
 
@@ -581,14 +581,15 @@ static bool __shmem_is_huge(struct inode
 	}
 }
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index,
+bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
 		   bool shmem_huge_force, struct mm_struct *mm,
 		   unsigned long vm_flags)
 {
 	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
 
-	return __shmem_is_huge(inode, index, shmem_huge_force, mm, vm_flags);
+	return __shmem_huge_global_enabled(inode, index, shmem_huge_force,
+					   mm, vm_flags);
 }
 
 #if defined(CONFIG_SYSFS)
@@ -1156,7 +1157,7 @@ static int shmem_getattr(struct mnt_idma
 			STATX_ATTR_NODUMP);
 	generic_fillattr(idmap, request_mask, inode, stat);
 
-	if (shmem_is_huge(inode, 0, false, NULL, 0))
+	if (shmem_huge_global_enabled(inode, 0, false, NULL, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -2153,7 +2154,7 @@ repeat:
 		return 0;
 	}
 
-	huge = shmem_is_huge(inode, index, false, fault_mm,
+	huge = shmem_huge_global_enabled(inode, index, false, fault_mm,
 			     vma ? vma->vm_flags : 0);
 	/* Find hugepage orders that are allowed for anonymous shmem. */
 	if (vma && vma_is_anon_shmem(vma))
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch

