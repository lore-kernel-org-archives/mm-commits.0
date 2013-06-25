From: akpm@linux-foundation.org
Subject: + mm-thp-fix-doc-for-transparent-huge-zero-page.patch added to
 -mm tree
Date: Tue, 25 Jun 2013 15:23:50 -0700
Message-ID: <51ca1876.zGJg3UD7gx2QPEi5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43474 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab3FYWXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, liwanp@linux.vnet.ibm.com

Subject: + mm-thp-fix-doc-for-transparent-huge-zero-page.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:23:50 -0700


The patch titled
     Subject: mm/thp: fix doc for transparent huge zero page
has been added to the -mm tree.  Its filename is
     mm-thp-fix-doc-for-transparent-huge-zero-page.patch

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
Subject: mm/thp: fix doc for transparent huge zero page

Transparent huge zero page is used during the page fault instead of in
khugepaged.

# ls /sys/kernel/mm/transparent_hugepage/
defrag  enabled  khugepaged  use_zero_page
# ls /sys/kernel/mm/transparent_hugepage/khugepaged/
alloc_sleep_millisecs  defrag  full_scans  max_ptes_none  pages_collapsed  pages_to_scan  scan_sleep_millisecs

This patch corrects the documentation just like the codes done.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/transhuge.txt~mm-thp-fix-doc-for-transparent-huge-zero-page Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~mm-thp-fix-doc-for-transparent-huge-zero-page
+++ a/Documentation/vm/transhuge.txt
@@ -120,8 +120,8 @@ By default kernel tries to use huge zero
 It's possible to disable huge zero page by writing 0 or enable it
 back by writing 1:
 
-echo 0 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
-echo 1 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
+echo 0 >/sys/kernel/mm/transparent_hugepage/use_zero_page
+echo 1 >/sys/kernel/mm/transparent_hugepage/use_zero_page
 
 khugepaged will be automatically started when
 transparent_hugepage/enabled is set to "always" or "madvise, and it'll
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

