From: akpm@linux-foundation.org
Subject: +
 revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch added to -mm tree
Date: Fri, 24 Apr 2015 10:42:37 -0700
Message-ID: <553a808d.tMp1rMVhqI2gdG9C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbbDXRmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Apr 2015 13:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, torvalds@linux-foundation.org, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "fanotify: don't set FAN_ONDIR implicitly on a marks ignored mask"
has been added to the -mm tree.  Its filename is
     revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch

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
Subject: revert "fanotify: don't set FAN_ONDIR implicitly on a marks ignored mask"

Revert

: commit 66ba93c0d7fe63def447ad0afe380307ff9ebcad
: Author:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
: AuthorDate: Tue Feb 10 14:08:27 2015 -0800
: Commit:     Linus Torvalds <torvalds@linux-foundation.org>
: CommitDate: Tue Feb 10 14:30:28 2015 -0800
: 
:     fanotify: don't set FAN_ONDIR implicitly on a marks ignored mask

Due to the regression reported by Huang Ling
(http://lkml.iu.edu/hypermail/linux/kernel/1504.2/04392.html).

Reported-by: Huang Ying <ying.huang@intel.com>
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -491,17 +491,10 @@ static __u32 fanotify_mark_remove_from_m
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
-		__u32 tmask = fsn_mark->mask & ~mask;
-
-		if (flags & FAN_MARK_ONDIR)
-			tmask &= ~FAN_ONDIR;
-
 		oldmask = fsn_mark->mask;
-		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
+		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask & ~mask;
-		if (flags & FAN_MARK_ONDIR)
-			tmask &= ~FAN_ONDIR;
 
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
@@ -576,22 +569,20 @@ static __u32 fanotify_mark_add_to_mask(s
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
-		__u32 tmask = fsn_mark->mask | mask;
-
-		if (flags & FAN_MARK_ONDIR)
-			tmask |= FAN_ONDIR;
-
 		oldmask = fsn_mark->mask;
-		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
+		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask | mask));
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask | mask;
-		if (flags & FAN_MARK_ONDIR)
-			tmask |= FAN_ONDIR;
-
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}
+
+	if (!(flags & FAN_MARK_ONDIR)) {
+		__u32 tmask = fsn_mark->ignored_mask | FAN_ONDIR;
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
+	}
+
 	spin_unlock(&fsn_mark->lock);
 
 	return mask & ~oldmask;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
revert-fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
linux-next.patch
linux-next-git-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

