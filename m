From: akpm@linux-foundation.org
Subject: + mm-slab-use-list_move-instead-of-list_del-list_add.patch added
 to -mm tree
Date: Tue, 19 Jul 2016 16:33:22 -0700
Message-ID: <578eb8c2.8dMJDjsppo9nTOFU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbcGSXdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 19:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: use list_move instead of list_del/list_add
has been added to the -mm tree.  Its filename is
     mm-slab-use-list_move-instead-of-list_del-list_add.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-use-list_move-instead-of-list_del-list_add.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-use-list_move-instead-of-list_del-list_add.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: mm/slab: use list_move instead of list_del/list_add

Using list_move() instead of list_del() + list_add() to avoid needlessly
poisoning the next and prev values.

Link: http://lkml.kernel.org/r/1468929772-9174-1-git-send-email-weiyj_lk@163.com
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/slab.c~mm-slab-use-list_move-instead-of-list_del-list_add mm/slab.c
--- a/mm/slab.c~mm-slab-use-list_move-instead-of-list_del-list_add
+++ a/mm/slab.c
@@ -3452,8 +3452,7 @@ static void free_block(struct kmem_cache
 		n->free_objects -= cachep->num;
 
 		page = list_last_entry(&n->slabs_free, struct page, lru);
-		list_del(&page->lru);
-		list_add(&page->lru, list);
+		list_move(&page->lru, list);
 	}
 }
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

mm-slab-use-list_move-instead-of-list_del-list_add.patch

