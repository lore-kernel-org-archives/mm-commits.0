From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 22 Sep 2010 12:44:07 -0700
Message-ID: <201009222015.o8MKF7SL009753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0IVUPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Sep 2010 16:15:39 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o8MKF8Cd012636
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 22 Sep 2010 13:15:09 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ceph/Kconfig      |    3 ---
 fs/ceph/mds_client.c |   18 ------------------
 2 files changed, 21 deletions(-)

diff -puN fs/ceph/Kconfig~linux-next-git-rejects fs/ceph/Kconfig
--- a/fs/ceph/Kconfig~linux-next-git-rejects
+++ a/fs/ceph/Kconfig
@@ -4,11 +4,8 @@ config CEPH_FS
 	select CEPH_LIB
 	select LIBCRC32C
 	select CRYPTO_AES
-<<<<<<< HEAD
 	select CRYPTO
-=======
 	default n
->>>>>>> FETCH_HEAD
 	help
 	  Choose Y or M here to include support for mounting the
 	  experimental Ceph distributed file system.  Ceph is an extremely
diff -puN fs/ceph/mds_client.c~linux-next-git-rejects fs/ceph/mds_client.c
--- a/fs/ceph/mds_client.c~linux-next-git-rejects
+++ a/fs/ceph/mds_client.c
@@ -2365,23 +2365,6 @@ static int encode_caps_cb(struct inode *
 
 	if (recon_state->flock) {
 		int num_fcntl_locks, num_flock_locks;
-<<<<<<< HEAD
-
-		lock_kernel();
-		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
-		rec.v2.flock_len = (2*sizeof(u32) +
-				    (num_fcntl_locks+num_flock_locks) *
-				    sizeof(struct ceph_filelock));
-
-		err = ceph_pagelist_append(pagelist, &rec, reclen);
-		if (!err)
-			err = ceph_encode_locks(inode, pagelist,
-						num_fcntl_locks,
-						num_flock_locks);
-		unlock_kernel();
-	} else {
-		err = ceph_pagelist_append(pagelist, &rec, reclen);
-=======
 		struct ceph_pagelist_cursor trunc_point;
 
 		ceph_pagelist_set_cursor(pagelist, &trunc_point);
@@ -2411,7 +2394,6 @@ static int encode_caps_cb(struct inode *
 				unlock_kernel();
 			}
 		} while (err == -ENOSPC);
->>>>>>> FETCH_HEAD
 	}
 
 out_free:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
efifb-support-the-efi-framebuffer-on-more-apple-hardware-checkpatch-fixes.patch
drivers-pci-intel-iommuc-fix-build-with-older-gccs.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
fs-inodec-work-around-bug.patch
i-need-old-gcc.patch
mm-vmap-area-cache.patch
acpi-apei-fix-erst-move_data-instruction-implementation.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
parport-prevent-arm-boards-frmo-crashing-when-cups-is-loaded-fix.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
drivers-media-video-cx23885-cx23885-corec-fix-cx23885_dev_checkrevision.patch
fs-notify-fanotify-fanotify_userc-fix-warnings.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
sctp-prevent-reading-out-of-bounds-memory-cleanup.patch
drivers-net-tulip-de4x5c-fix-copy-length-in-de4x5_ioctl-checkpatch-fixes.patch
serial-add-sc16is7x2-driver-update-fix.patch
security-add-const-to-security_task_setscheduler.patch
sched-make-sched_param-argument-static-variables-in-some-sched_setscheduler-caller.patch
drivers-message-fusion-mptsasc-fix-warning.patch
usb-storage-add-new-no_read_disc_info-quirk-fix.patch
mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
mm-only-build-per-node-scan_unevictable-functions-when-numa-is-enabled-cleanup.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
kernelh-add-minmax3-macros-fix.patch
include-linux-kernelh-add-__must_check-to-strict_strto.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
idr-fix-idr_pre_get-locking-description-fix.patch
mmc-move-regulator-handling-closer-to-core-v3-fix.patch
checkpatch-returning-errno-typically-should-be-negative.patch
select-rename-estimate_accuracy-to-select_estimate_accuracy.patch
viafb-add-interface-for-output-device-configuration.patch
cgroup_freezer-update_freezer_state-does-incorrect-state-transitions-checkpatch-fixes.patch
memcg-cpu-hotplug-aware-quick-acount_move-detection-checkpatch-fixes.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2.patch
core_pattern-fix-long-parameters-was-truncated-by-core_pattern-handler-update-2-checkpatch-fixes.patch
drivers-char-hvc_consolec-remove-unneeded-__set_current_statetask_running.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
pps-add-async-pps-event-handler-fix.patch
kernel-resourcec-handle-reinsertion-of-an-already-inserted-resource.patch
ramoops-use-the-platform-data-structure-instead-of-module-params-fix.patch
vfs-add-super-operation-writeback_inodes-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4-export-find_get_pages.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
reiser4-fixups.patch
reiser4-broke.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch

