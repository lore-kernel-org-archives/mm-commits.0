From: akpm@linux-foundation.org
Subject: - md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:01 -0800
Message-ID: <200802070029.m170TgKt007304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764520AbYBGAnl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:43:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     md: fix use-after-free bug when dropping an rdev from an md array
has been removed from the -mm tree.  Its filename was
     md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix use-after-free bug when dropping an rdev from an md array
From: NeilBrown <neilb@suse.de>

Due to possible deadlock issues we need to use a schedule work to kobject_del
an 'rdev' object from a different thread.

A recent change means that kobject_add no longer gets a refernce, and
kobject_del doesn't put a reference.  Consequently, we need to explicitly hold
a reference to ensure that the last reference isn't dropped before the
scheduled work get a chance to call kobject_del.

Also, rename delayed_delete to md_delayed_delete to that it is more obvious in
a stack trace which code is to blame.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/md/md.c~md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array drivers/md/md.c
--- a/drivers/md/md.c~md-fix-use-after-free-bug-when-dropping-an-rdev-from-an-md-array
+++ a/drivers/md/md.c
@@ -1419,10 +1419,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 	return err;
 }
 
-static void delayed_delete(struct work_struct *ws)
+static void md_delayed_delete(struct work_struct *ws)
 {
 	mdk_rdev_t *rdev = container_of(ws, mdk_rdev_t, del_work);
 	kobject_del(&rdev->kobj);
+	kobject_put(&rdev->kobj);
 }
 
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
@@ -1441,7 +1442,8 @@ static void unbind_rdev_from_array(mdk_r
 	/* We need to delay this, otherwise we can deadlock when
 	 * writing to 'remove' to "dev/state"
 	 */
-	INIT_WORK(&rdev->del_work, delayed_delete);
+	INIT_WORK(&rdev->del_work, md_delayed_delete);
+	kobject_get(&rdev->kobj);
 	schedule_work(&rdev->del_work);
 }
 
@@ -3686,7 +3688,7 @@ static int do_md_stop(mddev_t * mddev, i
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
 
-		/* make sure all delayed_delete calls have finished */
+		/* make sure all md_delayed_delete calls have finished */
 		flush_scheduled_work();
 
 		export_array(mddev);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
one-less-parameter-to-__d_path.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
d_path-make-d_path-use-a-struct-path-fix.patch
