From: akpm@linux-foundation.org
Subject: [patch 025/126] mm/slab: use list_move instead of
 list_del/list_add
Date: Tue, 26 Jul 2016 15:22:11 -0700
Message-ID: <5797e293.MKMDht0RR6jVNld0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757758AbcGZWWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yongjun_wei@trendmicro.com.cn, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: mm/slab: use list_move instead of list_del/list_add

Using list_move() instead of list_del() + list_add() to avoid needlessly
poisoning the next and prev values.

Link: http://lkml.kernel.org/r/1468929772-9174-1-git-send-email-weiyj_lk@163.com
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
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
