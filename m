Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDAB610E;
	Sat, 24 Feb 2024 01:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708738075; cv=none; b=B2Kn6Ns9LNcK6OkW2L9zJ6d9Oej+no9vEBMnEftg0VfsgA99gB83VhryTdf2PZZpFReAK2j1IGpp32ucZCNDiyVT1y1kvLlJdmu0nH2ONKgOfdi/kZ79DKZpVgrNNhzBg2Ad1dnhgpq3mW995kFKJNDKoW2vZ2Luy1h/eH1O870=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708738075; c=relaxed/simple;
	bh=PeD7Y3P75louvCgnjUPddiRNz9ZMs/bYe6U8rkjNSOs=;
	h=Date:To:From:Subject:Message-Id; b=MljbHynBujur/0b2MEFtXm4U666dYwXpZ1GYjEx7n2qUYEv7f4tqCwiSaks3VmKSGACT/GJtoOh4rRaoR3LMyUFnEyj2aPqVx5pikgLxIwN1CCK24mlkMjMT0rQBYu30JJEvCwnUooiLxTb70T168ONna4NXqNNhN7V/wxQ6iks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jTUn9QsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jTUn9QsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F38C43399;
	Sat, 24 Feb 2024 01:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708738074;
	bh=PeD7Y3P75louvCgnjUPddiRNz9ZMs/bYe6U8rkjNSOs=;
	h=Date:To:From:Subject:From;
	b=jTUn9QsQDqyR7WfreV3SvFuMxOGaahiPr8dtXcDxf3J0KTrSguZoqYtUFTcTFecZr
	 /MMiuLW0ewx3Z6eNjOP4D18CjYHXyhI85wLPChrJrBm5FXjek/+2RigshJKjozNBkz
	 R7MZ+wznV9gEx6YSDqLKtuBA1s1D2zyCJgNbcab4=
Date: Fri, 23 Feb 2024 17:27:54 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,mpe@ellerman.id.au,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-debug_vm_pgtable-fix-bug_on-with-pud-advanced-test.patch removed from -mm tree
Message-Id: <20240224012754.D1F38C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/debug_vm_pgtable: fix BUG_ON with pud advanced test
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-fix-bug_on-with-pud-advanced-test.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Aneesh Kumar K.V (IBM)" <aneesh.kumar@kernel.org>
Subject: mm/debug_vm_pgtable: fix BUG_ON with pud advanced test
Date: Mon, 29 Jan 2024 11:30:22 +0530

Architectures like powerpc add debug checks to ensure we find only devmap
PUD pte entries.  These debug checks are only done with CONFIG_DEBUG_VM. 
This patch marks the ptes used for PUD advanced test devmap pte entries so
that we don't hit on debug checks on architecture like ppc64 as below.

WARNING: CPU: 2 PID: 1 at arch/powerpc/mm/book3s64/radix_pgtable.c:1382 radix__pud_hugepage_update+0x38/0x138
....
NIP [c0000000000a7004] radix__pud_hugepage_update+0x38/0x138
LR [c0000000000a77a8] radix__pudp_huge_get_and_clear+0x28/0x60
Call Trace:
[c000000004a2f950] [c000000004a2f9a0] 0xc000000004a2f9a0 (unreliable)
[c000000004a2f980] [000d34c100000000] 0xd34c100000000
[c000000004a2f9a0] [c00000000206ba98] pud_advanced_tests+0x118/0x334
[c000000004a2fa40] [c00000000206db34] debug_vm_pgtable+0xcbc/0x1c48
[c000000004a2fc10] [c00000000000fd28] do_one_initcall+0x60/0x388

Also

 kernel BUG at arch/powerpc/mm/book3s64/pgtable.c:202!
 ....

 NIP [c000000000096510] pudp_huge_get_and_clear_full+0x98/0x174
 LR [c00000000206bb34] pud_advanced_tests+0x1b4/0x334
 Call Trace:
 [c000000004a2f950] [000d34c100000000] 0xd34c100000000 (unreliable)
 [c000000004a2f9a0] [c00000000206bb34] pud_advanced_tests+0x1b4/0x334
 [c000000004a2fa40] [c00000000206db34] debug_vm_pgtable+0xcbc/0x1c48
 [c000000004a2fc10] [c00000000000fd28] do_one_initcall+0x60/0x388

Link: https://lkml.kernel.org/r/20240129060022.68044-1-aneesh.kumar@kernel.org
Fixes: 27af67f35631 ("powerpc/book3s64/mm: enable transparent pud hugepage")
Signed-off-by: Aneesh Kumar K.V (IBM) <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-fix-bug_on-with-pud-advanced-test
+++ a/mm/debug_vm_pgtable.c
@@ -362,6 +362,12 @@ static void __init pud_advanced_tests(st
 	vaddr &= HPAGE_PUD_MASK;
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	/*
+	 * Some architectures have debug checks to make sure
+	 * huge pud mapping are only found with devmap entries
+	 * For now test with only devmap entries.
+	 */
+	pud = pud_mkdevmap(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);
 	pudp_set_wrprotect(args->mm, vaddr, args->pudp);
@@ -374,6 +380,7 @@ static void __init pud_advanced_tests(st
 	WARN_ON(!pud_none(pud));
 #endif /* __PAGETABLE_PMD_FOLDED */
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	pud = pud_mkdevmap(pud);
 	pud = pud_wrprotect(pud);
 	pud = pud_mkclean(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
@@ -391,6 +398,7 @@ static void __init pud_advanced_tests(st
 #endif /* __PAGETABLE_PMD_FOLDED */
 
 	pud = pfn_pud(args->pud_pfn, args->page_prot);
+	pud = pud_mkdevmap(pud);
 	pud = pud_mkyoung(pud);
 	set_pud_at(args->mm, vaddr, args->pudp, pud);
 	flush_dcache_page(page);
_

Patches currently in -mm which might be from aneesh.kumar@kernel.org are


