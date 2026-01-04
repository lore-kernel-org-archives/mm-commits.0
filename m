Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078AB3A1E70;
	Sun,  4 Jan 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767549548; cv=none; b=UYnme/USBsr+YwuKJ5k/GQ0xKkW7+DnGpircCAxxR/bJvMwzzbTvbBNpJFkMdGC/n6q2JutIyhP+oi2EPtuPKRJNgQpBrMpPwyea6bI3Q1ZH1S6B9QFXXERa1HBZyQH0QT2B3rZD2xxmUwlRxchAFNLzwzGkGlB8qM0In6Dt/QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767549548; c=relaxed/simple;
	bh=0OZPDaxVwdoSeACdoaN1quQhyId1qv1e8mlXVzC1RvQ=;
	h=Date:To:From:Subject:Message-Id; b=exnLOZ+ptQvGfZ6rOU2J1CGBGljadCfIJYW7VPPwPA3ipOTei6pVhEuKZgO+1qK3m/fYuz+N//KCRmGL44DCTWRd1MWJM+vdSeBT4JLhFVcS4phfO4plvxzqRCl3iMLJVhvBohAKw2fCONTa7SB8tjaXfsEjDrg+WPtong9KdtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x0dEkahT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x0dEkahT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFE4C19421;
	Sun,  4 Jan 2026 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767549545;
	bh=0OZPDaxVwdoSeACdoaN1quQhyId1qv1e8mlXVzC1RvQ=;
	h=Date:To:From:Subject:From;
	b=x0dEkahT6hgSAyvVNETPNm1CXwE2zG7nFdZ/H3FuU9Xmio+uMV513Z7/eNbbNNkVc
	 beUaaVyGKoIDYbFVBw61cXaVrH4k0UDSrKWwsYuIBIACrzXuPoYFRWTY2p8nUiQcp4
	 kjxCwWf7oPElyA1DJ9quYtKRqvrHAOlDIT+I9b0M=
Date: Sun, 04 Jan 2026 09:59:05 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20260104175905.AAFE4C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: fix poisoning of high-order non-compound pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-fix-poisoning-of-high-order-non-compound-pages.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

