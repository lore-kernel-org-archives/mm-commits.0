From: akpm@linux-foundation.org
Subject: +
 hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings.patch added to -mm tree
Date: Thu, 24 Jul 2014 16:08:57 -0700
Message-ID: <53d19209.yhOLwtxU4k2lYHai%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:53595 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934703AbaGXXI6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jul 2014 19:08:58 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so744669oig.3
        for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2014 16:08:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, slaoub@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: call action_result() in failure path of hwpoison_user_mappings()
has been added to the -mm tree.  Its filename is
     hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings.patch

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
Subject: hwpoison: call action_result() in failure path of hwpoison_user_mappings()

hwpoison_user_mappings() could fail for various reasons, so printk()s to
print out the reasons should be done in each failure check inside
hwpoison_user_mappings().

And currently we don't call action_result() when hwpoison_user_mappings()
fails, which is not consistent with other exit points of memory error
handler.  So this patch fixes these messaging problems.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chen Yucong <slaoub@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -911,8 +911,10 @@ static int hwpoison_user_mappings(struct
 	if (!page_mapped(hpage))
 		return SWAP_SUCCESS;
 
-	if (PageKsm(p))
+	if (PageKsm(p)) {
+		pr_err("MCE %#lx: can't handle KSM pages.\n", pfn);
 		return SWAP_FAIL;
+	}
 
 	if (PageSwapCache(p)) {
 		printk(KERN_ERR
@@ -1235,7 +1237,7 @@ int memory_failure(unsigned long pfn, in
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
 	    != SWAP_SUCCESS) {
-		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
+		action_result(pfn, "unmapping failed", IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
hwpoison-fix-hugetlbfs-thp-precheck-in-hwpoison_user_mappings.patch
hwpoison-call-action_result-in-failure-path-of-hwpoison_user_mappings.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-refactor-page-index-offset-getters.patch
mm-refactor-page-index-offset-getters-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

