From: akpm@linux-foundation.org
Subject: +
 fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch added to -mm tree
Date: Fri, 19 Dec 2014 16:36:54 -0800
Message-ID: <5494c4a6.0XlaGRi7chobvC1b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44466 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaLTAgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:36:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, LinoSanfilippo@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch

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
Subject: fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes

WARNING: Missing a blank line after declarations
#34: FILE: fs/notify/fanotify/fanotify_user.c:498:
+		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);

total: 0 errors, 1 warnings, 18 lines checked

./patches/fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -495,6 +495,7 @@ static __u32 fanotify_mark_remove_from_m
 		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
lib-bitmap-update-bitmap_onto-to-unsigned-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

