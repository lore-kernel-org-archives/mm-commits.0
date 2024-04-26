Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9743C2F
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 03:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714103848; cv=none; b=Tk9/R8Coj109i/M9eKTjGndGDcvpKApSGVVE3AB27YqkGg8jdk9eKSdfjQqjGcR+J+IZUZFpQxe0z2xu0Xm8JlGBC2IbsVZQPFFv4GmmKWXWXFrqPdR3vyil36U0diefQwvMiOBOjbFM/mo+FZMfo5qBlxcMNiFhpBXjBHbJOFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714103848; c=relaxed/simple;
	bh=r2VzYKoGmLXh7R1ra/NCYsduUkcs1HYHycbrwZFluCQ=;
	h=Date:To:From:Subject:Message-Id; b=JmHvr3NumugXG+/Zm8jWKn+Rs/KOcjQkN1Vyh69WTUNbGcATCqbWSH0ibxL/bWfawzQ8tIXXJmtXaflOLtZJWvBw8C3gz++yWvz0CBob2JXf3sSf1jDqQ9HHEdMdc2p+8NLoA89VLO8mhKpAzv50ZmVX/5CuE1I578GctNNYqnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UQdHEE2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UQdHEE2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D65C113CD;
	Fri, 26 Apr 2024 03:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714103848;
	bh=r2VzYKoGmLXh7R1ra/NCYsduUkcs1HYHycbrwZFluCQ=;
	h=Date:To:From:Subject:From;
	b=UQdHEE2mNm1VBkt/+ICEFVsRbJnVAMYhOI2OGP973lK2Vom4ApXhFU+SfVzcJkzbo
	 axXNbTTnFbELZyzDJhY9Ltp/sClpm+r9Y14NETRJ+MvPv3wfOnJ8X30ToWrRnvkxIO
	 HaIMXOUJ5nNrPEum6cUNdlma4XwMmgX1LNMszYQA=
Date: Thu, 25 Apr 2024 20:57:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,nao.horiguchi@gmail.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gup-cache-p4d-in-follow_p4d_mask.patch removed from -mm tree
Message-Id: <20240426035728.27D65C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/gup: cache p4d in follow_p4d_mask()
has been removed from the -mm tree.  Its filename was
     mm-gup-cache-p4d-in-follow_p4d_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/gup: cache p4d in follow_p4d_mask()
Date: Mon, 18 Mar 2024 16:03:52 -0400

Add a variable to cache p4d in follow_p4d_mask().  It's a good practise to
make sure all the following checks will have a consistent view of the
entry.

Link: https://lkml.kernel.org/r/20240318200404.448346-3-peterx@redhat.com
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
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/mm/gup.c~mm-gup-cache-p4d-in-follow_p4d_mask
+++ a/mm/gup.c
@@ -772,16 +772,17 @@ static struct page *follow_p4d_mask(stru
 				    unsigned int flags,
 				    struct follow_page_context *ctx)
 {
-	p4d_t *p4d;
+	p4d_t *p4dp, p4d;
 
-	p4d = p4d_offset(pgdp, address);
-	if (p4d_none(*p4d))
+	p4dp = p4d_offset(pgdp, address);
+	p4d = READ_ONCE(*p4dp);
+	if (p4d_none(p4d))
 		return no_page_table(vma, flags);
-	BUILD_BUG_ON(p4d_huge(*p4d));
-	if (unlikely(p4d_bad(*p4d)))
+	BUILD_BUG_ON(p4d_huge(p4d));
+	if (unlikely(p4d_bad(p4d)))
 		return no_page_table(vma, flags);
 
-	return follow_pud_mask(vma, address, p4d, flags, ctx);
+	return follow_pud_mask(vma, address, p4dp, flags, ctx);
 }
 
 /**
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-userfaultfd-reset-ptes-when-close-for-wr-protected-ones.patch
mm-hugetlb-assert-hugetlb_lock-in-__hugetlb_cgroup_commit_charge.patch
mm-page_table_check-support-userfault-wr-protect-entries.patch

