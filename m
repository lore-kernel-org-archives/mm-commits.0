From: akpm@linux-foundation.org
Subject: + hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch added to -mm tree
Date: Fri, 07 Dec 2012 14:29:26 -0800
Message-ID: <20121207222927.65D50100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:34242 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2LGW33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2012 17:29:29 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so118187qaq.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Dec 2012 14:29:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com


The patch titled
     Subject: mm/hugetlb.c: fix warning on freeing hwpoisoned hugepage
has been added to the -mm tree.  Its filename is
     hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/hugetlb.c: fix warning on freeing hwpoisoned hugepage

Fix the warning from __list_del_entry() which is triggered when a process
tries to do free_huge_page() for a hwpoisoned hugepage.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage mm/hugetlb.c
--- a/mm/hugetlb.c~hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage
+++ a/mm/hugetlb.c
@@ -3178,7 +3178,13 @@ int dequeue_hwpoisoned_huge_page(struct 
 
 	spin_lock(&hugetlb_lock);
 	if (is_hugepage_on_freelist(hpage)) {
-		list_del(&hpage->lru);
+		/*
+		 * Hwpoisoned hugepage isn't linked to activelist or freelist,
+		 * but dangling hpage->lru can trigger list-debug warnings
+		 * (this happens when we call unpoison_memory() on it),
+		 * so let it point to itself with list_del_init().
+		 */
+		list_del_init(&hpage->lru);
 		set_page_refcounted(hpage);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix-fix.patch
hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch

