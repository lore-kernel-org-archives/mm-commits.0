From: akpm@linux-foundation.org
Subject: + hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch added to -mm tree
Date: Thu, 07 Feb 2013 14:24:21 -0800
Message-ID: <20130207222422.CF3B81CA15E@corp2gmr1-1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f201.google.com ([209.85.217.201]:33853 "EHLO
	mail-lb0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422664Ab3BGWY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Feb 2013 17:24:26 -0500
Received: by mail-lb0-f201.google.com with SMTP id gi11so225220lbb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Feb 2013 14:24:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, tony.luck@intel.com


The patch titled
     Subject: HWPOISON: fix misjudgement of page_action() for errors on mlocked pages
has been added to the -mm tree.  Its filename is
     hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch

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
Subject: HWPOISON: fix misjudgement of page_action() for errors on mlocked pages

memory_failure() can't handle memory errors on mlocked pages correctly,
because page_action() judges such errors as ones on "unknown pages"
instead of ones on "unevictable LRU page" or "mlocked LRU page".  In order
to determine page_state page_action() checks page flags at the timing of
the judgement, but such page flags are not the same with those just after
memory_failure() is called, because memory_failure() does unmapping of the
error pages before doing page_action().  This unmapping changes the page
state, especially page_remove_rmap() (called from try_to_unmap_one())
clears PG_mlocked, so page_action() can't catch mlocked pages after that.

With this patch, we store the page flag of the error page before doing
unmap, and (only) if the first check with page flags at the time decided
the error page is unknown, we do the second check with the stored page
flag.  This implementation doesn't change error handling for the page
types for which the first check can determine the page state correctly.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff -puN mm/memory-failure.c~hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages
+++ a/mm/memory-failure.c
@@ -1021,6 +1021,7 @@ int memory_failure(unsigned long pfn, in
 	struct page *hpage;
 	int res;
 	unsigned int nr_pages;
+	unsigned long page_flags;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure from trap %d on page %lx", trapno, pfn);
@@ -1129,6 +1130,15 @@ int memory_failure(unsigned long pfn, in
 	lock_page(hpage);
 
 	/*
+	 * We use page flags to determine what action should be taken,
+	 * but it can be modified by the error containment action.
+	 * One example is mlocked page, where PG_mlocked is cleared by
+	 * page_remove_rmap() in try_to_unmap_one(). So to determine page
+	 * status correctly, we store the page flags at this timing.
+	 */
+	page_flags = p->flags;
+
+	/*
 	 * unpoison always clear PG_hwpoison inside page lock
 	 */
 	if (!PageHWPoison(p)) {
@@ -1186,12 +1196,19 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	res = -EBUSY;
-	for (ps = error_states;; ps++) {
-		if ((p->flags & ps->mask) == ps->res) {
-			res = page_action(ps, p, pfn);
+	/*
+	 * The first check uses the current page flag which might not have any
+	 * relevant information. The second check with stored page flags are
+	 * carried out only if the first check can't determine the page status.
+	 */
+	for (ps = error_states;; ps++)
+		if ((p->flags & ps->mask) == ps->res)
 			break;
-		}
-	}
+	if (!ps->mask)
+		for (ps = error_states;; ps++)
+			if ((page_flags & ps->mask) == ps->res)
+				break;
+	res = page_action(ps, p, pfn);
 out:
 	unlock_page(hpage);
 	return res;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

memory-failure-fix-an-error-of-mce_bad_pages-statistics.patch
mm-memory-failurec-clean-up-soft_offline_page.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp.patch
mm-memory-failurec-fix-wrong-num_poisoned_pages-in-handling-memory-error-on-thp-fix.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch
hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages-fix.patch
hwpoison-change-order-of-error_statess-elements.patch

