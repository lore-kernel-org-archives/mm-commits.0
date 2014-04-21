From: akpm@linux-foundation.org
Subject: + ocfs2-limit-printk-when-journal-is-aborted-fix.patch added to
 -mm tree
Date: Mon, 21 Apr 2014 12:18:32 -0700
Message-ID: <53556f08.1XOgZwH3VlCTRqaF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaDUTSd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 15:18:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, akpm@linux-foundation.org

Subject: + ocfs2-limit-printk-when-journal-is-aborted-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 12:18:32 -0700


The patch titled
     Subject: ocfs2-limit-printk-when-journal-is-aborted-fix
has been added to the -mm tree.  Its filename is
     ocfs2-limit-printk-when-journal-is-aborted-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-limit-printk-when-journal-is-aborted-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-limit-printk-when-journal-is-aborted-fix.patch

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
Subject: ocfs2-limit-printk-when-journal-is-aborted-fix

document the msleep

Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/journal.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted-fix fs/ocfs2/journal.c
--- a/fs/ocfs2/journal.c~ocfs2-limit-printk-when-journal-is-aborted-fix
+++ a/fs/ocfs2/journal.c
@@ -2193,6 +2193,11 @@ static int ocfs2_commit_thread(void *arg
 			if (printk_timed_ratelimit(&abort_warn_time, 60*HZ))
 				mlog(ML_ERROR, "status = %d, journal is "
 						"already aborted.\n", status);
+			/*
+			 * After ocfs2_commit_cache() fails, j_num_trans has a
+			 * non-zero value.  Sleep here to avoid a busy-wait
+			 * loop.
+			 */
 			msleep_interruptible(1000);
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-gupc-tweaks.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

