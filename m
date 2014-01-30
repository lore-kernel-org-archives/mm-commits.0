From: akpm@linux-foundation.org
Subject: [merged] memblock-add-limit-checking-to-memblock_virt_alloc.patch removed from -mm tree
Date: Thu, 30 Jan 2014 12:05:22 -0800
Message-ID: <52eab082.BoAeyXfXDujo1/bL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42396 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbaA3UFX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Jan 2014 15:05:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, santosh.shilimkar@ti.com, sachin.kamat@linaro.org, olof@lixom.net, mingo@elte.hu, konrad.wilk@oracle.com, khilman@linaro.org, hpa@zytor.com, grygorii.strashko@ti.com, dave.hansen@intel.com, yinghai@kernel.org

Subject: [merged] memblock-add-limit-checking-to-memblock_virt_alloc.patch removed from -mm tree
To: yinghai@kernel.org,dave.hansen@intel.com,grygorii.strashko@ti.com,hpa@zytor.com,khilman@linaro.org,konrad.wilk@oracle.com,mingo@elte.hu,olof@lixom.net,sachin.kamat@linaro.org,santosh.shilimkar@ti.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 30 Jan 2014 12:05:22 -0800


The patch titled
     Subject: memblock: add limit checking to memblock_virt_alloc
has been removed from the -mm tree.  Its filename was
     memblock-add-limit-checking-to-memblock_virt_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: memblock: add limit checking to memblock_virt_alloc

In original bootmem wrapper for memblock, we have limit checking.

Add it to memblock_virt_alloc, to address arm and x86 booting crash.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Reported-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>
Reported-by: Olof Johansson <olof@lixom.net>
Tested-by: Olof Johansson <olof@lixom.net>
Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Strashko, Grygorii" <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memblock.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/memblock.c~memblock-add-limit-checking-to-memblock_virt_alloc mm/memblock.c
--- a/mm/memblock.c~memblock-add-limit-checking-to-memblock_virt_alloc
+++ a/mm/memblock.c
@@ -1077,6 +1077,9 @@ static void * __init memblock_virt_alloc
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
+	if (max_addr > memblock.current_limit)
+		max_addr = memblock.current_limit;
+
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
 					    nid);
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
memblock-bootmem-restore-goal-for-alloc_low.patch
linux-next.patch

