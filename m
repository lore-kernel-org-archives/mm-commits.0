From: akpm@linux-foundation.org
Subject: [patch 088/124] mm/thp/autonuma: use TNF flag instead of vm fault
Date: Fri, 24 Feb 2017 14:59:56 -0800
Message-ID: <58b0baec.wiYyYZyDIeFIC/U0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38868 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdBXW76 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 17:59:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, riel@surriel.com

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
