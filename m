From: akpm@linux-foundation.org
Subject: + mm-vmalloc-use-numa_no_node.patch added to -mm tree
Date: Fri, 13 Sep 2013 15:33:56 -0700
Message-ID: <523392d4.8aD6r8CKcTzd9YoB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39356 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3IMWd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 18:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, wujianguo@huawei.com

Subject: + mm-vmalloc-use-numa_no_node.patch added to -mm tree
To: wujianguo@huawei.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 15:33:56 -0700


The patch titled
     Subject: mm/vmalloc: use NUMA_NO_NODE
has been added to the -mm tree.  Its filename is
     mm-vmalloc-use-numa_no_node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-use-numa_no_node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-use-numa_no_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianguo Wu <wujianguo@huawei.com>
Subject: mm/vmalloc: use NUMA_NO_NODE

Use more appropriate "if (node == NUMA_NO_NODE)" instead of "if (node < 0)"

Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmalloc-use-numa_no_node mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-use-numa_no_node
+++ a/mm/vmalloc.c
@@ -1577,7 +1577,7 @@ static void *__vmalloc_area_node(struct
 		struct page *page;
 		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
-		if (node < 0)
+		if (node == NUMA_NO_NODE)
 			page = alloc_page(tmp_mask);
 		else
 			page = alloc_pages_node(node, tmp_mask, order);
_

Patches currently in -mm which might be from wujianguo@huawei.com are

origin.patch
mm-vmalloc-use-numa_no_node.patch
mm-acpi-use-numa_no_node.patch
x86-srat-use-numa_no_node.patch

