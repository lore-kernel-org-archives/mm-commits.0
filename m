From: akpm@linux-foundation.org
Subject: + md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch added to -mm tree
Date: Mon, 02 Apr 2007 01:01:57 -0700
Message-ID: <200704020801.l3281vMB027936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.osdl.org ([65.172.181.25]:46088 "EHLO smtp1.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbXDBIPK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 04:15:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, stern@rowland.harvard.edu


The patch titled
     md: avoid a deadlock when removing a device from an md array via sysfs
has been added to the -mm tree.  Its filename is
     md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: md: avoid a deadlock when removing a device from an md array via sysfs
From: NeilBrown <neilb@suse.de>

A device can be removed from an md array via e.g.
  echo remove > /sys/block/md3/md/dev-sde/state

This will try to remove the 'dev-sde' subtree which will deadlock
since
  commit e7b0d26a86943370c04d6833c6edba2a72a6e240

With this patch we run the kobject_del via schedule_work so as to
avoid the deadlock.

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c           |   13 ++++++++++++-
 include/linux/raid/md_k.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs drivers/md/md.c
--- a/drivers/md/md.c~md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs
+++ a/drivers/md/md.c
@@ -1378,6 +1378,12 @@ static int bind_rdev_to_array(mdk_rdev_t
 	return err;
 }
 
+static void delayed_delete(struct work_struct *ws)
+{
+	mdk_rdev_t *rdev = container_of(ws, mdk_rdev_t, del_work);
+	kobject_del(&rdev->kobj);
+}
+
 static void unbind_rdev_from_array(mdk_rdev_t * rdev)
 {
 	char b[BDEVNAME_SIZE];
@@ -1390,7 +1396,12 @@ static void unbind_rdev_from_array(mdk_r
 	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
-	kobject_del(&rdev->kobj);
+
+	/* We need to delay this, otherwise we can deadlock when
+	 * writing to 'remove' to "dev/state"
+	 */
+	INIT_WORK(&rdev->del_work, delayed_delete);
+	schedule_work(&rdev->del_work);
 }
 
 /*
diff -puN include/linux/raid/md_k.h~md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs include/linux/raid/md_k.h
--- a/include/linux/raid/md_k.h~md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs
+++ a/include/linux/raid/md_k.h
@@ -104,6 +104,7 @@ struct mdk_rdev_s
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
+	struct work_struct del_work;	/* used for delayed sysfs removal */
 };
 
 struct mddev_s
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
