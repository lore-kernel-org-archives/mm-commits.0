Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5743112DDAF
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824879; cv=none; b=GLWRwgsri+ZSlSCDllSZ5LquC6dSu1CGRAtLctlMUftCCCDPicmuMUrdDDAESGbIQVYL2I4DLXmerQYLxBiDzF05CMjzSGjREVH5llJy9cXPVntxHK3PH9pJ/BqVf5yRb14//mj3VvFhI2BUvd+H3kEsme0fftIG4sPTr5H5odI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824879; c=relaxed/simple;
	bh=loDWP6XjRd1+N6udvPpyYy0jNQWCSzFS2PTNXoND4Vw=;
	h=Date:To:From:Subject:Message-Id; b=inalIeed8FO5y5XsMTpRQSZy8zg+Qy7oL/0GsIRV8BQfvVHb2AEHIvLrSmAmV1FBFAwFQmoYCVPdcfVSdUzOk8nPVmUUIuDQ2Q9H7cegucyVQiA601/Y9q5ET+r8QZ8IIDn4sHduzggMTxzxrnEDq9t3MxpL7/JdPrEIdGdzm/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sef+yDO9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sef+yDO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E201C32782;
	Fri, 12 Jul 2024 22:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824879;
	bh=loDWP6XjRd1+N6udvPpyYy0jNQWCSzFS2PTNXoND4Vw=;
	h=Date:To:From:Subject:From;
	b=sef+yDO9RdxFKiC7rTWcMedXOtkMl6bjrhhUm2nFf/gMo6cqFOkTQD/wWjVBZhivG
	 ZQZZAaaa9FKabAMiuMvvbCky488AIF1babTvmwwvxG0eC6TzDRCKgo8XshMRPC+jwf
	 5u9B62bdAyIDtYSuQzBTkSgUGqoLXXdJkKHYs5f0=
Date: Fri, 12 Jul 2024 15:54:38 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,osalvador@suse.de,npiggin@gmail.com,mpe@ellerman.id.au,jgg@nvidia.com,christophe.leroy@csgroup.eu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch removed from -mm tree
Message-Id: <20240712225439.2E201C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: powerpc/e500: don't pre-check write access on data TLB error
has been removed from the -mm tree.  Its filename was
     powerpc-e500-dont-pre-check-write-access-on-data-tlb-error.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc/e500: don't pre-check write access on data TLB error
Date: Tue, 2 Jul 2024 15:51:30 +0200

Don't pre-check write access on read-only pages on data TLB error.

Load the TLB anyway and take a DSI exception when it happens.  This avoids
reading SPRN_ESR at every data TLB error exception.

Link: https://lkml.kernel.org/r/8525518e1657d6032b7e980c1888102828d66950.1719928057.git.christophe.leroy@csgroup.eu
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/head_85xx.S |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/arch/powerpc/kernel/head_85xx.S~powerpc-e500-dont-pre-check-write-access-on-data-tlb-error
+++ a/arch/powerpc/kernel/head_85xx.S
@@ -472,27 +472,12 @@ END_BTB_FLUSH_SECTION
 #endif
 
 4:
-	/* Mask of required permission bits. Note that while we
-	 * do copy ESR:ST to _PAGE_WRITE position as trying to write
-	 * to an RO page is pretty common, we don't do it with
-	 * _PAGE_DIRTY. We could do it, but it's a fairly rare
-	 * event so I'd rather take the overhead when it happens
-	 * rather than adding an instruction here. We should measure
-	 * whether the whole thing is worth it in the first place
-	 * as we could avoid loading SPRN_ESR completely in the first
-	 * place...
-	 *
-	 * TODO: Is it worth doing that mfspr & rlwimi in the first
-	 *       place or can we save a couple of instructions here ?
-	 */
-	mfspr	r12,SPRN_ESR
 #ifdef CONFIG_PTE_64BIT
 	li	r13,_PAGE_PRESENT|_PAGE_BAP_SR
 	oris	r13,r13,_PAGE_ACCESSED@h
 #else
 	li	r13,_PAGE_PRESENT|_PAGE_READ|_PAGE_ACCESSED
 #endif
-	rlwimi	r13,r12,11,29,29
 
 	FIND_PTE
 	andc.	r13,r13,r11		/* Check permission */
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are


