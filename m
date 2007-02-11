From: akpm@linux-foundation.org
Subject: - xfs-remove-useless-wmb-memory-barrier.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:56:10 -0800
Message-ID: <200702112256.l1BMuANV016389@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932908AbXBKW72 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:59:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: remove useless wmb() memory barrier
has been removed from the -mm tree.  Its filename was
     xfs-remove-useless-wmb-memory-barrier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfs: remove useless wmb() memory barrier
From: Ralf Baechle <ralf@linux-mips.org>

wake_up's implementation does an implicit memory barrier and I think that's
the only sane semantics as the caller shouldn't have to worry.  So this
write memory barrier is useless.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_super.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_super.c~xfs-remove-useless-wmb-memory-barrier fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~xfs-remove-useless-wmb-memory-barrier
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -553,7 +553,6 @@ vfs_sync_worker(
 		error = bhv_vfs_sync(vfsp, SYNC_FSDATA | SYNC_BDFLUSH | \
 					SYNC_ATTR | SYNC_REFCACHE, NULL);
 	vfsp->vfs_sync_seq++;
-	wmb();
 	wake_up(&vfsp->vfs_wait_single_sync_task);
 }
 
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
mips-remove-smp_tune_scheduling.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
simplify-the-stacktrace-code.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
clocksource-fixup-is_continous-changes-on-mips.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
