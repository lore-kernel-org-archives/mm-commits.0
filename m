From: akpm@linux-foundation.org
Subject: + fs-isofs-logging-clean-up-fix.patch added to -mm tree
Date: Tue, 17 Jun 2014 16:11:50 -0700
Message-ID: <53a0cb36.wufrdnVDvqRJ6CvV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964837AbaFQXLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jun 2014 19:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be, akpm@linux-foundation.org


The patch titled
     Subject: fs-isofs-logging-clean-up-fix
has been added to the -mm tree.  Its filename is
     fs-isofs-logging-clean-up-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-isofs-logging-clean-up-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-isofs-logging-clean-up-fix.patch

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
Subject: fs-isofs-logging-clean-up-fix

118-column lines make my eyes bleed.

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/compress.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN fs/isofs/compress.c~fs-isofs-logging-clean-up-fix fs/isofs/compress.c
--- a/fs/isofs/compress.c~fs-isofs-logging-clean-up-fix
+++ a/fs/isofs/compress.c
@@ -156,10 +156,15 @@ static loff_t zisofs_uncompress_block(st
 				if (zerr == Z_MEM_ERROR)
 					*errp = -ENOMEM;
 				else {
-					pr_debug("zisofs_inflate returned %d, inode = %lu, page idx = %d, bh idx = %d, avail_in = %d, avail_out = %d\n",
-						 zerr, inode->i_ino, curpage,
-						 curbh, stream.avail_in,
-						 stream.avail_out);
+					pr_debug(
+					       "zisofs: zisofs_inflate returned"
+					       " %d, inode = %lu,"
+					       " page idx = %d, bh idx = %d,"
+					       " avail_in = %d,"
+					       " avail_out = %d\n",
+					       zerr, inode->i_ino, curpage,
+					       curbh, stream.avail_in,
+					       stream.avail_out);
 					*errp = -EIO;
 				}
 				goto inflate_out;
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
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
fs-isofs-logging-clean-up-fix.patch
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

