From: akpm@linux-foundation.org
Subject: + mm-document-get_user_pages_fast.patch added to -mm tree
Date: Thu, 09 Apr 2009 17:59:15 -0700
Message-ID: <200904100059.n3A0xFNK027982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754815AbZDJBB5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 21:01:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andy.grover@oracle.com, mingo@elte.hu, nickpiggin@yahoo.com.au


The patch titled
     mm: document get_user_pages_fast()
has been added to the -mm tree.  Its filename is
     mm-document-get_user_pages_fast.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

mm-document-get_user_pages_fast.patch

