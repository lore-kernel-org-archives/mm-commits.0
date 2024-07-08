Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA4214EC43;
	Mon,  8 Jul 2024 21:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720475399; cv=none; b=iaXz7VdCH/f5b/0TCb+K+efyh4O19+a5CQcu2VIxpWfIWaXAUb0a76Q3kZh5jhEvdYJK7fJfC1LCJ86ZLmnh5neSq6T8g7QDCO2KxycUyTWrcTPrypCozAJGjnPdbSHRsRUWcogasXnQYwzUeScvY1cQxK42r9Gj/SxrrWtchdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720475399; c=relaxed/simple;
	bh=ptl0zh3PleOOX4Swi/ucEUby+SXTa7g0RclwVuM4xlI=;
	h=Date:To:From:Subject:Message-Id; b=FErIAHJrYw8x4lHBWJdngCvzWirBXe2U+aTEtXWO6kCfOVSnOJd4BMia44U5DxVC+lLEJwWOiO7yIkhhqoyByAxONNQSno9hV7oltIIg3amg/MYmQspYslPfrJkF0uHL48zXFzACWAKzS+XCJwpX5kbexH94r/vejjbdMnAedRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MAmQpMAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MAmQpMAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F249AC116B1;
	Mon,  8 Jul 2024 21:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720475399;
	bh=ptl0zh3PleOOX4Swi/ucEUby+SXTa7g0RclwVuM4xlI=;
	h=Date:To:From:Subject:From;
	b=MAmQpMAqCqfY/wk82OAC4iHm8LDUzxMI0f6zzhJ11hKDtzJXXkkEJ+ZTWs39Fdoff
	 LltMhtW054iL4CbFtCkz5RWQq8hVHIwj+wGPM23Go/vmvvC+vbjD8+Q9c+bAo0kZm+
	 pAxjeVA6rz7omP+6/8XvlG57S3zyGBLz3k9E1Yf4=
Date: Mon, 08 Jul 2024 14:49:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,linmiaohe@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio.patch added to mm-hotfixes-unstable branch
Message-Id: <20240708214958.F249AC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential race in __update_and_free_hugetlb_folio()
Date: Mon, 8 Jul 2024 10:51:27 +0800

There is a potential race between __update_and_free_hugetlb_folio() and
try_memory_failure_hugetlb():

 CPU1					CPU2
 __update_and_free_hugetlb_folio	try_memory_failure_hugetlb
					 folio_test_hugetlb
					  -- It's still hugetlb folio.
  folio_clear_hugetlb_hwpoison
  					  spin_lock_irq(&hugetlb_lock);
					   __get_huge_page_for_hwpoison
					    folio_set_hugetlb_hwpoison
					  spin_unlock_irq(&hugetlb_lock);
  spin_lock_irq(&hugetlb_lock);
  __folio_clear_hugetlb(folio);
   -- Hugetlb flag is cleared but too late.
  spin_unlock_irq(&hugetlb_lock);

When the above race occurs, raw error page info will be leaked.  Even
worse, raw error pages won't have hwpoisoned flag set and hit
pcplists/buddy.  Fix this issue by deferring
folio_clear_hugetlb_hwpoison() until __folio_clear_hugetlb() is done.  So
all raw error pages will have hwpoisoned flag set.

Link: https://lkml.kernel.org/r/20240708025127.107713-1-linmiaohe@huawei.com
Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -1726,13 +1726,6 @@ static void __update_and_free_hugetlb_fo
 	}
 
 	/*
-	 * Move PageHWPoison flag from head page to the raw error pages,
-	 * which makes any healthy subpages reusable.
-	 */
-	if (unlikely(folio_test_hwpoison(folio)))
-		folio_clear_hugetlb_hwpoison(folio);
-
-	/*
 	 * If vmemmap pages were allocated above, then we need to clear the
 	 * hugetlb flag under the hugetlb lock.
 	 */
@@ -1742,6 +1735,13 @@ static void __update_and_free_hugetlb_fo
 		spin_unlock_irq(&hugetlb_lock);
 	}
 
+	/*
+	 * Move PageHWPoison flag from head page to the raw error pages,
+	 * which makes any healthy subpages reusable.
+	 */
+	if (unlikely(folio_test_hwpoison(folio)))
+		folio_clear_hugetlb_hwpoison(folio);
+
 	folio_ref_unfreeze(folio, 1);
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-fix-potential-race-in-__update_and_free_hugetlb_folio.patch
mm-memory-failure-remove-obsolete-mf_msg_different_compound.patch

