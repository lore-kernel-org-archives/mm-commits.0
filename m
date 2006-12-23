From: akpm@osdl.org
Subject: - md-fix-a-few-problems-with-the-interface-sysfs-and-ioctl-to-md.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:55:02 -0800
Message-ID: <200612230755.kBN7t2MM010265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49810 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbWLWHzH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md: fix a few problems with the interface (sysfs and ioctl) to md
has been removed from the -mm tree.  Its filename was
     md-fix-a-few-problems-with-the-interface-sysfs-and-ioctl-to-md.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: md: fix a few problems with the interface (sysfs and ioctl) to md
From: NeilBrown <neilb@suse.de>

While developing more functionality in mdadm I found some bugs in md...

- When we remove a device from an inactive array (write 'remove' to
  the 'state' sysfs file - see 'state_store') would should not
  update the superblock information - as we may not have
  read and processed it all properly yet.

- initialise all raid_disk entries to '-1' else the 'slot sysfs file
  will claim '0' for all devices in an array before the array is
  started.

- all '\n' not to be present at the end of words written to
  sysfs files

- when we use SET_ARRAY_INFO to set the md metadata version,
  set the flag to say that there is persistant metadata.

- allow GET_BITMAP_FILE to be called on an array that hasn't
  been started yet.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/md.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/md/md.c~md-fix-a-few-problems-with-the-interface-sysfs-and-ioctl-to-md drivers/md/md.c
--- a/drivers/md/md.c~md-fix-a-few-problems-with-the-interface-sysfs-and-ioctl-to-md
+++ a/drivers/md/md.c
@@ -1792,7 +1792,8 @@ state_store(mdk_rdev_t *rdev, const char
 		else {
 			mddev_t *mddev = rdev->mddev;
 			kick_rdev_from_array(rdev);
-			md_update_sb(mddev, 1);
+			if (mddev->pers)
+				md_update_sb(mddev, 1);
 			md_new_event(mddev);
 			err = 0;
 		}
@@ -2004,6 +2005,7 @@ static mdk_rdev_t *md_import_device(dev_
 
 	rdev->desc_nr = -1;
 	rdev->saved_raid_disk = -1;
+	rdev->raid_disk = -1;
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;
@@ -2233,7 +2235,6 @@ static int update_raid_disks(mddev_t *md
 static ssize_t
 raid_disks_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	/* can only set raid_disks if array is not yet active */
 	char *e;
 	int rv = 0;
 	unsigned long n = simple_strtoul(buf, &e, 10);
@@ -2631,7 +2632,7 @@ metadata_store(mddev_t *mddev, const cha
 		return -EINVAL;
 	buf = e+1;
 	minor = simple_strtoul(buf, &e, 10);
-	if (e==buf || *e != '\n')
+	if (e==buf || (*e && *e != '\n') )
 		return -EINVAL;
 	if (major >= sizeof(super_types)/sizeof(super_types[0]) ||
 	    super_types[major].name == NULL)
@@ -3980,6 +3981,7 @@ static int set_array_info(mddev_t * mdde
 		mddev->major_version = info->major_version;
 		mddev->minor_version = info->minor_version;
 		mddev->patch_version = info->patch_version;
+		mddev->persistent = !info->not_persistent;
 		return 0;
 	}
 	mddev->major_version = MD_MAJOR_VERSION;
@@ -4304,9 +4306,10 @@ static int md_ioctl(struct inode *inode,
 	 * Commands querying/configuring an existing array:
 	 */
 	/* if we are not initialised yet, only ADD_NEW_DISK, STOP_ARRAY,
-	 * RUN_ARRAY, and SET_BITMAP_FILE are allowed */
+	 * RUN_ARRAY, and GET_ and SET_BITMAP_FILE are allowed */
 	if (!mddev->raid_disks && cmd != ADD_NEW_DISK && cmd != STOP_ARRAY
-			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE) {
+			&& cmd != RUN_ARRAY && cmd != SET_BITMAP_FILE
+	    		&& cmd != GET_BITMAP_FILE) {
 		err = -ENODEV;
 		goto abort_unlock;
 	}
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
igrab-should-check-for-i_clear.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch

