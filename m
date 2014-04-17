From: akpm@linux-foundation.org
Subject: +
 fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch added to -mm tree
Date: Thu, 17 Apr 2014 13:36:30 -0700
Message-ID: <53503b4e.D8mtilW1aFKufLB4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaDQUgb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 16:36:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tvrtko.ursulin@onelan.co.uk, jack@suse.cz, eparis@redhat.com, xypron.glpk@gmx.de

Subject: + fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch added to -mm tree
To: xypron.glpk@gmx.de,eparis@redhat.com,jack@suse.cz,tvrtko.ursulin@onelan.co.uk
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 13:36:30 -0700


The patch titled
     Subject: fanotify: FAN_MARK_FLUSH: avoid having to provide a fake/invalid fd and path
has been added to the -mm tree.  Its filename is
     fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -811,6 +811,15 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
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
@@ -822,7 +831,7 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
 		mnt = path.mnt;
 
 	/* create/update an inode mark */
-	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE | FAN_MARK_FLUSH)) {
+	switch (flags & (FAN_MARK_ADD | FAN_MARK_REMOVE)) {
 	case FAN_MARK_ADD:
 		if (flags & FAN_MARK_MOUNT)
 			ret = fanotify_add_vfsmount_mark(group, mnt, mask, flags);
@@ -835,12 +844,6 @@ SYSCALL_DEFINE5(fanotify_mark, int, fano
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

fanotify-fan_mark_flush-avoid-having-to-provide-a-fake-invalid-fd-and-path.patch

