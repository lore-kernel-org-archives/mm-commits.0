From: akpm@linux-foundation.org
Subject: - md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:29:07 -0700
Message-ID: <200803212029.m2LKT7Hl008841@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754934AbYCUU3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: remove the 'super' sysfs attribute from devices in an 'md' array
has been removed from the -mm tree.  Its filename was
     md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: md: remove the 'super' sysfs attribute from devices in an 'md' array
From: NeilBrown <neilb@suse.de>

Exposing the binary blob which is the md 'super-block' via sysfs
doesn't really fit with the sysfs model, and since commit

   8118a859dc7abd873193986c77a8d9bdb877adc8

it doesn't actually work at all (as the size of the blob is often one page).

(akpm: as in, fs/sysfs/file.c:fill_read_buffer() goes BUG)

So just remove it altogether.  It isn't really useful.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |   12 ------------
 1 file changed, 12 deletions(-)

diff -puN drivers/md/md.c~md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array drivers/md/md.c
--- a/drivers/md/md.c~md-remove-the-super-sysfs-attribute-from-devices-in-an-md-array
+++ a/drivers/md/md.c
@@ -1864,17 +1864,6 @@ static struct rdev_sysfs_entry rdev_stat
 __ATTR(state, S_IRUGO|S_IWUSR, state_show, state_store);
 
 static ssize_t
-super_show(mdk_rdev_t *rdev, char *page)
-{
-	if (rdev->sb_loaded && rdev->sb_size) {
-		memcpy(page, page_address(rdev->sb_page), rdev->sb_size);
-		return rdev->sb_size;
-	} else
-		return 0;
-}
-static struct rdev_sysfs_entry rdev_super = __ATTR_RO(super);
