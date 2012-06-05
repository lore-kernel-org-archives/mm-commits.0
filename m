From: akpm@linux-foundation.org
Subject: + vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next.patch added to -mm tree
Date: Tue, 05 Jun 2012 15:36:37 -0700
Message-ID: <20120605223639.87D68A0274@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:55603 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab2FEWgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2012 18:36:42 -0400
Received: by lagr15 with SMTP id r15so358261lag.1
        for <mm-commits@vger.kernel.org>; Tue, 05 Jun 2012 15:36:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: honkiko@gmail.com, hannes@cmpxchg.org, npiggin@kernel.dk


The patch titled
     Subject: vmalloc: walk vmap_areas by sorted list instead of rb_next()
has been added to the -mm tree.  Its filename is
     vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hong zhi guo <honkiko@gmail.com>
Subject: vmalloc: walk vmap_areas by sorted list instead of rb_next()

There's a walk by repeating rb_next to find a suitable hole.  Could be
simply replaced by walk on the sorted vmap_area_list.  More simpler and
efficient.

Mutation of the list and tree only happens in pair within
__insert_vmap_area and __free_vmap_area, under protection of
vmap_area_lock.  The patch code is also under vmap_area_lock, so the list
walk is safe, and consistent with the tree walk.

Tested on SMP by repeating batch of vmalloc anf vfree for random sizes and
rounds for hours.

Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next
+++ a/mm/vmalloc.c
@@ -413,11 +413,11 @@ nocache:
 		if (addr + size - 1 < addr)
 			goto overflow;
 
-		n = rb_next(&first->rb_node);
-		if (n)
-			first = rb_entry(n, struct vmap_area, rb_node);
-		else
+		if (list_is_last(&first->list, &vmap_area_list))
 			goto found;
+
+		first = list_entry(first->list.next,
+				struct vmap_area, list);
 	}
 
 found:
_
Subject: Subject: vmalloc: walk vmap_areas by sorted list instead of rb_next()

Patches currently in -mm which might be from honkiko@gmail.com are

vmalloc-walk-vmap_areas-by-sorted-list-instead-of-rb_next.patch

