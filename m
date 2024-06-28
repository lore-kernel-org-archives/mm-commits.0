Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196B0524B4
	for <mm-commits@vger.kernel.org>; Fri, 28 Jun 2024 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719600827; cv=none; b=n4hZG77buBI3cItc9GMqnqtPqyX71P8lSxAwBCah+6MO6aPGzmMXkG5P4lnYDQ0n8mu2ypKaaqoTbpj57z2NVR/jtuggQIH+sDDeN+lHq9FTmXoHNfBudoZrNBvm4v38Kp+1IfOg1kvgluPhAoHrv984XFIMvvOblnJ6nZjNJM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719600827; c=relaxed/simple;
	bh=obuu8amshKC6rJHdsNbXi0FO2lKkrlkc9+vTDk8mAQo=;
	h=Date:To:From:Subject:Message-Id; b=huD4r3O23SmK+cmghamNZ9rz3knjG4QNzZPx8FzWU38QOxUAEtvH8M7bwfb5Hb+QOFwGLAcKI3P8IdwwKsdw53cqRm1gOzGs6XjKitAcDaPoC5JYCPTOvaXKZG+JclIAcyydRajEcoCfW+gsFnspR2Lo8BkwhZP+aNCWuW22TZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d3g+Cd+t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d3g+Cd+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACA8C116B1;
	Fri, 28 Jun 2024 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719600826;
	bh=obuu8amshKC6rJHdsNbXi0FO2lKkrlkc9+vTDk8mAQo=;
	h=Date:To:From:Subject:From;
	b=d3g+Cd+tjbJbtZbQbsrMRuXEKZ7gt/gEPHPv05AP487SUJEaFrKzHc5JIOSfJaaXc
	 va7T96/3GlHuCUOLc3OlQwivqqtrUQTnA6w7V0uJCJ8szjk3e6YpHlHIDaXMIFAnUA
	 emdQTiiuung6ZSgcd0GwC5qaDY0VONDP/eL8WCPk=
Date: Fri, 28 Jun 2024 11:53:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,libang.li@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch added to mm-unstable branch
Message-Id: <20240628185346.8ACA8C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: smaps: support "THPeligible" semantics for mTHP with anonymous shmem
has been added to the -mm mm-unstable branch.  Its filename is
     support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

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
Subject: smaps: support "THPeligible" semantics for mTHP with anonymous shmem
Date: Fri, 28 Jun 2024 18:49:26 +0800

After the commit 7fb1b252afb5 ("mm: shmem: add mTHP support for
anonymous shmem"), we can configure different policies through
the multi-size THP sysfs interface for anonymous shmem. But
currently "THPeligible" indicates only whether the mapping is
eligible for allocating THP-pages as well as the THP is PMD
mappable or not for anonymous shmem, we need to support semantics
for mTHP with anonymous shmem similar to those for mTHP with
anonymous memory.

Link: https://lkml.kernel.org/r/20240628104926.34209-1-libang.li@antgroup.com
Signed-off-by: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c      |   10 +++++++---
 include/linux/huge_mm.h |   11 +++++++++++
 mm/shmem.c              |    9 +--------
 3 files changed, 19 insertions(+), 11 deletions(-)

--- a/fs/proc/task_mmu.c~support-thpeligible-semantics-for-mthp-with-anonymous-shmem
+++ a/fs/proc/task_mmu.c
@@ -1145,6 +1145,7 @@ static int show_smap(struct seq_file *m,
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
+	bool thp_eligible;
 
 	smap_gather_stats(vma, &mss, 0);
 
@@ -1157,9 +1158,12 @@ static int show_smap(struct seq_file *m,
 
 	__show_smap(m, &mss, false);
 
-	seq_printf(m, "THPeligible:    %8u\n",
-		   !!thp_vma_allowable_orders(vma, vma->vm_flags,
-			   TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL));
+	thp_eligible = !!thp_vma_allowable_orders(vma, vma->vm_flags,
+						TVA_SMAPS | TVA_ENFORCE_SYSFS, THP_ORDERS_ALL);
+	if (vma_is_anon_shmem(vma))
+		thp_eligible = !!shmem_allowable_huge_orders(file_inode(vma->vm_file),
+							vma, vma->vm_pgoff, thp_eligible);
+	seq_printf(m, "THPeligible:    %8u\n", thp_eligible);
 
 	if (arch_pkeys_enabled())
 		seq_printf(m, "ProtectionKey:  %8u\n", vma_pkey(vma));
--- a/include/linux/huge_mm.h~support-thpeligible-semantics-for-mthp-with-anonymous-shmem
+++ a/include/linux/huge_mm.h
@@ -267,6 +267,10 @@ unsigned long thp_vma_allowable_orders(s
 	return __thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
 }
 
+unsigned long shmem_allowable_huge_orders(struct inode *inode,
+				struct vm_area_struct *vma, pgoff_t index,
+				bool global_huge);
+
 struct thpsize {
 	struct kobject kobj;
 	struct list_head node;
@@ -462,6 +466,13 @@ static inline unsigned long thp_vma_allo
 {
 	return 0;
 }
+
+static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
+				struct vm_area_struct *vma, pgoff_t index,
+				bool global_huge)
+{
+	return 0;
+}
 
 #define transparent_hugepage_flags 0UL
 
--- a/mm/shmem.c~support-thpeligible-semantics-for-mthp-with-anonymous-shmem
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

support-thpeligible-semantics-for-mthp-with-anonymous-shmem.patch

