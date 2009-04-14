From: akpm@linux-foundation.org
Subject: [merged] mm-document-get_user_pages_fast.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:40 -0700
Message-ID: <200904141949.n3EJnefr019740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbZDNTwl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andy.grover@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     mm: document get_user_pages_fast()
has been removed from the -mm tree.  Its filename was
     mm-document-get_user_pages_fast.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: document get_user_pages_fast()
From: Andy Grover <andy.grover@oracle.com>

While better than get_user_pages(), the usage of gupf(), especially the
return values and the fact that it can potentially only partially pin the
range, warranted some documentation.

Signed-off-by: Andy Grover <andy.grover@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/util.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN mm/util.c~mm-document-get_user_pages_fast mm/util.c
--- a/mm/util.c~mm-document-get_user_pages_fast
+++ a/mm/util.c
@@ -223,6 +223,22 @@ void arch_pick_mmap_layout(struct mm_str
 }
 #endif
 
+/**
+ * get_user_pages_fast() - pin user pages in memory
+ * @start:	starting user address
+ * @nr_pages:	number of pages from start to pin
+ * @write:	whether pages will be written to
+ * @pages:	array that receives pointers to the pages pinned.
+ *		Should be at least nr_pages long.
+ *
+ * Attempt to pin user pages in memory without taking mm->mmap_sem.
+ * If not successful, it will fall back to taking the lock and
+ * calling get_user_pages().
+ *
+ * Returns number of pages pinned. This may be fewer than the number
+ * requested. If nr_pages is 0 or negative, returns 0. If no pages
+ * were pinned, returns -errno.
+ */
 int __attribute__((weak)) get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
 {
_

Patches currently in -mm which might be from andy.grover@oracle.com are

origin.patch

