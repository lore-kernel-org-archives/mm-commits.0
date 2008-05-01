From: akpm@linux-foundation.org
Subject: - md-fix-use-after-free-when-removing-rdev-via-sysfs.patch removed from -mm tree
Date: Thu, 01 May 2008 02:25:27 -0700
Message-ID: <200805010925.m419PRRa030202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332AbYEAJ0W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:26:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, neilb@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     md: fix use after free when removing rdev via sysfs
has been removed from the -mm tree.  Its filename was
     md-fix-use-after-free-when-removing-rdev-via-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: fix use after free when removing rdev via sysfs
From: Dan Williams <dan.j.williams@intel.com>

rdev->mddev is no longer valid upon return from entry->store() when the
'remove' command is given.

Cc: <stable@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/md.c~md-fix-use-after-free-when-removing-rdev-via-sysfs drivers/md/md.c
--- a/drivers/md/md.c~md-fix-use-after-free-when-removing-rdev-via-sysfs
+++ a/drivers/md/md.c
@@ -2097,7 +2097,7 @@ rdev_attr_store(struct kobject *kobj, st
 			rv = -EBUSY;
 		else
 			rv = entry->store(rdev, page, length);
-		mddev_unlock(rdev->mddev);
+		mddev_unlock(mddev);
 	}
 	return rv;
 }
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
fsldma-the-mpc8377mds-board-device-tree-node-for-fsldma-driver.patch

