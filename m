Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B859163
	for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2024 18:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710356316; cv=none; b=C47xqDV+T/7YIHIrSDgrRVYFIH0bCsnbmESUfU4u7YKBIdRnBp7/LGcrjNEIwD+dpIm39lBkT3SArT9qUaeEfmXoMCitslFkUvod3bwXLw0MaXryvks8wtinn7xt+3xaRxe3K/ZUflJ0sbA7efCbSRoqVzl9KG3JLhuD0G9fK7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710356316; c=relaxed/simple;
	bh=wbNJIGppaiHT4St3V/9fnAxs73fW143vvC4AP2UQGgQ=;
	h=Date:To:From:Subject:Message-Id; b=JVNHymm+xKu3LqITL8Zpdy+wWjjlBiYbzkAtUG12rsiiQGCaJKVuZaT5ITyLS7Xg6NJe9smCpi0LyBH4yYK2L7yQgk01P1Rd0dlqcxcK31vk/ZnAkVJ+Q7RimoRLfOpFME1CtkUcH+1BG0yzIXnzQhcEoThx2ZBo5rRa+oLc2e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0iuTDeR1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0iuTDeR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F857C433F1;
	Wed, 13 Mar 2024 18:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710356316;
	bh=wbNJIGppaiHT4St3V/9fnAxs73fW143vvC4AP2UQGgQ=;
	h=Date:To:From:Subject:From;
	b=0iuTDeR139+QWRkU1O12oPg/UjeTGzDQ/KVOVeMxMZhBUPkO/D5ZFLx1A3AhOsRua
	 XEyHjRVg8p7w2ZNK7xzjZoVzLqXKu49cLqKO3KocXAIBRGFE7B5VaHUymDvIeROWre
	 w/6xIugBg7Zj1XA7K4rK+yCUa4+ul1ZJdu/8V3vg=
Date: Wed, 13 Mar 2024 11:58:35 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,lkp@intel.com,jgg@nvidia.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-arm64-include-asm-pgtableh-904-16-error-implicit-declaration-of-function-pud_leaf-did-you-mean-pmd_leaf.patch added to mm-unstable branch
Message-Id: <20240313185836.1F857C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: recover pud_leaf() definitions in nopmd case
has been added to the -mm mm-unstable branch.  Its filename is
     arch-arm64-include-asm-pgtableh-904-16-error-implicit-declaration-of-function-pud_leaf-did-you-mean-pmd_leaf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-arm64-include-asm-pgtableh-904-16-error-implicit-declaration-of-function-pud_leaf-did-you-mean-pmd_leaf.patch

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
Subject: mm: recover pud_leaf() definitions in nopmd case
Date: Mon, 11 Mar 2024 12:10:45 -0400

This reverts one change in commit 924bd6a8c967 ("mm/x86: drop two
unnecessary pud_leaf() definitions").

One issue with that is it broke nopmd builds for at least both arm64 and
riscv (CONFIG_PGTABLE_LEVELS=2).  The other issue is it was overlooked that
it's a common change rather than x86 specific (relevant to the commit
message of the commit).

Normally there's no need for empty definition of pXd_leaf() because of the
fallback functions, however this logic may not apply to pgtable-nopmd.h,
because that's a header that can even be used by arch *pgtable.h headers,
which can use the *_leaf() definitions _before_ the fallback functions are
defined.  Leave it there to pass PGTABLE_LEVELS=2 builds.

Link: https://lkml.kernel.org/r/Ze8vFNV9YSdgC2S7@x1n
Fixes: 924bd6a8c967 ("mm/x86: drop two unnecessary pud_leaf() definitions")
Signed-off-by: Peter Xu <peterx@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403090900.OwPqmRuI-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202403101607.a42gaLOS-lkp@intel.com/
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable-nopmd.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/asm-generic/pgtable-nopmd.h~arch-arm64-include-asm-pgtableh-904-16-error-implicit-declaration-of-function-pud_leaf-did-you-mean-pmd_leaf
+++ a/include/asm-generic/pgtable-nopmd.h
@@ -31,6 +31,7 @@ static inline int pud_none(pud_t pud)		{
 static inline int pud_bad(pud_t pud)		{ return 0; }
 static inline int pud_present(pud_t pud)	{ return 1; }
 static inline int pud_user(pud_t pud)		{ return 0; }
+static inline int pud_leaf(pud_t pud)		{ return 0; }
 static inline void pud_clear(pud_t *pud)	{ }
 #define pmd_ERROR(pmd)				(pud_ERROR((pmd).pud))
 
_

Patches currently in -mm which might be from peterx@redhat.com are

arch-arm64-include-asm-pgtableh-904-16-error-implicit-declaration-of-function-pud_leaf-did-you-mean-pmd_leaf.patch

