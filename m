From: akpm@linux-foundation.org
Subject: + git-block-git-rejects.patch added to -mm tree
Date: Thu, 14 Feb 2008 14:12:35 -0500
Message-ID: <200802150215.m1F2FsCX014815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59108 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756257AbYBOCQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:16:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com


The patch titled
     git-block-git-rejects
has been added to the -mm tree.  Its filename is
     git-block-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-block-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/splice.c |  126 --------------------------------------------------
 1 file changed, 126 deletions(-)

diff -puN fs/splice.c~git-block-git-rejects fs/splice.c
--- a/fs/splice.c~git-block-git-rejects
+++ a/fs/splice.c
@@ -1517,132 +1517,6 @@ static int get_iovec_page_array(const st
 	return error;
 }
 
-<<<<<<< HEAD:fs/splice.c
-static int pipe_to_user(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
-			struct splice_desc *sd)
-{
-	char *src;
-	int ret;
-
-	ret = buf->ops->confirm(pipe, buf);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * See if we can use the atomic maps, by prefaulting in the
-	 * pages and doing an atomic copy
-	 */
-	if (!fault_in_pages_writeable(sd->u.userptr, sd->len)) {
-		src = buf->ops->map(pipe, buf, 1);
-		ret = __copy_to_user_inatomic(sd->u.userptr, src + buf->offset,
-							sd->len);
-		buf->ops->unmap(pipe, buf, src);
-		if (!ret) {
-			ret = sd->len;
-			goto out;
-		}
-	}
-
-	/*
-	 * No dice, use slow non-atomic map and copy
- 	 */
-	src = buf->ops->map(pipe, buf, 0);
-
-	ret = sd->len;
-	if (copy_to_user(sd->u.userptr, src + buf->offset, sd->len))
-		ret = -EFAULT;
-
-	buf->ops->unmap(pipe, buf, src);
-out:
-	if (ret > 0)
-		sd->u.userptr += ret;
-	return ret;
-}
-
-/*
- * For lack of a better implementation, implement vmsplice() to userspace
- * as a simple copy of the pipes pages to the user iov.
- */
-static long vmsplice_to_user(struct file *file, const struct iovec __user *iov,
-			     unsigned long nr_segs, unsigned int flags)
-{
-	struct pipe_inode_info *pipe;
-	struct splice_desc sd;
-	ssize_t size;
-	int error;
-	long ret;
-
-	pipe = pipe_info(file->f_path.dentry->d_inode);
-	if (!pipe)
-		return -EBADF;
-
-	if (pipe->inode)
-		mutex_lock(&pipe->inode->i_mutex);
-
-	error = ret = 0;
-	while (nr_segs) {
-		void __user *base;
-		size_t len;
-
-		/*
-		 * Get user address base and length for this iovec.
-		 */
-		error = get_user(base, &iov->iov_base);
-		if (unlikely(error))
-			break;
-		error = get_user(len, &iov->iov_len);
-		if (unlikely(error))
-			break;
-
-		/*
-		 * Sanity check this iovec. 0 read succeeds.
-		 */
-		if (unlikely(!len))
-			break;
-		if (unlikely(!base)) {
-			error = -EFAULT;
-			break;
-		}
-
-		if (unlikely(!access_ok(VERIFY_WRITE, base, len))) {
-			error = -EFAULT;
-			break;
-		}
-
-		sd.len = 0;
-		sd.total_len = len;
-		sd.flags = flags;
-		sd.u.userptr = base;
-		sd.pos = 0;
-
-		size = __splice_from_pipe(pipe, &sd, pipe_to_user);
-		if (size < 0) {
-			if (!ret)
-				ret = size;
-
-			break;
-		}
-
-		ret += size;
-
-		if (size < len)
-			break;
-
-		nr_segs--;
-		iov++;
-	}
-
-	if (pipe->inode)
-		mutex_unlock(&pipe->inode->i_mutex);
-
-	if (!ret)
-		ret = error;
-
-	return ret;
-}
-
-=======
->>>>>>> FETCH_HEAD:fs/splice.c
 /*
  * vmsplice splices a user address range into a pipe. It can be thought of
  * as splice-from-memory, where the regular splice is splice-from-file (or
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
introduce-path_put.patch
one-less-parameter-to-__d_path.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
use-struct-path-in-struct-svc_export.patch
d_path-make-d_path-use-a-struct-path.patch
softlockup-workaround.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
scsi-fix-data-corruption-caused-by-ses-checkpatch-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-sparc64.patch
git-unionfs.patch
git-unionfs-fixup.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
git-x86-vs-git-kvm.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-git-rejects.patch
git-xtensa.patch
add-rcu_assign_index-if-ever-needed-fix.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
