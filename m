Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885192E4274
	for <mm-commits@vger.kernel.org>; Thu, 16 Oct 2025 21:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760649439; cv=none; b=ltCEZkvUcV0kJkeAznsL+VzXgOLhbgxigXQ+yX7ZGFDG/o/W5xhEbv9bEuwPW/bPznjQ9xoe2WDxVuqa/EJOZox1xddPbSaNTNT2wxiSwFJEuwnYv+AyB5wvZyVJOEROHQ8kxqHbdrt90hwfVmhnMMOsnAR2meOZorUqMEvpXmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760649439; c=relaxed/simple;
	bh=O/8ZZo6dDzYj1/230/6PN+x1rmvmgtvLgt4tNE9q2Jk=;
	h=Date:To:From:Subject:Message-Id; b=CL+yeiZGeH7gJSUZNRFWT69VzzmUpaFOAvMxwrkNfrUcBBZOdZXBKIqvf/d7587PJ8EDTPNz038Oj1FJUCsy/H+Pgicu5tbzgpEWAy4uN6xYhaIzZpzCtLfgruryMiboeXjHHIPbHLN4hDbY5PeKrcAM+rFIfHY5aaoMcgwQT1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jusPjVCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jusPjVCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F25DC4CEF1;
	Thu, 16 Oct 2025 21:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760649439;
	bh=O/8ZZo6dDzYj1/230/6PN+x1rmvmgtvLgt4tNE9q2Jk=;
	h=Date:To:From:Subject:From;
	b=jusPjVCnW5vzb912lZmzLpCOnhqRSRGWKLJdAc7o31cxZtV1O/Q7orP+20Fw3swl4
	 fZ3BkwTW5AC59D7tsYg3FXjwBGmQFBZsX5kwwl6Wl0BwsUil0URNYHJHsjg5YaOQ9r
	 c6MklzPVq6FsHvvmJP/vvgTtYirCk5SNpc9XkSBY=
Date: Thu, 16 Oct 2025 14:17:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,rppt@kernel.org,guoren@kernel.org,thomas.weissschuh@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + csky-abiv2-adapt-to-new-folio-flags-field.patch added to mm-hotfixes-unstable branch
Message-Id: <20251016211719.0F25DC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Date: Mon, 6 Oct 2025 14:13:37 +0200
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     csky-abiv2-adapt-to-new-folio-flags-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/csky-abiv2-adapt-to-new-folio-flags-field.patch

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

Date: Mon, 6 Oct 2025 14:13:37 +0200
Subject: csky: abiv2: adapt to new folio flags field

Recent changes require the raw folio flags to be accessed via ".f".  The
merge commit introducing this change adapted most architecture code but
forgot the csky abiv2.

[rppt@kernel.org: add fix for arch/csky/abiv2/cacheflush.c]
Link: https://lkml.kernel.org/r/aPCE238oxAB9QcZa@kernel.org
Fixes: 53fbef56e07d ("mm: introduce memdesc_flags_t")
Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Guo Ren <guoren@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Guo Ren <guoren@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/csky/abiv2/cacheflush.c         |    2 +-
 arch/csky/abiv2/inc/abi/cacheflush.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/csky/abiv2/cacheflush.c~csky-abiv2-adapt-to-new-folio-flags-field
+++ a/arch/csky/abiv2/cacheflush.c
@@ -21,7 +21,7 @@ void update_mmu_cache_range(struct vm_fa
 
 	folio = page_folio(pfn_to_page(pfn));
 
-	if (test_and_set_bit(PG_dcache_clean, &folio->flags))
+	if (test_and_set_bit(PG_dcache_clean, &folio->flags.f))
 		return;
 
 	icache_inv_range(address, address + nr*PAGE_SIZE);
--- a/arch/csky/abiv2/inc/abi/cacheflush.h~csky-abiv2-adapt-to-new-folio-flags-field
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

Patches currently in -mm which might be from thomas.weissschuh@linutronix.de are

mempool-clarify-behavior-of-mempool_alloc_preallocated.patch
compiler-remove-arch_sel.patch

