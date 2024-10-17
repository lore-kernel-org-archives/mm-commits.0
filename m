Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76B91D63EE
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729201261; cv=none; b=nrhWd5Kuok8UDi9vN5iJ/CImA2OuF89JzARWTZXwrIjqi285zhpxndO2Aq6FMrSh3ZM7k8CW2EGEsQMv1oLMiKmkKVJodziyhYovNaUA/tvqLsQVjfX13NRWigvvQ7qlQGcG5ZaFo6Sf53Sd0GsSNndOvsEjkzOQGyhnvfTXcDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729201261; c=relaxed/simple;
	bh=NerkuuZhOcYbnMic7TVnAGDgrCGtA9Vp8mawR32d6X0=;
	h=Date:To:From:Subject:Message-Id; b=oIYHcvl9t7o6hMBnzikqrJ9cfRLdnMoYgkk9LFXndFg0KS/j6O++L7pTffMVLhBxMwsKzidqLUVyOey0LU/Ph2WRWXu4AkkmVe4cCUYiobeX0uGB2IaepcWuq/UWEsVlUWrZUTRT9yR00Y7PEw6bjuT5dsXNmwCxW7gQmj32AnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UVMtPvYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UVMtPvYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FD1BC4CED2;
	Thu, 17 Oct 2024 21:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729201261;
	bh=NerkuuZhOcYbnMic7TVnAGDgrCGtA9Vp8mawR32d6X0=;
	h=Date:To:From:Subject:From;
	b=UVMtPvYb3zg+Dqtq2J0y4ZnebMrmKZH0uA2G8o0pZHR/Nj/JEglkJDF7oQ6htinsO
	 8Y8mmpKa1A2rAVjJHnyI/ffvavvHbnSK+0h6Fip2wPxfLRyFwAJ4coRK8o/jYbQETH
	 OHttLfXoSm2uNRV8QEMSgqCG2rdy4dk/N2bmNCI0=
Date: Thu, 17 Oct 2024 14:41:00 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-remove-__shmem_huge_global_enabled.patch added to mm-unstable branch
Message-Id: <20241017214101.3FD1BC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: remove __shmem_huge_global_enabled()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-remove-__shmem_huge_global_enabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-remove-__shmem_huge_global_enabled.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: shmem: remove __shmem_huge_global_enabled()
Date: Thu, 17 Oct 2024 22:14:57 +0800

Remove __shmem_huge_global_enabled() since it as only one caller, and
remove repeated check of VM_NOHUGEPAGE/MMF_DISABLE_THP as they are checked
in shmem_allowable_huge_orders(), also remove unnecessary vma parameter.

Link: https://lkml.kernel.org/r/20241017141457.1169092-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   33 ++++++++++-----------------------
 1 file changed, 10 insertions(+), 23 deletions(-)

--- a/mm/shmem.c~mm-shmem-remove-__shmem_huge_global_enabled
+++ a/mm/shmem.c
@@ -548,17 +548,15 @@ static bool shmem_confirm_swap(struct ad
 
 static int shmem_huge __read_mostly = SHMEM_HUGE_NEVER;
 
-static bool __shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-					loff_t write_end, bool shmem_huge_force,
-					struct vm_area_struct *vma,
-					unsigned long vm_flags)
+static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
+				      loff_t write_end, bool shmem_huge_force,
+				      unsigned long vm_flags)
 {
-	struct mm_struct *mm = vma ? vma->vm_mm : NULL;
 	loff_t i_size;
 
-	if (!S_ISREG(inode->i_mode))
+	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
 		return false;
-	if (mm && ((vm_flags & VM_NOHUGEPAGE) || test_bit(MMF_DISABLE_THP, &mm->flags)))
+	if (!S_ISREG(inode->i_mode))
 		return false;
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
@@ -576,7 +574,7 @@ static bool __shmem_huge_global_enabled(
 			return true;
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
-		if (mm && (vm_flags & VM_HUGEPAGE))
+		if (vm_flags & VM_HUGEPAGE)
 			return true;
 		fallthrough;
 	default:
@@ -584,17 +582,6 @@ static bool __shmem_huge_global_enabled(
 	}
 }
 
-static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-		   loff_t write_end, bool shmem_huge_force,
-		   struct vm_area_struct *vma, unsigned long vm_flags)
-{
-	if (HPAGE_PMD_ORDER > MAX_PAGECACHE_ORDER)
-		return false;
-
-	return __shmem_huge_global_enabled(inode, index, write_end,
-					   shmem_huge_force, vma, vm_flags);
-}
-
 #if defined(CONFIG_SYSFS)
 static int shmem_parse_huge(const char *str)
 {
@@ -772,8 +759,8 @@ static unsigned long shmem_unused_huge_s
 }
 
 static bool shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
-		loff_t write_end, bool shmem_huge_force,
-		struct vm_area_struct *vma, unsigned long vm_flags)
+				      loff_t write_end, bool shmem_huge_force,
+				      unsigned long vm_flags)
 {
 	return false;
 }
@@ -1170,7 +1157,7 @@ static int shmem_getattr(struct mnt_idma
 	generic_fillattr(idmap, request_mask, inode, stat);
 	inode_unlock_shared(inode);
 
-	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
+	if (shmem_huge_global_enabled(inode, 0, 0, false, 0))
 		stat->blksize = HPAGE_PMD_SIZE;
 
 	if (request_mask & STATX_BTIME) {
@@ -1687,7 +1674,7 @@ unsigned long shmem_allowable_huge_order
 		return 0;
 
 	global_huge = shmem_huge_global_enabled(inode, index, write_end,
-					shmem_huge_force, vma, vm_flags);
+						shmem_huge_force, vm_flags);
 	if (!vma || !vma_is_anon_shmem(vma)) {
 		/*
 		 * For tmpfs, we now only support PMD sized THP if huge page
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-remove-unused-hugepage-for-vma_alloc_folio.patch
tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-huge_memory-move-file_thp_enabled-into-huge_memoryc.patch
mm-shmem-remove-__shmem_huge_global_enabled.patch

