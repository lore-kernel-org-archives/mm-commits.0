From: akpm@linux-foundation.org
Subject: +
 mm-correct-the-comment-about-the-value-for-buddy-_mapcount.patch added to
 -mm tree
Date: Thu, 22 Aug 2013 15:28:48 -0700
Message-ID: <521690a0.3Fn7oYqZnRdV7t79%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47162 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HVW2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Aug 2013 18:28:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, shhuiw@gmail.com

Subject: + mm-correct-the-comment-about-the-value-for-buddy-_mapcount.patch added to -mm tree
To: shhuiw@gmail.com,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Thu, 22 Aug 2013 15:28:48 -0700


The patch titled
     Subject: mm: correct the comment about the value for buddy _mapcount
has been added to the -mm tree.  Its filename is
     mm-correct-the-comment-about-the-value-for-buddy-_mapcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-correct-the-comment-about-the-value-for-buddy-_mapcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-correct-the-comment-about-the-value-for-buddy-_mapcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm: correct the comment about the value for buddy _mapcount

Set _mapcount PAGE_BUDDY_MAPCOUNT_VALUE to make the page buddy.  Not the
magic number -2.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-correct-the-comment-about-the-value-for-buddy-_mapcount mm/page_alloc.c
--- a/mm/page_alloc.c~mm-correct-the-comment-about-the-value-for-buddy-_mapcount
+++ a/mm/page_alloc.c
@@ -489,8 +489,10 @@ __find_buddy_index(unsigned long page_id
  * (c) a page and its buddy have the same order &&
  * (d) a page and its buddy are in the same zone.
  *
- * For recording whether a page is in the buddy system, we set ->_mapcount -2.
- * Setting, clearing, and testing _mapcount -2 is serialized by zone->lock.
+ * For recording whether a page is in the buddy system, we set ->_mapcount
+ * PAGE_BUDDY_MAPCOUNT_VALUE.
+ * Setting, clearing, and testing _mapcount PAGE_BUDDY_MAPCOUNT_VALUE is
+ * serialized by zone->lock.
  *
  * For recording page's order, we use page_private(page).
  */
@@ -528,8 +530,9 @@ static inline int page_is_buddy(struct p
  * as necessary, plus some accounting needed to play nicely with other
  * parts of the VM system.
  * At each level, we keep a list of pages, which are heads of continuous
- * free pages of length of (1 << order) and marked with _mapcount -2. Page's
- * order is recorded in page_private(page) field.
+ * free pages of length of (1 << order) and marked with _mapcount
+ * PAGE_BUDDY_MAPCOUNT_VALUE. Page's order is recorded in page_private(page)
+ * field.
  * So when we are allocating or freeing one, we can derive the state of the
  * other.  That is, if we allocate a small block, and both were
  * free, the remainder of the region must be split into blocks.
_

Patches currently in -mm which might be from shhuiw@gmail.com are

mm-correct-the-comment-about-the-value-for-buddy-_mapcount.patch
linux-next.patch

