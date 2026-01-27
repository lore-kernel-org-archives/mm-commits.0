Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA1C1E5702
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486749; cv=none; b=XOivNW+tJr3BOITXvm2V89E1MgAhqt7ma3sk9RaJb7NI2qkONApBtiwwmHH9Rbd3Gt3qc8f37coSi4wDZ+e02WpK6L1hyuifzBELbrgsfXf/a4zOntM3foMhJtTUSqndTvZn6+6FwdTKevin7P5zzSkep4SJ7DcEG6HjW+h3y/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486749; c=relaxed/simple;
	bh=6HFf8KVbjU5Y9yXcGhQHVl1KhosM5gDprYiy1Mobceo=;
	h=Date:To:From:Subject:Message-Id; b=NtbJsNV2VP2Ryx+pdtUN3TM5G0CtQZbK2glM5tfjwEfdp54ZQdhNydmWKDXBd0PtLewIrZqAFWWpcU/1G4dLxQ1ozVlSzzQSpzyAnVPtcwA58+KFutgj+tSTc30FhhyR6j4DNw0TX99b7M5dj5rdB8A+SneNkH1mP4oCS4ax+pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2BJL1owi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2BJL1owi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F973C116C6;
	Tue, 27 Jan 2026 04:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486749;
	bh=6HFf8KVbjU5Y9yXcGhQHVl1KhosM5gDprYiy1Mobceo=;
	h=Date:To:From:Subject:From;
	b=2BJL1owiQJPgsp/Vzxl6Ukn/h17GnbLm5xTmS+kUj0vLO0uJPJnSZ7BDX4htFXWem
	 EhG+MhXRoee6sKHWVuuKvMnWscnp00hSfoYg/cl0GCXL802hZEgFoJEtk8Vr9IGwa7
	 tjBELKzXlT8WAsLipdFveWSKL2EwpUshoON5+qGo=
Date: Mon, 26 Jan 2026 20:05:48 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,zhengqi.arch@bytedance.com,willy@infradead.org,vishal.moola@gmail.com,thuth@redhat.com,sweettea-kernel@dorminy.me,ritesh.list@gmail.com,paulus@ozlabs.org,pasha.tatashin@soleen.com,npiggin@gmail.com,nicholas@linux.ibm.com,mpe@ellerman.id.au,mingo@kernel.org,maddy@linux.ibm.com,linmag7@gmail.com,kevin.brodsky@arm.com,jgg@ziepe.ca,guoweikang.kernel@gmail.com,donettom@linux.ibm.com,david@kernel.org,christophe.leroy@csgroup.eu,chleroy@kernel.org,apopple@nvidia.com,alexghiti@rivosinc.com,alex@ghiti.fr,ajd@linux.ibm.com,agordeev@linux.ibm.com,rmclure@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-mm-implement-_user_accessible_page-for-ptes.patch removed from -mm tree
Message-Id: <20260127040549.1F973C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/mm: implement *_user_accessible_page() for ptes
has been removed from the -mm tree.  Its filename was
     powerpc-mm-implement-_user_accessible_page-for-ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rohan McLure <rmclure@linux.ibm.com>
Subject: powerpc/mm: implement *_user_accessible_page() for ptes
Date: Fri, 19 Dec 2025 04:09:42 +1100

Page table checking depends on architectures providing an implementation
of p{te,md,ud}_user_accessible_page.  With refactorisations made on
powerpc/mm, the pte_access_permitted() and similar methods verify whether
a userland page is accessible with the required permissions.

Since page table checking is the only user of
p{te,md,ud}_user_accessible_page(), implement these for all platforms,
using some of the same preliminary checks taken by pte_access_permitted()
on that platform.

Since commit 8e9bd41e4ce1 ("powerpc/nohash: Replace pte_user() by
pte_read()") pte_user() is no longer required to be present on all
platforms as it may be equivalent to or implied by pte_read().  Hence
implementations of pte_user_accessible_page() are specialised.

[ajd@linux.ibm.com: rebase and clean up]
Link: https://lkml.kernel.org/r/20251219-pgtable_check_v18rebase-v18-10-755bc151a50b@linux.ibm.com
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Guo Weikang <guoweikang.kernel@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Miehlbradt <nicholas@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Thomas Huth <thuth@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/book3s/32/pgtable.h |    5 +++++
 arch/powerpc/include/asm/book3s/64/pgtable.h |   17 +++++++++++++++++
 arch/powerpc/include/asm/nohash/pgtable.h    |    5 +++++
 arch/powerpc/include/asm/pgtable.h           |    8 ++++++++
 4 files changed, 35 insertions(+)

--- a/arch/powerpc/include/asm/book3s/32/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/book3s/32/pgtable.h
@@ -437,6 +437,11 @@ static inline bool pte_access_permitted(
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -539,6 +539,11 @@ static inline bool pte_access_permitted(
 	return arch_pte_access_permitted(pte_val(pte), write, 0);
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && pte_user(pte);
+}
+
 /*
  * Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
@@ -909,6 +914,12 @@ static inline bool pud_access_permitted(
 	return pte_access_permitted(pud_pte(pud), write);
 }
 
+#define pud_user_accessible_page pud_user_accessible_page
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
+{
+	return pud_leaf(pud) && pte_user_accessible_page(pud_pte(pud), addr);
+}
+
 #define __p4d_raw(x)	((p4d_t) { __pgd_raw(x) })
 static inline __be64 p4d_raw(p4d_t x)
 {
@@ -1074,6 +1085,12 @@ static inline bool pmd_access_permitted(
 	return pte_access_permitted(pmd_pte(pmd), write);
 }
 
+#define pmd_user_accessible_page pmd_user_accessible_page
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
+{
+	return pmd_leaf(pmd) && pte_user_accessible_page(pmd_pte(pmd), addr);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern pmd_t pfn_pmd(unsigned long pfn, pgprot_t pgprot);
 extern pud_t pfn_pud(unsigned long pfn, pgprot_t pgprot);
--- a/arch/powerpc/include/asm/nohash/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/nohash/pgtable.h
@@ -243,6 +243,11 @@ static inline bool pte_access_permitted(
 	return true;
 }
 
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
+{
+	return pte_present(pte) && !is_kernel_addr(addr);
+}
+
 /* Conversion functions: convert a page and protection to a page entry,
  * and a page entry and page directory to the page they refer to.
  *
--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-implement-_user_accessible_page-for-ptes
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -202,6 +202,14 @@ static inline bool arch_supports_memmap_
 
 #endif /* CONFIG_PPC64 */
 
+#ifndef pmd_user_accessible_page
+#define pmd_user_accessible_page(pmd, addr)	false
+#endif
+
+#ifndef pud_user_accessible_page
+#define pud_user_accessible_page(pud, addr)	false
+#endif
+
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
_

Patches currently in -mm which might be from rmclure@linux.ibm.com are


