From: akpm@linux-foundation.org
Subject: + vfs-lseekfd-0-seek_cur-race-condition-fix.patch added to -mm tree
Date: Mon, 10 Nov 2008 17:08:20 -0800
Message-ID: <200811110108.mAB18Ko3031103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbYKKBIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 20:08:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alain@knaff.lu, hch@lst.de, viro@zeniv.linux.org.uk


The patch titled
     vfs-lseekfd-0-seek_cur-race-condition-fix
has been added to the -mm tree.  Its filename is
     vfs-lseekfd-0-seek_cur-race-condition-fix.patch

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

cpusets-update-mems-allowed-in-page-allocator-fix.patch
remove-ratelimt.patch
doc-add-printk-formatstxt-fix.patch
kernel-kprobesc-dont-pad-kretprobe_table_locks-on-uniprocessor-builds.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-basic-implementation-of-epson-rx-8581-i2c-real-time-clock.patch
w1-export-w1_read_8-function-checkpatch-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-setupc-omit-dmi_low_memory_corruption-when-it-is-unneeded.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
input-ad7879-fix-workaroud-build-error-reported-by-andrew-morton.patch
pci-uninline-pci_ioremap_bar.patch
pcie-add-option-to-passively-listen-for-pcie-hotplug-events-checkpatch-fixes.patch
align-avoid-evaluating-its-argument-twice.patch
vfs-lseekfd-0-seek_cur-race-condition-fix.patch
bdi-register-sysfs-bdi-device-only-once-per-queue-fix.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
alsa-fix-snd_bug_on-and-friends.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-more-terminate-quickly.patch
init-properly-placing-noinline-keyword.patch
binfmtsh-include-listh-fix.patch
spi_gpio-driver-cleanups.patch
quota-permit-separately-enabling-quota-accounting-and-enforcing-limits-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix.patch
quota-move-quotaio_vh-from-include-linux-to-fs-fix-2.patch
quota-convert-union-in-mem_dqinfo-to-a-pointer-cleanup.patch
quota-support-64-bit-quota-format-fix.patch
quota-support-64-bit-quota-format-fix-2.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
edac-struct-device-replace-bus_id-with-dev_name-dev_set_name-checkpatch-fixes.patch
edac-x38-use-the-architectures-readq-function-fix.patch
filesystem-freeze-implement-generic-freeze-feature-fix.patch
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
reiser4-broke.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

