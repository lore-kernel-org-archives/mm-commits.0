From: akpm@linux-foundation.org
Subject: - device-suspend-debug.patch removed from -mm tree
Date: Fri, 12 Oct 2007 14:43:30 -0700
Message-ID: <200710122143.l9CLhUoM004807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757662AbXJLVnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 17:43:33 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9CLhVgM000804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 12 Oct 2007 14:43:32 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     device_suspend() debugging
has been removed from the -mm tree.  Its filename was
     device-suspend-debug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: device_suspend() debugging
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/suspend.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/base/power/suspend.c~device-suspend-debug drivers/base/power/suspend.c
--- a/drivers/base/power/suspend.c~device-suspend-debug
+++ a/drivers/base/power/suspend.c
@@ -136,6 +136,8 @@ int device_suspend(pm_message_t state)
 		get_device(dev);
 		mutex_unlock(&dpm_list_mtx);
 
+		printk("Suspending device %s\n", kobject_name(&dev->kobj));
+
 		error = suspend_device(dev, state);
 
 		mutex_lock(&dpm_list_mtx);
_

Patches currently in -mm which might be from akpm@osdl.org are

update-smc91x-driver-with-arm-versatile-board-info.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
ext2-reservations.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
