Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD4637F750
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243168; cv=none; b=LWrOMzLDMdWOGwD5EJV4VUOx468ng7pLGQUdaZYwaLC88FF2L2PQYGrniIbz1GXzCcq+KAHGmfnCn35wRyu+3OaJ7z27njCNKTqiSmEKwiYSBogiQr+jAViQca6vt+XfyDCh0nwdY93ixLpQzuhakvRfmGWGOFoe8dzT8Ytit0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243168; c=relaxed/simple;
	bh=U6H7etpstOFEcKsxGZAim9I6mfVaPPFQWXM+3wIaE+E=;
	h=Date:To:From:Subject:Message-Id; b=a0Sq6+qf9oJLYoaC419tGD/HHiX4ndK5hxVQ2251Q7Eax7GdeTCk6eUmXh+RANTIA0PPtJMs86xzF8pzdyWlPNUyK7N6+E8v7LRJy+7smKtqk6RH5aCKAFojBBNmvYGYe+7sZNVh7lmyhkpKJSbCWk4BXStdBS8vsjwypZYryQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zti9XcHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zti9XcHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEC6C116D0;
	Mon, 12 Jan 2026 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243168;
	bh=U6H7etpstOFEcKsxGZAim9I6mfVaPPFQWXM+3wIaE+E=;
	h=Date:To:From:Subject:From;
	b=Zti9XcHwsDgL2HpZna20mZINY4A/boQENa16Q8XIv3UZ81LF80ho5ZIXRxw3ECHik
	 /DXofLDol5Bi8+FpDHd8BDryRRSxzQ5WnGSvm/ky0zJhL8APIPhyehJPID1DvXMOnD
	 9kmlrDdEynSugA7qrlY6wbSCV3mRbx4ISTlWkizQ=
Date: Mon, 12 Jan 2026 10:39:27 -0800
To: mm-commits@vger.kernel.org,yuanchu@google.com,yeoreum.yun@arm.com,will@kernel.org,weixugc@google.com,vincenzo.frascino@arm.com,vbabka@suse.cz,urezki@gmail.com,ubizjak@gmail.com,trintaeoitogc@gmail.com,thuth@redhat.com,thomas.lendacky@amd.com,tglx@kernel.org,surenb@google.com,smostafa@google.com,samuel.holland@sifive.com,samitolvanen@google.com,ryabinin.a.a@gmail.com,rppt@kernel.org,peterz@infradead.org,osandov@fb.com,nathan@kernel.org,morbo@google.com,mingo@redhat.com,mhocko@suse.com,maz@kernel.org,mark.rutland@arm.com,luto@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,leitao@debian.org,kees@kernel.org,kbingham@kernel.org,justinstitt@google.com,jpoimboe@kernel.org,jeremy.linton@arm.com,jan.kiszka@siemens.com,jackmanb@google.com,hpa@zytor.com,glider@google.com,dvyukov@google.com,david@kernel.org,dave.hansen@linux.intel.com,corbet@lwn.net,catalin.marinas@arm.com,brgerst@gmail.com,bp@alien8.de,bigeasy@linutronix.de,axelrasmussen@google.com,ardb@kernel.org,anshuman.khandual@arm.com,andreyknvl@gmail.com,maciej.wieczor-retman@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-physical-address-comparisons-in-fill_pd-pte.patch added to mm-new branch
Message-Id: <20260112183927.ECEC6C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: physical address comparisons in fill_p*d/pte
has been added to the -mm mm-new branch.  Its filename is
     x86-mm-physical-address-comparisons-in-fill_pd-pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-physical-address-comparisons-in-fill_pd-pte.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Subject: x86/mm: physical address comparisons in fill_p*d/pte
Date: Mon, 12 Jan 2026 17:27:59 +0000

Calculating page offset returns a pointer without a tag.  When comparing
the calculated offset to a tagged page pointer an error is raised because
they are not equal.

Change pointer comparisons to physical address comparisons as to avoid
issues with tagged pointers that pointer arithmetic would create.  Open
code pte_offset_kernel(), pmd_offset(), pud_offset() and p4d_offset(). 
Because one parameter is always zero and the rest of the function insides
are enclosed inside __va(), removing that layer lowers the complexity of
final assembly.

Link: https://lkml.kernel.org/r/3775e34b030fe5a8e3306026654f51d7b7ca33f7.1768233085.git.m.wieczorretman@pm.me
Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Mostafa Saleh <smostafa@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Thomas Lendacky <thomas.lendacky@amd.com>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-physical-address-comparisons-in-fill_pd-pte
+++ a/arch/x86/mm/init_64.c
@@ -269,7 +269,10 @@ static p4d_t *fill_p4d(pgd_t *pgd, unsig
 	if (pgd_none(*pgd)) {
 		p4d_t *p4d = (p4d_t *)spp_getpage();
 		pgd_populate(&init_mm, pgd, p4d);
-		if (p4d != p4d_offset(pgd, 0))
+
+		if (__pa(p4d) != (pgtable_l5_enabled() ?
+				  (unsigned long)pgd_val(*pgd) & PTE_PFN_MASK :
+				  __pa(pgd)))
 			printk(KERN_ERR "PAGETABLE BUG #00! %p <-> %p\n",
 			       p4d, p4d_offset(pgd, 0));
 	}
@@ -281,7 +284,7 @@ static pud_t *fill_pud(p4d_t *p4d, unsig
 	if (p4d_none(*p4d)) {
 		pud_t *pud = (pud_t *)spp_getpage();
 		p4d_populate(&init_mm, p4d, pud);
-		if (pud != pud_offset(p4d, 0))
+		if (__pa(pud) != (p4d_val(*p4d) & p4d_pfn_mask(*p4d)))
 			printk(KERN_ERR "PAGETABLE BUG #01! %p <-> %p\n",
 			       pud, pud_offset(p4d, 0));
 	}
@@ -293,7 +296,7 @@ static pmd_t *fill_pmd(pud_t *pud, unsig
 	if (pud_none(*pud)) {
 		pmd_t *pmd = (pmd_t *) spp_getpage();
 		pud_populate(&init_mm, pud, pmd);
-		if (pmd != pmd_offset(pud, 0))
+		if (__pa(pmd) != (pud_val(*pud) & pud_pfn_mask(*pud)))
 			printk(KERN_ERR "PAGETABLE BUG #02! %p <-> %p\n",
 			       pmd, pmd_offset(pud, 0));
 	}
@@ -305,7 +308,7 @@ static pte_t *fill_pte(pmd_t *pmd, unsig
 	if (pmd_none(*pmd)) {
 		pte_t *pte = (pte_t *) spp_getpage();
 		pmd_populate_kernel(&init_mm, pmd, pte);
-		if (pte != pte_offset_kernel(pmd, 0))
+		if (__pa(pte) != (pmd_val(*pmd) & pmd_pfn_mask(*pmd)))
 			printk(KERN_ERR "PAGETABLE BUG #03!\n");
 	}
 	return pte_offset_kernel(pmd, vaddr);
_

Patches currently in -mm which might be from maciej.wieczor-retman@intel.com are

kasan-fix-inline-mode-for-x86-tag-based-mode.patch
x86-kasan-add-arch-specific-kasan-functions.patch
x86-mm-reset-tag-for-virtual-to-physical-address-conversions.patch
mm-execmem-untag-addresses-in-execmem_rox-related-pointer-arithmetic.patch
x86-mm-physical-address-comparisons-in-fill_pd-pte.patch
x86-kasan-kasan-raw-shadow-memory-pte-init.patch
x86-mm-lam-compatible-non-canonical-definition.patch
x86-mm-lam-initialization.patch
x86-minimal-slab-alignment.patch
arm64-unify-software-tag-based-kasan-inline-recovery-path.patch
x86-kasan-logical-bit-shift-for-kasan_mem_to_shadow.patch
x86-kasan-make-software-tag-based-kasan-available.patch

