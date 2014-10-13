From: akpm@linux-foundation.org
Subject: [merged]
 fsnotify-dont-put-user-context-if-it-was-never-assigned.patch removed from
 -mm tree
Date: Mon, 13 Oct 2014 11:17:15 -0700
Message-ID: <543c172b.lHvxmxSlbA164bYF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbaJMSRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, eparis@parisplace.org, jack@suse.cz, john@johnmccutchan.com, rlove@rlove.org, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: fsnotify: don't put user context if it was never assigned
has been removed from the -mm tree.  Its filename was
     fsnotify-dont-put-user-context-if-it-was-never-assigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: fsnotify: don't put user context if it was never assigned

On some failure paths we may attempt to free user context even if it
wasn't assigned yet.  This will cause a NULL ptr deref and a kernel BUG.

The path I was looking at is in inotify_new_group():

        oevent = kmalloc(sizeof(struct inotify_event_info), GFP_KERNEL);
        if (unlikely(!oevent)) {
                fsnotify_destroy_group(group);
                return ERR_PTR(-ENOMEM);
        }

fsnotify_destroy_group() would get called here, but
group->inotify_data.user is only getting assigned later:

	group->inotify_data.user = get_current_user();

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>
Reviewed-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/inotify/inotify_fsnotify.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/notify/inotify/inotify_fsnotify.c~fsnotify-dont-put-user-context-if-it-was-never-assigned fs/notify/inotify/inotify_fsnotify.c
--- a/fs/notify/inotify/inotify_fsnotify.c~fsnotify-dont-put-user-context-if-it-was-never-assigned
+++ a/fs/notify/inotify/inotify_fsnotify.c
@@ -165,8 +165,10 @@ static void inotify_free_group_priv(stru
 	/* ideally the idr is empty and we won't hit the BUG in the callback */
 	idr_for_each(&group->inotify_data.idr, idr_callback, group);
 	idr_destroy(&group->inotify_data.idr);
-	atomic_dec(&group->inotify_data.user->inotify_devs);
-	free_uid(group->inotify_data.user);
+	if (group->inotify_data.user) {
+		atomic_dec(&group->inotify_data.user->inotify_devs);
+		free_uid(group->inotify_data.user);
+	}
 }
 
 static void inotify_free_event(struct fsnotify_event *fsn_event)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
kernel-add-support-for-gcc-5.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

