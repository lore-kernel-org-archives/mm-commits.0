From: akpm@linux-foundation.org
Subject: + mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch
 added to -mm tree
Date: Wed, 09 Aug 2017 13:55:45 -0700
Message-ID: <598b76d1.9scJl82oAkn/H9kY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51358 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753151AbdHIUzq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Aug 2017 16:55:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: byungchul.park@lge.com, aryabinin@virtuozzo.com, joelaf@google.com, mhocko@suse.com, vbabka@suse.cz, zijun_hu@htc.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: don't reinvent the wheel but use existing llist API
has been added to the -mm tree.  Its filename is
     mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-dont-reinvent-the-wheel-but-use-existing-llist-api.patch

