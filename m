Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCE4127E0F
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824875; cv=none; b=AMAaL6whJZh0JTTVBRnLOGs42z75VrUhcmMtcvYUjWLxwS4nowbVox5kX5q+dmcZwiJYA+WRnt8VPacNEzmw+K9epEtw/9mPH+1Wq+kyLFENPEDOO0zlXfwNGH4XYto2VFBnagn8PNB5nE8gDoVKOjM1x6WcWKdN933u6cgU0hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824875; c=relaxed/simple;
	bh=TTbKEhni9VKmqYlwMrODvyLgsVvFutPbnQPRnNvpPo0=;
	h=Date:To:From:Subject:Message-Id; b=cgBSi/trvu6DKG+ulf/TAEzP5Or1yOz9HyCiES/az/M1dKJJ+w4Yy8994qZziquGCuSonEqHqDHUs1p9/77dUVhBdeh+WURiS9ZOusyqFmCBf5fAUufZlFrA5WcSdeeuAoQqQ299/njrjbYJVACJqZuG8I3+oc5OEn8rN2GIZms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=16t4xd7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="16t4xd7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85ACC4AF07;
	Fri, 12 Jul 2024 22:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824874;
	bh=TTbKEhni9VKmqYlwMrODvyLgsVvFutPbnQPRnNvpPo0=;
	h=Date:To:From:Subject:From;
	b=16t4xd7WhmzKN1ec6uv6lNwPLyqD/HFGpZGDE9maZKRWvNWVG+zt3AZAbYds5Lccb
	 LAbdws6ubNFH9VGcMVL/cpAX1nf5MOCgckWiPNPFhLsD736WdjBQTNukWXvycpIJt5
	 NM/p9yeKSvQnY6nM4b6jYchDv2Vl3p2CT6BxOmpU=
Date: Fri, 12 Jul 2024 15:54:34 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-8xx-simplify-struct-mmu_psize_def.patch removed from -mm tree
Message-Id: <20240712225434.D85ACC4AF07@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/8xx: simplify struct mmu_psize_def
has been removed from the -mm tree.  Its filename was
     powerpc-8xx-simplify-struct-mmu_psize_def.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/8xx: simplify struct mmu_psize_def
Date: Tue, 2 Jul 2024 15:51:26 +0200

On 8xx, only the shift field is used in struct mmu_psize_def

Remove other fields and related macros.

Link: https://lkml.kernel.org/r/dd0587a9e8354005858c7f8c9a775ad05523b314.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/nohash/32/mmu-8xx.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h~powerpc-8xx-simplify-struct-mmu_psize_def
+++ a/arch/powerpc/include/asm/nohash/32/mmu-8xx.h
@@ -189,19 +189,14 @@ typedef struct {
 
 #define PHYS_IMMR_BASE (mfspr(SPRN_IMMR) & 0xfff80000)
 
-/* Page size definitions, common between 32 and 64-bit
+/*
+ * Page size definitions for 8xx
  *
  *    shift : is the "PAGE_SHIFT" value for that page size
- *    penc  : is the pte encoding mask
  *
  */
 struct mmu_psize_def {
 	unsigned int	shift;	/* number of bits */
-	unsigned int	enc;	/* PTE encoding */
-	unsigned int    ind;    /* Corresponding indirect page size shift */
-	unsigned int	flags;
-#define MMU_PAGE_SIZE_DIRECT	0x1	/* Supported as a direct size */
-#define MMU_PAGE_SIZE_INDIRECT	0x2	/* Supported as an indirect size */
 };
 
 extern struct mmu_psize_def mmu_psize_defs[MMU_PAGE_COUNT];
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


