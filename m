Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2F7BE6C
	for <mm-commits@vger.kernel.org>; Thu, 20 Mar 2025 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506022; cv=none; b=TC0MVW1kT40PjyyEVEvBj6rxdBipCs8/Rdrns/qxv/JB3HC6iKSYvdoR9bdBNpWiANDukYZmJGYZW7Tl6HJsp4KriMhDsUPBooLUcSbhOn3XpbGDDeXiNdIXh7RNVSayj4JiE4liSc+X9N32GWYNwDmm3vQTG3PRH1ufpbwB4pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506022; c=relaxed/simple;
	bh=JM/pbcz2NP0sMsU+ERZ59dcXFsZRUQVPMHzmLbypnpM=;
	h=Date:To:From:Subject:Message-Id; b=oJFLvSP98kBe/mR4jag9UeN6G4KdyEF0VGcy8Bm6BZxz24NDIXkSyAk3I3/1autYqINUVTDMNcFswxdvAfJB7ZGL6eAXe/xjM2S5UFAcFk22UecsiR5teGANWyAeytHH1887Fef8Ceel2vtH3E421XamEi6afgXwM2SngvGKIhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=blCUcNax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="blCUcNax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9221FC4CEDD;
	Thu, 20 Mar 2025 21:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742506021;
	bh=JM/pbcz2NP0sMsU+ERZ59dcXFsZRUQVPMHzmLbypnpM=;
	h=Date:To:From:Subject:From;
	b=blCUcNaxjHYBUzLFAjoBajIzAU3GcBpQchV++8G2mUroEIc/WcA3updQ1IgTl5lYc
	 uxeb4TKjbrI6DtAhHtNX9Sbbf3/WLAQhAewWa4CeJYXsSMsyxz2ae+7psKP44LkS1A
	 /rwwc2ye3cA7gbb/9OeLRviLF9shhdyKscI7k8Vg=
Date: Thu, 20 Mar 2025 14:27:01 -0700
To: mm-commits@vger.kernel.org,sidhartha.kumar@oracle.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch added to mm-unstable branch
Message-Id: <20250320212701.9221FC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: replace flag check with PageHWPoison() in check_new_page_bad()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch

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
From: Ye Liu <liuye@kylinos.cn>
Subject: mm/page_alloc: replace flag check with PageHWPoison() in check_new_page_bad()
Date: Thu, 20 Mar 2025 14:33:46 +0800

This patch replaces the direct check for the __PG_HWPOISON flag with the
PageHWPoison() macro, improving code readability and maintaining
consistency with other parts of the memory management code.

Link: https://lkml.kernel.org/r/20250320063346.489030-1-ye.liu@linux.dev
Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad
+++ a/mm/page_alloc.c
@@ -1559,7 +1559,7 @@ static __always_inline void page_del_and
 
 static void check_new_page_bad(struct page *page)
 {
-	if (unlikely(page->flags & __PG_HWPOISON)) {
+	if (unlikely(PageHWPoison(page))) {
 		/* Don't complain about hwpoisoned pages */
 		if (PageBuddy(page))
 			__ClearPageBuddy(page);
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-page_alloc-remove-unnecessary-__maybe_unused-in-order_to_pindex.patch
mm-page_alloc-replace-flag-check-with-pagehwpoison-in-check_new_page_bad.patch

