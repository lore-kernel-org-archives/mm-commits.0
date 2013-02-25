From: akpm@linux-foundation.org
Subject: [merged] hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:55:34 -0800
Message-ID: <20130225205534.D91635A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62681 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759774Ab3BYUzg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:55:36 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so347542ghb.5
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:55:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: HWPOISON: fix misjudgement of page_action() for errors on mlocked pages
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-misjudgement-of-page_action-for-errors-on-mlocked-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: tweak comments]
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
+	 * We use page flags to determine what action should be taken, but
+	 * the flags can be modified by the error containment action.  One
+	 * example is an mlocked page, where PG_mlocked is cleared by
+	 * page_remove_rmap() in try_to_unmap_one(). So to determine page status
+	 * correctly, we save a copy of the page flags at this time.
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
+	 * The first check uses the current page flags which may not have any
+	 * relevant information. The second check with the saved page flagss is
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

origin.patch

