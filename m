Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDF312DDAF
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824878; cv=none; b=VZsSouMw/B+CqjTz5dHkG1sW1G5+wnQSxAcyNCDRzxwPQG42T7LWYRmlmaGSrTJOYr6zVfPpzVRGx7ryV+181PDYsr3T0qul46+XtV8pCOI1qdOvY0ItAtvzmScs3lZsOgwa1ONEV2DSNm+Xxz6A0awRwsL3VjiOiybNu0qd0CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824878; c=relaxed/simple;
	bh=NzyWciBP/OSg3tSO7MoOcFgsxai1Kg0iofNZafyl6D8=;
	h=Date:To:From:Subject:Message-Id; b=YrgC7p1ZAEetrtvJrGa/7p2+9G9tbv4+SXV6BR+PGKZ4d+KqaekUr9H1kIPtYkPscFX6MgAeiLusddW6Rr5FlxFW88QHXmT0WxrvI4w/rhkwmNoKaXMfD4ar4p1A2w29FeyWa+mZjpbZbXBAywI7b/Lf3ZAIZY4xladp5ZcWQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uTvluyqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTvluyqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CD7C32782;
	Fri, 12 Jul 2024 22:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824878;
	bh=NzyWciBP/OSg3tSO7MoOcFgsxai1Kg0iofNZafyl6D8=;
	h=Date:To:From:Subject:From;
	b=uTvluyqOK6vzFZnf55i++7Bx+mg1l1nC9dudspwUrVGuDwgcCx88mFR2P1qQz/oBW
	 MkAGN199ECrgqqumzlfE7iaRnnHTd+gCoq0cik2k/sbdI9vU0Z46JSjs5MYZMQS8Q2
	 UY4ctdFoVX25oDl0NJEoUP9Kaf5vd2VkoLQoxcg0=
Date: Fri, 12 Jul 2024 15:54:37 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-e500-encode-hugepage-size-in-pte-bits.patch removed from -mm tree
Message-Id: <20240712225438.22CD7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/e500: encode hugepage size in PTE bits
has been removed from the -mm tree.  Its filename was
     powerpc-e500-encode-hugepage-size-in-pte-bits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


