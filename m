From: akpm@linux-foundation.org
Subject: [to-be-updated] sparc-add-pmd_-for-thp.patch removed from -mm
 tree
Date: Mon, 02 Nov 2015 15:13:09 -0800
Message-ID: <5637ee05.mc9Y1j8o975g04SF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbKBXNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 18:13:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: add pmd_[dirty|mkclean] for THP
has been removed from the -mm tree.  Its filename was
     sparc-add-pmd_-for-thp.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: sparc: add pmd_[dirty|mkclean] for THP

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent overwrite
of the contents since MADV_FREE syscall is called for THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

akpm@linux-foundation.org: mm-fix-huge-zero-page-accounting-in-smaps-report.patch already added pmd_dirty()]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_64.h |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/sparc/include/asm/pgtable_64.h~sparc-add-pmd_-for-thp arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~sparc-add-pmd_-for-thp
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -710,6 +710,15 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 	return __pmd(pte_val(pte));
 }
 
+static inline pmd_t pmd_mkclean(pmd_t pmd)
+{
+	pte_t pte = __pte(pmd_val(pmd));
+
+	pte = pte_mkclean(pte);
+
+	return __pmd(pte_val(pte));
+}
+
 static inline pmd_t pmd_mkyoung(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
_

Patches currently in -mm which might be from minchan@kernel.org are

powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch

