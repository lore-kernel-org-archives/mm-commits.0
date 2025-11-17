Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F1E23BD1F
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343268; cv=none; b=FR3QInUvZoKkO/habp7IXyslMcOtYGd0dsf+o70RpZZrchTPHb+z2eugIr1lbLXsC8HbHEFjDqy6iV2cYnsn17EHzkCUnJeF11KHqO6W4jUuCvxx2Ys7o4KHnN+oe8zF+JBINICBWqUpasiUkXVmkJ1ddeUoXxQgmQWxFUzruLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343268; c=relaxed/simple;
	bh=OQJ0MFrM09+7wVTb9Af2Ap1tU3DcD5KoldT/XcpTOZ0=;
	h=Date:To:From:Subject:Message-Id; b=F1heM3HXb4G8CXs6uQtW5kaT8LT3WXz8723WS9JQkO97LGbxX0l78W6KeI7/f9dPte+Xrsali9HDwqWBg3ZrigMko1Fmx0DUg/4EnXk/uC2LxoS4yqPiDBX40sXr6sRDy27mCOp4d8pOgPRhNbGf6aIMQaksMz/Cegp5RwvppCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EjngIV3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EjngIV3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF13C113D0;
	Mon, 17 Nov 2025 01:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343268;
	bh=OQJ0MFrM09+7wVTb9Af2Ap1tU3DcD5KoldT/XcpTOZ0=;
	h=Date:To:From:Subject:From;
	b=EjngIV3gpWyhDuBnY5l2svLQ/TQ0KAzzZYWt1JNFQ/HQuoceOYbHgbbU5lyw8emFa
	 TBQzXek9CJpuKrp3/ky8BtZO/o/giwOcXtIMJ8KNom7W0vxHs+sBXpJqQqKEIi+ce/
	 UOk6AbVkmXi7ZDRJGrELcwRWlbb67tg/1+zjtjws=
Date: Sun, 16 Nov 2025 17:34:27 -0800
To: mm-commits@vger.kernel.org,agordeev@linux.ibm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-invalid_phys_addr-a-generic-macro.patch removed from -mm tree
Message-Id: <20251117013427.EDF13C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make INVALID_PHYS_ADDR a generic macro
has been removed from the -mm tree.  Its filename was
     mm-make-invalid_phys_addr-a-generic-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: make INVALID_PHYS_ADDR a generic macro
Date: Tue, 21 Oct 2025 03:56:38 +0100

INVALID_PHYS_ADDR has very similar definitions across the code base. 
Hence just move that inside header <liux/mm.h> for more generic usage. 
Also drop the now redundant ones which are no longer required.

Link: https://lkml.kernel.org/r/20251021025638.2420216-1-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	[s390]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c                  |    2 --
 arch/s390/boot/vmem.c                |    1 -
 drivers/vdpa/vdpa_user/iova_domain.h |    2 --
 include/linux/mm.h                   |    2 ++
 kernel/dma/swiotlb.c                 |    2 --
 5 files changed, 2 insertions(+), 7 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-make-invalid_phys_addr-a-generic-macro
+++ a/arch/arm64/mm/mmu.c
@@ -470,8 +470,6 @@ static void __create_pgd_mapping(pgd_t *
 	mutex_unlock(&fixmap_lock);
 }
 
-#define INVALID_PHYS_ADDR	(-1ULL)
-
 static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
 				       enum pgtable_type pgtable_type)
 {
--- a/arch/s390/boot/vmem.c~mm-make-invalid_phys_addr-a-generic-macro
+++ a/arch/s390/boot/vmem.c
@@ -16,7 +16,6 @@
 #include "decompressor.h"
 #include "boot.h"
 
-#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
 struct ctlreg __bootdata_preserved(s390_invalid_asce);
 
 #ifdef CONFIG_PROC_FS
--- a/drivers/vdpa/vdpa_user/iova_domain.h~mm-make-invalid_phys_addr-a-generic-macro
+++ a/drivers/vdpa/vdpa_user/iova_domain.h
@@ -17,8 +17,6 @@
 
 #define IOVA_START_PFN 1
 
-#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
-
 #define BOUNCE_MAP_SHIFT	12
 #define BOUNCE_MAP_SIZE	(1 << BOUNCE_MAP_SHIFT)
 #define BOUNCE_MAP_MASK	(~(BOUNCE_MAP_SIZE - 1))
--- a/include/linux/mm.h~mm-make-invalid_phys_addr-a-generic-macro
+++ a/include/linux/mm.h
@@ -105,6 +105,8 @@ extern int mmap_rnd_compat_bits __read_m
 # endif
 #endif
 
+#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
+
 #include <asm/page.h>
 #include <asm/processor.h>
 
--- a/kernel/dma/swiotlb.c~mm-make-invalid_phys_addr-a-generic-macro
+++ a/kernel/dma/swiotlb.c
@@ -61,8 +61,6 @@
  */
 #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
 
-#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
-
 /**
  * struct io_tlb_slot - IO TLB slot descriptor
  * @orig_addr:	The original address corresponding to a mapped entry.
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are


