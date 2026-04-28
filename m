Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B88A1A9F8C
	for <mm-commits@vger.kernel.org>; Tue, 28 Apr 2026 20:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777409885; cv=none; b=l4JwMjKtJLCqaMgdRsGgrPWFRpNqE86tyu79yqrtNLHeWjoXLM6WZq8C3nkkULJyk31SGx2CflkXwBaQC52atmKJy7mno5u7zREHiADpjvDUdLTVJHeyIi9aT9bnxZ7aL42TiD/WR5q48Zbh8q21i8MEt6UGJVQcde+vbVx32Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777409885; c=relaxed/simple;
	bh=VL3Gd0yrwpJkHYFG68i6txUEEM+wjSDcsZg9jognMXk=;
	h=Date:To:From:Subject:Message-Id; b=E1SzwbRFg1st+AQ+14q+mcMkeDKNU3P1k1D7pkJ7FAL0sukvHJEw4sKesP0LixUvt/xRWN/KSfyCGxQHy+r5yCQftH9mPsNyj96CDsmS/wcPiX5bPFwICEo+GJWLaiOLPaF/miSzyvlAyLplFTE97ruDG5iscbU7uyM+npwbpQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXE1iSlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXE1iSlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14EEFC2BCAF;
	Tue, 28 Apr 2026 20:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777409885;
	bh=VL3Gd0yrwpJkHYFG68i6txUEEM+wjSDcsZg9jognMXk=;
	h=Date:To:From:Subject:From;
	b=KXE1iSlNQnkK1OXwlx+xrUzn2skAsubh2pZlz/k5pcvTiK3ljZjmzy9oA86lrdajn
	 4Stly+Jx2fbTJF6+iaJlAhNdd2AsP9xyCduC1APBOk/2M79feDGZj/ko9YNBwtTdo/
	 YPbR+GgqKvZHF68h5c1hmYB4klkOihHfqdZ4Sh6c=
Date: Tue, 28 Apr 2026 13:58:04 -0700
To: mm-commits@vger.kernel.org,npiggin@gmail.com,msalter@redhat.com,mpe@ellerman.id.au,maddy@linux.ibm.com,lkp@intel.com,david.laight.linux@gmail.com,david@kernel.org,dave@stgolabs.net,chmh0624@gmail.com,chleroy@kernel.org,arnd@arndb.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch removed from -mm tree
Message-Id: <20260428205805.14EEFC2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
has been removed from the -mm tree.  Its filename was
     include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix.patch

This patch was dropped because it was folded into include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
Date: Mon Apr 27 07:52:27 AM PDT 2026

fix powerpc

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202604271114.ebmzs1LE-lkp@intel.com/
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Mark Salter <msalter@redhat.com>
Cc: Min-Hsun Chang <chmh0624@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/fixmap.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/powerpc/include/asm/fixmap.h~include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix
+++ a/arch/powerpc/include/asm/fixmap.h
@@ -88,6 +88,9 @@ enum fixed_addresses {
 #define FIXMAP_PAGE_NOCACHE PAGE_KERNEL_NCG
 #define FIXMAP_PAGE_IO	PAGE_KERNEL_NCG
 
+static inline void __set_fixmap(enum fixed_addresses idx,
+				phys_addr_t phys, pgprot_t flags);
+
 #include <asm-generic/fixmap.h>
 
 static inline void __set_fixmap(enum fixed_addresses idx,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
proc-rewrite-next_tgid-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch

