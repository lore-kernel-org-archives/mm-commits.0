From: akpm@linux-foundation.org
Subject: [merged] nbd-do-not-allow-two-clients-at-the-same-time.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:17:06 -0800
Message-ID: <200901161917.n0GJH62P025671@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937436AbZAPTX1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:23:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: do not allow two clients at the same time
has been removed from the -mm tree.  Its filename was
     nbd-do-not-allow-two-clients-at-the-same-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: do not allow two clients at the same time
From: Pavel Machek <pavel@suse.cz>

Two nbd-clients at same time are bad idea, and cause WARN_ON from nbd in
2.6.28-rc7 from sysfs_add_one.  This simply prevents that from happening.

To reproduce:

 cat /dev/zero | head -c 10000000 > /tmp/delme.fstest.fs
 nbd-server 9100 -l /anyone.can.connect > /tmp/delme.fstest.fs &
 sleep 1
 nbd-client localhost 9100 /dev/nd0 &
 nbd-client localhost 9100 /dev/nd0 &

Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/block/nbd.c~nbd-do-not-allow-two-clients-at-the-same-time drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-do-not-allow-two-clients-at-the-same-time
+++ a/drivers/block/nbd.c
@@ -406,6 +406,7 @@ static int nbd_do_it(struct nbd_device *
 	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		lo->pid = 0;
 		return ret;
 	}
 
@@ -413,6 +414,7 @@ static int nbd_do_it(struct nbd_device *
 		nbd_end_request(req);
 
 	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	lo->pid = 0;
 	return 0;
 }
 
@@ -648,6 +650,8 @@ static int nbd_ioctl(struct block_device
 		set_capacity(lo->disk, lo->bytesize >> 9);
 		return 0;
 	case NBD_DO_IT:
+		if (lo->pid)
+			return -EBUSY;
 		if (!lo->file)
 			return -EINVAL;
 		thread = kthread_create(nbd_thread, lo, lo->disk->disk_name);
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
resume-wait-for-device-probing-to-finish.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
nbd-trivial-cleanups.patch

