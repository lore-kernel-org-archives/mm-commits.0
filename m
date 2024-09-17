Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3247BB15
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560479; cv=none; b=g6GmMN0v0fZuPEg/id6er3lWzzHNNz8CnzoAzvWxoVEn8b2gve+0zZo9IIMqP9p+sZk7xqUR4pvQujt21j5uKQvBMj3iaOQ7CnkM8YaHsdRZZeWUK1UV8+tFkX1O/ClAul/zTBMoMEM5HbrDzIwAxUiNOcbN1FH/8J2t4d6fNCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560479; c=relaxed/simple;
	bh=nEeLnRjfzoDZNluD776oGF7NeuZ/uHyibEbqrE75BMI=;
	h=Date:To:From:Subject:Message-Id; b=cuYuuNQr9JDFxte7mg8EepP3WeIye/zW61BSacsOxD22qGb84ctof5lANZ2GLJ2gHtlTjrlz9AmEPFlYRjpE/MVAkhXddbnke3oUKtxAQqkF3aInLBF8irHqzBgn3qOi99tAKc0TW1Bvnwb97iS8qCCrqYMorwIbLhshXEQb3vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FLqm7ZwH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FLqm7ZwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6CCC4CEC6;
	Tue, 17 Sep 2024 08:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560479;
	bh=nEeLnRjfzoDZNluD776oGF7NeuZ/uHyibEbqrE75BMI=;
	h=Date:To:From:Subject:From;
	b=FLqm7ZwH7rOdULck9v3VgC2HXc6D8qiYE9Cek7Dwbs2bcG5gRBC/Uf4aYTo/G5Dwk
	 wiI8SLmtVgAJ3SAUL/7DSpvMV9kjztmoqSH4t/XH/lYNDoSzM2cGTW+EjGjnAJ28eY
	 nEg6wLJiItCs01Yz+LE7dE+jlPWjU39Xx+wwbvHA=
Date: Tue, 17 Sep 2024 01:07:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-always-define-pxx_pgprot.patch removed from -mm tree
Message-Id: <20240917080758.9E6CCC4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: always define pxx_pgprot()
has been removed from the -mm tree.  Its filename was
     mm-always-define-pxx_pgprot.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: always define pxx_pgprot()
Date: Mon, 26 Aug 2024 16:43:42 -0400

There're:

  - 8 archs (arc, arm64, include, mips, powerpc, s390, sh, x86) that
  support pte_pgprot().

  - 2 archs (x86, sparc) that support pmd_pgprot().

  - 1 arch (x86) that support pud_pgprot().

Always define them to be used in generic code, and then we don't need to
fiddle with "#ifdef"s when doing so.

Link: https://lkml.kernel.org/r/20240826204353.2228736-9-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
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

 arch/arm64/include/asm/pgtable.h    |    1 +
 arch/powerpc/include/asm/pgtable.h  |    1 +
 arch/s390/include/asm/pgtable.h     |    1 +
 arch/sparc/include/asm/pgtable_64.h |    1 +
 include/linux/pgtable.h             |   12 ++++++++++++
 5 files changed, 16 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~mm-always-define-pxx_pgprot
+++ a/arch/arm64/include/asm/pgtable.h
@@ -384,6 +384,7 @@ static inline void __sync_cache_and_tags
 /*
  * Select all bits except the pfn
  */
+#define pte_pgprot pte_pgprot
 static inline pgprot_t pte_pgprot(pte_t pte)
 {
 	unsigned long pfn = pte_pfn(pte);
--- a/arch/powerpc/include/asm/pgtable.h~mm-always-define-pxx_pgprot
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -65,6 +65,7 @@ static inline unsigned long pte_pfn(pte_
 /*
  * Select all bits except the pfn
  */
+#define pte_pgprot pte_pgprot
 static inline pgprot_t pte_pgprot(pte_t pte)
 {
 	unsigned long pte_flags;
--- a/arch/s390/include/asm/pgtable.h~mm-always-define-pxx_pgprot
+++ a/arch/s390/include/asm/pgtable.h
@@ -955,6 +955,7 @@ static inline int pte_unused(pte_t pte)
  * young/old accounting is not supported, i.e _PAGE_PROTECT and _PAGE_INVALID
  * must not be set.
  */
+#define pte_pgprot pte_pgprot
 static inline pgprot_t pte_pgprot(pte_t pte)
 {
 	unsigned long pte_flags = pte_val(pte) & _PAGE_CHG_MASK;
--- a/arch/sparc/include/asm/pgtable_64.h~mm-always-define-pxx_pgprot
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -783,6 +783,7 @@ static inline pmd_t pmd_mkwrite_novma(pm
 	return __pmd(pte_val(pte));
 }
 
+#define pmd_pgprot pmd_pgprot
 static inline pgprot_t pmd_pgprot(pmd_t entry)
 {
 	unsigned long val = pmd_val(entry);
--- a/include/linux/pgtable.h~mm-always-define-pxx_pgprot
+++ a/include/linux/pgtable.h
@@ -1956,6 +1956,18 @@ typedef unsigned int pgtbl_mod_mask;
 #define MAX_PTRS_PER_P4D PTRS_PER_P4D
 #endif
 
+#ifndef pte_pgprot
+#define pte_pgprot(x) ((pgprot_t) {0})
+#endif
+
+#ifndef pmd_pgprot
+#define pmd_pgprot(x) ((pgprot_t) {0})
+#endif
+
+#ifndef pud_pgprot
+#define pud_pgprot(x) ((pgprot_t) {0})
+#endif
+
 /* description of effects of mapping type and prot in current implementation.
  * this is due to the limited x86 page protection hardware.  The expected
  * behavior is in parens:
_

Patches currently in -mm which might be from peterx@redhat.com are


