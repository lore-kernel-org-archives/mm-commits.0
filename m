Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B241E491
	for <mm-commits@vger.kernel.org>; Tue, 14 May 2024 21:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715721331; cv=none; b=ZS8POKmbuJ73O2XdJ8LcruS6Ry9N9IgapuK/MewQhsNwrr3EvfQPULdgfMGIfN+se+/1OXrtwzll6GR2KfK/aEVspJpVuRFzja6mHQJ4xNI2JUL7nd6DnjvdoCYBxfK+NtSm3wiaadp2malrDyYVbtYReObO44to/grjNFaJ4jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715721331; c=relaxed/simple;
	bh=gyM2JMGN6d20UkTocpE0ii1sK2SEoHHfhTRvgpM5iFg=;
	h=Date:To:From:Subject:Message-Id; b=GoKb6HJlKq/NJDoNP8+ueF9Sy/Z7Apypr2XoCn/X/uKQp8DYsNfyg3Z+B5NzEjfokZCLjA1KButBigYuAi4TXWLDCgaEcXpQWKLxBCk1DVn1fc+gCYKT4zgv6gisZWD+DHUIAlf/xcx3VVKc19cwGtw/vpd30QJfhStCUSPQnpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HCfH4xCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HCfH4xCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E962DC2BD10;
	Tue, 14 May 2024 21:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715721331;
	bh=gyM2JMGN6d20UkTocpE0ii1sK2SEoHHfhTRvgpM5iFg=;
	h=Date:To:From:Subject:From;
	b=HCfH4xCoe9Yv2oP+lJwTuz2kQQPwMvAI7P99kwRwoVnkp0Bcc1k9Q9S5MACIwkBPO
	 2vHKgzuiYs8U2k1/mAXvFCgxx+B/Ns551JsBySWpVMeldITsbhOx4xVwvbkNSpId9E
	 ZpKmFEsWw9VoYR/muifzuzcBQ1r/e4vSsHoD7REY=
Date: Tue, 14 May 2024 14:15:30 -0700
To: mm-commits@vger.kernel.org,xuyu@linux.alibaba.com,willy@infradead.org,shy828301@gmail.com,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch added to mm-unstable branch
Message-Id: <20240514211530.E962DC2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-huge_memory-mark-huge_zero_page-reserved-fix-fix
Date: Tue May 14 02:13:29 PM PDT 2024

s/clear/set/doh

Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Xu Yu <xuyu@linux.alibaba.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-mark-huge_zero_page-reserved-fix-fix
+++ a/mm/huge_memory.c
@@ -212,7 +212,7 @@ retry:
 		folio_put(zero_folio);
 		goto retry;
 	}
-	__folio_clear_reserved(zero_folio);
+	__folio_set_reserved(zero_folio);
 	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
 
 	/* We take additional reference here. It will be put back by shrinker */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-huge_memory-mark-huge_zero_page-reserved-fix.patch
mm-huge_memory-mark-huge_zero_page-reserved-fix-fix.patch
lib-add-version-into-proc-allocinfo-output-fix.patch
__mod_memcg_lruvec_state-enhance-diagnostics.patch
__mod_memcg_lruvec_state-enhance-diagnostics-fix.patch

