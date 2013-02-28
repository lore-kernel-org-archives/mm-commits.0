From: akpm@linux-foundation.org
Subject: [merged] inotify-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:33 -0800
Message-ID: <20130228201533.AC7C85A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58827 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758305Ab3B1UPe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:34 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so261338qaj.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     inotify-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: inotify: convert to idr_alloc()

Convert to the much saner new idr interface.

Note that the adhoc cyclic id allocation is buggy.  If wraparound
happens, the previous code with idr_get_new_above() may segfault and
the converted code will trigger WARN and return -EINVAL.  Even if it's
fixed to wrap to zero, the code will be prone to unnecessary -ENOSPC
failures after the first wraparound.  We probably need to implement
proper cyclic support in idr.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_user.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff -puN fs/notify/inotify/inotify_user.c~inotify-convert-to-idr_alloc fs/notify/inotify/inotify_user.c
--- a/fs/notify/inotify/inotify_user.c~inotify-convert-to-idr_alloc
+++ a/fs/notify/inotify/inotify_user.c
@@ -364,22 +364,20 @@ static int inotify_add_to_idr(struct idr
 {
 	int ret;
 
-	do {
-		if (unlikely(!idr_pre_get(idr, GFP_KERNEL)))
-			return -ENOMEM;
-
-		spin_lock(idr_lock);
-		ret = idr_get_new_above(idr, i_mark, *last_wd + 1,
-					&i_mark->wd);
+	idr_preload(GFP_KERNEL);
+	spin_lock(idr_lock);
+
+	ret = idr_alloc(idr, i_mark, *last_wd + 1, 0, GFP_NOWAIT);
+	if (ret >= 0) {
 		/* we added the mark to the idr, take a reference */
-		if (!ret) {
-			*last_wd = i_mark->wd;
-			fsnotify_get_mark(&i_mark->fsn_mark);
-		}
-		spin_unlock(idr_lock);
-	} while (ret == -EAGAIN);
+		i_mark->wd = ret;
+		*last_wd = i_mark->wd;
+		fsnotify_get_mark(&i_mark->fsn_mark);
+	}
 
-	return ret;
+	spin_unlock(idr_lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 static struct inotify_inode_mark *inotify_idr_find_locked(struct fsnotify_group *group,
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

