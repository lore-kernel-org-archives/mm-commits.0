Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2BA10F4
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560471; cv=none; b=cuqPk4EiO+RDStGumvO/od4pg+xN55PI6P5AQOk+RV9t1K0PSfAFoADLsKZBjyKhzDSqucydE5luTwCMbgbnAw/ckh7UI5oJW7WxxLLfDUi6MaUsAr8XKeFD5HWkwVB+3byjTqUblLAML+hcDNzNf5Mna7WMYRXupmjmO42Cm5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560471; c=relaxed/simple;
	bh=e776nbsSDl2ICkMarhJj3phKDD9uJogMM1soLa5U1wY=;
	h=Date:To:From:Subject:Message-Id; b=KMEjKcj0C2BdA774bF9q7l4Yblh28/n9x+wnF9b03+1MqA72k9fhHIwakvvwxbM/GrXMxJZTSCA7ixiMRT/r/aujL2S0mmn/UWxjrI9ExnOkMD5//j9crD3+KXfqdW4x/xTdHSf+6T/ac2bbk0WLRhXqkvCkq07WeMYWmTQQ7ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ok11hDRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ok11hDRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7811C4CEC6;
	Tue, 17 Sep 2024 08:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560471;
	bh=e776nbsSDl2ICkMarhJj3phKDD9uJogMM1soLa5U1wY=;
	h=Date:To:From:Subject:From;
	b=Ok11hDREniq5699E8FSehYgO45oNEefCBjInhY18pyDyU5EgBt8qavsRgMhO3hXlw
	 FF0/vrdecLQQdiWblzdy9oUtFY/+vxEtHQLP4JdbHrv8RiUdWSnnUcWBA4uatzDkDG
	 A47L9RHYnFHSA9kgLpnRdP9VY62Wu+o4BGBHClQU=
Date: Tue, 17 Sep 2024 01:07:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pagewalk-check-pfnmap-for-folio_walk_start.patch removed from -mm tree
Message-Id: <20240917080750.B7811C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/pagewalk: check pfnmap for folio_walk_start()
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-check-pfnmap-for-folio_walk_start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/pagewalk: check pfnmap for folio_walk_start()
Date: Mon, 26 Aug 2024 16:43:40 -0400

Teach folio_walk_start() to recognize special pmd/pud mappings, and fail
them properly as it means there's no folio backing them.

[peterx@redhat.com: remove some stale comments, per David]
  Link: https://lkml.kernel.org/r/20240829202237.2640288-1-peterx@redhat.com
Link: https://lkml.kernel.org/r/20240826204353.2228736-7-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c   |    9 ++++-----
 mm/pagewalk.c |    2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-pagewalk-check-pfnmap-for-folio_walk_start
+++ a/mm/memory.c
@@ -672,11 +672,10 @@ struct page *vm_normal_page_pmd(struct v
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
-	/*
-	 * There is no pmd_special() but there may be special pmds, e.g.
-	 * in a direct-access (dax) mapping, so let's just replicate the
-	 * !CONFIG_ARCH_HAS_PTE_SPECIAL case from vm_normal_page() here.
-	 */
+	/* Currently it's only used for huge pfnmaps */
+	if (unlikely(pmd_special(pmd)))
+		return NULL;
+
 	if (unlikely(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP))) {
 		if (vma->vm_flags & VM_MIXEDMAP) {
 			if (!pfn_valid(pfn))
--- a/mm/pagewalk.c~mm-pagewalk-check-pfnmap-for-folio_walk_start
+++ a/mm/pagewalk.c
@@ -753,7 +753,7 @@ struct folio *folio_walk_start(struct fo
 		fw->pudp = pudp;
 		fw->pud = pud;
 
-		if (!pud_present(pud) || pud_devmap(pud)) {
+		if (!pud_present(pud) || pud_devmap(pud) || pud_special(pud)) {
 			spin_unlock(ptl);
 			goto not_found;
 		} else if (!pud_leaf(pud)) {
_

Patches currently in -mm which might be from peterx@redhat.com are


