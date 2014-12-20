From: akpm@linux-foundation.org
Subject: +
 fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch added
 to -mm tree
Date: Fri, 19 Dec 2014 16:31:51 -0800
Message-ID: <5494c377.ImLdZ1EQ/B3EOQK3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaLTAbw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Dec 2014 19:31:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: LinoSanfilippo@gmx.de, eparis@redhat.com, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fanotify: don't set FAN_ONDIR implicitly on a marks ignored mask
has been added to the -mm tree.  Its filename is
     fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask.patch

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
Subject: fanotify: don't set FAN_ONDIR implicitly on a marks ignored mask

Currently FAN_ONDIR is always set on a mark's ignored mask when the event
mask is extended without FAN_MARK_ONDIR being set.  This may result in
events for directories being ignored unexpectedly for call sequences like

fanotify_mark(fd, FAN_MARK_ADD, FAN_OPEN | FAN_ONDIR , AT_FDCWD, "dir");
fanotify_mark(fd, FAN_MARK_ADD, FAN_CLOSE, AT_FDCWD, "dir");

Also FAN_MARK_ONDIR is only honored when adding events to a mark's mask,
but not for event removal.  Fix both issues by not setting FAN_ONDIR
implicitly on the ignore mask any more.  Instead treat FAN_ONDIR as any
other event flag and require FAN_MARK_ONDIR to be set by the user for both
event mask and ignore mask.  Furthermore take FAN_MARK_ONDIR into account
when set for event removal.

Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify.c      |    2 +-
 fs/notify/fanotify/fanotify_user.c |   24 ++++++++++++++++--------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff -puN fs/notify/fanotify/fanotify.c~fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask fs/notify/fanotify/fanotify.c
--- a/fs/notify/fanotify/fanotify.c~fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask
+++ a/fs/notify/fanotify/fanotify.c
@@ -140,7 +140,7 @@ static bool fanotify_should_send_event(s
 	}
 
 	if (S_ISDIR(path->dentry->d_inode->i_mode) &&
-	    (marks_ignored_mask & FS_ISDIR))
+	    !(marks_mask & FS_ISDIR & ~marks_ignored_mask))
 		return false;
 
 	if (event_mask & marks_mask & ~marks_ignored_mask)
diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-dont-set-fan_ondir-implicitly-on-a-marks-ignored-mask
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -491,10 +491,17 @@ static __u32 fanotify_mark_remove_from_m
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
+		__u32 tmask = fsn_mark->mask & ~mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask &= ~FAN_ONDIR;
+
 		oldmask = fsn_mark->mask;
-		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask & ~mask));
+		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask & ~mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask &= ~FAN_ONDIR;
+
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 	}
 	*destroy = !(fsn_mark->mask | fsn_mark->ignored_mask);
@@ -568,20 +575,21 @@ static __u32 fanotify_mark_add_to_mask(s
 
 	spin_lock(&fsn_mark->lock);
 	if (!(flags & FAN_MARK_IGNORED_MASK)) {
+		__u32 tmask = fsn_mark->mask | mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask |= FAN_ONDIR;
+
 		oldmask = fsn_mark->mask;
-		fsnotify_set_mark_mask_locked(fsn_mark, (oldmask | mask));
+		fsnotify_set_mark_mask_locked(fsn_mark, tmask);
 	} else {
 		__u32 tmask = fsn_mark->ignored_mask | mask;
+		if (flags & FAN_MARK_ONDIR)
+			tmask |= FAN_ONDIR;
+
 		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
 		if (flags & FAN_MARK_IGNORED_SURV_MODIFY)
 			fsn_mark->flags |= FSNOTIFY_MARK_FLAG_IGNORED_SURV_MODIFY;
 	}
-
-	if (!(flags & FAN_MARK_ONDIR)) {
-		__u32 tmask = fsn_mark->ignored_mask | FAN_ONDIR;
-		fsnotify_set_mark_ignored_mask_locked(fsn_mark, tmask);
-	}
