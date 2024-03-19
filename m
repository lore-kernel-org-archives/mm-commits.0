Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C4B3D55B
	for <mm-commits@vger.kernel.org>; Tue, 19 Mar 2024 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710882971; cv=none; b=sV/II4aiz/M/C0skKbalW7BzEkoduydGJDGRbrslxi+iIcCUAZTE7PJR0eaKgaqmI4JIwouRw83onN8HmcxSajyMx4KhSGB+xmrXsrbAl9eDsYPGk6SNuuMEHLsd/ejUIE+QdnKN8qA4YVCXsKWs2O/wAkdFxBxlGJ+z6vOICQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710882971; c=relaxed/simple;
	bh=2LZacbNgUAf4efvBJIjmP9JZElhyJrCHSdpdr0vYsVA=;
	h=Date:To:From:Subject:Message-Id; b=KeCBUZKAYSKkVx4ki9ltR04a3Y62uv4IxudglpwmaPHyd8VmQZ9N3ur+XP98cICzm3pBYX5dqr8iPTV+qjutYVFYq78I5owekMNEGB6uaveGIDaDflX8tNt740WbhhPy+DD1zKWyl4Y6Sn4Xzvs7j3yH3J5wv3hbf1zL1V9T1Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cTOdALfe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cTOdALfe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD04C433C7;
	Tue, 19 Mar 2024 21:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710882970;
	bh=2LZacbNgUAf4efvBJIjmP9JZElhyJrCHSdpdr0vYsVA=;
	h=Date:To:From:Subject:From;
	b=cTOdALfeLMTIX7QMreX3ed8B6vDb1SlH+DAGavp7xuCMY2ZWx/YzZH/KPyUPtuC45
	 siwVT74S6dPS0fj8Kk7aN5pWc5YQbx+K2ZTD47so2FQjIK4bNt68aYsBditmIymp4n
	 T6G0jU447pE5VDQ7/MCqMoVXF2B6mYvdC1ZZCCO4=
Date: Tue, 19 Mar 2024 14:16:10 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,tglx@linutronix.de,shawnguo@kernel.org,rppt@kernel.org,npiggin@gmail.com,naveen.n.rao@linux.ibm.com,naoya.horiguchi@nec.com,muchun.song@linux.dev,msalter@redhat.com,mpe@ellerman.id.au,mingo@redhat.com,l.stach@pengutronix.de,linux@armlinux.org.uk,krzysztof.kozlowski@linaro.org,konrad.dybcio@linaro.org,jgg@nvidia.com,festevam@denx.de,davem@davemloft.net,dave.hansen@linux.intel.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,bp@alien8.de,arnd@arndb.de,apopple@nvidia.com,aneesh.kumar@kernel.org,andreas@gaisler.com,andersson@kernel.org,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-cache-p4d-in-follow_p4d_mask.patch added to mm-unstable branch
Message-Id: <20240319211610.9AD04C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/gup: cache p4d in follow_p4d_mask()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-cache-p4d-in-follow_p4d_mask.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-cache-p4d-in-follow_p4d_mask.patch

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
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

