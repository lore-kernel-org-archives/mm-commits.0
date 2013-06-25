From: akpm@linux-foundation.org
Subject: + mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch added
 to -mm tree
Date: Tue, 25 Jun 2013 15:42:59 -0700
Message-ID: <51ca1cf3.hMmH1keE8+LYE/e4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3FYWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, unix140@gmail.com, rientjes@google.com, minchan@kernel.org, kosaki.motohiro@jp.fujitsu.com, dbaluta@ixiacom.com, zhangyanfei.yes@gmail.com

Subject: + mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch added to -mm tree
To: zhangyanfei.yes@gmail.com,dbaluta@ixiacom.com,kosaki.motohiro@jp.fujitsu.com,minchan@kernel.org,rientjes@google.com,unix140@gmail.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:42:59 -0700


The patch titled
     Subject: mm/vmalloc.c: fix an overflow bug in alloc_vmap_area()
has been added to the -mm tree.  Its filename is
     mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmallocc-fix-an-overflow-bug-in-alloc_vmap_area.patch

