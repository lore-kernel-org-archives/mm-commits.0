Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AA014E2E3
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560459; cv=none; b=sOFPJe1gNnT3mMu0mmk75DRiolQC7WhyjnhUJo+cAiTMTPo/AOMzP7pG8S6wtsqDYGfq6MnY2ltP9wmqDtmdZNdwVfkOapv9rq3c63lBh7xnYdeEYY7Wk5RY2uyHh76pEvbiXW0IAw3+tWYxeeZ74ksigHJlDQXh177hpTTQ6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560459; c=relaxed/simple;
	bh=pX9NWfWZrUS4+agPg2l2IBtNgq3psmgMVSso4Z9XOms=;
	h=Date:To:From:Subject:Message-Id; b=KPG+RiMYNtkoAd3FJCYkG8ccj1feogtGajXYD5BeqW1fUNu8/XNt3+MDNu6SEDfq4ecNHbMCBQLcGwv/ysUs8S5jZzxuwh8DOGpkv4HwF73FB0qlaP/ykabtdsvfdgGQumgNdI+djAkNPy8eB8ragjePuRMG6MidJ9wsmw0DSV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wPYCLNJ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wPYCLNJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E46C4CECE;
	Tue, 17 Sep 2024 08:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560459;
	bh=pX9NWfWZrUS4+agPg2l2IBtNgq3psmgMVSso4Z9XOms=;
	h=Date:To:From:Subject:From;
	b=wPYCLNJ0MYEOK5pPDans7cdeKqx1HTyhtE71Dll0iddw72JpbdjM/rlIermIOSpg5
	 W8QHxxLuMlf+l5pEVaUohhcqXXW1BfWnNzIhywWlC6oRFcqVSoPKWMs8lvh+tXr+Je
	 QGRItC4lIJ7pTnNIesmRJpgplC79qf0U5tzkd3wQ=
Date: Tue, 17 Sep 2024 01:07:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch removed from -mm tree
Message-Id: <20240917080738.A3E46C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mark special bits for huge pfn mappings when inject
has been removed from the -mm tree.  Its filename was
     mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: mark special bits for huge pfn mappings when inject
Date: Mon, 26 Aug 2024 16:43:37 -0400

We need these special bits to be around on pfnmaps.  Mark properly for
!devmap case, reflecting that there's no page struct backing the entry.

Link: https://lkml.kernel.org/r/20240826204353.2228736-4-peterx@redhat.com
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-mark-special-bits-for-huge-pfn-mappings-when-inject
+++ a/mm/huge_memory.c
@@ -1370,6 +1370,8 @@ static void insert_pfn_pmd(struct vm_are
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pmd_mkdevmap(entry);
+	else
+		entry = pmd_mkspecial(entry);
 	if (write) {
 		entry = pmd_mkyoung(pmd_mkdirty(entry));
 		entry = maybe_pmd_mkwrite(entry, vma);
@@ -1466,6 +1468,8 @@ static void insert_pfn_pud(struct vm_are
 	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
 	if (pfn_t_devmap(pfn))
 		entry = pud_mkdevmap(entry);
+	else
+		entry = pud_mkspecial(entry);
 	if (write) {
 		entry = pud_mkyoung(pud_mkdirty(entry));
 		entry = maybe_pud_mkwrite(entry, vma);
_

Patches currently in -mm which might be from peterx@redhat.com are


