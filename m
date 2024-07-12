Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1E31CF96
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824877; cv=none; b=IrckO7oWAlm0deVhrxOvMcq1nNxs1y8Y3Moe+NjJIBl8MVZWPBx6K7sUtTRa0R8fJD3X0Yw/Wm+bCOncU8gZNMxd2wuSrapFjLHdp1bLVaJqghgHs/lqLT41maQe3rrxqcLUjbjIJ7454JsfXa+sOWI6vgZcX0mCOCNYkJVVlqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824877; c=relaxed/simple;
	bh=dZHsUs4fJEeQsovoyRYyDAaqgLsa4qi24mDeFhyklJA=;
	h=Date:To:From:Subject:Message-Id; b=jZdqTLKJOS77Vv4ldwF+kLLvsvL9W+LNEG3Z1C92vT3oNYXXVBia2BNhtKYv6nz+FrpxemjfM/qQ1qw0+5+ySXZz+n9/XiUj4SWuSjdupGiFMdkjHNfjNOSge4WbXfwjquJ5MmNf8hc8NFqynT6yb5+68GGdsoKtiuVQHX/5nZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eBkVpWKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eBkVpWKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11044C32782;
	Fri, 12 Jul 2024 22:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824877;
	bh=dZHsUs4fJEeQsovoyRYyDAaqgLsa4qi24mDeFhyklJA=;
	h=Date:To:From:Subject:From;
	b=eBkVpWKbr93+0pObysmqT1yBYJsXIkiCeX4N1PcSLKSO4kq8oL4taTi5GZPowYF5g
	 hjKsALCer/roZ8M3Tx/wICxvW+ZI+A2wR9O/JpQOm/Zp42Ki3HaD6DH+kSXGXe2D7K
	 2dhaT2fN5ciM/P4FPAev/6kvZvdA6wR676MJ01Co=
Date: Fri, 12 Jul 2024 15:54:36 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch removed from -mm tree
Message-Id: <20240712225437.11044C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/e500: switch to 64 bits PGD on 85xx (32 bits)
has been removed from the -mm tree.  Its filename was
     powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/e500: switch to 64 bits PGD on 85xx (32 bits)
Date: Tue, 2 Jul 2024 15:51:28 +0200

At the time being when CONFIG_PTE_64BIT is selected, PTE entries are 64
bits but PGD entries are still 32 bits.

In order to allow leaf PMD entries, switch the PGD to 64 bits entries.

Link: https://lkml.kernel.org/r/ca85397df02564e5edc3a3c27b55cf43af3e4ef3.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-types.h |    4 ++++
 arch/powerpc/kernel/head_85xx.S          |   10 ++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/pgtable-types.h~powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits
+++ a/arch/powerpc/include/asm/pgtable-types.h
@@ -49,7 +49,11 @@ static inline unsigned long pud_val(pud_
 #endif /* CONFIG_PPC64 */
 
 /* PGD level */
+#if defined(CONFIG_PPC_E500) && defined(CONFIG_PTE_64BIT)
+typedef struct { unsigned long long pgd; } pgd_t;
+#else
 typedef struct { unsigned long pgd; } pgd_t;
+#endif
 #define __pgd(x)	((pgd_t) { (x) })
 static inline unsigned long pgd_val(pgd_t x)
 {
--- a/arch/powerpc/kernel/head_85xx.S~powerpc-e500-switch-to-64-bits-pgd-on-85xx-32-bits
+++ a/arch/powerpc/kernel/head_85xx.S
@@ -307,8 +307,9 @@ set_ivor:
 #ifdef CONFIG_PTE_64BIT
 #ifdef CONFIG_HUGETLB_PAGE
 #define FIND_PTE	\
-	rlwinm	r12, r10, 13, 19, 29;	/* Compute pgdir/pmd offset */	\
-	lwzx	r11, r12, r11;		/* Get pgd/pmd entry */		\
+	rlwinm	r12, r10, 14, 18, 28;	/* Compute pgdir/pmd offset */	\
+	add	r12, r11, r12;						\
+	lwz	r11, 4(r12);		/* Get pgd/pmd entry */		\
 	rlwinm.	r12, r11, 0, 0, 20;	/* Extract pt base address */	\
 	blt	1000f;			/* Normal non-huge page */	\
 	beq	2f;			/* Bail if no table */		\
@@ -321,8 +322,9 @@ set_ivor:
 1001:	lwz	r11, 4(r12);		/* Get pte entry */
 #else
 #define FIND_PTE	\
-	rlwinm	r12, r10, 13, 19, 29;	/* Compute pgdir/pmd offset */	\
-	lwzx	r11, r12, r11;		/* Get pgd/pmd entry */		\
+	rlwinm	r12, r10, 14, 18, 28;	/* Compute pgdir/pmd offset */	\
+	add	r12, r11, r12;						\
+	lwz	r11, 4(r12);		/* Get pgd/pmd entry */		\
 	rlwinm.	r12, r11, 0, 0, 20;	/* Extract pt base address */	\
 	beq	2f;			/* Bail if no table */		\
 	rlwimi	r12, r10, 23, 20, 28;	/* Compute pte address */	\
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


