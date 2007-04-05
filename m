From: akpm@linux-foundation.org
Subject: - md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:07:16 -0700
Message-ID: <200704050207.l3527GiF004949@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38174 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbXDECHV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:07:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs fix
has been removed from the -mm tree.  Its filename was
     md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch

This patch was dropped because it was folded into md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch

------------------------------------------------------
Subject: md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs fix
From: Neil Brown <neilb@suse.de>

Avoid a deadlock when removing a device from an md array via sysfs. - fix

Make sure any delayed_delete calls finish before module unload.
For simplicity, flush the queue when we stop the array.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/md/md.c~md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix drivers/md/md.c
--- a/drivers/md/md.c~md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix
+++ a/drivers/md/md.c
@@ -3400,6 +3400,9 @@ static int do_md_stop(mddev_t * mddev, i
 				sysfs_remove_link(&mddev->kobj, nm);
 			}
 
+		/* make sure all delayed_delete calls have finished */
+		flush_scheduled_work();
+
 		export_array(mddev);
 
 		mddev->array_size = 0;
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs.patch
md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch
net-sunrpc-svcsockc-fix-a-check.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
fix-__d_path-for-lazy-unmounts-and-make-it-unambiguous.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
