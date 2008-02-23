From: akpm@linux-foundation.org
Subject: - dm-raid1c-fix-null-dereferences.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:24:03 -0800
Message-ID: <200802232024.m1NKO3mB013605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:60208 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763306AbYBWU31 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, agk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dm-raid1.c: fix NULL dereferences
has been removed from the -mm tree.  Its filename was
     dm-raid1c-fix-null-dereferences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dm-raid1.c: fix NULL dereferences
From: Adrian Bunk <bunk@kernel.org>

Fix two NULL dereferences introduced by commit
06386bbfd2441416875d0403d405c56822f6ebac and spotted by the Coverity
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-raid1.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1c-fix-null-dereferences drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1c-fix-null-dereferences
+++ a/drivers/md/dm-raid1.c
@@ -1696,14 +1696,15 @@ static int mirror_end_io(struct dm_targe
 			 * information for a retry or there was no other
 			 * mirror in-sync.
 			 */
-			DMERR_LIMIT("Mirror read failed from %s.",
-				    m->dev->name);
+			DMERR_LIMIT("Mirror read failed.");
 			return -EIO;
 		}
+
+		m = read_record->m;
+
 		DMERR("Mirror read failed from %s. Trying alternative device.",
 		      m->dev->name);
 
-		m = read_record->m;
 		fail_mirror(m, DM_RAID1_READ_ERROR);
 
 		/*
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
sparc-fix-build.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-net.patch
make-s2iocinit_tti-static.patch
git-nfsd.patch
git-ocfs2.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
ieee80211-fix-broken-error-handling-in-ieee80211_sta_process_addba_request.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
make-udf_error-static.patch
fs-hfsplus-proper-externs.patch
fs-freevxfs-proper-externs.patch
make-__put_super-static.patch
make-vfs_ioctl-static.patch
fs-fs-writeback-make-2-functions-static.patch
fs-drop_cachesc-make-2-functions-static.patch
fs-aioc-make-3-functions-static.patch
let-log_buf_shift-default-to-17.patch
fs-timerfdc-should-include-linux-syscallsh.patch
remove-generic_commit_write.patch
make-fs-bufferccont_expand_zero-static.patch
make-binfmt_flat-a-bool.patch
remove-mca_is_adapter_used.patch
ipwireless-remove-dead-code.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
kernel-cpusetc-make-3-functions-static.patch
make-ext4_xattr_list-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
reiser4.patch
