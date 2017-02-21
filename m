From: akpm@linux-foundation.org
Subject: + mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch added to -mm tree
Date: Tue, 21 Feb 2017 14:08:17 -0800
Message-ID: <58acba51.hA4LYbkwvZVdR1Sr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40594 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbdBUWIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Feb 2017 17:08:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp/autonuma: use TNF flag instead of vm fault
has been added to the -mm tree.  Its filename is
     mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Rik van Riel <riel@surriel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
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

mm-autonuma-dont-use-set_pte_at-when-updating-protnone-ptes.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte.patch
mm-autonuma-let-architecture-override-how-the-write-bit-should-be-stashed-in-a-protnone-pte-v3.patch
mm-ksm-handle-protnone-saved-writes-when-making-page-write-protect.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write.patch
powerpc-mm-autonuma-switch-ppc64-to-its-own-implementeation-of-saved-write-v3.patch
mm-thp-autonuma-use-tnf-flag-instead-of-vm-fault.patch

