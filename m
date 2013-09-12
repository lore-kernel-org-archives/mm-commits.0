From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-fix-race-against-poison-thp.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:45:25 -0700
Message-ID: <523219d5.fc91mgOISExCQvkQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181Ab3ILTp0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:45:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony.luck@intel.com, n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, liwanp@linux.vnet.ibm.com

Subject: [merged] mm-hwpoison-fix-race-against-poison-thp.patch removed from -mm tree
To: liwanp@linux.vnet.ibm.com,andi@firstfloor.org,n-horiguchi@ah.jp.nec.com,tony.luck@intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:45:25 -0700


The patch titled
     Subject: mm/hwpoison: fix race against poison thp
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-race-against-poison-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: mm/hwpoison: fix race against poison thp

There is a race between hwpoison page and unpoison page, memory_failure
set the page hwpoison and increase num_poisoned_pages without hold page
lock, and one page count will be accounted against thp for
num_poisoned_pages.  However, unpoison can occur before memory_failure
hold page lock and split transparent hugepage, unpoison will decrease
num_poisoned_pages by 1 << compound_order since memory_failure has not yet
split transparent hugepage with page lock held.  That means we account one
page for hwpoison and 1 << compound_order for unpoison.  This patch fix it
by inserting a PageTransHuge check before doing TestClearPageHWPoison,
unpoison failed without clearing PageHWPoison and decreasing
num_poisoned_pages.

            A                                                 	B
    	memory_failue
        TestSetPageHWPoison(p);
        if (PageHuge(p))
            nr_pages = 1 << compound_order(hpage);
        else
            nr_pages = 1;
        atomic_long_add(nr_pages, &num_poisoned_pages);
                                                            unpoison_memory
	                                                        nr_pages = 1<< compound_trans_order(page);
                                                            if(TestClearPageHWPoison(p))
                                                            atomic_long_sub(nr_pages, &num_poisoned_pages);
        lock page
        if (!PageHWPoison(p))
        	unlock page and return
        hwpoison_user_mappings
        if (PageTransHuge(hpage))
        	split_huge_page(hpage);

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-race-against-poison-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-race-against-poison-thp
+++ a/mm/memory-failure.c
@@ -1342,6 +1342,16 @@ int unpoison_memory(unsigned long pfn)
 		return 0;
 	}
 
+	/*
+	 * unpoison_memory() can encounter thp only when the thp is being
+	 * worked by memory_failure() and the page lock is not held yet.
+	 * In such case, we yield to memory_failure() and make unpoison fail.
+	 */
+	if (PageTransHuge(page)) {
+		pr_info("MCE: Memory failure is now running on %#lx\n", pfn);
+			return 0;
+	}
+
 	nr_pages = 1 << compound_order(page);
 
 	if (!get_page_unless_zero(page)) {
_

Patches currently in -mm which might be from liwanp@linux.vnet.ibm.com are

origin.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

