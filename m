From: akpm@linux-foundation.org
Subject: +
 shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 17 Jun 2014 13:38:12 -0700
Message-ID: <53a0a734.jhfi7nFB20j6Kigl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56187 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964980AbaFQUiN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 16:38:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, akpm@linux-foundation.org


The patch titled
     Subject: shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch

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
Subject: shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes

ERROR: trailing whitespace
#64: FILE: mm/shmem.c:1243:
+^I * wait on i_mutex to be released if vmf->flags permits, $

WARNING: Missing a blank line after declarations
#68: FILE: mm/shmem.c:1247:
+		struct shmem_falloc *shmem_falloc;
+		spin_lock(&inode->i_lock);

total: 1 errors, 1 warnings, 92 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/shmem-fix-faulting-into-a-hole-while-its-punched.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/shmem.c~shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes mm/shmem.c
--- a/mm/shmem.c~shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes
+++ a/mm/shmem.c
@@ -1240,10 +1240,11 @@ static int shmem_fault(struct vm_area_st
 	 * prevent the hole-punch from ever completing: which in turn
 	 * locks writers out with its hold on i_mutex.  So refrain from
 	 * faulting pages into the hole while it's being punched, and
-	 * wait on i_mutex to be released if vmf->flags permits, 
+	 * wait on i_mutex to be released if vmf->flags permits.
 	 */
 	if (unlikely(inode->i_private)) {
 		struct shmem_falloc *shmem_falloc;
+
 		spin_lock(&inode->i_lock);
 		shmem_falloc = inode->i_private;
 		if (!shmem_falloc ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry-checkpatch-fixes.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep-checkpatch-fixes.patch
shmem-fix-faulting-into-a-hole-while-its-punched-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

