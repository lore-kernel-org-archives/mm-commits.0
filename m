Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFE62D63F6;
	Sun,  4 Jan 2026 18:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767549784; cv=none; b=oxTAMPT+WhMBrOVKywP13khCMYmjLw8R9fqzEGZalhiv2ehDazY6HJIswZB5gpP7cVOzD0b0QP9BWrfI8g11MA1iZ8RQi4LF7UPLNL1NdXKt/6MbdvMFOo0khHhH42lZ+F5fMu+uL90yWRlrbcYMz24cx9ooz5z9JJ3Ks3uEXmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767549784; c=relaxed/simple;
	bh=NL4nsUn9Cy47iV2WBS1fcjwxk+rtYVZEXHWYp2xSVvo=;
	h=Date:To:From:Subject:Message-Id; b=mj0ZqdVL2SYrYbV9YIGAWNSJN3cOgPORGbrUOo7yNqegbFiWfhZ7Al+zm1pUqsg9LBfsjT0AjQ73AuVNh13aTdvV3qu1w35fxJZbxvML2o0sH0z/QIy9LhbOWDVFeRTld2s7tY2+lryUeSuFptZRqAG8gJRPmfvtc4l26Sp7VBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGnswWPR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGnswWPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09584C4CEF7;
	Sun,  4 Jan 2026 18:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767549784;
	bh=NL4nsUn9Cy47iV2WBS1fcjwxk+rtYVZEXHWYp2xSVvo=;
	h=Date:To:From:Subject:From;
	b=ZGnswWPRrifoCTMF5dSOIo+XZvnMw8Gu5zC4tSdePA6QgLE4D70Ce1OXGJVcH7ENc
	 WQC4NCu9wj6zqMo+OZ0zBEzABB4vJVuYkBJuJxqt3iaDWYD41TRfvfakaItzsAz2mf
	 LQj+ujBozaf5aRGtLf6yShBKXVuHH+ACuw1TPScY=
Date: Sun, 04 Jan 2026 10:03:03 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch added to mm-new branch
Message-Id: <20260104180304.09584C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: fix poisoning of high-order non-compound pages
has been added to the -mm mm-new branch.  Its filename is
     mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: kmsan: fix poisoning of high-order non-compound pages
Date: Sun, 4 Jan 2026 13:43:47 +0000

kmsan_free_page() is called by the page allocator's free_pages_prepare()
during page freeing.  Its job is to poison all the memory covered by the
page.  It can be called with an order-0 page, a compound high-order page
or a non-compound high-order page.  But page_size() only works for order-0
and compound pages.  For a non-compound high-order page it will
incorrectly return PAGE_SIZE.

The implication is that the tail pages of a high-order non-compound page
do not get poisoned at free, so any invalid access while they are free
could go unnoticed.  It looks like the pages will be poisoned again at
allocation time, so that would bookend the window.

Fix this by using the order parameter to calculate the size.

Link: https://lkml.kernel.org/r/20260104134348.3544298-1-ryan.roberts@arm.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/shadow.c~mm-kmsan-fix-poisoning-of-high-order-non-compound-pages
+++ a/mm/kmsan/shadow.c
@@ -207,7 +207,7 @@ void kmsan_free_page(struct page *page,
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(page_address(page), page_size(page),
+	kmsan_internal_poison_memory(page_address(page), PAGE_SIZE << order,
 				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch

