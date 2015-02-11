From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:20:43 -0800
Message-ID: <54dbb99b.3osqoYRWcpN/bCvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbBKUUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:20:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: don't recalculate a marks mask if only the ignored mask changed
has been removed from the -mm tree.  Its filename was
     fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: fanotify: don't recalculate a marks mask if only the ignored mask changed

If removing bits from a mark's ignored mask, the concerning
inodes/vfsmounts mask is not affected.  So don't recalculate it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -487,15 +487,16 @@ static __u32 fanotify_mark_remove_from_m
 					    unsigned int flags,
 					    int *destroy)
 {
-	__u32 oldmask;
+	__u32 oldmask = 0;
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
 		oldmask = fsn_mark->mask;
 		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
 	} else {
-		oldmask = fsn_mark->ignored_mask;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, (oldmask & ~mask));
+		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch

