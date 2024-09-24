Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5CD1C32
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 23:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727219751; cv=none; b=gpkmjfduNCYGycOG6rRr5p4GfZxgNx8Xua515ACjKV37shSs6TUKTYqqC9l/9wiLHF4GeeFVBdzePAFBgPAYCbj7tWKby+b6ustSMRrz5prV4x4pCIJ7M6WmIhX4R4JXcacS53FiWisxFLrstgn//QqK5TPI8owIveZhxlgDrpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727219751; c=relaxed/simple;
	bh=R/AUDZ2Mp6WCHBjlLpI5QEhFhm1tvP2jYEtun0D34YA=;
	h=Date:To:From:Subject:Message-Id; b=grMuNClJ69B7+EXGfD3v2sHQDFOn3hkR4Vo7kNyEDl+BqiNXH+nfFFAuGa5muNaZsSl0xTL9r54ib4srLht1DrHXiWMHfqVp54o01Pk6jrghULXYNv/QAN6XfWSgleFe+OXaiFQ5a3MiX853bKgEYyx9HEN8JqRuj48UTxDVR7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MVbBw0j6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MVbBw0j6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B966AC4CEC4;
	Tue, 24 Sep 2024 23:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727219750;
	bh=R/AUDZ2Mp6WCHBjlLpI5QEhFhm1tvP2jYEtun0D34YA=;
	h=Date:To:From:Subject:From;
	b=MVbBw0j6rikJsIoQkhDv47++W6fpdCqmcdNBEcGpyGpsSg7ZM1YlLjEW7yiF4fJE5
	 JBdBWsHY/L5AIB0Ykz1q7ROjHRAyNPCUNmJRXvVHdRVkdX+5Vw0tFZKLQ5w3YnMMk3
	 +aj6zWWm69NmhR7ryiSxzbKKGimb2jnAeHxN3HhE=
Date: Tue, 24 Sep 2024 16:15:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch added to mm-unstable branch
Message-Id: <20240924231550.B966AC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix khugepaged activation policy for shmem
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch

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
Subject: mm: shmem: fix khugepaged activation policy for shmem
Date: Sun, 22 Sep 2024 12:32:13 +0800

Shmem has a separate interface (different from anonymous pages) to control
huge page allocation, that means shmem THP can be enabled while anonymous
THP is disabled.  However, in this case, khugepaged will not start to
collapse shmem THP, which is unreasonable.

To fix this issue, we should call start_stop_khugepaged() to activate or
deactivate the khugepaged thread when setting shmem mTHP interfaces. 
Moreover, add a new helper shmem_hpage_pmd_enabled() to help to check
whether shmem THP is enabled, which will determine if khugepaged should be
activated.

Link: https://lkml.kernel.org/r/9b9c6cbc4499bf44c6455367fd9e0f6036525680.1726978977.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
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
+	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
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
@@ -5030,7 +5047,7 @@ static ssize_t shmem_enabled_store(struc
 		struct kobj_attribute *attr, const char *buf, size_t count)
 {
 	char tmp[16];
-	int huge;
+	int huge, err;
 
 	if (count + 1 > sizeof(tmp))
 		return -EINVAL;
@@ -5054,7 +5071,9 @@ static ssize_t shmem_enabled_store(struc
 	shmem_huge = huge;
 	if (shmem_huge > SHMEM_HUGE_DENY)
 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
-	return count;
+
+	err = start_stop_khugepaged();
+	return err ? err : count;
 }
 
 struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
@@ -5131,6 +5150,12 @@ static ssize_t thpsize_shmem_enabled_sto
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

mm-shmem-fix-khugepaged-activation-policy-for-shmem.patch

