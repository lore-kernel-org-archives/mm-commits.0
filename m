From: akpm@linux-foundation.org
Subject: - md-prevent-duplicates-in-bind_rdev_to_array.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:39 -0700
Message-ID: <200805010925.m419PdDO030227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416AbYEAJ0M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: prevent duplicates in bind_rdev_to_array
has been removed from the -mm tree.  Its filename was
     md-prevent-duplicates-in-bind_rdev_to_array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: prevent duplicates in bind_rdev_to_array
From: Dan Williams <dan.j.williams@intel.com>

Found when trying to reassemble an active externally managed array.  Without
this check we hit the more noisy "sysfs duplicate" warning in the later call
to kobject_add.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/md/md.c~md-prevent-duplicates-in-bind_rdev_to_array drivers/md/md.c
--- a/drivers/md/md.c~md-prevent-duplicates-in-bind_rdev_to_array
+++ a/drivers/md/md.c
@@ -1370,6 +1370,11 @@ static int bind_rdev_to_array(mdk_rdev_t
 		MD_BUG();
 		return -EINVAL;
 	}
+
+	/* prevent duplicates */
+	if (find_rdev(mddev, rdev->bdev->bd_dev))
+		return -EEXIST;
+
 	/* make sure rdev->size exceeds mddev->size */
 	if (rdev->size && (mddev->size == 0 || rdev->size < mddev->size)) {
 		if (mddev->pers) {
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

