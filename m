Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AF21BE249
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 17:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941212; cv=none; b=jM2E/kT1JHGjLahciWyd7zloIK5RA0WZyJLybMLUyyfa/ppGuAVk7OBKBUlXN2nnbpIk8ysG8/AOX1m9ncCL2kXtNSirIn7wlK+9iqf46MFo/mGfQVVpM79uHIbDE1U42Q4B6Cq+CzhAmvj/MCy+WqD3WyH3MKjMAw+5CA40R20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941212; c=relaxed/simple;
	bh=BErSxVvPpVp0EzRofOvYFh9sL0CqKAnvqy/fXg6TlMc=;
	h=Date:To:From:Subject:Message-Id; b=uPobztZelrM4UjAUGjWHD2fcDcAAmCAGx/NQN2pD1uk2eZ+QwUD0/K1TniVc4CKoDQKeug/vTG1+V8HZE3AhkhCc1MkQWIMhBh3UpXwkxhKDMGvrQsPsWqITOeVpgLKeypoPOQnnjsdTTKUy8TL5HZIvbCzjrRV6kVHPjhfA+kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DbrJGF1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DbrJGF1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3641C116B1;
	Tue,  2 Jul 2024 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719941211;
	bh=BErSxVvPpVp0EzRofOvYFh9sL0CqKAnvqy/fXg6TlMc=;
	h=Date:To:From:Subject:From;
	b=DbrJGF1l9ryHsHMONvAXkPLvMr0JqkQigCiJOwwFfW61+t9s4fgh8Mf6n1VCktPs0
	 G6IrcBQPkx0Kri4MQWouhLWBiPu7AsNr84vmAJ53J6fWseORlbapYRPh7WXpvlMymm
	 FLWHGEAfScy/8QosenxLF3LwuwXf9yhnqfFa4po0=
Date: Tue, 02 Jul 2024 10:26:51 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-e500-encode-hugepage-size-in-pte-bits.patch added to mm-unstable branch
Message-Id: <20240702172651.C3641C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc/e500: encode hugepage size in PTE bits
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-e500-encode-hugepage-size-in-pte-bits.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-e500-encode-hugepage-size-in-pte-bits.patch

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
Subject: powerpc/e500: encode hugepage size in PTE bits
Date: Tue, 2 Jul 2024 15:51:29 +0200

Use PTE page size bits to encode hugepage size with the following format
corresponding to the values expected in bits 52-55 in MAS1 register. 
Those bits are called TSIZE:
	0001 	4 Kbyte
	0010 	16 Kbyte
	0011 	64 Kbyte
	0100 	256 Kbyte
	0101 	1 Mbyte
	0110 	4 Mbyte
	0111 	16 Mbyte
	1000 	64 Mbyte
	1001 	256 Mbyte
	1010 	1 Gbyte
	1011 	4 Gbyte
	1100 	16 Gbyte
	1101	64 Gbyte
	1110	256 Gbyte
	1111	1 Tbyte

It corresponds to shift value minus 10 with lowest bit removed.

It is not the value expected in the PTE in that field, but only e6500
performs HW based TLB loading and the e6500 reference manual explicitely
says that this field is ignored.

Also add pte_huge_size() which will be used later.

Link: https://lkml.kernel.org/r/6f7ce82fa8c381d55f65342d77060fc55802e612.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/hugetlb-e500.h |    9 ++++
 arch/powerpc/include/asm/nohash/pte-e500.h     |   28 ++++++---------
 2 files changed, 22 insertions(+), 15 deletions(-)

--- a/arch/powerpc/include/asm/nohash/hugetlb-e500.h~powerpc-e500-encode-hugepage-size-in-pte-bits
+++ a/arch/powerpc/include/asm/nohash/hugetlb-e500.h
@@ -42,4 +42,13 @@ static inline int check_and_get_huge_psi
 	return shift_to_mmu_psize(shift);
 }
 
+static inline pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
+{
+	unsigned int tsize = shift - _PAGE_PSIZE_SHIFT_OFFSET;
+	pte_basic_t val = (tsize << _PAGE_PSIZE_SHIFT) & _PAGE_PSIZE_MSK;
+
+	return __pte((pte_val(entry) & ~(pte_basic_t)_PAGE_PSIZE_MSK) | val);
+}
+#define arch_make_huge_pte arch_make_huge_pte
+
 #endif /* _ASM_POWERPC_NOHASH_HUGETLB_E500_H */
--- a/arch/powerpc/include/asm/nohash/pte-e500.h~powerpc-e500-encode-hugepage-size-in-pte-bits
+++ a/arch/powerpc/include/asm/nohash/pte-e500.h
@@ -19,20 +19,7 @@
 #define _PAGE_BAP_SX	0x000040
 #define _PAGE_BAP_UX	0x000080
 #define _PAGE_PSIZE_MSK	0x000f00
-#define _PAGE_PSIZE_4K	0x000200
-#define _PAGE_PSIZE_8K	0x000300
-#define _PAGE_PSIZE_16K	0x000400
-#define _PAGE_PSIZE_32K	0x000500
-#define _PAGE_PSIZE_64K	0x000600
-#define _PAGE_PSIZE_128K	0x000700
-#define _PAGE_PSIZE_256K	0x000800
-#define _PAGE_PSIZE_512K	0x000900
-#define _PAGE_PSIZE_1M	0x000a00
-#define _PAGE_PSIZE_2M	0x000b00
-#define _PAGE_PSIZE_4M	0x000c00
-#define _PAGE_PSIZE_8M	0x000d00
-#define _PAGE_PSIZE_16M	0x000e00
-#define _PAGE_PSIZE_32M	0x000f00
+#define _PAGE_TSIZE_4K	0x000100
 #define _PAGE_DIRTY	0x001000 /* C: page changed */
 #define _PAGE_SW0	0x002000
 #define _PAGE_U3	0x004000
@@ -46,6 +33,9 @@
 #define _PAGE_NO_CACHE	0x400000 /* I: cache inhibit */
 #define _PAGE_WRITETHRU	0x800000 /* W: cache write-through */
 
+#define _PAGE_PSIZE_SHIFT		7
+#define _PAGE_PSIZE_SHIFT_OFFSET	10
+
 /* "Higher level" linux bit combinations */
 #define _PAGE_EXEC		(_PAGE_BAP_SX | _PAGE_BAP_UX) /* .. and was cache cleaned */
 #define _PAGE_READ		(_PAGE_BAP_SR | _PAGE_BAP_UR) /* User read permission */
@@ -87,7 +77,7 @@
  * pages. We always set _PAGE_COHERENT when SMP is enabled or
  * the processor might need it for DMA coherency.
  */
-#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_PSIZE_4K)
+#define _PAGE_BASE_NC	(_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_TSIZE_4K)
 #if defined(CONFIG_SMP)
 #define _PAGE_BASE	(_PAGE_BASE_NC | _PAGE_COHERENT)
 #else
@@ -103,6 +93,14 @@ static inline pte_t pte_mkexec(pte_t pte
 }
 #define pte_mkexec pte_mkexec
 
+static inline unsigned long pte_huge_size(pte_t pte)
+{
+	pte_basic_t val = pte_val(pte);
+
+	return 1UL << (((val & _PAGE_PSIZE_MSK) >> _PAGE_PSIZE_SHIFT) + _PAGE_PSIZE_SHIFT_OFFSET);
+}
+#define pte_huge_size pte_huge_size
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* __KERNEL__ */
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

