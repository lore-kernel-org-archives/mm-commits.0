From: akpm@linux-foundation.org
Subject: + nbd-do-not-allow-two-clients-at-the-same-time.patch added to -mm tree
Date: Tue, 13 Jan 2009 14:20:31 -0800
Message-ID: <200901132220.n0DMKVMU024571@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874AbZAMWVE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 17:21:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, paul.clements@steeleye.com


The patch titled
     nbd: do not allow two clients at the same time
has been added to the -mm tree.  Its filename is
     nbd-do-not-allow-two-clients-at-the-same-time.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

lis3lv02d-merge-with-leds-hp-disk.patch
maintainers-add-entry-for-freezer.patch
hp_accel-do-not-call-acpi-from-invalid-context.patch
hp_accel-do-not-call-acpi-from-invalid-context-fix.patch
nbd-do-not-allow-two-clients-at-the-same-time.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
nbd-trivial-cleanups.patch

