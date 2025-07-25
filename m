Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2E2E36FA
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409735; cv=none; b=piwW7IWR9p64pz7dQnC9t9rngOCJhujmYBa9MK53wBoBvdEcBKtG9XtK/10m3Oi5F8DlG52s548jPxXmR/lCcXJFz7B0ainIrexpVTzczAfbS3X57rJY6rd2i3kEk7QrnlsYJNtVCh0KulyAyVVbRbuhXCawxs4TTA3NmrJMXDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409735; c=relaxed/simple;
	bh=6YRBGSAFldm0niRIdqGPjJ1xTDnaJwBH4FaPcWxLsn0=;
	h=Date:To:From:Subject:Message-Id; b=tjbJw6B9WyNxWRc6Lu6AF8zyYLxuZxfTP9PqaOXHHvbwTt65y3M8RGpDtEpxAEddEyLIy8KV3X2c5PjNOzbIuzzDsyJlNp0aFxYWmNOs54nVkCfsEeon3W1Bnbfne7qGdSA4jOfoVXWGHFbIY4EKJ/aqRqubLR1FQPvoQIUbcWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQgkQF4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQgkQF4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B70C4CEED;
	Fri, 25 Jul 2025 02:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409735;
	bh=6YRBGSAFldm0niRIdqGPjJ1xTDnaJwBH4FaPcWxLsn0=;
	h=Date:To:From:Subject:From;
	b=VQgkQF4L9+3O4SgilgzrqSWHs0dpgL0mZxNHdEIuRNwt1pNFpUtC5ltHIihnSRzDU
	 pLsYICO5KsjIF8tXxon2xCCbRt1OT7W7zWMSZ0kC6jcPQXmGiRKFYS6XvCR3NgpLOA
	 +zVZFAUHnhXufdRffW2G/Mp+fgXpmLIzv+AN8pIU=
Date: Thu, 24 Jul 2025 19:15:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-split-can_change_pte_writable-into-private-and-shared-parts.patch removed from -mm tree
Message-Id: <20250725021535.69B70C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: split can_change_pte_writable() into private and shared parts
has been removed from the -mm tree.  Its filename was
     mm-split-can_change_pte_writable-into-private-and-shared-parts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm: split can_change_pte_writable() into private and shared parts
Date: Fri, 18 Jul 2025 14:32:42 +0530

In preparation for patch 6 and modularizing the code in general, split
can_change_pte_writable() into private and shared VMA parts.  No
functional change intended.

Link: https://lkml.kernel.org/r/20250718090244.21092-6-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Cc: Zhenhua Huang <quic_zhenhuah@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   50 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 14 deletions(-)

--- a/mm/mprotect.c~mm-split-can_change_pte_writable-into-private-and-shared-parts
+++ a/mm/mprotect.c
@@ -40,11 +40,8 @@
 
 #include "internal.h"
 
-bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
-			     pte_t pte)
+static bool maybe_change_pte_writable(struct vm_area_struct *vma, pte_t pte)
 {
-	struct page *page;
-
 	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
 		return false;
 
@@ -60,16 +57,32 @@ bool can_change_pte_writable(struct vm_a
 	if (userfaultfd_pte_wp(vma, pte))
 		return false;
 
-	if (!(vma->vm_flags & VM_SHARED)) {
-		/*
-		 * Writable MAP_PRIVATE mapping: We can only special-case on
-		 * exclusive anonymous pages, because we know that our
-		 * write-fault handler similarly would map them writable without
-		 * any additional checks while holding the PT lock.
-		 */
-		page = vm_normal_page(vma, addr, pte);
-		return page && PageAnon(page) && PageAnonExclusive(page);
-	}
+	return true;
+}
+
+static bool can_change_private_pte_writable(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t pte)
+{
+	struct page *page;
+
+	if (!maybe_change_pte_writable(vma, pte))
+		return false;
+
+	/*
+	 * Writable MAP_PRIVATE mapping: We can only special-case on
+	 * exclusive anonymous pages, because we know that our
+	 * write-fault handler similarly would map them writable without
+	 * any additional checks while holding the PT lock.
+	 */
+	page = vm_normal_page(vma, addr, pte);
+	return page && PageAnon(page) && PageAnonExclusive(page);
+}
+
+static bool can_change_shared_pte_writable(struct vm_area_struct *vma,
+					   pte_t pte)
+{
+	if (!maybe_change_pte_writable(vma, pte))
+		return false;
 
 	VM_WARN_ON_ONCE(is_zero_pfn(pte_pfn(pte)) && pte_dirty(pte));
 
@@ -83,6 +96,15 @@ bool can_change_pte_writable(struct vm_a
 	return pte_dirty(pte);
 }
 
+bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t pte)
+{
+	if (!(vma->vm_flags & VM_SHARED))
+		return can_change_private_pte_writable(vma, addr, pte);
+
+	return can_change_shared_pte_writable(vma, pte);
+}
+
 static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes)
 {
_

Patches currently in -mm which might be from dev.jain@arm.com are

khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch
khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

