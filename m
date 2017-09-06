From: akpm@linux-foundation.org
Subject: [patch 105/119] mm/vmalloc.c: don't reinvent the wheel but
 use existing llist API
Date: Wed, 06 Sep 2017 16:24:26 -0700
Message-ID: <20170906232426.5yji7ccS9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51184 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752525AbdIFXY1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:24:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, byungchul.park@lge.com, joelaf@google.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vbabka@suse.cz, zijun_hu@htc.com

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
