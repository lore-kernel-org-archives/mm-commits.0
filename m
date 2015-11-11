From: akpm@linux-foundation.org
Subject: +
 mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch
 added to -mm tree
Date: Wed, 11 Nov 2015 15:00:23 -0800
Message-ID: <5643c887.1yMJV0Kemt38ssx0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57626 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbKKXAX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 18:00:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klimov.linux@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: drop unneeded initialization in munlock_vma_pages_range()
has been added to the -mm tree.  Its filename is
     mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexey Klimov <klimov.linux@gmail.com>
Subject: mm/mlock.c: drop unneeded initialization in munlock_vma_pages_range()

Before usage page pointer initialized by NULL is reinitialized by
follow_page_mask().  Drop useless init of page pointer in the beginning of
loop.

Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mlock.c~mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range mm/mlock.c
--- a/mm/mlock.c~mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range
+++ a/mm/mlock.c
@@ -425,7 +425,7 @@ void munlock_vma_pages_range(struct vm_a
 	vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 
 	while (start < end) {
-		struct page *page = NULL;
+		struct page *page;
 		unsigned int page_mask;
 		unsigned long page_increm;
 		struct pagevec pvec;
_

Patches currently in -mm which might be from klimov.linux@gmail.com are

mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch

