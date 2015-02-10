From: akpm@linux-foundation.org
Subject: [folded-merged]
 fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Feb 2015 13:59:24 -0800
Message-ID: <54da7f3c.a+RL3wffz4axjxah%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbBJV7Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 16:59:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, LinoSanfilippo@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed-checkpatch-fixes.patch

This patch was dropped because it was folded into fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch

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
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch

