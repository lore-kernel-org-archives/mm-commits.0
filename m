From: akpm@linux-foundation.org
Subject: + mm-use-unsigned-long-constant-for-page-flags.patch added to -mm tree
Date: Fri, 29 Apr 2016 16:22:01 -0700
Message-ID: <5723ec99.vXMuyhmGb7KTzNCY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbcD2XWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 19:22:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use unsigned long constant for page flags
has been added to the -mm tree.  Its filename is
     mm-use-unsigned-long-constant-for-page-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-unsigned-long-constant-for-page-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-unsigned-long-constant-for-page-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: use unsigned long constant for page flags

struct page->flags is unsigned long, so when shifting bits we should
use UL suffix to match it.

Found this problem after I added 64-bit CPU specific page flags and
failed to compile the kernel:
mm/page_alloc.c: In function '__free_one_page':
mm/page_alloc.c:672:2: error: integer overflow in expression [-Werror=overflow]

Link: http://lkml.kernel.org/r/1461971723-16187-1-git-send-email-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Michal Hocko <mhocko@suse.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Jerome Marchand <jmarchan@redhat.com>, Denys Vlasenko <dvlasenk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/page-flags.h~mm-use-unsigned-long-constant-for-page-flags include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-use-unsigned-long-constant-for-page-flags
+++ a/include/linux/page-flags.h
@@ -479,7 +479,7 @@ static inline void ClearPageCompound(str
 }
 #endif
 
-#define PG_head_mask ((1L << PG_head))
+#define PG_head_mask ((1UL << PG_head))
 
 #ifdef CONFIG_HUGETLB_PAGE
 int PageHuge(struct page *page);
@@ -670,7 +670,7 @@ static inline void ClearPageSlabPfmemall
 }
 
 #ifdef CONFIG_MMU
-#define __PG_MLOCKED		(1 << PG_mlocked)
+#define __PG_MLOCKED		(1UL << PG_mlocked)
 #else
 #define __PG_MLOCKED		0
 #endif
@@ -680,11 +680,11 @@ static inline void ClearPageSlabPfmemall
  * these flags set.  It they are, there is a problem.
  */
 #define PAGE_FLAGS_CHECK_AT_FREE \
-	(1 << PG_lru	 | 1 << PG_locked    | \
-	 1 << PG_private | 1 << PG_private_2 | \
-	 1 << PG_writeback | 1 << PG_reserved | \
-	 1 << PG_slab	 | 1 << PG_swapcache | 1 << PG_active | \
-	 1 << PG_unevictable | __PG_MLOCKED)
+	(1UL << PG_lru	 | 1UL << PG_locked    | \
+	 1UL << PG_private | 1UL << PG_private_2 | \
+	 1UL << PG_writeback | 1UL << PG_reserved | \
+	 1UL << PG_slab	 | 1UL << PG_swapcache | 1UL << PG_active | \
+	 1UL << PG_unevictable | __PG_MLOCKED)
 
 /*
  * Flags checked when a page is prepped for return by the page allocator.
@@ -695,10 +695,10 @@ static inline void ClearPageSlabPfmemall
  * alloc-free cycle to prevent from reusing the page.
  */
 #define PAGE_FLAGS_CHECK_AT_PREP	\
-	(((1 << NR_PAGEFLAGS) - 1) & ~__PG_HWPOISON)
+	(((1UL << NR_PAGEFLAGS) - 1) & ~__PG_HWPOISON)
 
 #define PAGE_FLAGS_PRIVATE				\
-	(1 << PG_private | 1 << PG_private_2)
+	(1UL << PG_private | 1UL << PG_private_2)
 /**
  * page_has_private - Determine if page has private stuff
  * @page: The page to be checked
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-use-unsigned-long-constant-for-page-flags.patch

