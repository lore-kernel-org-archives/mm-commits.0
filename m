Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3063C47C
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882973; cv=none; b=AXX6/59O1HZm2QDKdBc+OV0I+khmfFiFQjEc89VMHtqfBungmjA9S+hSyW7/Nj4wbJtvUO8al7kOPvp9UDZuMclpxTOQsV74pUFhfNVxULQPlf7lb30L56+PZinbBJEazMVZwjW/S6rQmVHsonNnvOcLDeHMxM4TX6VXxcUbOYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882973; c=relaxed/simple;
	bh=z7s2Ed1wINXl4kbA/TGy/zjBvVNdPnf0l87TXDVK6iQ=;
	h=Date:To:From:Subject:Message-Id; b=YqyrGKAf+jEyQOpIaUqBQ2ciqbhR7wdxXjSVgUZA18dfqMK0KzjV6fkgw9mJii7c4/5aMQxuoaCu5KMirbq2BWc6Na99ZJmTT1Vzg4ETbBeJ4pMABSXfJsp6UNhrL+9h/+tdIKTmIS11oA8C6p3rGLPxmlfBPGMZd0g4z9yMvCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IoTeBx05; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IoTeBx05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D4C43394;
	Tue, 19 Mar 2024 21:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882972;
	bh=z7s2Ed1wINXl4kbA/TGy/zjBvVNdPnf0l87TXDVK6iQ=;
	h=Date:To:From:Subject:From;
	b=IoTeBx05i6IZ8DxD2PP88dEFldJOIoyDKd2O8plILHPE5kvV99pdUcH+Nro5ZCMW0
	 zp0PndP5KZs2xe5/zV6bggHULd3LxhyGjHLA54vMzseEtgzWWUjCmSAXnIy001fk86
	 V9H5RcSkC/ROiLNdd2VoVOQxFq69gdhh9uypSyzI=
Date: Tue, 19 Mar 2024 14:16:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-check-p4d-presence-before-going-on.patch added to mm-unstable branch
Message-Id: <20240319211612.B08D4C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: check p4d presence before going on
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-check-p4d-presence-before-going-on.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-check-p4d-presence-before-going-on.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: check p4d presence before going on
Date: Mon, 18 Mar 2024 16:03:53 -0400

Currently there should have no p4d swap entries so it may not matter much,
however this may help us to rule out swap entries in pXd_huge() API, which
will include p4d_huge().  The p4d_present() checks make it 100% clear that
we won't rely on p4d_huge() for swap entries.

Link: https://lkml.kernel.org/r/20240318200404.448346-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
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
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Mark Salter <msalter@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/gup.c~mm-gup-check-p4d-presence-before-going-on
+++ a/mm/gup.c
@@ -776,7 +776,7 @@ static struct page *follow_p4d_mask(stru
 
 	p4dp = p4d_offset(pgdp, address);
 	p4d = READ_ONCE(*p4dp);
-	if (p4d_none(p4d))
+	if (!p4d_present(p4d))
 		return no_page_table(vma, flags);
 	BUILD_BUG_ON(p4d_huge(p4d));
 	if (unlikely(p4d_bad(p4d)))
@@ -3079,7 +3079,7 @@ static int gup_p4d_range(pgd_t *pgdp, pg
 		p4d_t p4d = READ_ONCE(*p4dp);
 
 		next = p4d_addr_end(addr, end);
-		if (p4d_none(p4d))
+		if (!p4d_present(p4d))
 			return 0;
 		BUILD_BUG_ON(p4d_huge(p4d));
 		if (unlikely(is_hugepd(__hugepd(p4d_val(p4d))))) {
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-memory-fix-missing-pte-marker-for-page-on-pte-zaps.patch
mm-hmm-process-pud-swap-entry-without-pud_huge.patch
mm-gup-cache-p4d-in-follow_p4d_mask.patch
mm-gup-check-p4d-presence-before-going-on.patch
mm-x86-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-sparc-change-pxd_huge-behavior-to-exclude-swap-entries.patch
mm-arm-use-macros-to-define-pmd-pud-helpers.patch
mm-arm-redefine-pmd_huge-with-pmd_leaf.patch
mm-arm64-merge-pxd_huge-and-pxd_leaf-definitions.patch
mm-powerpc-redefine-pxd_huge-with-pxd_leaf.patch
mm-gup-merge-pxd-huge-mapping-checks.patch
mm-treewide-replace-pxd_huge-with-pxd_leaf.patch
mm-treewide-remove-pxd_huge.patch
mm-arm-remove-pmd_thp_or_huge.patch
mm-document-pxd_leaf-api.patch

