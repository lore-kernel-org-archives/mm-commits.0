Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA27DA73
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 05:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740548792; cv=none; b=Eti2L+ZNE2KU21tFhI9fl9o7ScQzwyPrgoqsWyE2nEZpiy/r2JtShdqfWER3U38Sm3OmnhGSgYJYpmbrRm7qsdJuzh5LkjWiZq6s9HgpBEs1h/tTHV/IqIsWCeY6XAypgVSE9HGjEPAt2NuHqwkqMSxroQZcx5q54sNepznBvRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740548792; c=relaxed/simple;
	bh=yGhjeS+h7M+2qhanUxpduf7vpL6uqoSVz5qYdFtC0Qw=;
	h=Date:To:From:Subject:Message-Id; b=lyRPdMcBgDvFw+8OWJ/p10JiErdjE5FWAc8d9mnu5uABjEKctJ2vm8VdfrZeSg//HdZC8leMr3QobET4tySfVErEnXl3Y/xJJhLJP6ZnsCeypd/RivG9FXIemVZZ+z7w1Mfd2Y1X2PdvOV/+YKRhvLWvmBYna5RxDHoR1Eok0lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VV/gMBr6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VV/gMBr6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA654C4CED6;
	Wed, 26 Feb 2025 05:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740548792;
	bh=yGhjeS+h7M+2qhanUxpduf7vpL6uqoSVz5qYdFtC0Qw=;
	h=Date:To:From:Subject:From;
	b=VV/gMBr6FMgU6tC3HWULRiLbu1SXX+IvxHg3ZeqEeejXKnvg/Z42X6s4R0xjk+B1C
	 xaPTB02n4BT5YGaL9RWYx3AL7/t2Waz1doYjcZvX3HveN7F3hg1+bxlli19CHfLJHe
	 dz8MBxytkXUTpq0Z9ak2aTih4RC/3MVb1Gh3KXg4=
Date: Tue, 25 Feb 2025 21:46:31 -0800
To: mm-commits@vger.kernel.org,kasong@tencent.com,bhe@redhat.com,sfr@canb.auug.org.au,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-simplify-folio-swap-allocation-fix.patch added to mm-unstable branch
Message-Id: <20250226054631.EA654C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix up for "mm, swap: simplify folio swap allocation"
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-simplify-folio-swap-allocation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-simplify-folio-swap-allocation-fix.patch

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
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: fix up for "mm, swap: simplify folio swap allocation"
Date: Wed, 26 Feb 2025 15:54:33 +1100

folio_alloc_swap() should be inlined

Link: https://lkml.kernel.org/r/20250226161217.1e7c5ae1@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/swap.h~mm-swap-simplify-folio-swap-allocation-fix
+++ a/include/linux/swap.h
@@ -587,7 +587,7 @@ static inline int swp_swapcount(swp_entr
 	return 0;
 }
 
-static int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
+static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask)
 {
 	return -EINVAL;
 }
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-swap-simplify-folio-swap-allocation-fix.patch

