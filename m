Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB013002D3
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 21:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760565060; cv=none; b=a7TUeFHe6jEz7kwe9mbzzzSQbucKuo0vi/hfvGX5iaBrYWr0E5NfpBw4GdTIR6DPLvAPsVH2bTWNVrH1yFz6rQ6wcAsxqlb0HmfV6jy73Wh0kzPhae0zddwEtV5Tf0BFAX/FkT1hHOdFGxDubaFyyvAcLxZrK/p4BrNvUp2JAd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760565060; c=relaxed/simple;
	bh=3lyoHxNxLdNI0I3wOM8O4bhCC7NjpS91NbkCTClqJc8=;
	h=Date:To:From:Subject:Message-Id; b=l9tDXkYGZG0K8UDXNFVWASvy7QGgcdBVLUtwiewt8TvjXvtuD9f9C0/cqaS0LvevS28bztwjStOt9o6tetb1kr0wKcRfhoC9gzttS+AnC7fQaooaGHvpXPoZeFJducI7MSvVV7QpP2Mc24ki8dAwMectMBDy5vH2rnm0Fqq4yI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K3Twzapc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K3Twzapc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D610BC4CEFB;
	Wed, 15 Oct 2025 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760565059;
	bh=3lyoHxNxLdNI0I3wOM8O4bhCC7NjpS91NbkCTClqJc8=;
	h=Date:To:From:Subject:From;
	b=K3TwzapcX7zaKLv+HzEpSgmJnMNuzmUlyEoBq0am3ZR4dZojaAMb4sHe0uZXadtmF
	 Sj9fWE2GrRtnMUGzKDEA/mzoL84pfqEowY6jlwZGKeQLZJpYYGjZiwueoA6yXOkPMI
	 ccEWrT1ZyaGoenrvh6HUThOcaSaEYD5gVuEeEMq4=
Date: Wed, 15 Oct 2025 14:50:59 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,guoren@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch added to mm-hotfixes-unstable branch
Message-Id: <20251015215059.D610BC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: csky/mm: fix build errors cause by folio flags changes
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: csky/mm: fix build errors cause by folio flags changes
Date: Wed, 15 Oct 2025 09:47:59 +0300

Kernel compilation on csky fails because csky was not updated during
conversion of folio flags to memdesc_flags_t:

arch/csky/abiv2/inc/abi/cacheflush.h: In function 'flush_dcache_folio':
arch/csky/abiv2/inc/abi/cacheflush.h:23:39: error: passing argument 2 of 'const_test_bit' from incompatible pointer type [-Werror=incompatible-pointer-types]
   23 |         if (test_bit(PG_dcache_clean, &folio->flags))
      |                                       ^~~~~~~~~~~~~
      |                                       |
      |                                       memdesc_flags_t *
include/linux/bitops.h:47:24: note: in definition of macro 'bitop'
   47 |          const##op(nr, addr) : op(nr, addr))
      |                        ^~~~
arch/csky/abiv2/inc/abi/cacheflush.h:23:13: note: in expansion of macro 'test_bit'
   23 |         if (test_bit(PG_dcache_clean, &folio->flags))
      |             ^~~~~~~~

Update references of folio->flags in arch/csky.

Link: https://lkml.kernel.org/r/20251015064759.2993842-1-rppt@kernel.org
Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Guo Ren <guoren@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv2/cacheflush.c         |    2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/csky/abiv2/cacheflush.c~csky-mm-fix-build-errors-cause-by-folio-flags-changes
+++ a/arch/csky/abiv2/cacheflush.c
@@ -21,7 +21,7 @@ void update_mmu_cache_range(struct vm_fa
 
 	folio = page_folio(pfn_to_page(pfn));
 
-	if (test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		return;
 
 	icache_inv_range(address, address + nr*PAGE_SIZE);
--- a/arch/csky/abiv2/inc/abi/cacheflush.h~csky-mm-fix-build-errors-cause-by-folio-flags-changes
+++ a/arch/csky/abiv2/inc/abi/cacheflush.h
@@ -20,8 +20,8 @@
 
 static inline void flush_dcache_folio(struct folio *folio)
 {
-	if (test_bit(PG_dcache_clean, &folio->flags))
-		clear_bit(PG_dcache_clean, &folio->flags);
+	if (test_bit(PG_dcache_clean, &folio->flags.f))
+		clear_bit(PG_dcache_clean, &folio->flags.f);
 }
 #define flush_dcache_folio flush_dcache_folio
 
_

Patches currently in -mm which might be from rppt@kernel.org are

csky-mm-fix-build-errors-cause-by-folio-flags-changes.patch
kho-drop-notifiers.patch

