From: akpm@linux-foundation.org
Subject: [to-be-updated] powerpc-add-pmd_-for-thp.patch removed from -mm
 tree
Date: Mon, 02 Nov 2015 15:13:11 -0800
Message-ID: <5637ee07.6Zm+ZPQ39V7gTzvL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbKBXNL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 18:13:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add pmd_[dirty|mkclean] for THP
has been removed from the -mm tree.  Its filename was
     powerpc-add-pmd_-for-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: powerpc: add pmd_[dirty|mkclean] for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-ppc64.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-add-pmd_-for-thp arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-add-pmd_-for-thp
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -494,9 +494,11 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_pfn(pmd)		pte_pfn(pmd_pte(pmd))
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
+#define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
 #define pmd_mkdirty(pmd)	pte_pmd(pte_mkdirty(pmd_pte(pmd)))
+#define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkwrite(pmd)	pte_pmd(pte_mkwrite(pmd_pte(pmd)))
 
_

Patches currently in -mm which might be from minchan@kernel.org are

arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch

