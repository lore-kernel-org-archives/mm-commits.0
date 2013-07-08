From: akpm@linux-foundation.org
Subject: [merged]
 mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:27:14 -0700
Message-ID: <51db1292.kgN4joXkJ1kXRWSS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab3GHT1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rkuo@codeaurora.org, jiang.liu@huawei.com, liuj97@gmail.com

Subject: [merged] mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch removed from -mm tree
To: liuj97@gmail.com,jiang.liu@huawei.com,rkuo@codeaurora.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:27:14 -0700


The patch titled
     Subject: mm/hexagon: prepare for removing num_physpages and simplify mem_init()
has been removed from the -mm tree.  Its filename was
     mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Liu <liuj97@gmail.com>
Subject: mm/hexagon: prepare for removing num_physpages and simplify mem_init()

Prepare for removing num_physpages and simplify mem_init().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/init.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/hexagon/mm/init.c~mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init arch/hexagon/mm/init.c
--- a/arch/hexagon/mm/init.c~mm-hexagon-prepare-for-removing-num_physpages-and-simplify-mem_init
+++ a/arch/hexagon/mm/init.c
@@ -71,9 +71,7 @@ void __init mem_init(void)
 {
 	/*  No idea where this is actually declared.  Seems to evade LXR.  */
 	free_all_bootmem();
-	num_physpages = bootmem_lastpg-ARCH_PFN_OFFSET;
