From: akpm@linux-foundation.org
Subject: - md-lock-access-to-rdev-attributes-properly.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:31 -0800
Message-ID: <200803050746.m257kV5T021778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764558AbYCEHqg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: lock access to rdev attributes properly
has been removed from the -mm tree.  Its filename was
     md-lock-access-to-rdev-attributes-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: lock access to rdev attributes properly
From: NeilBrown <neilb@suse.de>

When we access attributes of an rdev (component device on an md array) through
sysfs, we really need to lock the array against concurrent changes.  We
currently do that when we change an attribute, but not when we read an
attribute.  We need to lock when reading as well else rdev->mddev could become
NULL while we are accessing it.

So add appropriate locking (mddev_lock) to rdev_attr_show.

rdev_size_store requires some extra care as well as it needs to unlock the
mddev while scanning other mddevs for overlapping regions.  We currently
assume that rdev->mddev will still be unchanged after the scan, but that
cannot be certain.  So take a copy of rdev->mddev for use at the end of the
function.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff -puN drivers/md/md.c~md-lock-access-to-rdev-attributes-properly drivers/md/md.c
--- a/drivers/md/md.c~md-lock-access-to-rdev-attributes-properly
+++ a/drivers/md/md.c
@@ -2001,9 +2001,11 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	char *e;
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	unsigned long long oldsize = rdev->size;
+	mddev_t *my_mddev = rdev->mddev;
+
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
+	if (my_mddev->pers)
 		return -EBUSY;
 	rdev->size = size;
 	if (size > oldsize && rdev->mddev->external) {
@@ -2016,7 +2018,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 		int overlap = 0;
 		struct list_head *tmp, *tmp2;
 
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(my_mddev);
 		for_each_mddev(mddev, tmp) {
 			mdk_rdev_t *rdev2;
 
@@ -2036,7 +2038,7 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 				break;
 			}
 		}
-		mddev_lock(rdev->mddev);
+		mddev_lock(my_mddev);
 		if (overlap) {
 			/* Someone else could have slipped in a size
 			 * change here, but doing so is just silly.
@@ -2048,8 +2050,8 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 			return -EBUSY;
 		}
 	}
-	if (size < rdev->mddev->size || rdev->mddev->size == 0)
-		rdev->mddev->size = size;
+	if (size < my_mddev->size || my_mddev->size == 0)
+		my_mddev->size = size;
 	return len;
 }
 
@@ -2070,10 +2072,21 @@ rdev_attr_show(struct kobject *kobj, str
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
+	mddev_t *mddev = rdev->mddev;
+	ssize_t rv;
 
 	if (!entry->show)
 		return -EIO;
-	return entry->show(rdev, page);
+
+	rv = mddev ? mddev_lock(mddev) : -EBUSY;
+	if (!rv) {
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->show(rdev, page);
+		mddev_unlock(mddev);
+	}
+	return rv;
 }
 
 static ssize_t
@@ -2082,15 +2095,19 @@ rdev_attr_store(struct kobject *kobj, st
 {
 	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
 	mdk_rdev_t *rdev = container_of(kobj, mdk_rdev_t, kobj);
-	int rv;
+	ssize_t rv;
+	mddev_t *mddev = rdev->mddev;
 
 	if (!entry->store)
 		return -EIO;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	rv = mddev_lock(rdev->mddev);
+	rv = mddev ? mddev_lock(mddev): -EBUSY;
 	if (!rv) {
-		rv = entry->store(rdev, page, length);
+		if (rdev->mddev == NULL)
+			rv = -EBUSY;
+		else
+			rv = entry->store(rdev, page, length);
 		mddev_unlock(rdev->mddev);
 	}
 	return rv;
_

Patches currently in -mm which might be from neilb@suse.de are

git-nfsd.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch

