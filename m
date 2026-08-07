Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE933B2D24
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068108; cv=none; b=qCjmi0lOOdnloufvdN6NZtVTYw3k3U7Tcim8263c22Wfg5PZLAVGqqoy3SZi3nYYgEAPT1EUEKfOFvp67m6F4Ef03PU0eZlqP+walo+3CJG8JyN/0IlQ+opaZaa3/wIkCsBMEtZKbvMeVRS3fH1noSHKt5tnI3oPl6+j46IGCPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068108; c=relaxed/simple;
	bh=UFY0Zl8gM97Sn7NsZlSZd2eW+cjn88DOYv6fsd7D+5c=;
	h=Date:To:From:Subject:Message-Id; b=J4M+jZt70XH70p/KzRDhesr8Mcf6TuXxKT9BDwF65LiWR3b4NHin88Mif0B2WVkrViUj8NyGz6h8TGOEr3Fz3Amd8NsJYXSuSNtLeVWP+6L/YMJyoLn1wzXmvYc2Wz1O3/0r8g2w066DZunay1FG4xj0mHP25tVEwrP6sLj/fEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0wT5qNIs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0wT5qNIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F68E1F000E9;
	Fri,  7 Aug 2026 02:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068106;
	bh=SXqOvtxJ8qbZuWjFoDlnFI1MBTpLbg6ON0Vdx8uMPno=;
	h=Date:To:From:Subject;
	b=0wT5qNIsVy+qdxSP7aWCA/ZkLMLw6KqFNn8Ro2n2WI6N8vecn+JY/q/3NogOutLm0
	 bHtpEJ0kwNUwFkxB6K6gr8+jnNd7bDybxWGinYFwQqd5xok8DYsZnNy5NleeDRt1ME
	 ELuJXCGSawHeWCPCi+IZSMpnFXDbxB6v1f0cHm5Y=
Date: Thu, 06 Aug 2026 19:01:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-introduce-pud_is_huge-helper.patch removed from -mm tree
Message-Id: <20260807020146.9F68E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: introduce pud_is_huge() helper
has been removed from the -mm tree.  Its filename was
     mm-introduce-pud_is_huge-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: introduce pud_is_huge() helper
Date: Fri, 17 Jul 2026 17:13:42 +0800

Patch series "mm: mincore: misc cleanups", v3.

This series cleans up and simplifies the mincore.  Most importantly, it
removes the historical special behavior that always reports VM_PFNMAP
pages as non-resident.


This patch (of 6):

Introduce the pud_is_huge() helper function to check whether a PUD is a
huge PUD or a software leaf entry.  Note that, unlike PMD, PUD currently
does not support transparent migration entries or device private entries. 
However, the function still includes `!pud_none()` branches to accommodate
potential future implementations.

Link: https://lore.kernel.org/20260717091347.1144789-1-wangkefeng.wang@huawei.com
Link: https://lore.kernel.org/20260717091347.1144789-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/include/linux/huge_mm.h~mm-introduce-pud_is_huge-helper
+++ a/include/linux/huge_mm.h
@@ -472,6 +472,24 @@ void split_huge_pmd_address(struct vm_ar
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address);
 
+/**
+ * pud_is_huge() - Is this PUD either a huge PUD entry or a software leaf entry?
+ * @pud: The PUD to check.
+ *
+ * This is similar to pmd_is_huge(), but it checks at the PUD level.
+ *
+ * Returns: true if this PUD is huge, false otherwise.
+ */
+static inline bool pud_is_huge(pud_t pud)
+{
+	if (pud_present(pud))
+		return pud_trans_huge(pud);
+	else if (!pud_none(pud))
+		return true;
+
+	return false;
+}
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
@@ -798,6 +816,11 @@ static inline bool pmd_is_huge(pmd_t pmd
 {
 	return false;
 }
+
+static inline bool pud_is_huge(pud_t pud)
+{
+	return false;
+}
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline bool is_pmd_order(unsigned int order)
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


