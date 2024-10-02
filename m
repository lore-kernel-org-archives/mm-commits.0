Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94E1D1E60
	for <mm-commits@vger.kernel.org>; Wed,  2 Oct 2024 21:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727903186; cv=none; b=csOPbcZ6lUvc5x3kOaQUnQab6qwf54xg+t6XpHkLcwWPoUnZXVS3jOurOUm9zIietgmQL/KjhBWpuwIgdIKkZhN4g8kaXR5HZVcCPrW4q6T/JM6l9mV0hkXhGiscGfQrLhsKggrNUXLIQ8NfKD0i4Qtu3Ip6kWk3Z3SYjtbHoBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727903186; c=relaxed/simple;
	bh=Gtr8voSTo9c39nTU8mFd+55BmV6thhZHryzrFhx6/kk=;
	h=Date:To:From:Subject:Message-Id; b=ZcSfZKbT5nQBsU+CLB/iYf4cdjUdoNoEEX94QaCPTacRE5iqNXrHlMib3k341Ui9nBu3YzEh/YR6xZ9vLYT2fq3bUUkoKF9TGl7fOsifn3ej4QZ5w5mE01rmyxqhrXhjAOMYPPp6aqJnPwRqlP8S8vl4Ms8NrU0qgpvPhH0DgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MblA2c64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MblA2c64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5683C4CEC2;
	Wed,  2 Oct 2024 21:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727903185;
	bh=Gtr8voSTo9c39nTU8mFd+55BmV6thhZHryzrFhx6/kk=;
	h=Date:To:From:Subject:From;
	b=MblA2c646i+nwNj9kR0q4ibBo7MuGP2ajTdoFIPf2DeJr0T3OHdu5ek34AVXegjjZ
	 O1+jZ9US2dfClhS1jkLPqSeH4IBxUGemCORQUjDSAEGuEZ1WnPpcTRWj2+67DgiAhA
	 tuBViVAwpUltEy/zxEs5L0PFVJ8mz7f5CWKHv4ZQ=
Date: Wed, 02 Oct 2024 14:06:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch added to mm-unstable branch
Message-Id: <20241002210625.C5683C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gup: convert FOLL_TOUCH case in follow_page_pte() to folio
has been added to the -mm mm-unstable branch.  Its filename is
     gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch

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
Subject: gup: convert FOLL_TOUCH case in follow_page_pte() to folio
Date: Wed, 2 Oct 2024 16:13:27 +0100

We already have the folio here, so just use it, removing three hidden
calls to compound_head().

Link: https://lkml.kernel.org/r/20241002151403.1345296-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/gup.c~gup-convert-foll_touch-case-in-follow_page_pte-to-folio
+++ a/mm/gup.c
@@ -922,14 +922,14 @@ static struct page *follow_page_pte(stru
 	}
 	if (flags & FOLL_TOUCH) {
 		if ((flags & FOLL_WRITE) &&
-		    !pte_dirty(pte) && !PageDirty(page))
-			set_page_dirty(page);
+		    !pte_dirty(pte) && !folio_test_dirty(folio))
+			folio_mark_dirty(folio);
 		/*
 		 * pte_mkyoung() would be more correct here, but atomic care
 		 * is needed to avoid losing the dirty bit: it is easier to use
-		 * mark_page_accessed().
+		 * folio_mark_accessed().
 		 */
-		mark_page_accessed(page);
+		folio_mark_accessed(folio);
 	}
 out:
 	pte_unmap_unlock(ptep, ptl);
_

Patches currently in -mm which might be from willy@infradead.org are

ksm-use-a-folio-in-try_to_merge_one_page.patch
ksm-convert-cmp_and_merge_page-to-use-a-folio.patch
ksm-convert-should_skip_rmap_item-to-take-a-folio.patch
mm-add-pageanonnotksm.patch
mm-remove-pageksm.patch
gup-convert-foll_touch-case-in-follow_page_pte-to-folio.patch

