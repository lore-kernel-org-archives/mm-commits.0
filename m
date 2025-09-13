Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0F52BE034
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757802119; cv=none; b=nm7y4O9/NedL+V5kFrvVhbcJwfRIxMGK/0+im8NHHingxeztltGP0+APAEDge++H9kZ1jITpVtkWkbmhG3MRLxT+nQX9zf0mtEPc3aLFvJuZMDGsQFQRnhqfGY2ETv9V0kwvi+/jhIponj9zzKigLZFY83BcU5HoQPsIGD3nlaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757802119; c=relaxed/simple;
	bh=2DESH7Oj2p68T0q5+hFm6NA67CRq4kwR7UBPpewn++w=;
	h=Date:To:From:Subject:Message-Id; b=iEZLF7kWy8TDxMvlL98OptHA1o+cAgVUbsfIzKRai2yVOo08hzT+Lfy1B76otoFNWc4UNWENfeED3lI1+ioG23T1g7k5IOSitFazZF/v4ZrFr8t89Ckg+/MwyTtOQu/6E/R0yau2MeWdPj9yzdAHRhIaXgBq2rpP+tuT6weCbzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wBVcT1nB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wBVcT1nB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD4AC4CEF7;
	Sat, 13 Sep 2025 22:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757802119;
	bh=2DESH7Oj2p68T0q5+hFm6NA67CRq4kwR7UBPpewn++w=;
	h=Date:To:From:Subject:From;
	b=wBVcT1nBYI7c/8RRhuLb+OO9QIjDLoCpLleQ/qXUkP2hf4+OWycT0w9Bn2n+FHox/
	 vYPGc+Q4aJF6E46GSAnNNDAMG5+UEh96oQe9Pif4A6UTAzwevZCm7nxPd6p9XBTmIu
	 kxdODJvHJQsKNzUJ95jY+YlnVbLxb7orI7sPQ+1I=
Date: Sat, 13 Sep 2025 15:21:58 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tsbogend@alpha.franken.de,naresh.kamboju@linaro.org,anders.roxell@linaro.org,nicola.vetrini@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-introduce-memdesc_flags_t-fix-2.patch removed from -mm tree
Message-Id: <20250913222158.ECD4AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mips: fix compilation error
has been removed from the -mm tree.  Its filename was
     mm-introduce-memdesc_flags_t-fix-2.patch

This patch was dropped because it was folded into mm-introduce-memdesc_flags_t.patch

------------------------------------------------------
From: Nicola Vetrini <nicola.vetrini@gmail.com>
Subject: mips: fix compilation error
Date: Mon, 25 Aug 2025 23:42:45 +0200

The following build error occurs on a mips build configuration
(32r2el_defconfig and similar ones)
./arch/mips/include/asm/cacheflush.h:42:34: error: passing argument 2 of `set_bit'
from incompatible pointer type [-Werror=incompatible-pointer-types]
   42 |         set_bit(PG_dcache_dirty, &(folio)->flags)
      |                                  ^~~~~~~~~~~~~~~
      |                                  |
      |                                  memdesc_flags_t *

This is due to changes introduced by
commit 30f45bf18d55 ("mm: introduce memdesc_flags_t"), which did not update
these usage sites.

Link: https://lore.kernel.org/lkml/CA+G9fYvkpmqGr6wjBNHY=dRp71PLCoi2341JxOudi60yqaeUdg@mail.gmail.com/
Link: https://lkml.kernel.org/r/20250825214245.1838158-1-nicola.vetrini@gmail.com
Signed-off-by: Nicola Vetrini <nicola.vetrini@gmail.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/cacheflush.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/include/asm/cacheflush.h~mm-introduce-memdesc_flags_t-fix-2
+++ a/arch/mips/include/asm/cacheflush.h
@@ -37,11 +37,11 @@
 #define PG_dcache_dirty			PG_arch_1
 
 #define folio_test_dcache_dirty(folio)		\
-	test_bit(PG_dcache_dirty, &(folio)->flags)
+	test_bit(PG_dcache_dirty, &(folio)->flags.f)
 #define folio_set_dcache_dirty(folio)	\
-	set_bit(PG_dcache_dirty, &(folio)->flags)
+	set_bit(PG_dcache_dirty, &(folio)->flags.f)
 #define folio_clear_dcache_dirty(folio)	\
-	clear_bit(PG_dcache_dirty, &(folio)->flags)
+	clear_bit(PG_dcache_dirty, &(folio)->flags.f)
 
 extern void (*flush_cache_all)(void);
 extern void (*__flush_cache_all)(void);
_

Patches currently in -mm which might be from nicola.vetrini@gmail.com are

mm-introduce-memdesc_flags_t.patch

