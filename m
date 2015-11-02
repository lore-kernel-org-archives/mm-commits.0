From: akpm@linux-foundation.org
Subject: [to-be-updated] arm-add-pmd_mkclean-for-thp.patch removed from
 -mm tree
Date: Mon, 02 Nov 2015 15:13:13 -0800
Message-ID: <5637ee09.aTsjo/I4BFBruo8P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbKBXNN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 18:13:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: add pmd_mkclean for THP
has been removed from the -mm tree.  Its filename was
     arm-add-pmd_mkclean-for-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: arm: add pmd_mkclean for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_mkclean for THP page MADV_FREE support.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/arm/include/asm/pgtable-3level.h~arm-add-pmd_mkclean-for-thp arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-add-pmd_mkclean-for-thp
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -240,6 +240,7 @@ PMD_BIT_FUNC(wrprotect,	|= L_PMD_SECT_RD
 PMD_BIT_FUNC(mkold,	&= ~PMD_SECT_AF);
 PMD_BIT_FUNC(mkwrite,   &= ~L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkdirty,   |= L_PMD_SECT_DIRTY);
+PMD_BIT_FUNC(mkclean,   &= ~L_PMD_SECT_DIRTY);
 PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
_

Patches currently in -mm which might be from minchan@kernel.org are

arm64-add-pmd_-for-thp.patch

