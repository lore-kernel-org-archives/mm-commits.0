From: akpm@linux-foundation.org
Subject: + 9p-return-on-mutex_lock_interruptible.patch added to -mm tree
Date: Thu, 01 Apr 2010 13:53:42 -0700
Message-ID: <201004012053.o31KrgtX008595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50916 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab0DAUxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 16:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov


The patch titled
     9p: return on mutex_lock_interruptible()
has been added to the -mm tree.  Its filename is
     9p-return-on-mutex_lock_interruptible.patch

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
Subject: 9p: return on mutex_lock_interruptible()
From: Dan Carpenter <error27@gmail.com>

If "err" is -EINTR here the original code calls mutex_unlock() and then
returns, but it should just return directly.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_dir.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/9p/vfs_dir.c~9p-return-on-mutex_lock_interruptible fs/9p/vfs_dir.c
--- a/fs/9p/vfs_dir.c~9p-return-on-mutex_lock_interruptible
+++ a/fs/9p/vfs_dir.c
@@ -131,6 +131,8 @@ static int v9fs_dir_readdir(struct file 
 	rdir = (struct p9_rdir *) fid->rdir;
 
 	err = mutex_lock_interruptible(&rdir->mutex);
+	if (err)
+		return err;
 	while (err == 0) {
 		if (rdir->tail == rdir->head) {
 			err = v9fs_file_readn(filp, rdir->buf, NULL,
_

Patches currently in -mm which might be from error27@gmail.com are

linux-next.patch
power_meter-acpi_device_class-power_meter_resource-too-long.patch
dpt_i20-several-use-after-free-issues.patch
sbshc-acpi_device_class-smbus_host_controller-too-long.patch
acpi_pad-processor_aggregator-name-too-long.patch
drivers-gpu-drm-via-via_videoc-fix-off-by-one-issue.patch
drivers-gpu-drm-radeon-radeon_atombiosc-range-check-issues.patch
drivers-gpu-drm-drm_sysfsc-sysfs-files-error-handling.patch
drivers-gpu-drm-drm_memoryc-fix-check-for-end-of-loop.patch
drivers-media-video-au0828-au0828-videoc-off-by-one-bug.patch
drivers-media-video-zc0301-zc0301_corec-improve-error-handling.patch
drivers-media-video-et61x251-et61x251_corec-improve-error-handling.patch
drivers-media-video-sn9c102-sn9c102_corec-improve-error-handling.patch
drivers-mfd-pcf50633-corec-off-by-one-issue.patch
backlight-backlight_device_register-return-err_ptr.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
iscsi-change-to.patch
drivers-staging-otus-hal-hpanic-using-the-wrong-variable.patch
drivers-staging-comedi-drivers-dt2801c-off-by-one-issue.patch
musb-potential-use-after-free.patch
usb-oxu210hp-release-spinlock-on-error-path.patch
9p-return-on-mutex_lock_interruptible.patch
9p-saving-negative-to-unsigned-char.patch
dynamic_debug-small-cleanup-in-ddebug_proc_write.patch
sis-strcpy-=-strlcpy.patch
proc-cleanup-remove-unused-assignments.patch

