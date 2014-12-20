From: akpm@linux-foundation.org
Subject: +
 fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch added to -mm tree
Date: Fri, 19 Dec 2014 16:31:49 -0800
Message-ID: <5494c375.45OO3ennjVMRNQAE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbaLTAbu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:31:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: don't recalculate a marks mask if only the ignored mask changed
has been added to the -mm tree.  Its filename is
     fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: fanotify: don't recalculate a marks mask if only the ignored mask changed

If removing bits from a mark's ignored mask, the concerning
inodes/vfsmounts mask is not affected.  So don't recalculate it.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -487,15 +487,15 @@ static __u32 fanotify_mark_remove_from_m
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
+		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
 	spin_unlock(&fsn_mark->lock);
_

Patches currently in -mm which might be from LinoSanfilippo@gmx.de are

origin.patch
fanotify-only-destroy-mark-when-both-mask-and-ignored_mask-are-cleared.patch
fanotify-dont-recalculate-a-marks-mask-if-only-the-ignored-mask-changed.patch
fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
linux-next.patch

