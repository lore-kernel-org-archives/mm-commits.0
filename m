From: akpm@linux-foundation.org
Subject: [merged] genalloc-fix-device-node-resource-counter.patch removed
 from -mm tree
Date: Mon, 29 Sep 2014 13:22:32 -0700
Message-ID: <5429bf88.2QTFSJt+IeVC1kiT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbaI2UWc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Sep 2014 16:22:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vladimir_zapolskiy@mentor.com, catalin.marinas@arm.com, olof@lixom.net, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: genalloc: fix device node resource counter
has been removed from the -mm tree.  Its filename was
     genalloc-fix-device-node-resource-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: genalloc: fix device node resource counter

Decrement the np_pool device_node refcount, which was incremented on
the preceding of_parse_phandle() call.

Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/genalloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/genalloc.c~genalloc-fix-device-node-resource-counter lib/genalloc.c
--- a/lib/genalloc.c~genalloc-fix-device-node-resource-counter
+++ a/lib/genalloc.c
@@ -588,6 +588,7 @@ struct gen_pool *of_get_named_gen_pool(s
 	if (!np_pool)
 		return NULL;
 	pdev = of_find_device_by_node(np_pool);
+	of_node_put(np_pool);
 	if (!pdev)
 		return NULL;
 	return dev_get_gen_pool(&pdev->dev);
_

Patches currently in -mm which might be from vladimir_zapolskiy@mentor.com are


