From: akpm@linux-foundation.org
Subject: - alpha-lock-bitops-fix.patch removed from -mm tree
Date: Thu, 06 Mar 2008 14:27:54 -0800
Message-ID: <200803062227.m26MRs8M021132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757359AbYCFW3I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 17:29:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, ink@jurassic.park.msu.ru, npiggin@suse.de, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha bitops.h must #include <asm/barrier.h>
has been removed from the -mm tree.  Its filename was
     alpha-lock-bitops-fix.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha bitops.h must #include <asm/barrier.h>
From: Adrian Bunk <bunk@kernel.org>

In file included from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/bitops.h:17,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/kernel.h:15,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/include/linux/sched.h:50,
                 from /home/bunk/linux/kernel-2.6/linux-2.6.23-rc4-mm1/arch/alpha/kernel/asm-offsets.c:9:
include2/asm/bitops.h: In function 'clear_bit_unlock':
include2/asm/bitops.h:75: error: implicit declaration of function 'smp_mb'
make[2]: *** [arch/alpha/kernel/asm-offsets.s] Error 1

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/bitops.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-alpha/bitops.h~alpha-lock-bitops-fix include/asm-alpha/bitops.h
--- a/include/asm-alpha/bitops.h~alpha-lock-bitops-fix
+++ a/include/asm-alpha/bitops.h
@@ -6,6 +6,7 @@
 #endif
 
 #include <asm/compiler.h>
+#include <asm/barrier.h>
 
 /*
  * Copyright 1994, Linus Torvalds.
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-acpi.patch
git-dvb.patch
git-gfs2-nmw.patch
git-dlm.patch
mtdoopsc-make-struct-oops_cxt-static-again.patch
make-mtd-nand-cs553x_nandcpart_probes-static.patch
git-udf.patch
git-net.patch
git-nfsd.patch
git-parisc.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-selinux.patch
pci_alloc_child_bus-mustnt-be-__devinit.patch
pci_scan_device-mustnt-be-__devinit.patch
pci_bus_size_cardbus-mustnt-be-__devinit.patch
pci_setup_bridge-mustnt-be-__devinit.patch
scsi-aic94xx-cleanups.patch
if-0-ses_match_host.patch
remove-ps2esdi.patch
git-watchdog.patch
make-b43_mac_enablesuspend-static.patch
the-scheduled-bcm43xx-removal.patch
the-scheduled-ieee80211-softmac-removal.patch
the-scheduled-rc80211-simplec-removal.patch
git-cryptodev.patch
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
reiser4.patch

