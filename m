From: akpm@linux-foundation.org
Subject: + mm-remove-unused-page-flags.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:52:43 -0800
Message-ID: <200703151852.l2FIqjAc023400@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35718 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbXCOSww (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, pavel@ucw.cz


The patch titled
     mm: remove unused page flags
has been added to the -mm tree.  Its filename is
     mm-remove-unused-page-flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: remove unused page flags
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove the two page flags that were previously used by swsusp and are no
longer needed.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN include/linux/page-flags.h~mm-remove-unused-page-flags include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-remove-unused-page-flags
+++ a/include/linux/page-flags.h
@@ -82,13 +82,11 @@
 #define PG_private		11	/* If pagecache, has fs-private data */
 
 #define PG_writeback		12	/* Page is under writeback */
-#define PG_nosave		13	/* Used for system suspend/resume */
 #define PG_compound		14	/* Part of a compound page */
 #define PG_swapcache		15	/* Swap page: swp_entry_t in private */
 
 #define PG_mappedtodisk		16	/* Has blocks allocated on-disk */
 #define PG_reclaim		17	/* To be reclaimed asap */
-#define PG_nosave_free		18	/* Used for system suspend/resume */
 #define PG_buddy		19	/* Page is free, on buddy lists */
 
 /* PG_owner_priv_1 users should have descriptive aliases */
@@ -214,16 +212,6 @@ static inline void SetPageUptodate(struc
 		ret;							\
 	})
 
-#define PageNosave(page)	test_bit(PG_nosave, &(page)->flags)
-#define SetPageNosave(page)	set_bit(PG_nosave, &(page)->flags)
-#define TestSetPageNosave(page)	test_and_set_bit(PG_nosave, &(page)->flags)
-#define ClearPageNosave(page)		clear_bit(PG_nosave, &(page)->flags)
-#define TestClearPageNosave(page)	test_and_clear_bit(PG_nosave, &(page)->flags)
-
-#define PageNosaveFree(page)	test_bit(PG_nosave_free, &(page)->flags)
-#define SetPageNosaveFree(page)	set_bit(PG_nosave_free, &(page)->flags)
-#define ClearPageNosaveFree(page)		clear_bit(PG_nosave_free, &(page)->flags)
-
 #define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
 #define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
 #define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
_

Patches currently in -mm which might be from rjw@sisk.pl are

swsusp-fix-resume-error-path-in-platform-mode.patch
swsusp-disable-nonboot-cpus-before-entering-platform-suspend.patch
swsusp-disable-nonboot-cpus-before-entering-platform-suspend-update.patch
software-suspend-fix-suspend-when-console-is-in.patch
software-suspend-fix-suspend-when-console-is-in-tidy.patch
make-xfs-workqueues-nonfreezable.patch
swsusp-use-inline-functions-for-changing-page-flags.patch
swsusp-do-not-use-page-flags.patch
mm-remove-unused-page-flags.patch
fix-refrigerator-vs-thaw_process-race.patch
freezer-task-exit_state-should-be-treated-as-bolean.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
freezer-read-pf_borrowed_mm-in-a-nonracy-way.patch
freezer-close-theoretical-race-between-refrigerator-and-thaw_tasks.patch
freezer-remove-pf_nofreeze-from-rcutorture-thread.patch
freezer-remove-pf_nofreeze-from-bluetooth-threads.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
freezer-fix-vfork-problem.patch
freezer-take-kernel_execve-into-consideration.patch
shrink_slab-handle-bad-shrinkers.patch
