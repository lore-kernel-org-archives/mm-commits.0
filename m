Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDAE812
	for <mm-commits@vger.kernel.org>; Thu, 20 Jun 2024 01:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718847376; cv=none; b=tD+Vurj9ZGZa/T5WqBht3cSLP7waphVO45/PhIXOycoUe3W31awlMi7q+XzzGx/vf2btAwX9Wirq53cD6C7V5iNnbLNPpNKr+zehACzRwms9ks/w5qXc7Bcm3nc3uJtJwMgKPEyATfPQqvzoStjTrYOvI4wEKP5/1iyBZyzU04I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718847376; c=relaxed/simple;
	bh=J0d1JlenSRyLrZHocB6MSQJiwcPuZmVgiFy/DQrOzgE=;
	h=Date:To:From:Subject:Message-Id; b=r2pAQ76LPTy0DksWmyA0h3XZHGfAyK611AV55Nfx6xFbG6nAxFE/Qw9qu6Tu1zkawIbO3psw6LCaqVwnr+6/dSxGa1WQM2GdUN/Jv3g8JDh0JIWbfjxfZbYPMxrHA4xk5xXBKDGSbkJO+9xyughG803rbw/5+T5rFQ4PAvhE5WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fdJ3Bing; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fdJ3Bing"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F76C32786;
	Thu, 20 Jun 2024 01:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718847376;
	bh=J0d1JlenSRyLrZHocB6MSQJiwcPuZmVgiFy/DQrOzgE=;
	h=Date:To:From:Subject:From;
	b=fdJ3BingGBF/sZba7KqrE8hsNgg/aEkxZTW8tZ8ORuYF9Tq8Src2F1Zs/rD0z/Nm6
	 ZVk0l1l38X2lGC1TH1Si43seh8xrJNzIi9hyXC39F8M6c8wVMXBzVEXhHDLRH6ndcY
	 S8JPsi74MwWCWcEZegA7/XB8n6uoUUY9jYag7BGA=
Date: Wed, 19 Jun 2024 18:36:16 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch added to mm-unstable branch
Message-Id: <20240620013616.98F76C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: reword the comment of buddy_merge_likely()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/page_alloc: reword the comment of buddy_merge_likely()
Date: Wed, 19 Jun 2024 01:06:12 +0000

For page with order O, we are checking its order (O + 1)'s buddy.  If it
is free, we would like to put it to the tail and expect it would be merged
to a page with order (O + 2).

Reword the comment to reflect it.

Link: https://lkml.kernel.org/r/20240619010612.20740-4-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-reword-the-comment-of-buddy_merge_likely
+++ a/mm/page_alloc.c
@@ -711,12 +711,12 @@ static inline struct page *get_page_from
 }
 
 /*
- * If this is not the largest possible page, check if the buddy
- * of the next-highest order is free. If it is, it's possible
+ * If this is less than the 2nd largest possible page, check if the buddy
+ * of the next-higher order is free. If it is, it's possible
  * that pages are being freed that will coalesce soon. In case,
  * that is happening, add the free page to the tail of the list
  * so it's less likely to be used soon and more likely to be merged
- * as a higher order page
+ * as a 2-level higher order page
  */
 static inline bool
 buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-mm_initc-print-mem_init-info-after-defer_init-is-done.patch
mm-mm_initc-simplify-logic-of-deferred__pages.patch
mm-mm_initc-simplify-logic-of-deferred__pages-v2.patch
mm-sparse-nr_pages-wont-be-0.patch
mm-mm_initc-move-build-check-on-max_zonelists-out-of-ifdef.patch
mm-page_alloc-fix-a-typo-in-comment-about-gfp-flag.patch
mm-page_alloc-reword-the-comment-of-buddy_merge_likely.patch

