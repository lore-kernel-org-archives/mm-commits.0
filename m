From: akpm@linux-foundation.org
Subject: [merged] mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch
 removed from -mm tree
Date: Mon, 27 Feb 2017 12:28:03 -0800
Message-ID: <58b48bd3.rVyYS8WDRYH9umIA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60458 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751991AbdB0U2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp/autonuma: use TNF flag instead of vm fault
has been removed from the -mm tree.  Its filename was
     mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: mm/thp/autonuma: use TNF flag instead of vm fault

We are using the wrong flag value in task_numa_falt function.  This can
result in us doing wrong numa fault statistics update, because we update
num_pages_migrate and numa_fault_locality etc based on the flag argument
passed.

Fixes: bae473a423 ("mm: introduce fault_env")
Link: http://lkml.kernel.org/r/1487498395-9544-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault
+++ a/mm/huge_memory.c
@@ -1506,7 +1506,7 @@ out:
 
 	if (page_nid != -1)
 		task_numa_fault(last_cpupid, page_nid, HPAGE_PMD_NR,
-				vmf->flags);
+				flags);
 
 	return 0;
 }
_

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are


