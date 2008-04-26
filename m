From: akpm@linux-foundation.org
Subject: - pci_setup_bridge-mustnt-be-__devinit.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:06 -0700
Message-ID: <200804261642.m3QGg66X031181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757285AbYDZQm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     pci_setup_bridge() mustn't be __devinit
has been removed from the -mm tree.  Its filename was
     pci_setup_bridge-mustnt-be-__devinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci_setup_bridge() mustn't be __devinit
From: Adrian Bunk <bunk@kernel.org>

WARNING: drivers/pci/built-in.o(.text+0x28ee9): Section mismatch in reference from the function pci_bus_assign_resources() to the function .devinit.text:pci_setup_bridge()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/setup-bus.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/pci/setup-bus.c~pci_setup_bridge-mustnt-be-__devinit drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~pci_setup_bridge-mustnt-be-__devinit
+++ a/drivers/pci/setup-bus.c
@@ -145,8 +145,7 @@ EXPORT_SYMBOL(pci_setup_cardbus);
    config space writes, so it's quite possible that an I/O window of
    the bridge will have some undesirable address (e.g. 0) after the
    first write. Ditto 64-bit prefetchable MMIO.  */
-static void __devinit
-pci_setup_bridge(struct pci_bus *bus)
+static void pci_setup_bridge(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
 	struct pci_bus_region region;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
rtc-pcf8583-build-fix.patch
git-acpi.patch
git-x86.patch
arch-x86-video-fbdevc-add-module_license.patch
git-dvb.patch
git-m32r.patch
git-nfsd.patch
git-ocfs2.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-pci.patch
git-sh.patch
git-scsi-misc.patch
if-0-ses_match_host.patch
git-watchdog.patch
make-swap_pte_to_pagemap_entry-static.patch
fs-ramfs-extern-cleanup.patch
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
proper-__do_softirq-prototype.patch
proper-extern-for-late_time_init.patch
remove-ecryptfs_header_cache_0.patch
make-ds1511_rtc_readset_time-static.patch
pnp-skip-dev-protocol-null-checks.patch
make-ext3_xattr_list-static.patch
make-cgroup_enable_task_cg_lists-static.patch
cgroups-kernel-ns_cgroupc-should-include-linux-nsproxyh.patch
kernel-cpusetc-make-3-functions-static.patch
include-linux-sysctlh-remove-empty-else.patch
remove-aoedev_isbusy.patch
make-marker_debug-static.patch
edac-remove-unneeded-functions-and-add-static-accessor.patch
reiser4.patch

