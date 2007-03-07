From: akpm@linux-foundation.org
Subject: - fix-2621-rfcomm-lockups.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:21:03 -0800
Message-ID: <200703070421.l274L3ji018860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47022 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161303AbXCGEV2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:21:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkml@rtr.ca, cornelia.huck@de.ibm.com, davem@sunset.davemloft.net, greg@kroah.com, marcel@holtmann.org, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     Fix 2.6.21 rfcomm lockups
has been removed from the -mm tree.  Its filename was
     fix-2621-rfcomm-lockups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix 2.6.21 rfcomm lockups
From: Mark Lord <lkml@rtr.ca>

Any attempt to open/use a bluetooth rfcomm device locks up
scheduling completely on my machine.

Interrupts (ping, alt-sysrq) seem to be alive, but nothing else.

This was working fine in 2.6.20, broken now in 2.6.21-rc2-git*

Reverting this change (below) fixes it:

| author    Marcel Holtmann <marcel@holtmann.org>
|      Sat, 17 Feb 2007 22:58:57 +0000 (23:58 +0100)
| committer    David S. Miller <davem@sunset.davemloft.net>
|      Mon, 26 Feb 2007 19:42:41 +0000 (11:42 -0800)
| commit    c1a3313698895d8ad4760f98642007bf236af2e8
| tree    337a876f727061362b6a169f8759849c105b8f7a    tree | snapshot
| parent    f5ffd4620aba9e55656483ae1ef5c79ba81f5403    commit | diff
| | [Bluetooth] Make use of device_move() for RFCOMM TTY devices
| | In the case of bound RFCOMM TTY devices the parent is not available
| before its usage. So when opening a RFCOMM TTY device, move it to
| the corresponding ACL device as a child. When closing the device,
| move it back to the virtual device tree.
| Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

The simplest fix for this bug is to prevent sysfs_move_dir()
from self-deadlocking when (old_parent == new_parent).

This patch prevents total system lockup when using rfcomm devices.

Signed-off-by:  Mark Lord <mlord@pobox.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/sysfs/dir.c~fix-2621-rfcomm-lockups fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~fix-2621-rfcomm-lockups
+++ a/fs/sysfs/dir.c
@@ -431,6 +431,8 @@ int sysfs_move_dir(struct kobject *kobj,
 	new_parent_dentry = new_parent ?
 		new_parent->dentry : sysfs_mount->mnt_sb->s_root;
 
+	if (old_parent_dentry->d_inode == new_parent_dentry->d_inode)
+		return 0;	/* nothing to move */
 again:
 	mutex_lock(&old_parent_dentry->d_inode->i_mutex);
 	if (!mutex_trylock(&new_parent_dentry->d_inode->i_mutex)) {
_

Patches currently in -mm which might be from lkml@rtr.ca are

origin.patch
