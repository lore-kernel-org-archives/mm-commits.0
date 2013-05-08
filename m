From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch added to -mm tree
Date: Wed, 08 May 2013 12:28:02 -0700
Message-ID: <20130508192802.96B2E31C078@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:34138 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3EHT2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 15:28:03 -0400
Received: by mail-ye0-f202.google.com with SMTP id r13so213653yen.3
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 12:28:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, holt@sgi.com, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix

tweak comments

Cc: Robin Holt <holt@sgi.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix
+++ a/mm/mmu_notifier.c
@@ -46,11 +46,10 @@ void __mmu_notifier_release(struct mm_st
 	id = srcu_read_lock(&srcu);
 	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist)
 		/*
-		 * if ->release runs before mmu_notifier_unregister it
-		 * must be handled as it's the only way for the driver
-		 * to flush all existing sptes and stop the driver
-		 * from establishing any more sptes before all the
-		 * pages in the mm are freed.
+		 * If ->release runs before mmu_notifier_unregister it must be
+		 * handled, as it's the only way for the driver to flush all
+		 * existing sptes and stop the driver from establishing any more
+		 * sptes before all the pages in the mm are freed.
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
@@ -63,22 +62,22 @@ void __mmu_notifier_release(struct mm_st
 				 hlist);
 		/*
 		 * We arrived before mmu_notifier_unregister so
-		 * mmu_notifier_unregister will do nothing other than
-		 * to wait ->release to finish and
-		 * mmu_notifier_unregister to return.
+		 * mmu_notifier_unregister will do nothing other than to wait
+		 * for ->release to finish and for mmu_notifier_unregister to
+		 * return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	/*
-	 * synchronize_srcu here prevents mmu_notifier_release to
-	 * return to exit_mmap (which would proceed freeing all pages
-	 * in the mm) until the ->release method returns, if it was
-	 * invoked by mmu_notifier_unregister.
+	 * synchronize_srcu here prevents mmu_notifier_release from returning to
+	 * exit_mmap (which would proceed with freeing all pages in the mm)
+	 * until the ->release method returns, if it was invoked by
+	 * mmu_notifier_unregister.
 	 *
-	 * The mmu_notifier_mm can't go away from under us because one
-	 * mm_count is hold by exit_mmap.
+	 * The mmu_notifier_mm can't go away from under us because one mm_count
+	 * is held by exit_mmap.
 	 */
 	synchronize_srcu(&srcu);
 }
@@ -291,16 +290,15 @@ void mmu_notifier_unregister(struct mmu_
 
 	if (!hlist_unhashed(&mn->hlist)) {
 		/*
-		 * SRCU here will force exit_mmap to wait ->release to finish
-		 * before freeing the pages.
+		 * SRCU here will force exit_mmap to wait for ->release to
+		 * finish before freeing the pages.
 		 */
 		int id;
 
 		id = srcu_read_lock(&srcu);
 		/*
-		 * exit_mmap will block in mmu_notifier_release to
-		 * guarantee ->release is called before freeing the
-		 * pages.
+		 * exit_mmap will block in mmu_notifier_release to guarantee
+		 * that ->release is called before freeing the pages.
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
@@ -316,7 +314,7 @@ void mmu_notifier_unregister(struct mmu_
 	}
 
 	/*
-	 * Wait any running method to finish, of course including
+	 * Wait for any running method to finish, of course including
 	 * ->release if it was run by mmu_notifier_relase instead of us.
 	 */
 	synchronize_srcu(&srcu);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
drivers-video-implement-a-simple-framebuffer-driver.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm.patch
clear_refs-sanitize-accepted-commands-declaration.patch
include-linux-mmzoneh-cleanups.patch
include-linux-mmzoneh-cleanups-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
generic-dynamic-per-cpu-refcounting.patch
block-prep-work-for-batch-completion.patch
block-prep-work-for-batch-completion-fix-2.patch
block-prep-work-for-batch-completion-fix-3.patch
block-prep-work-for-batch-completion-fix-3-fix.patch
block-prep-work-for-batch-completion-fix-99.patch
block-aio-batch-completion-for-bios-kiocbs-fix.patch
block-aio-batch-completion-for-bios-kiocbs.patch
lib-add-lz4-compressor-module-fix.patch
crypto-add-lz4-cryptographic-api-fix.patch
bpf-add-comments-explaining-the-schedule_work-operation.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

