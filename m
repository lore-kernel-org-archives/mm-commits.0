Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB07518732E
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854822; cv=none; b=SwyAaadE6iaOQNqXHmfLdWEE93zJwcsYPeqsogWEOxQz9dSzPTfdwUrpZbct57e1jhwZCWeUnZL4G1sx+r24Z9jZ2hIbNEdkhtqfdQlyAl6qzs+AeA6JbAqHe0FM8cyRIQUgX9eSotSjKoPHJObPgqrpzHVG6YccaDrA5wVWETA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854822; c=relaxed/simple;
	bh=9C849KAjgIKC6JQb24v3XISyWP7KFrytBsvZmzIhv4o=;
	h=Date:To:From:Subject:Message-Id; b=n01+vKgZ+T87CI6vqEr3KdGmgQ+fVr8KACC497kDJi1rKx3Lr6GnZ0hM0lz6r/ix3sWJdQaLTCpuoZ8qmZgxjBMjnOYKWCTxGoprjThpE+NkHiP7l2eZGevVo7U+7tGvaFMmH0PGE3It1Y2cQkmd8beFKX/HyTIKUmH8Wuxlmhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9LHLn2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9LHLn2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82702C4CECF;
	Wed,  6 Nov 2024 01:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854822;
	bh=9C849KAjgIKC6JQb24v3XISyWP7KFrytBsvZmzIhv4o=;
	h=Date:To:From:Subject:From;
	b=u9LHLn2B1k85mM7BeE32z8M3x2OaStPwzbBL8AQ6W3OvnhxKptvZ80CArrpnGpQCQ
	 6Ctl4XeRmSZw+7F3nzwrJL2UkcyxlUgvbsqmHNAPdHxPDSc6VpDu1xq97kkLlw+62q
	 UX1fcKqHHzMAMu62Ot9Cb8+CCp3Nl82/6S5QwL/s=
Date: Tue, 05 Nov 2024 17:00:22 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-remove-__shmem_huge_global_enabled.patch removed from -mm tree
Message-Id: <20241106010022.82702C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: remove __shmem_huge_global_enabled()
has been removed from the -mm tree.  Its filename was
     mm-shmem-remove-__shmem_huge_global_enabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <baohua@kernel.org>
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

mm-use-aligned-address-in-clear_gigantic_page.patch
mm-use-aligned-address-in-copy_user_gigantic_page.patch

