From: akpm@linux-foundation.org
Subject: [folded-merged]
 fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 10 Feb 2015 13:59:46 -0800
Message-ID: <54da7f52.p2pzAmt1eR8/CwVa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbbBJV7r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Feb 2015 16:59:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, LinoSanfilippo@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes.patch

This patch was dropped because it was folded into fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes

WARNING: Missing a blank line after declarations
#48: FILE: fs/notify/fanotify/fanotify_user.c:495:
+		__u32 tmask = fsn_mark->mask & ~mask;
+		if (flags & FAN_MARK_ONDIR)

WARNING: Missing a blank line after declarations
#67: FILE: fs/notify/fanotify/fanotify_user.c:579:
+		__u32 tmask = fsn_mark->mask | mask;
+		if (flags & FAN_MARK_ONDIR)

total: 0 errors, 2 warnings, 54 lines checked

./patches/fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask-checkpatch-fixes
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -492,6 +492,7 @@ static __u32 fanotify_mark_remove_from_m
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		__u32 tmask = fsn_mark->mask & ~mask;
+
 		if (flags & FAN_MARK_ONDIR)
 			tmask &= ~FAN_ONDIR;
 
@@ -576,6 +577,7 @@ static __u32 fanotify_mark_add_to_mask(s
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		__u32 tmask = fsn_mark->mask | mask;
+
 		if (flags & FAN_MARK_ONDIR)
 			tmask |= FAN_ONDIR;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
mm-vmstatc-fix-cleanup-ifdefs.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub-fix.patch

