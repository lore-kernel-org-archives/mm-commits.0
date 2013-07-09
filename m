From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:19 -0700
Message-ID: <51dc9ab3.6Ffe574maEgWUXFc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab3GIXUU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, unix140@gmail.com, rientjes@google.com, minchan@kernel.org, kosaki.motohiro@jp.fujitsu.com, dbaluta@ixiacom.com, zhangyanfei.yes@gmail.com

Subject: [merged] mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch removed from -mm tree
To: zhangyanfei.yes@gmail.com,dbaluta@ixiacom.com,kosaki.motohiro@jp.fujitsu.com,minchan@kernel.org,rientjes@google.com,unix140@gmail.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:19 -0700


The patch titled
     Subject: mm/vmalloc.c: fix an overflow bug in alloc_vmap_area()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Subject: mm/vmalloc.c: fix an overflow bug in alloc_vmap_area()

When searching a vmap area in the vmalloc space, we use (addr + size - 1)
to check if the value is less than addr, which is an overflow.  But we
assign (addr + size) to vmap_area->va_end.

So if we come across the  below case:

(addr + size - 1) : not overflow
(addr + size)     : overflow

we will assign an overflow value (e.g 0) to vmap_area->va_end, And this
will trigger BUG in __insert_vmap_area, causing system panic.

So using (addr + size) to check the overflow should be the correct
behaviour, not (addr + size - 1).

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reported-by: Ghennadi Procopciuc <unix140@gmail.com>
Tested-by: Daniel Baluta <dbaluta@ixiacom.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area
+++ a/mm/vmalloc.c
@@ -388,12 +388,12 @@ nocache:
 		addr = ALIGN(first->va_end, align);
 		if (addr < vstart)
 			goto nocache;
-		if (addr + size - 1 < addr)
+		if (addr + size < addr)
 			goto overflow;
 
 	} else {
 		addr = ALIGN(vstart, align);
-		if (addr + size - 1 < addr)
+		if (addr + size < addr)
 			goto overflow;
 
 		n = vmap_area_root.rb_node;
@@ -420,7 +420,7 @@ nocache:
 		if (addr + cached_hole_size < first->va_start)
 			cached_hole_size = first->va_start - addr;
 		addr = ALIGN(first->va_end, align);
-		if (addr + size - 1 < addr)
+		if (addr + size < addr)
 			goto overflow;
 
 		if (list_is_last(&first->list, &vmap_area_list))
_

Patches currently in -mm which might be from zhangyanfei.yes@gmail.com are

origin.patch

