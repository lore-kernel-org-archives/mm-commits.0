From: akpm@linux-foundation.org
Subject: [merged]
 fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:42:07 -0700
Message-ID: <5390c80f.5yWiSF+2LBTDGnS6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55515 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFETmI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tvrtko.ursulin@onelan.co.uk, jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de

Subject: [merged] fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch removed from -mm tree
To: xypron.glpk@gmx.de,eparis@redhat.com,jack@suse.cz,tvrtko.ursulin@onelan.co.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:07 -0700


The patch titled
     Subject: fanotify: FAN_MARK_FLUSH: avoid having to provide a fake/invalid fd and path
has been removed from the -mm tree.  Its filename was
     fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: fanotify: FAN_MARK_FLUSH: avoid having to provide a fake/invalid fd and path

Originally from Tvrtko Ursulin (https://lkml.org/lkml/2011/1/12/112)

Avoid having to provide a fake/invalid fd and path when flushing marks

Currently for a group to flush marks it has set it needs to provide a fake
or invalid (but resolvable) file descriptor and path when calling
fanotify_mark.  This patch pulls the flush handling a bit up so file
descriptor and path are completely ignored when flushing.

I reworked the patch to be applicable again (the signature of fanotify_mark
has changed since Tvrtko's work).

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN fs/notify/fanotify/fanotify_user.c~fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path fs/notify/fanotify/fanotify_user.c
--- a/fs/notify/fanotify/fanotify_user.c~fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -813,6 +813,15 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
 	    group->priority == FS_PRIO_0)
 		goto fput_and_out;
 
+	if (flags & FAN_MARK_FLUSH) {
+		ret = 0;
+		if (flags & FAN_MARK_MOUNT)
+			fsnotify_clear_vfsmount_marks_by_group(group);
+		else
+			fsnotify_clear_inode_marks_by_group(group);
+		goto fput_and_out;
+	}
+
 	ret = fanotify_find_path(dfd, pathname, &path, flags);
 	if (ret)
 		goto fput_and_out;
@@ -824,7 +833,7 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
 		mnt = path.mnt;
 
 	/* create/update an inode mark */
-	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
+	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE)) {
 	case FAN_MARK_ADD:
 		if (flags & FAN_MARK_MOUNT)
 			ret = fanotify_add_vfsmount_mark(group, mnt, mask, flags);
@@ -837,12 +846,6 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
 		else
 			ret = fanotify_remove_inode_mark(group, inode, mask, flags);
 		break;
-	case FAN_MARK_FLUSH:
-		if (flags & FAN_MARK_MOUNT)
-			fsnotify_clear_vfsmount_marks_by_group(group);
-		else
-			fsnotify_clear_inode_marks_by_group(group);
-		break;
 	default:
 		ret = -EINVAL;
 	}
_

Patches currently in -mm which might be from xypron.glpk@gmx.de are

origin.patch
linux-next.patch

