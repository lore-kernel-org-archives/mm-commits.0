Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663AF2581;
	Thu,  3 Apr 2025 03:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743652795; cv=none; b=mXg0m2Y80Z2jb3dWcGc8mB4PgPi88HWGaXPyexIfSJC9CCjcEv77+y8FTYSYb/8E/bBs+o6kmm8zu98k57q2Tg4v37wLDswb5pWhJjLtnuBMouVVpgidtW483WJxhp0zFYpMrkh+U5y+osfkzCC5vBqe5HvJN3ENnQ/8uwbk3yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743652795; c=relaxed/simple;
	bh=a1W8uK/mtFZRgxv1ycxIHxj31XYVSUtlLTwzZB8HCBQ=;
	h=Date:To:From:Subject:Message-Id; b=MF1f7OKrpfmHWhR38su/maSZtfcfcgyGdelOZ71cNL7twU+QN+jr5xvfUWS0oj7nJv0gpZQrRkYca0nPWI5QejxR0pAIUlH5Ovgo8wYnCD1Av51EOq6K35UWI9aCPbUQ45hlignyna+e8p3pzVxp5kYaDagSVDlmFKAXUkrtANo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IWbYgMh5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IWbYgMh5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F0BC4CEE3;
	Thu,  3 Apr 2025 03:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743652795;
	bh=a1W8uK/mtFZRgxv1ycxIHxj31XYVSUtlLTwzZB8HCBQ=;
	h=Date:To:From:Subject:From;
	b=IWbYgMh5WVUS8UlkU4CribUjZbLpCnenRBx8PpXl/kFqhD0ReBBjaKk3l4yInFmdg
	 JcItI257rcFK5o8E+fE4Ps0cHw6jEdYcReT1XEWuSKJdVMYY20sAlg+kKihRNUu8mB
	 gMCcd77d7kctOM8kt0rnlaX/q+12U5hN0jEuYnLQ=
Date: Wed, 02 Apr 2025 20:59:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,vishal.moola@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch added to mm-hotfixes-unstable branch
Message-Id: <20250403035955.07F0BC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/compaction: fix bug in hugetlb handling pathway
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch

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
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/compaction: fix bug in hugetlb handling pathway
Date: Mon, 31 Mar 2025 19:10:24 -0700

The compaction code doesn't take references on pages until we're certain
we should attempt to handle it.

In the hugetlb case, isolate_or_dissolve_huge_page() may return -EBUSY
without taking a reference to the folio associated with our pfn.  If our
folio's refcount drops to 0, compound_nr() becomes unpredictable, making
low_pfn and nr_scanned unreliable.  The user-visible effect is minimal -
this should rarely happen (if ever).

Fix this by storing the folio statistics earlier on the stack (just like
the THP and Buddy cases).

Also revert commit 66fe1cf7f581 ("mm: compaction: use helper compound_nr
in isolate_migratepages_block") to make backporting easier.

Link: https://lkml.kernel.org/r/20250401021025.637333-1-vishal.moola@gmail.com
Fixes: 369fa227c219 ("mm: make alloc_contig_range handle free hugetlb pages")
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-fix-bug-in-hugetlb-handling-pathway
+++ a/mm/compaction.c
@@ -981,13 +981,13 @@ isolate_migratepages_block(struct compac
 		}
 
 		if (PageHuge(page)) {
+			const unsigned int order = compound_order(page);
 			/*
 			 * skip hugetlbfs if we are not compacting for pages
 			 * bigger than its order. THPs and other compound pages
 			 * are handled below.
 			 */
 			if (!cc->alloc_contig) {
-				const unsigned int order = compound_order(page);
 
 				if (order <= MAX_PAGE_ORDER) {
 					low_pfn += (1UL << order) - 1;
@@ -1011,8 +1011,8 @@ isolate_migratepages_block(struct compac
 				 /* Do not report -EBUSY down the chain */
 				if (ret == -EBUSY)
 					ret = 0;
-				low_pfn += compound_nr(page) - 1;
-				nr_scanned += compound_nr(page) - 1;
+				low_pfn += (1UL << order) - 1;
+				nr_scanned += (1UL << order) - 1;
 				goto isolate_fail;
 			}
 
_

Patches currently in -mm which might be from vishal.moola@gmail.com are

mm-compaction-fix-bug-in-hugetlb-handling-pathway.patch

