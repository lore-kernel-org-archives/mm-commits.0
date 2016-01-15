From: akpm@linux-foundation.org
Subject: [merged]
 mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch
 removed from -mm tree
Date: Fri, 15 Jan 2016 14:32:28 -0800
Message-ID: <5699737c.rQ/rRAaCaHmEallQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59140 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbcAOWc2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:32:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: klimov.linux@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mlock.c: drop unneeded initialization in munlock_vma_pages_range()
has been removed from the -mm tree.  Its filename was
     mm-mlockc-drop-unneeded-initialization-in-munlock_vma_pages_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


