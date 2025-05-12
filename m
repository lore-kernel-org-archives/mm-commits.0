Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41821E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010978; cv=none; b=JeGSu1UP6D61k+97UhHSljpswnWEJLExPlG15GTPivMCNx7Svvfxq+YxZv7+J/RfvxK9JYEkshZfY9/Gt3Zk3+T7+R/prxu/bdUsuZ3/dcr2TxMYJW0KlWqJCvsv/ADK/cLizyeFpE+xPWt6exEaOiaTk1T2Goz68EVfaUPuBOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010978; c=relaxed/simple;
	bh=DNuO4+sEburZml4DEf2pOrWqjf/qeX26HpIe2Whh3tE=;
	h=Date:To:From:Subject:Message-Id; b=Te4wryHlMEF4RnYD5Cf0ytms3wGH0gnAqLWCPBBJydijPxcnjS+uXsi25rFdRQ4W1JG6QN8rtJLC2napZ1pMth9l0VC2SuHVf2osv0LdpcpGHGWovqfCzcENVHsqIPcXKPMyA8tYMltO8cfo0xiBdHXCZXSZW1/IDHcrzl3UUXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KBRpAd3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KBRpAd3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C447C4CEE4;
	Mon, 12 May 2025 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010978;
	bh=DNuO4+sEburZml4DEf2pOrWqjf/qeX26HpIe2Whh3tE=;
	h=Date:To:From:Subject:From;
	b=KBRpAd3BH8B2KJmKjlP2HaePunRWLGb7YFzN18SGgDMkGkRdvR7fV8U84Q7i/qXLv
	 RR0lRR/FtZALu19HKUH6DsJllfoD+43S6D0mgmc4eI1PbemF3hkk7b7Mwtv+RCmDcO
	 cpUvVihXL8ZYAZG+UaN16QVfyU9NgTI4+si+IcCA=
Date: Sun, 11 May 2025 17:49:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sparc32-remove-custom-definition-of-mk_pte.patch removed from -mm tree
Message-Id: <20250512004938.1C447C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: sparc32: remove custom definition of mk_pte()
has been removed from the -mm tree.  Its filename was
     sparc32-remove-custom-definition-of-mk_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: sparc32: remove custom definition of mk_pte()
Date: Wed, 2 Apr 2025 19:16:57 +0100

Instead of defining pfn_pte() in terms of mk_pte(), make pfn_pte() the
base implementation.  That lets us use the generic definition of mk_pte().

Link: https://lkml.kernel.org/r/20250402181709.2386022-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/include/asm/pgtable_32.h |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/arch/sparc/include/asm/pgtable_32.h~sparc32-remove-custom-definition-of-mk_pte
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -255,7 +255,11 @@ static inline pte_t pte_mkyoung(pte_t pt
 }
 
 #define PFN_PTE_SHIFT			(PAGE_SHIFT - 4)
-#define pfn_pte(pfn, prot)		mk_pte(pfn_to_page(pfn), prot)
+
+static inline pte_t pfn_pte(unsigned long pfn, pgprot_t pgprot)
+{
+	return __pte((pfn << PFN_PTE_SHIFT) | pgprot_val(pgprot));
+}
 
 static inline unsigned long pte_pfn(pte_t pte)
 {
@@ -272,15 +276,6 @@ static inline unsigned long pte_pfn(pte_
 
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
-/*
- * Conversion functions: convert a page and protection to a page entry,
- * and a page entry and page directory to the page they refer to.
- */
-static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
-{
-	return __pte((page_to_pfn(page) << (PAGE_SHIFT-4)) | pgprot_val(pgprot));
-}
-
 static inline pte_t mk_pte_phys(unsigned long page, pgprot_t pgprot)
 {
 	return __pte(((page) >> 4) | pgprot_val(pgprot));
_

Patches currently in -mm which might be from willy@infradead.org are


