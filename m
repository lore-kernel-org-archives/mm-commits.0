From: akpm@linux-foundation.org
Subject: - vfs-lseekfd-0-seek_cur-race-condition-fix.patch removed from -mm tree
Date: Mon, 01 Dec 2008 13:11:31 -0800
Message-ID: <200812012127.mB1LR6sl015094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751768AbYLAV1X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 16:27:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alain@knaff.lu, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs-lseekfd-0-seek_cur-race-condition-fix
has been removed from the -mm tree.  Its filename was
     vfs-lseekfd-0-seek_cur-race-condition-fix.patch

This patch was dropped because it was folded into vfs-lseekfd-0-seek_cur-race-condition.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs-lseekfd-0-seek_cur-race-condition-fix
From: Andrew Morton <akpm@linux-foundation.org>

- fix coding-style
- fix default_llseek() as well
- add comments

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alain Knaff <alain@knaff.lu>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff -puN fs/read_write.c~vfs-lseekfd-0-seek_cur-race-condition-fix fs/read_write.c
--- a/fs/read_write.c~vfs-lseekfd-0-seek_cur-race-condition-fix
+++ a/fs/read_write.c
@@ -50,6 +50,14 @@ generic_file_llseek_unlocked(struct file
 		offset += inode->i_size;
 		break;
 	case SEEK_CUR:
+		/*
+		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
+		 * position-querying operation.  Avoid rewriting the "same"
+		 * f_pos value back to the file because a concurrent read(),
+		 * write() or lseek() might have altered it
+		 */
+		if (offset == 0)
+			return file->f_pos;
 		offset += file->f_pos;
 		break;
 	}
@@ -105,8 +113,14 @@ loff_t default_llseek(struct file *file,
 			offset += i_size_read(file->f_path.dentry->d_inode);
 			break;
 		case SEEK_CUR:
-			if(offset == 0)
-				return file->f_pos;
+			/*
+			 * See SEEK_CUR description in
+			 * generic_file_llseek_unlocked()
+			 */
+			if (offset == 0) {
+				retval = file->f_pos;
+				goto out;
+			}
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
@@ -117,6 +131,7 @@ loff_t default_llseek(struct file *file,
 		}
 		retval = offset;
 	}
+out:
 	unlock_kernel();
 	return retval;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
epoll-introduce-resource-usage-limits.patch
vfs-lseekfd-0-seek_cur-race-condition.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
drivers-gpu-drm-i915-i915_irqc-fix-warning.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
backlight-catch-invalid-input-checkpatch-fixes.patch
backlight-catch-invalid-input-fix.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
add-pr_prefix-to-pr_xyz-macros-checkpatch-fixes.patch
poll-allow-f_op-poll-to-sleep-take6.patch
binfmtsh-include-listh-fix.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
spi_gpio-driver-cleanups.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-support-probing-module-__exit-function-fix-2.patch
rtc-au1000-on-chip-counter0-as-rtc-driver-fix.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memcg-avoid-unnecessary-system-wide-oom-killer-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

