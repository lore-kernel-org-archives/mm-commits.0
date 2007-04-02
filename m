From: akpm@linux-foundation.org
Subject: + md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch added to -mm tree
Date: Mon, 02 Apr 2007 14:13:31 -0700
Message-ID: <200704022113.l32LDVqt009589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45927 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965913AbXDBVNf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 17:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs fix
has been added to the -mm tree.  Its filename is
     md-avoid-a-deadlock-when-removing-a-device-from-an-md-array-via-sysfs-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
