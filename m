From: akpm@linux-foundation.org
Subject: + mm-vmalloc-use-list_nextfirst_entry.patch added to -mm tree
Date: Tue, 17 Nov 2015 16:38:43 -0800
Message-ID: <564bc893.gEnaqob3I2LyGIsK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49688 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbbKRAin (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Nov 2015 19:38:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: use list_{next,first}_entry
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-list_nextfirst_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-list_nextfirst_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-list_nextfirst_entry.patch

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
Subject: mm/vmalloc.c: use list_{next,first}_entry

To make the intention clearer, use list_{next,first}_entry instead of
list_entry.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-list_nextfirst_entry mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-list_nextfirst_entry
+++ a/mm/vmalloc.c
@@ -441,8 +441,7 @@ nocache:
 		if (list_is_last(&first->list, &vmap_area_list))
 			goto found;
 
-		first = list_entry(first->list.next,
-				struct vmap_area, list);
+		first = list_next_entry(first, list);
 	}
 
 found:
@@ -2559,10 +2558,10 @@ static void *s_start(struct seq_file *m,
 	struct vmap_area *va;
 
 	spin_lock(&vmap_area_lock);
-	va = list_entry((&vmap_area_list)->next, typeof(*va), list);
+	va = list_first_entry(&vmap_area_list, typeof(*va), list);
 	while (n > 0 && &va->list != &vmap_area_list) {
 		n--;
-		va = list_entry(va->list.next, typeof(*va), list);
+		va = list_next_entry(va, list);
 	}
 	if (!n && &va->list != &vmap_area_list)
 		return va;
@@ -2576,7 +2575,7 @@ static void *s_next(struct seq_file *m,
 	struct vmap_area *va = p, *next;
 
 	++*pos;
-	next = list_entry(va->list.next, typeof(*va), list);
+	next = list_next_entry(va, list);
 	if (&next->list != &vmap_area_list)
 		return next;
 
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-vmalloc-use-list_nextfirst_entry.patch

