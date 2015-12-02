From: akpm@linux-foundation.org
Subject: + mm-slab-use-list_for_each_entry-in-cache_flusharray.patch added to -mm tree
Date: Wed, 02 Dec 2015 14:58:40 -0800
Message-ID: <565f77a0.u/ib1bSVGDgfi4LB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbbLBW6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:58:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: use list_for_each_entry in cache_flusharray
has been added to the -mm tree.  Its filename is
     mm-slab-use-list_for_each_entry-in-cache_flusharray.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-use-list_for_each_entry-in-cache_flusharray.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-use-list_for_each_entry-in-cache_flusharray.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/slab.c: use list_for_each_entry in cache_flusharray

Simplify the code with list_for_each_entry().

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN mm/slab.c~mm-slab-use-list_for_each_entry-in-cache_flusharray mm/slab.c
--- a/mm/slab.c~mm-slab-use-list_for_each_entry-in-cache_flusharray
+++ a/mm/slab.c
@@ -3338,17 +3338,12 @@ free_done:
 #if STATS
 	{
 		int i = 0;
-		struct list_head *p;
+		struct page *page;
 
-		p = n->slabs_free.next;
-		while (p != &(n->slabs_free)) {
-			struct page *page;
