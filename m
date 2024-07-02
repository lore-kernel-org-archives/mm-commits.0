Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2051BE223
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941190; cv=none; b=I86HZT13m8XkkymU7C5cpISCcVppMCwm5TbD0K4bzGwzOQbnF4hManQDAddwF42cW/CGn6Ceiq0e+lSsLXpb75cxL0/c6ZzqYqv9Y4ODoVzvRmLKhl5QWE4VZGUU+FcsYb+DSxT9ed4Qgr+WvvXgCPwUNzTn45kCnvYT4MIr7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941190; c=relaxed/simple;
	bh=xfkNZ4+ILWf7CV1oV4jp9NWo1YHgt76WDit9m53r238=;
	h=Date:To:From:Subject:Message-Id; b=TKk5zEeL29KsrQJpiK4eVatXVVWvn/nQ1LrU0vKhtuz1tV45fmXJrPafmvtFmQk1WXwBXB1w+E3X0FIGqm7mxaaO7gkl7DHU3QGSWA3vmFXGESlwZjpF6bajglw5nDUiCrZ1wMbKSD5s9qwCam3bp8qXtjj+Gx1NYcDB5vxJDUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mb+iojNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mb+iojNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F536C4AF0C;
	Tue,  2 Jul 2024 17:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941190;
	bh=xfkNZ4+ILWf7CV1oV4jp9NWo1YHgt76WDit9m53r238=;
	h=Date:To:From:Subject:From;
	b=mb+iojNIhFAvbyBM/+a6h7toIAaDMgpZq7NYX19BD+rAk40exumfI6bLfP4wlWlKT
	 gakrOYFMk6a4ixZp9m4KnRbVChF3cpjiG9DxY9B2wYVhLCFcjaUZiXsQ7Z7YkanYF+
	 /5Wp/YB/9lh1XxUXbW5zl1XxcTLg8duiJuhuhNrs=
Date: Tue, 02 Jul 2024 10:26:29 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch added to mm-unstable branch
Message-Id: <20240702172630.6F536C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/mm: fix __find_linux_pte() on 32 bits with PMD leaf entries
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/mm: fix __find_linux_pte() on 32 bits with PMD leaf entries
Date: Tue, 2 Jul 2024 15:51:22 +0200

Building on 32 bits with pmd_leaf() not returning always false leads to
the following error:

  CC      arch/powerpc/mm/pgtable.o
arch/powerpc/mm/pgtable.c: In function '__find_linux_pte':
arch/powerpc/mm/pgtable.c:506:1: error: function may return address of local variable [-Werror=return-local-addr]
  506 | }
      | ^
arch/powerpc/mm/pgtable.c:394:15: note: declared here
  394 |         pud_t pud, *pudp;
      |               ^~~
arch/powerpc/mm/pgtable.c:394:15: note: declared here

This is due to pmd_offset() being a no-op in that case.

So rework it for powerpc/32 so that pXd_offset() are used on real
pointers and not on on-stack copies.

Behind fixing the problem, it also has the advantage of simplifying
__find_linux_pte() including the removal of stack frame:

After this patch:

	00000018 <__find_linux_pte>:
	  18:	2c 06 00 00 	cmpwi   r6,0
	  1c:	41 82 00 0c 	beq     28 <__find_linux_pte+0x10>
	  20:	39 20 00 00 	li      r9,0
	  24:	91 26 00 00 	stw     r9,0(r6)
	  28:	2f 85 00 00 	cmpwi   cr7,r5,0
	  2c:	41 9e 00 0c 	beq     cr7,38 <__find_linux_pte+0x20>
	  30:	39 20 00 00 	li      r9,0
	  34:	99 25 00 00 	stb     r9,0(r5)
	  38:	54 89 65 3a 	rlwinm  r9,r4,12,20,29
	  3c:	7c 63 48 2e 	lwzx    r3,r3,r9
	  40:	2f 83 00 00 	cmpwi   cr7,r3,0
	  44:	41 9e 00 30 	beq     cr7,74 <__find_linux_pte+0x5c>
	  48:	54 69 07 3a 	rlwinm  r9,r3,0,28,29
	  4c:	2f 89 00 0c 	cmpwi   cr7,r9,12
	  50:	54 63 00 26 	clrrwi  r3,r3,12
	  54:	54 84 b5 36 	rlwinm  r4,r4,22,20,27
	  58:	3c 63 c0 00 	addis   r3,r3,-16384
	  5c:	7c 63 22 14 	add     r3,r3,r4
	  60:	4c be 00 20 	bnelr+  cr7
	  64:	4d 82 00 20 	beqlr
	  68:	39 20 00 17 	li      r9,23
	  6c:	91 26 00 00 	stw     r9,0(r6)
	  70:	4e 80 00 20 	blr
	  74:	38 60 00 00 	li      r3,0
	  78:	4e 80 00 20 	blr

Before this patch:

	00000018 <__find_linux_pte>:
	  18:	2c 06 00 00 	cmpwi   r6,0
	  1c:	94 21 ff e0 	stwu    r1,-32(r1)
	  20:	41 82 00 0c 	beq     2c <__find_linux_pte+0x14>
	  24:	39 20 00 00 	li      r9,0
	  28:	91 26 00 00 	stw     r9,0(r6)
	  2c:	2f 85 00 00 	cmpwi   cr7,r5,0
	  30:	41 9e 00 0c 	beq     cr7,3c <__find_linux_pte+0x24>
	  34:	39 20 00 00 	li      r9,0
	  38:	99 25 00 00 	stb     r9,0(r5)
	  3c:	54 89 65 3a 	rlwinm  r9,r4,12,20,29
	  40:	7c 63 48 2e 	lwzx    r3,r3,r9
	  44:	54 69 07 3a 	rlwinm  r9,r3,0,28,29
	  48:	2f 89 00 0c 	cmpwi   cr7,r9,12
	  4c:	90 61 00 0c 	stw     r3,12(r1)
	  50:	41 9e 00 4c 	beq     cr7,9c <__find_linux_pte+0x84>
	  54:	80 61 00 0c 	lwz     r3,12(r1)
	  58:	54 69 07 3a 	rlwinm  r9,r3,0,28,29
	  5c:	2f 89 00 0c 	cmpwi   cr7,r9,12
	  60:	90 61 00 08 	stw     r3,8(r1)
	  64:	41 9e 00 38 	beq     cr7,9c <__find_linux_pte+0x84>
	  68:	80 61 00 08 	lwz     r3,8(r1)
	  6c:	2f 83 00 00 	cmpwi   cr7,r3,0
	  70:	41 9e 00 54 	beq     cr7,c4 <__find_linux_pte+0xac>
	  74:	54 69 07 3a 	rlwinm  r9,r3,0,28,29
	  78:	2f 89 00 0c 	cmpwi   cr7,r9,12
	  7c:	54 69 00 26 	clrrwi  r9,r3,12
	  80:	54 8a b5 36 	rlwinm  r10,r4,22,20,27
	  84:	3c 69 c0 00 	addis   r3,r9,-16384
	  88:	7c 63 52 14 	add     r3,r3,r10
	  8c:	54 84 93 be 	srwi    r4,r4,14
	  90:	41 9e 00 14 	beq     cr7,a4 <__find_linux_pte+0x8c>
	  94:	38 21 00 20 	addi    r1,r1,32
	  98:	4e 80 00 20 	blr
	  9c:	54 69 00 26 	clrrwi  r9,r3,12
	  a0:	54 84 93 be 	srwi    r4,r4,14
	  a4:	3c 69 c0 00 	addis   r3,r9,-16384
	  a8:	54 84 25 36 	rlwinm  r4,r4,4,20,27
	  ac:	7c 63 22 14 	add     r3,r3,r4
	  b0:	41 a2 ff e4 	beq     94 <__find_linux_pte+0x7c>
	  b4:	39 20 00 17 	li      r9,23
	  b8:	91 26 00 00 	stw     r9,0(r6)
	  bc:	38 21 00 20 	addi    r1,r1,32
	  c0:	4e 80 00 20 	blr
	  c4:	38 60 00 00 	li      r3,0
	  c8:	38 21 00 20 	addi    r1,r1,32
	  cc:	4e 80 00 20 	blr

Link: https://lkml.kernel.org/r/50a3cfbab5b11890a0da027de5cb011a9d47ba89.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/pgtable.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/pgtable.c~powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries
+++ a/arch/powerpc/mm/pgtable.c
@@ -382,8 +382,10 @@ pte_t *__find_linux_pte(pgd_t *pgdir, un
 			bool *is_thp, unsigned *hpage_shift)
 {
 	pgd_t *pgdp;
+#ifdef CONFIG_PPC64
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
+#endif
 	pmd_t pmd, *pmdp;
 	pte_t *ret_pte;
 	hugepd_t *hpdp = NULL;
@@ -401,8 +403,12 @@ pte_t *__find_linux_pte(pgd_t *pgdir, un
 	 * page fault or a page unmap. The return pte_t * is still not
 	 * stable. So should be checked there for above conditions.
 	 * Top level is an exception because it is folded into p4d.
+	 *
+	 * On PPC32, P4D/PUD/PMD are folded into PGD so go straight to
+	 * PMD level.
 	 */
 	pgdp = pgdir + pgd_index(ea);
+#ifdef CONFIG_PPC64
 	p4dp = p4d_offset(pgdp, ea);
 	p4d  = READ_ONCE(*p4dp);
 	pdshift = P4D_SHIFT;
@@ -442,8 +448,11 @@ pte_t *__find_linux_pte(pgd_t *pgdir, un
 		goto out_huge;
 	}
 
-	pdshift = PMD_SHIFT;
 	pmdp = pmd_offset(&pud, ea);
+#else
+	pmdp = pmd_offset(pud_offset(p4d_offset(pgdp, ea), ea), ea);
+#endif
+	pdshift = PMD_SHIFT;
 	pmd  = READ_ONCE(*pmdp);
 
 	/*
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-define-__pte_leaf_size-to-also-take-a-pmd-entry.patch
mm-provide-mm_struct-and-address-to-huge_ptep_get.patch
powerpc-mm-remove-_page_psize.patch
powerpc-mm-fix-__find_linux_pte-on-32-bits-with-pmd-leaf-entries.patch
powerpc-mm-allow-hugepages-without-hugepd.patch
powerpc-8xx-fix-size-given-to-set_huge_pte_at.patch
powerpc-8xx-rework-support-for-8m-pages-using-contiguous-pte-entries.patch
powerpc-8xx-simplify-struct-mmu_psize_def.patch
powerpc-e500-remove-enc-and-ind-fields-from-struct-mmu_psize_def.patch
powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch
powerpc-e500-encode-hugepage-size-in-pte-bits.patch
powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch
powerpc-e500-free-r10-for-find_pte.patch
powerpc-e500-use-contiguous-pmd-instead-of-hugepd.patch
powerpc-64s-use-contiguous-pmd-pud-instead-of-hugepd.patch
powerpc-mm-remove-hugepd-leftovers.patch
mm-remove-config_arch_has_hugepd.patch

