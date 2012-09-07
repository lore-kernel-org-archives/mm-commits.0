From: akpm@linux-foundation.org
Subject: [obsolete] mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail.patch removed from -mm tree
Date: Fri, 07 Sep 2012 16:07:35 -0700
Message-ID: <20120907230735.C23F51E0096@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:59359 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab2IGXHg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 19:07:36 -0400
Received: by yhl10 with SMTP id 10so19028yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 16:07:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap.c: use list_move_tail instead of list_del/list_add_tail
has been removed from the -mm tree.  Its filename was
     mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: mm/rmap.c: use list_move_tail instead of list_del/list_add_tail

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/rmap.c~mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail mm/rmap.c
--- a/mm/rmap.c~mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail
+++ a/mm/rmap.c
@@ -307,8 +307,7 @@ void anon_vma_moveto_tail(struct vm_area
 		struct anon_vma *anon_vma = pavc->anon_vma;
 		VM_BUG_ON(pavc->vma != dst);
 		root = lock_anon_vma_root(root, anon_vma);
-		list_del(&pavc->same_anon_vma);
-		list_add_tail(&pavc->same_anon_vma, &anon_vma->head);
+		list_move_tail(&pavc->same_anon_vma, &anon_vma->head);
 	}
 	unlock_anon_vma_root(root);
 }
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
cciss-remove-useless-set-memory-to-zero-use-memset.patch
kdump-remove-unneeded-include.patch

