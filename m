From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
 removed from -mm tree
Date: Tue, 09 Jul 2013 16:20:11 -0700
Message-ID: <51dc9aab.s7XIh70Rw4jkswr+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38889 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab3GIXUL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:20:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-page_alloc-fix-doc-for-numa_zonelist_order.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:20:11 -0700


The patch titled
     Subject: mm/page_alloc: fix doc for numa_zonelist_order
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-doc-for-numa_zonelist_order.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/page_alloc: fix doc for numa_zonelist_order

The default zonelist order selecter will select "node" order if any node's
DMA zone comprises greater than 70% of its local memory instead of 60%,
according to default_zonelist_order::low_kmem_size > total * 70/100.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-page_alloc-fix-doc-for-numa_zonelist_order Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-page_alloc-fix-doc-for-numa_zonelist_order
+++ a/Documentation/sysctl/vm.txt
@@ -510,7 +510,7 @@ Specify "[Dd]efault" to request automati
 will select "node" order in following case.
 (1) if the DMA zone does not exist or
 (2) if the DMA zone comprises greater than 50% of the available memory or
-(3) if any node's DMA zone comprises greater than 60% of its local memory and
+(3) if any node's DMA zone comprises greater than 70% of its local memory and
     the amount of local memory is big enough.
 
 Otherwise, "zone" order will be selected. Default order is recommended unless
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
linux-next.patch

