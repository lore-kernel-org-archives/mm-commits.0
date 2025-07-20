Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12092A94F
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 00:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752970710; cv=none; b=XLz3Qy+tlFOIhnZhJbFSw+0IGVKGrvjgcoCYm/+74QMlrhn0SQu/iOJOY/lzV3ZVSF/X4vbqgyI5wNYWL+FsMPAsRJcny1YnPu/Wwqbnv9QJvtLMMJAzq0y/W8/53I3ebtmat5o7molqTGzTWTm/cmW99ikZYJ36w+LB4T8Bw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752970710; c=relaxed/simple;
	bh=5EAX10X7KhCdNpgkjQ75T3l06Ej7igWI3RlPwhjBE70=;
	h=Date:To:From:Subject:Message-Id; b=eMAC3y5m16ZzelKSTQsfbmBmTc38Xij8N015W46ZT7vKRoMBDYpEYNgdMcYb9gsXD1XZESM5HUrE2im0vexTx4MX87HjCzWV9mXJzaedw0tDPj5xc+7bgdkSmco91JTG1Gpx80Bu/0GLTMzaUdtoDTldB9+GnnQYntZD0CFurl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OjsN7ZDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OjsN7ZDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78050C4CEE3;
	Sun, 20 Jul 2025 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752970709;
	bh=5EAX10X7KhCdNpgkjQ75T3l06Ej7igWI3RlPwhjBE70=;
	h=Date:To:From:Subject:From;
	b=OjsN7ZDLHxbVFnJ8F2U1kvtvCa3FsVXj/Lr6luGFTYsAaByWBVASjWAL0KHQKDurs
	 IwzSgWTvaV/BgoO7/5lmH3hALmKdyVrosWOV0Z6aTDHxfx3/9vT9AVWTUiM9N+qghj
	 RdfMV97GWk5c7eIRPl/iZ4P3Cn7QXseqyW+xwHpY=
Date: Sat, 19 Jul 2025 17:18:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yangyicong@hisilicon.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,vbabka@suse.cz,ryan.roberts@arm.com,quic_zhenhuah@quicinc.com,peterx@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kevin.brodsky@arm.com,joey.gouly@arm.com,jannh@google.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-split-can_change_pte_writable-into-private-and-shared-parts.patch added to mm-new branch
Message-Id: <20250720001829.78050C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: split can_change_pte_writable() into private and shared parts
has been added to the -mm mm-new branch.  Its filename is
     mm-split-can_change_pte_writable-into-private-and-shared-parts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-split-can_change_pte_writable-into-private-and-shared-parts.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Zi Yan <ziy@nvidia.com>
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

mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch
mm-split-can_change_pte_writable-into-private-and-shared-parts.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch

