Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0813C2F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103864; cv=none; b=J7EEHn/9lz4SGIqbakr7VkVLtl94MGZJa20RZrG+NJE8fHUNeNvCPr9CH978Lmx187kE4m4/0qSRaJhnbxYI3bHWITjXEJ90HRtp/IPPEncM/RNMhDOL0w4oj2pQe+RD/WjfT2xvLpx+YRlOZV5QiSj2ehRu5hZq60Hd3vT9kTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103864; c=relaxed/simple;
	bh=skdz5ZIdMz6likpjQvZgVA4TmFGavpgeTsXjL4OgEmI=;
	h=Date:To:From:Subject:Message-Id; b=AWmIn4ziPWN+W+z4NmS4T7cRfxWmBnc9atrUcWBjlHf6/bRL/e74xo/8ap/6q/AVU6TPtR+WCM0UBmZP/5J2beLmmvDFM+WxBaTaUzOkgRWGKzYEqAGWUdfr0m/duCBpUzYDzzyujcmn1/WqrGURo0C8rp0lJfDswLE/gDG1vc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1yHD1PdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1yHD1PdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AADFC116B1;
	Fri, 26 Apr 2024 03:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103864;
	bh=skdz5ZIdMz6likpjQvZgVA4TmFGavpgeTsXjL4OgEmI=;
	h=Date:To:From:Subject:From;
	b=1yHD1PdTcfx5tiMT8yt8zYBSt6GtxWZwYvYzjR/gbEJlmGaYCTzSkXDw8Sms8qXD1
	 6yBIduJSkq/QhnRRuaRFRX5DyrFhefqghlBQPiKFyUJyS1wvsmSkKYI7ElJMbnePa+
	 j6IAjhbJMot82rNU9BKHGKaC9lKG2tQZwSiyhiGE=
Date: Thu, 25 Apr 2024 20:57:43 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-arm-remove-pmd_thp_or_huge.patch removed from -mm tree
Message-Id: <20240426035744.2AADFC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/arm: remove pmd_thp_or_huge()
has been removed from the -mm tree.  Its filename was
     mm-arm-remove-pmd_thp_or_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/arm: remove pmd_thp_or_huge()
Date: Mon, 18 Mar 2024 16:04:03 -0400

ARM/ARM64 used to define pmd_thp_or_huge().  Now this macro is completely
redundant.  Remove it and use pmd_leaf().

Link: https://lkml.kernel.org/r/20240318200404.448346-14-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-2level.h |    1 -
 arch/arm/include/asm/pgtable-3level.h |    1 -
 arch/arm/lib/uaccess_with_memcpy.c    |    4 ++--
 arch/arm64/include/asm/pgtable.h      |    2 --
 4 files changed, 2 insertions(+), 6 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm64/include/asm/pgtable.h
@@ -517,8 +517,6 @@ static inline pmd_t pmd_mkinvalid(pmd_t
 	return pmd;
 }
 
-#define pmd_thp_or_huge(pmd)	(pmd_leaf(pmd) || pmd_trans_huge(pmd))
-
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
 #define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
--- a/arch/arm/include/asm/pgtable-2level.h~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -241,7 +241,6 @@ static inline pmd_t *pmd_offset(pud_t *p
  * define empty stubs for use by pin_page_for_write.
  */
 #define pmd_hugewillfault(pmd)	(0)
-#define pmd_thp_or_huge(pmd)	(0)
 
 #endif /* __ASSEMBLY__ */
 
--- a/arch/arm/include/asm/pgtable-3level.h~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -190,7 +190,6 @@ static inline pte_t pte_mkspecial(pte_t
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
 
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
-#define pmd_thp_or_huge(pmd)	(pmd_leaf(pmd) || pmd_trans_huge(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
--- a/arch/arm/lib/uaccess_with_memcpy.c~mm-arm-remove-pmd_thp_or_huge
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -56,10 +56,10 @@ pin_page_for_write(const void __user *_a
 	 * to see that it's still huge and whether or not we will
 	 * need to fault on write.
 	 */
-	if (unlikely(pmd_thp_or_huge(*pmd))) {
+	if (unlikely(pmd_leaf(*pmd))) {
 		ptl = &current->mm->page_table_lock;
 		spin_lock(ptl);
-		if (unlikely(!pmd_thp_or_huge(*pmd)
+		if (unlikely(!pmd_leaf(*pmd)
 			|| pmd_hugewillfault(*pmd))) {
 			spin_unlock(ptl);
 			return 0;
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

