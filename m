From: akpm@linux-foundation.org
Subject: + mm-page_alloc-fix-doc-for-numa_zonelist_order.patch added to
 -mm tree
Date: Tue, 25 Jun 2013 15:23:49 -0700
Message-ID: <51ca1875.BC/YmmnodX6yVlQp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43471 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab3FYWXu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:23:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, liwanp@linux.vnet.ibm.com

Subject: + mm-page_alloc-fix-doc-for-numa_zonelist_order.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:23:49 -0700


The patch titled
     Subject: mm/page_alloc: fix doc for numa_zonelist_order
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-doc-for-numa_zonelist_order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages.patch
mm-memory-hotplug-fix-lowmem-count-overflow-when-offline-pages-fix.patch
mm-pageblock-remove-get-set_pageblock_flags.patch
mm-hugetlb-remove-hugetlb_prefault.patch
mm-hugetlb-use-already-exist-interface-huge_page_shift.patch
mm-writeback-remove-wb_reason_name.patch
mm-writeback-dont-check-force_wait-to-handle-bdi-work_list.patch
mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
mm-page_alloc-fix-doc-for-numa_zonelist_order.patch
mm-thp-fix-doc-for-transparent-huge-zero-page.patch
mm-pgtable-dont-accumulate-addr-during-pgd-prepopulate-pmd.patch

