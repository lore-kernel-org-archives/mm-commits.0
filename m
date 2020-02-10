From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 10 Feb 2020 13:58:38 -0800
Message-ID: <20200210215838.9lAjuyf-h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbgBJV6l (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 Feb 2020 16:58:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/irqchip/irq-gic-v3-its.c |   69 -----------------------------
 1 file changed, 69 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c~linux-next-git-rejects
+++ a/drivers/irqchip/irq-gic-v3-its.c
@@ -2443,75 +2443,6 @@ static u64 inherit_vpe_l1_table_from_rd(
 	return 0;
 }
 
-<<<<<<< HEAD
-static bool allocate_vpe_l2_table(int cpu, u32 id)
-{
-	void __iomem *base = gic_data_rdist_cpu(cpu)->rd_base;
-	unsigned int psz, esz, idx, npg, gpsz;
-	u64 val;
-	struct page *page;
-	__le64 *table;
-
-	if (!gic_rdists->has_rvpeid)
-		return true;
-
-	val  = gicr_read_vpropbaser(base + SZ_128K + GICR_VPROPBASER);
-
-	esz  = FIELD_GET(GICR_VPROPBASER_4_1_ENTRY_SIZE, val) + 1;
-	gpsz = FIELD_GET(GICR_VPROPBASER_4_1_PAGE_SIZE, val);
-	npg  = FIELD_GET(GICR_VPROPBASER_4_1_SIZE, val) + 1;
-
-	switch (gpsz) {
-	default:
-		WARN_ON(1);
-		/* fall through */
-	case GIC_PAGE_SIZE_4K:
-		psz = SZ_4K;
-		break;
-	case GIC_PAGE_SIZE_16K:
-		psz = SZ_16K;
-		break;
-	case GIC_PAGE_SIZE_64K:
-		psz = SZ_64K;
-		break;
-	}
-
-	/* Don't allow vpe_id that exceeds single, flat table limit */
-	if (!(val & GICR_VPROPBASER_4_1_INDIRECT))
-		return (id < (npg * psz / (esz * SZ_8)));
-
-	/* Compute 1st level table index & check if that exceeds table limit */
-	idx = id >> ilog2(psz / (esz * SZ_8));
-	if (idx >= (npg * psz / GITS_LVL1_ENTRY_SIZE))
-		return false;
-
-	table = gic_data_rdist_cpu(cpu)->vpe_l1_base;
-
-	/* Allocate memory for 2nd level table */
-	if (!table[idx]) {
-		page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(psz));
-		if (!page)
-			return false;
-
-		/* Flush Lvl2 table to PoC if hw doesn't support coherency */
-		if (!(val & GICR_VPROPBASER_SHAREABILITY_MASK))
-			gic_flush_dcache_to_poc(page_address(page), psz);
-
-		table[idx] = cpu_to_le64(page_to_phys(page) | GITS_BASER_VALID);
-
-		/* Flush Lvl1 entry to PoC if hw doesn't support coherency */
-		if (!(val & GICR_VPROPBASER_SHAREABILITY_MASK))
-			gic_flush_dcache_to_poc(table + idx, GITS_LVL1_ENTRY_SIZE);
-
-		/* Ensure updated table contents are visible to RD hardware */
-		dsb(sy);
-	}
-
-	return true;
-}
