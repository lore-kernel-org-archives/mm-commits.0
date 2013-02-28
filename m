From: akpm@linux-foundation.org
Subject: [merged] inotify-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:51 -0800
Message-ID: <20130228201252.16DB231C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:38046 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab3B1UMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:53 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so245088qea.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, eparis@parisplace.org, john@johnmccutchan.com, rlove@rlove.org, mm-commits@vger.kernel.org


The patch titled
     Subject: inotify: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     inotify-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: inotify: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_fsnotify.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/notify/inotify/inotify_fsnotify.c~inotify-dont-use-idr_remove_all fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~inotify-dont-use-idr_remove_all
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -197,7 +197,6 @@ static void inotify_free_group_priv(stru
 {
 	/* ideally the idr is empty and we won't hit the BUG in the callback */
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
-	idr_remove_all(&group->inotify_data.idr);
 	idr_destroy(&group->inotify_data.idr);
 	atomic_dec(&group->inotify_data.user->inotify_devs);
 	free_uid(group->inotify_data.user);
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

