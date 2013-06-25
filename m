From: akpm@linux-foundation.org
Subject: +
 mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch
 added to -mm tree
Date: Tue, 25 Jun 2013 15:23:48 -0700
Message-ID: <51ca1874.GK3UVXRbcrm2Ha5r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3FYWXt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jun 2013 18:23:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, liwanp@linux.vnet.ibm.com

Subject: + mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch added to -mm tree
To: liwanp@linux.vnet.ibm.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Jun 2013 15:23:48 -0700


The patch titled
     Subject: mm/writeback: commit reason of WB_REASON_FORKER_THREAD mismatch name
has been added to the -mm tree.  Its filename is
     mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name.patch

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
Subject: mm/writeback: commit reason of WB_REASON_FORKER_THREAD mismatch name

After 839a8e86 ("writeback: replace custom worker pool implementation with
unbound workqueue"), there is no bdi forker thread any more.  However,
WB_REASON_FORKER_THREAD is still used due to it is TPs userland visible
and we won't be exposing exactly the same information with just a
different name.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/writeback.h~mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name include/linux/writeback.h
--- a/include/linux/writeback.h~mm-writeback-commit-reason-of-wb_reason_forker_thread-mismatch-name
+++ a/include/linux/writeback.h
@@ -47,6 +47,12 @@ enum wb_reason {
 	WB_REASON_LAPTOP_TIMER,
 	WB_REASON_FREE_MORE_MEM,
 	WB_REASON_FS_FREE_SPACE,
+	/*
+	 * There is no bdi forker thread any more and works are done
+	 * by emergency worker, however, this is TPs userland visible
+	 * and we'll be exposing exactly the same information,
+	 * so it has a mismatch name.
+	 */
 	WB_REASON_FORKER_THREAD,
 
 	WB_REASON_MAX,
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

