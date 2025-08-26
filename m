Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72E430CDB4
	for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2025 22:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756249131; cv=none; b=jRXuzhg6Ibsfo712uB559GwmGZOEwZ/Mm2y6XmyfHrSlV7UWrQPhlabV/vwnaZdidw4x6BMfPeNCleyv2sXDwLEx/2Ei3ixmdhveiAwulpdPqFyP1ch1tkJcnFeHMWixHyrT5DGpAQIu8fY/do/x5WOOBUrpKXsKeHIOOhLFyA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756249131; c=relaxed/simple;
	bh=8pLA58R+hYefMHeGGo/9nt6fTK00oR/T6F406LT3tzE=;
	h=Date:To:From:Subject:Message-Id; b=SOMPRISrMkEou5n4FcE/nKg33f3s28PdnKZENAjxFoI5RiEOWLuV2jiw9WjBqVjl6wNLCDyDlHMrpo0TNPMYDDB1rBypsWV10aVP50OdQJ9XvEM4qWMMzuYK6b0R3Cwnfab7WjHl7BvhsLtQzJz6hq//KfD51w67DaHqCu0h7CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1xu38B3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1xu38B3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DD0C4CEF1;
	Tue, 26 Aug 2025 22:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756249131;
	bh=8pLA58R+hYefMHeGGo/9nt6fTK00oR/T6F406LT3tzE=;
	h=Date:To:From:Subject:From;
	b=1xu38B3+0DVzGiSn/zP3gKUCqjfodjGZFshj4Yj3iUQcEb+zllnL2ceQ8RKZqJWwR
	 BLjW1qngvqk4vDIg9quqrfpz3YcB+5ODkeu0eoSe0NWyPic5KLPsuAYhEqGfCAdWc0
	 eM40AnYpFu1CaOWssJuou7jqUW61sobVSyntuitE=
Date: Tue, 26 Aug 2025 15:58:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,tsbogend@alpha.franken.de,naresh.kamboju@linaro.org,anders.roxell@linaro.org,nicola.vetrini@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-memdesc_flags_t-fix-2.patch added to mm-unstable branch
Message-Id: <20250826225851.44DD0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mips: fix compilation error
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-memdesc_flags_t-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-memdesc_flags_t-fix-2.patch

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

mm-introduce-memdesc_flags_t-fix-2.patch

