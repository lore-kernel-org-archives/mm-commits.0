From: akpm@linux-foundation.org
Subject: + page-owners-correct-page-order-when-to-free-page.patch added to -mm tree
Date: Wed, 12 Mar 2014 13:03:50 -0700
Message-ID: <5320bda6.nYUD18ewFzDeF5VJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaCLUDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 16:03:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, iamjoonsoo.kim@lge.com, jungsoo.son@lge.com

Subject: + page-owners-correct-page-order-when-to-free-page.patch added to -mm tree
To: jungsoo.son@lge.com,iamjoonsoo.kim@lge.com,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 13:03:50 -0700


The patch titled
     Subject: page owners: correct page->order when to free page
has been added to the -mm tree.  Its filename is
     page-owners-correct-page-order-when-to-free-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-owners-correct-page-order-when-to-free-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-owners-correct-page-order-when-to-free-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jungsoo Son <jungsoo.son@lge.com>
Subject: page owners: correct page->order when to free page

When I use PAGE_OWNER in mmotm tree, I found a problem that mismatches the
number of allocated pages.  When I investigate, the problem is that
set_page_order is called for only a head page if freed page is merged to a
higher order page in the buddy allocator so tail pages of the higher order
page couldn't be reset to page->order = -1.

It means when we do 'cat /proc/page-owner', it could show wrong
information.

So page->order should be set to -1 for all the tail pages as well as the
first page before buddy allocator merges them.

This patch is for clearing page->order of all the tail pages in
free_pages_prepare() when to free page.

Signed-off-by: Jungsoo Son <jungsoo.son@lge.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/page_alloc.c~page-owners-correct-page-order-when-to-free-page mm/page_alloc.c
--- a/mm/page_alloc.c~page-owners-correct-page-order-when-to-free-page
+++ a/mm/page_alloc.c
@@ -742,6 +742,13 @@ static bool free_pages_prepare(struct pa
 	if (bad)
 		return false;
 
+#ifdef CONFIG_PAGE_OWNER
+	for (i = 0; i < (1 << order); i++) {
+		struct page *p = (page + i);
+		p->order = -1;
+	}
+#endif
+
 	if (!PageHighMem(page)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
_

Patches currently in -mm which might be from jungsoo.son@lge.com are

page-owners-correct-page-order-when-to-free-page.patch

