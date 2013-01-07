From: akpm@linux-foundation.org
Subject: + mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions.patch added to -mm tree
Date: Mon, 07 Jan 2013 13:24:06 -0800
Message-ID: <20130107212406.A2ED882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59061 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3AGVYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 16:24:07 -0500
Received: by mail-gg0-f201.google.com with SMTP id o6so2133431ggm.2
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 13:24:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linfeng@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, tj@kernel.org


The patch titled
     Subject: mm: memblock: fix wrong memmove size in memblock_merge_regions()
has been added to the -mm tree.  Its filename is
     mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lin Feng <linfeng@cn.fujitsu.com>
Subject: mm: memblock: fix wrong memmove size in memblock_merge_regions()

The memmove span covers from (next+1) to the end of the array, and the
index of next is (i+1), so the index of (next+1) is (i+2).  So the size of
remaining array elements is (type->cnt - (i + 2)).

Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/memblock.c~mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions mm/memblock.c
--- a/mm/memblock.c~mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions
+++ a/mm/memblock.c
@@ -314,7 +314,8 @@ static void __init_memblock memblock_mer
 		}
 
 		this->size += next->size;
-		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
+		/* move forward from next + 1, index of which is i + 2 */
+		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
 		type->cnt--;
 	}
 }
_

Patches currently in -mm which might be from linfeng@cn.fujitsu.com are

mm-memblock-fix-wrong-memmove-size-in-memblock_merge_regions.patch

