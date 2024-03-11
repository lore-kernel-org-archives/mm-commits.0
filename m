Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4741153E12
	for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2024 18:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710181687; cv=none; b=fqQDZnFpBQqrcazmp62EvraLYTgkLQ55vMCPl9M8tValUom7eUVuVBzo2u3hh1Rp07J0wm+04cO76VxoV/Lu8kN1R+ovg58uyxYsivJHWU5G63AtKHLa56PHQ5Xw61gW097kZ5esLD9EgSzvVPHTiUtb5PMIMapCeSm5brts1Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710181687; c=relaxed/simple;
	bh=lGQRQrxySWj8zR5lfkqDBZHkO3vH9z8zlUaIWlLgaHE=;
	h=Date:To:From:Subject:Message-Id; b=FSmEWEH8c8UtRnsDyJezn9tE2wJKjGrxpN0s2e49o7HdF7PA3oLnpPtUgl9xLSvuYF2orlEoq/aJXmq63EatulEBV8966fo8x9/GPliiUcP0hLjaFe6RWCLJLkqgPvTITtw7tqdiTZS4mLsYOZkWbbM+DO/oDbAR3epuSaafAqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cESB0chH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cESB0chH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C475CC433C7;
	Mon, 11 Mar 2024 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710181686;
	bh=lGQRQrxySWj8zR5lfkqDBZHkO3vH9z8zlUaIWlLgaHE=;
	h=Date:To:From:Subject:From;
	b=cESB0chHvMoeu2a96AlMfup8uxYHkoiEaWcYgB8ZzhebfkDyAhPlYpI96CEm/QvoM
	 pSgaf41z8ScTnSJnJ+WI7DbNksklQ29hOcvpZslCZ8YziA+iDXV4Mkt1TAdoRukwlK
	 MFb9CfFKWIkW1nYM3dJsyo+987/RVvM+sufDEcgA=
Date: Mon, 11 Mar 2024 11:28:06 -0700
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch added to mm-unstable branch
Message-Id: <20240311182806.C475CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove folio from deferred split list before uncharging it
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove folio from deferred split list before uncharging it
Date: Sun, 10 Mar 2024 13:48:48 +0000

When freeing a large folio, we must remove it from the deferred split list
before we uncharge it as each memcg has its own deferred split list (with
associated lock) and removing a folio from the deferred split list while
holding the wrong lock will corrupt that list and cause various related
problems.

Link: https://lore.kernel.org/linux-mm/367a14f7-340e-4b29-90ae-bc3fcefdd5f4@arm.com/
Link: https://lkml.kernel.org/r/20240310134850.3825782-1-willy@infradead.org
Fixes: f77171d241e3 (mm: allow non-hugetlb large folios to be batch processed)
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Debugged-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap.c~mm-remove-folio-from-deferred-split-list-before-uncharging-it
+++ a/mm/swap.c
@@ -1012,6 +1012,8 @@ void folios_put_refs(struct folio_batch
 			free_huge_folio(folio);
 			continue;
 		}
+		if (folio_test_large(folio) && folio_test_large_rmappable(folio))
+			folio_undo_large_rmappable(folio);
 
 		__page_cache_release(folio, &lruvec, &flags);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio-from-deferred-split-list-before-uncharging-it.patch
mm-fix-list-corruption-in-put_pages_list.patch

