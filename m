From: akpm@linux-foundation.org
Subject: - scsi-fix-config_scsi_wait_scan=m.patch removed from -mm tree
Date: Wed, 30 May 2007 16:28:35 -0700
Message-ID: <200705302328.l4UNSYOX007765@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXE3X2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 19:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     scsi: fix CONFIG_SCSI_WAIT_SCAN=m
has been removed from the -mm tree.  Its filename was
     scsi-fix-config_scsi_wait_scan=m.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: scsi: fix CONFIG_SCSI_WAIT_SCAN=m
From: Hugh Dickins <hugh@veritas.com>

CONFIG_MODULES=y
CONFIG_SCSI=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2, but boots
okay if I change drivers/scsi/Kconfig to "default y" instead of "default m"
for SCSI_WAIT_SCAN.

Make sure there's a late_initcall to scsi_complete_async_scans when it's
built in, so a monolithic SCSI_SCAN_ASYNC kernel can rely on the scans
being completed before trying to mount root, even if they're slow.

[akpm@linux-foundation.org: build fixes]
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
---
James sayeth "This isn't the right fix ...  this has to be invoked last in the
call sequence ...  I can't see another way of doing this except yet another
file added as a final component to the link."
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m
+++ a/drivers/scsi/scsi_scan.c
@@ -184,6 +184,15 @@ int scsi_complete_async_scans(void)
 /* Only exported for the benefit of scsi_wait_scan */
 EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
 
+#ifndef MODULE
+/*
+ * For async scanning we need to wait for all the scans to complete before
+ * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
+ * yet.
+ */
+late_initcall(scsi_complete_async_scans);
+#endif
+
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
_

Patches currently in -mm which might be from hugh@veritas.com are

git-scsi-rc-fixes.patch
rework-ptep_set_access_flags-and-fix-sun4c.patch
unmap_vm_area-becomes-unmap_kernel_range-for-the-public.patch
make-map_vm_area-static.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
ext2-reservations.patch
ext2-balloc-use-io_error-label.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
coredump-masking-bound-suid_dumpable-sysctl.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
coredump-masking-add-an-interface-for-core-dump-filter.patch
coredump-masking-elf-enable-core-dump-filtering.patch
coredump-masking-elf-fdpic-remove-an-unused-argument.patch
coredump-masking-elf-fdpic-enable-core-dump-filtering.patch
coredump-masking-documentation-for-proc-pid-coredump_filter.patch
prio_tree-debugging-patch.patch
