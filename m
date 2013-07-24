From: akpm@linux-foundation.org
Subject: + mm-kill-one-if-loop-in-__free_pages_bootmem.patch added to -mm
 tree
Date: Wed, 24 Jul 2013 15:32:55 -0700
Message-ID: <51f05617.y/ivCQxwj3oUTeFb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab3GXWc4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 18:32:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de, hannes@cmpxchg.org, yinghai@kernel.org

Subject: + mm-kill-one-if-loop-in-__free_pages_bootmem.patch added to -mm tree
To: yinghai@kernel.org,hannes@cmpxchg.org,mgorman@suse.de
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 15:32:55 -0700


The patch titled
     Subject: mm: kill one if loop in __free_pages_bootmem()
has been added to the -mm tree.  Its filename is
     mm-kill-one-if-loop-in-__free_pages_bootmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kill-one-if-loop-in-__free_pages_bootmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kill-one-if-loop-in-__free_pages_bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: mm: kill one if loop in __free_pages_bootmem()

We should not check loop+1 with loop end in loop body.  Just duplicate two
lines code to avoid it.

That will help a bit when we have huge amount of pages on system with
16TiB memory.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-kill-one-if-loop-in-__free_pages_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-kill-one-if-loop-in-__free_pages_bootmem
+++ a/mm/page_alloc.c
@@ -751,19 +751,19 @@ static void __free_pages_ok(struct page
 void __init __free_pages_bootmem(struct page *page, unsigned int order)
 {
 	unsigned int nr_pages = 1 << order;
+	struct page *p = page;
 	unsigned int loop;
 
-	prefetchw(page);
-	for (loop = 0; loop < nr_pages; loop++) {
-		struct page *p = &page[loop];
