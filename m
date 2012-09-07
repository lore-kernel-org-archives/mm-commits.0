From: akpm@linux-foundation.org
Subject: + mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail.patch added to -mm tree
Date: Fri, 07 Sep 2012 14:56:22 -0700
Message-ID: <20120907215623.0A1C720017F@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:39693 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab2IGV4Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 17:56:25 -0400
Received: by eaac1 with SMTP id c1so2410eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 14:56:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn


The patch titled
     Subject: mm/rmap.c: use list_move_tail instead of list_del/list_add_tail
has been added to the -mm tree.  Its filename is
     mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail.patch

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
mm-rmapc-use-list_move_tail-instead-of-list_del-list_add_tail.patch
kdump-remove-unneeded-include.patch

