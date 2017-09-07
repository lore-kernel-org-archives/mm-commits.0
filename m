From: akpm@linux-foundation.org
Subject: [merged]
 mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch removed from
 -mm tree
Date: Thu, 07 Sep 2017 11:41:37 -0700
Message-ID: <20170907184137.9v0zoDMzS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57770 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSli (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:41:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, byungchul.park@lge.com, joelaf@google.com, mhocko@suse.com, mm-commits@vger.kernel.org, vbabka@suse.cz, zijun_hu@htc.com


The patch titled
     Subject: mm/vmalloc.c: don't reinvent the wheel but use existing llist API
has been removed from the -mm tree.  Its filename was
     mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Byungchul Park <byungchul.park@lge.com>
Subject: mm/vmalloc.c: don't reinvent the wheel but use existing llist API

Although llist provides proper APIs, they are not used.  Make them used.

Link: http://lkml.kernel.org/r/1502095374-16112-1-git-send-email-byungchul.park@lge.com
Signed-off-by: Byungchul Park <byungchul.park@lge.com>
Cc: zijun_hu <zijun_hu@htc.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joel Fernandes <joelaf@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/vmalloc.c~mm-dont-reinvent-the-wheel-but-use-existing-llist-api mm/vmalloc.c
--- a/mm/vmalloc.c~mm-dont-reinvent-the-wheel-but-use-existing-llist-api
+++ a/mm/vmalloc.c
@@ -49,12 +49,10 @@ static void __vunmap(const void *, int);
 static void free_work(struct work_struct *w)
 {
 	struct vfree_deferred *p = container_of(w, struct vfree_deferred, wq);
-	struct llist_node *llnode = llist_del_all(&p->list);
-	while (llnode) {
-		void *p = llnode;
-		llnode = llist_next(llnode);
-		__vunmap(p, 1);
-	}
+	struct llist_node *t, *llnode;
+
+	llist_for_each_safe(llnode, t, llist_del_all(&p->list))
+		__vunmap((void *)llnode, 1);
 }
 
 /*** Page table manipulation functions ***/
_

Patches currently in -mm which might be from byungchul.park@lge.com are


