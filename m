Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1447C4A08
	for <mm-commits@vger.kernel.org>; Sun, 26 Oct 2025 04:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761454716; cv=none; b=g92YmTvnbcY0OHXxMhUdbsycmml5SZhpze3xI0CFTyCcQg/spY7rqeoyE59SoCv0vq9NkzM9eDmaSxZ8eSc8POaeJs9FqD8OvSNYfsjAy5JsILwywpxEITlH12aI938yPdf54jcUFqsmHmVL6vcDU27A4T3nwsu+/3u9rncbEcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761454716; c=relaxed/simple;
	bh=hse1kbblfZ1uf7Tv3WLhx2NqXLFbGuYlY42i7fkCgxQ=;
	h=Date:To:From:Subject:Message-Id; b=l6C8W8RQ2sLlL0J1TXNG0COVmKIRjFuXLodIPmziw2Xw9jcQK0ImSlOyr3NCIuU0vKuIJ5MJz6wYvD28w7XmVwHzXB1TgVx1v5HDThrb2De/aIYH/SHmm4yvEfC/Jb+oTxPgATwhF9yTCt/RagySN7QjrLklp073OgKGWqKOsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t5FnDktW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t5FnDktW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A01C4CEE7;
	Sun, 26 Oct 2025 04:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761454715;
	bh=hse1kbblfZ1uf7Tv3WLhx2NqXLFbGuYlY42i7fkCgxQ=;
	h=Date:To:From:Subject:From;
	b=t5FnDktWWsqccsfsn8jkvVIjbKIaySrZML1wWSiLjYVxlcafl4Hq18rLdpuL7MOsE
	 UpyodOe12PA154cWauUUJqPRMVvYznv6iStlK1b9hx0a/H/zoLN8W+8CFPWHKI/s+3
	 8uHvf6150eHRPjfIiw9U1Ll5xYv9GAqTIOkNc9MY=
Date: Sat, 25 Oct 2025 21:58:34 -0700
To: mm-commits@vger.kernel.org,agordeev@linux.ibm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-invalid_phys_addr-a-generic-macro.patch added to mm-new branch
Message-Id: <20251026045835.68A01C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make INVALID_PHYS_ADDR a generic macro
has been added to the -mm mm-new branch.  Its filename is
     mm-make-invalid_phys_addr-a-generic-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-invalid_phys_addr-a-generic-macro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

mm-thp-drop-follow_devmap_pmd-default-stub.patch
mm-ptdump-replace-read_once-with-standard-page-table-accessors.patch
mm-replace-read_once-with-standard-page-table-accessors.patch
mm-dirty-replace-read_once-with-pudp_get.patch
mm-debug_vm_pgtable-add-_mkwrite_novma-tests.patch
mm-debug_vm_pgtable-add-_mkwrite_novma-tests-v3.patch
mm-make-invalid_phys_addr-a-generic-macro.patch

