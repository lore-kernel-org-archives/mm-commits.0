From: akpm@linux-foundation.org
Subject: + romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch added to -mm tree
Date: Tue, 02 Dec 2008 14:18:43 -0800
Message-ID: <200812022218.mB2MIhaA032693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbYLBWSq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 17:18:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, roel.kluin@gmail.com


The patch titled
     romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch

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
Subject: romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#32: FILE: fs/romfs/inode.c:530:
+        ret = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);$

ERROR: code indent should use tabs where possible
#33: FILE: fs/romfs/inode.c:531:
+        if (ret >= 0)$

ERROR: code indent should use tabs where possible
#34: FILE: fs/romfs/inode.c:532:
+                ino = ((ROMFH_SIZE+ret+1+ROMFH_PAD)&ROMFH_MASK);$

total: 3 errors, 0 warnings, 20 lines checked

./patches/romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: roel kluin <roel.kluin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/romfs/inode.c~romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes fs/romfs/inode.c
--- a/fs/romfs/inode.c~romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes
+++ a/fs/romfs/inode.c
@@ -527,11 +527,11 @@ romfs_iget(struct super_block *sb, unsig
 	i->i_uid = i->i_gid = 0;
 
         /* Precalculate the data offset */
-        ret = romfs_strnlen(i, ino+ROMFH_SIZE, ROMFS_MAXFN);
-        if (ret >= 0)
-                ino = ((ROMFH_SIZE+ret+1+ROMFH_PAD)&ROMFH_MASK);
-        else
-                ino = 0;
+	ret = romfs_strnlen(i, ino + ROMFH_SIZE, ROMFS_MAXFN);
+	if (ret >= 0)
+		ino = (ROMFH_SIZE + ret + 1 + ROMFH_PAD) & ROMFH_MASK;
+	else
+		ino = 0;
 
         ROMFS_I(i)->i_metasize = ino;
         ROMFS_I(i)->i_dataoffset = ino+(i->i_ino&ROMFH_MASK);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

bdi-register-sysfs-bdi-device-only-once-per-queue.patch
ksym_symbol_len-fixes.patch
mm-remove-the-might_sleep-from-lock_page.patch
make-linx-next-apply.patch
linux-next.patch
next-remove-localversion.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
linux-timexh-cleanup-for-userspace.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
netdev-smc911x-fix-for-driver-resume-cleanup.patch
backlight-catch-invalid-input.patch
pci-uninline-pci_ioremap_bar.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
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
romfs-romfs_iget-unsigned-ino-=-0-is-always-true-checkpatch-fixes.patch
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

