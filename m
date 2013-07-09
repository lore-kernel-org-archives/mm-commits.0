From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-unbreak-__vunmap.patch removed from -mm tree
Date: Tue, 09 Jul 2013 16:19:29 -0700
Message-ID: <51dc9a81.NRtCXPC5MEB3HofS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab3GIXTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, dan.carpenter@oracle.com

Subject: [merged] mm-vmallocc-unbreak-__vunmap.patch removed from -mm tree
To: dan.carpenter@oracle.com,zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:29 -0700


The patch titled
     Subject: mm/vmalloc.c: unbreak __vunmap()
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-unbreak-__vunmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/vmalloc.c: unbreak __vunmap()

There is an extra semi-colon so the function always returns.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-unbreak-__vunmap mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-unbreak-__vunmap
+++ a/mm/vmalloc.c
@@ -1453,7 +1453,7 @@ static void __vunmap(const void *addr, i
 		return;
 
 	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
-			addr));
+			addr))
 		return;
 
 	area = remove_vm_area(addr);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch

