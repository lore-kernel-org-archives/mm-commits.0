Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A080379989;
	Tue,  1 Sep 2026 05:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788239272; cv=none; b=HlvWZHcDD4pCq924v0wZA/aRxELpCyV6ono0swduedHUpAf4ht65UTgGAxEoS7LrCg7aFv1CuBZQmK2fnAgHlP8LoRqS4MxMSXN7S+5hxRqjwOTNAtu8e/7uumeblaIjvAJajQiS5WfVLOitNh2Wq/n5Z2vcg6lmOhBBNBWUyuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788239272; c=relaxed/simple;
	bh=41W8OLx1dG7/4ry/IjNcmGSZBJlYp4/DL6Kl88tZpmE=;
	h=Date:To:From:Subject:Message-Id; b=kUlVh6YCMFWXYRQotWvcadJZTskFN45XeM7TyVWv1xqfH6rfN7VFKAydIKtW6n6Yq1S03v3N/Pa+ZsU5pd2rRHDJ60BLDf/dgqgh4NN0YHNaYlt22DnskLrjwte2Y9CtHgW5eyBwkie2bKgIVJnnwNn3iU08fYYbYygz6061yCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T9qqVKGv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T9qqVKGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76DE1F000E9;
	Tue,  1 Sep 2026 05:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788239271;
	bh=ExawsuqHNUg2AFF+Jf06Kay9gpoR2oLYDLuGdIjOHb0=;
	h=Date:To:From:Subject;
	b=T9qqVKGvSKifeNHiXyUqOmbqYCu0RvzEKYk0MmavukX94jVqaSKnJaXwXv2Ubhhs3
	 MYhiKAJAvsYJruEmweliPxYoWln3MMmwgX8GFx27Pr2cQmJLu2j8VvN3/kvQs0up31
	 6y4/apJ6Fy5S6ldvAA2Gharcb+ZpJdD5sRYDAm5U=
Date: Mon, 31 Aug 2026 22:07:50 -0700
To: mm-commits@vger.kernel.org,vega@nebusec.ai,stable@vger.kernel.org,enjou1224z@gmail.com,roxy520tt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-skip-zero-pages.patch added to mm-new branch
Message-Id: <20260901050750.E76DE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_table_check: skip zero pages
has been added to the -mm mm-new branch.  Its filename is
     mm-page_table_check-skip-zero-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-skip-zero-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Zhiling Zou <roxy520tt@gmail.com>
Subject: mm/page_table_check: skip zero pages
Date: Tue, 21 Jul 2026 23:56:38 +0800

page_table_check_set() accounts pages by whether they are PageAnon().  The
shared zero page is a special page, not an ordinary file-backed page. 
Read faults on private anonymous mappings can install many read-only PTEs
that point at the zero page, but page_table_check currently accounts them
in file_map_count.

That lets an unprivileged process populate enough zero-page mappings to
overflow file_map_count and trip the BUG_ON() in page_table_check_set().

Skip zero pages in page_table_check accounting.  They do not need the
anonymous/file mapping conflict checks that page_table_check performs for
ordinary pages, and this keeps the existing counter size and page_ext
layout unchanged.

Link: https://lore.kernel.org/1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com
Fixes: df4e817b7108 ("mm: page table check")
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_table_check.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_table_check.c~mm-page_table_check-skip-zero-pages
+++ a/mm/page_table_check.c
@@ -67,7 +67,7 @@ static void page_table_check_clear(unsig
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
@@ -102,7 +102,7 @@ static void page_table_check_set(unsigne
 	struct page *page;
 	bool anon;
 
-	if (!pfn_valid(pfn))
+	if (!pfn_valid(pfn) || is_zero_pfn(pfn) || is_huge_zero_pfn(pfn))
 		return;
 
 	page = pfn_to_page(pfn);
_

Patches currently in -mm which might be from roxy520tt@gmail.com are

mm-page_table_check-skip-zero-pages.patch

