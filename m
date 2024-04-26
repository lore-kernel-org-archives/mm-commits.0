Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5DA3C2F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103847; cv=none; b=Sl+HQxLsl87eGXZO4iDnVYA2vFcVdv40s+jlYInEaFG/TanYQpFylsFRP3JLXFmJ32wdmDyU1/YgcTpLtS3JuI593Av06fJfn9mK980mEkMz+wv0Lqq5AZVNvC8tr8KsaRzZrVXB6z/BBl+kF+5MFQMtigyoSyaVnoUeUa1pHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103847; c=relaxed/simple;
	bh=pTsMY7jkxxfCdCGIIvCH6ukWpdaKM+1YisF84Iltm3g=;
	h=Date:To:From:Subject:Message-Id; b=rgyD+/fXdRSUhWbmMFcpzlARBFojhtxCfXRdj24i6gIWteH0Sf9CCXCWdKGDY7hD0Bytg6RmR2LpPPh2p16mKtFuBeE5XY4RaJsLjYFVQc260VRI040TgYhIK6Liy1zzFfMeypyqyDP7Xngi+9s6vcn9dJbYTQov0swRN3j7ITk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2S0v6QiW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2S0v6QiW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60DAC116B1;
	Fri, 26 Apr 2024 03:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103846;
	bh=pTsMY7jkxxfCdCGIIvCH6ukWpdaKM+1YisF84Iltm3g=;
	h=Date:To:From:Subject:From;
	b=2S0v6QiWjVrhwv5xniSnUX6LXOrEZNeedYfK1anEC3n3Kwe3A8l8uHPK+xKGLGTqT
	 5xNFqtTXjDXsKty0sgGansY4cQGReFNKtDsrdrlSGd6GoWjpiEq+t/z8RGCJcctNKt
	 wVzeIR8XUU8ACtR/c9WrD0KmjXwM7OwYuMy1PNDM=
Date: Thu, 25 Apr 2024 20:57:26 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmm-process-pud-swap-entry-without-pud_huge.patch removed from -mm tree
Message-Id: <20240426035726.C60DAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm: process pud swap entry without pud_huge()
has been removed from the -mm tree.  Its filename was
     mm-hmm-process-pud-swap-entry-without-pud_huge.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hmm: process pud swap entry without pud_huge()
Date: Mon, 18 Mar 2024 16:03:51 -0400

Swap pud entries do not always return true for pud_huge() for all archs. 
x86 and sparc (so far) allow it, but all the rest do not accept a swap
entry to be reported as pud_huge().  So it's not safe to check swap
entries within pud_huge().  Check swap entries before pud_huge(), so it
should be always safe.

This is the only place in the kernel that (IMHO, wrongly) relies on
pud_huge() to return true on pud swap entries.  The plan is to cleanup
pXd_huge() to only report non-swap mappings for all archs.

Link: https://lkml.kernel.org/r/20240318200404.448346-2-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Fabio Estevam <festevam@denx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/hmm.c~mm-hmm-process-pud-swap-entry-without-pud_huge
+++ a/mm/hmm.c
@@ -424,7 +424,7 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 	walk->action = ACTION_CONTINUE;
 
 	pud = READ_ONCE(*pudp);
-	if (pud_none(pud)) {
+	if (!pud_present(pud)) {
 		spin_unlock(ptl);
 		return hmm_vma_walk_hole(start, end, -1, walk);
 	}
@@ -435,11 +435,6 @@ static int hmm_vma_walk_pud(pud_t *pudp,
 		unsigned long *hmm_pfns;
 		unsigned long cpu_flags;
 
-		if (!pud_present(pud)) {
-			spin_unlock(ptl);
-			return hmm_vma_walk_hole(start, end, -1, walk);
-		}
-
 		i = (addr - range->start) >> PAGE_SHIFT;
 		npages = (end - addr) >> PAGE_SHIFT;
 		hmm_pfns = &range->hmm_pfns[i];
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

