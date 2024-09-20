Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339EB55E48
	for <mm-commits@vger.kernel.org>; Fri, 20 Sep 2024 10:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726829533; cv=none; b=UPtymrloNzXZl/C2qYnzBlmfJSj/V5/1QGW/KI7ZStl6zUnpzbygejXMudEwEbAG5m2ltANF+xi7Cvm+CiTuEcLVDtnmfRweclOpe9X6geCHPWH9AivZhqD7JJzkHJbP1KbJpY11istLkYjF4GN4lBN8ODeKnczjHKVlXkOZXlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726829533; c=relaxed/simple;
	bh=fu0ZKIub2ySdai6/Njegrtqnj90H8lb5ScDkklx2tiY=;
	h=Date:To:From:Subject:Message-Id; b=PXyWlO/6YKttTyLXS2RY3n0a9bbV46FW2xXg3T6u8yhEc8lTQ+wgSP2xpxBq6ODI34it0igaH/sayp0fNflE8RLW6sQKNWuNzW2b8dNoZaxq81TFFqGuRaeLUNjt8yAVyjBNCzqqLb+36g3vGQ9fPfzDyvRmrlYbVJ7BBha+SHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nOEKUX3M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nOEKUX3M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A335AC4CEC3;
	Fri, 20 Sep 2024 10:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726829532;
	bh=fu0ZKIub2ySdai6/Njegrtqnj90H8lb5ScDkklx2tiY=;
	h=Date:To:From:Subject:From;
	b=nOEKUX3M89IenyLaE5qkVUWGh6uSOKX5186LNAPyagKib168cUqIj4G6U30nUq4IX
	 zzbS4FHpI4aVgb9hy0YfDq2LOTkE7+TEWRV7It3cyDn6LaS5aJtoyzLefD0T2MSDet
	 mexO7hxp1KuhABgm9gt6ypdFs0FNVShSETPl09tw=
Date: Fri, 20 Sep 2024 03:52:11 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch removed from -mm tree
Message-Id: <20240920105212.A335AC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix khugepaged activation policy for shmem
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: fix khugepaged activation policy for shmem
Date: Wed, 11 Sep 2024 09:42:30 +0800

Shmem has a separate interface (different from anonymous pages) to control
huge page allocation, that means shmem THP can be enabled while anonymous
THP is disabled.  However, in this case, khugepaged will not start to
collapse shmem THP, which is unreasonable.

To fix this issue, we should call start_stop_khugepaged() to activate or
deactivate the khugepaged thread when setting shmem mTHP interfaces. 
Moreover, add a new helper shmem_hpage_pmd_enabled() to help to check
whether shmem THP is enabled, which will determine if khugepaged should be
activated.

Link: https://lkml.kernel.org/r/bc8e7e2d6306e561fbd2217df52f083eb5839c27.1726018044.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    6 ++++++
 mm/khugepaged.c          |    6 +++++-
 mm/shmem.c               |   29 +++++++++++++++++++++++++++--
 3 files changed, 38 insertions(+), 3 deletions(-)

--- a/include/linux/shmem_fs.h~mm-shmem-fix-khugepaged-activation-policy-for-shmem
+++ a/include/linux/shmem_fs.h
@@ -114,6 +114,7 @@ int shmem_unuse(unsigned int type);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
+bool shmem_hpage_pmd_enabled(void);
 #else
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
@@ -121,6 +122,11 @@ static inline unsigned long shmem_allowa
 {
 	return 0;
 }
+
+static inline bool shmem_hpage_pmd_enabled(void)
+{
+	return false;
+}
 #endif
 
 #ifdef CONFIG_SHMEM
--- a/mm/khugepaged.c~mm-shmem-fix-khugepaged-activation-policy-for-shmem
+++ a/mm/khugepaged.c
@@ -416,9 +416,11 @@ static inline int hpage_collapse_test_ex
 static bool hugepage_pmd_enabled(void)
 {
 	/*
-	 * We cover both the anon and the file-backed case here; file-backed
+	 * We cover the anon, shmem and the file-backed case here; file-backed
 	 * hugepages, when configured in, are determined by the global control.
 	 * Anon pmd-sized hugepages are determined by the pmd-size control.
+	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
+	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    hugepage_global_enabled())
@@ -430,6 +432,8 @@ static bool hugepage_pmd_enabled(void)
 	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
+	if (shmem_hpage_pmd_enabled())
+		return true;
 	return false;
 }
 
--- a/mm/shmem.c~mm-shmem-fix-khugepaged-activation-policy-for-shmem
+++ a/mm/shmem.c
@@ -1653,6 +1653,23 @@ static gfp_t limit_gfp_mask(gfp_t huge_g
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+bool shmem_hpage_pmd_enabled(void)
+{
+	if (shmem_huge == SHMEM_HUGE_DENY)
+		return false;
+	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_always))
+		return true;
+	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_madvise))
+		return true;
+	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_within_size))
+		return true;
+	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_inherit) &&
+	    shmem_huge != SHMEM_HUGE_NEVER)
+		return true;
+
+	return false;
+}
+
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force)
@@ -5036,7 +5053,7 @@ static ssize_t shmem_enabled_store(struc
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
 	char tmp[16];
-	int huge;
+	int huge, err;
 
 	if (count + 1 > sizeof(tmp))
 		return -EINVAL;
@@ -5060,7 +5077,9 @@ static ssize_t shmem_enabled_store(struc
 	shmem_huge = huge;
 	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
-	return count;
+
+	err = start_stop_khugepaged();
+	return err ? err : count;
 }
 
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
@@ -5137,6 +5156,12 @@ static ssize_t thpsize_shmem_enabled_sto
 		ret = -EINVAL;
 	}
 
+	if (ret > 0) {
+		int err = start_stop_khugepaged();
+
+		if (err)
+			ret = err;
+	}
 	return ret;
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


