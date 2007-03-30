From: akpm@linux-foundation.org
Subject: - e1000-printk-warning-fixes.patch removed from -mm tree
Date: Thu, 29 Mar 2007 18:55:47 -0700
Message-ID: <200703300157.l2U1vtE4017722@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45827 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792AbXC3B6B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 21:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, auke-jan.h.kok@intel.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     e1000 printk warning fixes
has been removed from the -mm tree.  Its filename was
     e1000-printk-warning-fixes.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: e1000 printk warning fixes
From: Andrew Morton <akpm@osdl.org>

ia64:

drivers/net/e1000/e1000_main.c: In function `e1000_dump':
drivers/net/e1000/e1000_main.c:3365: warning: long long unsigned int format, u64 arg (arg 3)
drivers/net/e1000/e1000_main.c:3365: warning: long long unsigned int format, u64 arg (arg 4)
drivers/net/e1000/e1000_main.c:3365: warning: long long unsigned int format, dma_addr_t arg (arg 5)
drivers/net/e1000/e1000_main.c:3365: warning: long long unsigned int format, long unsigned int arg (arg 8)
drivers/net/e1000/e1000_main.c:3397: warning: long long unsigned int format, u64 arg (arg 3)
drivers/net/e1000/e1000_main.c:3397: warning: long long unsigned int format, u64 arg (arg 4)
drivers/net/e1000/e1000_main.c:3397: warning: long long unsigned int format, u64 arg (arg 5)
drivers/net/e1000/e1000_main.c:3397: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/e1000/e1000_main.c:3405: warning: long long unsigned int format, u64 arg (arg 3)
drivers/net/e1000/e1000_main.c:3405: warning: long long unsigned int format, u64 arg (arg 4)
drivers/net/e1000/e1000_main.c:3405: warning: long long unsigned int format, u64 arg (arg 5)
drivers/net/e1000/e1000_main.c:3405: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/e1000/e1000_main.c:3426: warning: long long unsigned int format, u64 arg (arg 3)
drivers/net/e1000/e1000_main.c:3426: warning: long long unsigned int format, u64 arg (arg 4)
drivers/net/e1000/e1000_main.c:3426: warning: long long unsigned int format, dma_addr_t arg (arg 5)

you do not know what type is used to implement u64 and you cannot print them.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/e1000/e1000_main.c |   37 +++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff -puN drivers/net/e1000/e1000_main.c~e1000-printk-warning-fixes drivers/net/e1000/e1000_main.c
--- a/drivers/net/e1000/e1000_main.c~e1000-printk-warning-fixes
+++ a/drivers/net/e1000/e1000_main.c
@@ -3574,11 +3574,16 @@ void e1000_dump(struct e1000_adapter* ad
 		struct e1000_buffer *buffer_info = &tx_ring->buffer_info[i];
 		struct my_u { u64 a; u64 b;};
 		struct my_u *u = (struct my_u *)tx_desc;
-		printk("T[0x%03X]     %016llX %016llX %016llX %04X  %3X %016llX %p",
-		       i, le64_to_cpu(u->a),le64_to_cpu(u->b),
-		       (u64)buffer_info->dma, buffer_info->length,
-		       buffer_info->next_to_watch, (u64)buffer_info->time_stamp,
-		       buffer_info->skb);
+		printk("T[0x%03X]     %016llX %016llX %016llX %04X  %3X "
+				"%016llX %p",
+			i,
+			(unsigned long long)le64_to_cpu(u->a),
+			(unsigned long long)le64_to_cpu(u->b),
+			(unsigned long long)buffer_info->dma,
+			buffer_info->length,
+			buffer_info->next_to_watch,
+			(unsigned long long)buffer_info->time_stamp,
+			buffer_info->skb);
 		if(i == tx_ring->next_to_use && i == tx_ring->next_to_clean)
 			printk(" NTC/U\n");
 		else if(i == tx_ring->next_to_use)
@@ -3608,15 +3613,22 @@ void e1000_dump(struct e1000_adapter* ad
 			uint32_t staterr;
 			staterr = le32_to_cpu(rx_desc->wb.middle.status_error);
 			if (staterr & E1000_RXD_STAT_DD) {
-				printk("RWB[0x%03X]     %016llX %016llX %016llX %016llX %p",
-					i, le64_to_cpu(u->a),le64_to_cpu(u->b), le64_to_cpu(u->c), le64_to_cpu(u->d),
+				printk("RWB[0x%03X]     %016llX %016llX "
+					"%016llX %016llX %p",
+					i,
+					(unsigned long long)le64_to_cpu(u->a),
+					(unsigned long long)le64_to_cpu(u->b),
+					(unsigned long long)le64_to_cpu(u->c),
+					(unsigned long long)le64_to_cpu(u->d),
 					buffer_info->skb);
 			}
 			else {
 				printk("R  [0x%03X]     %016llX %016llX %016llX"
 					" %016llX %016llX %p", i,
-					le64_to_cpu(u->a), le64_to_cpu(u->b),
-					le64_to_cpu(u->c), le64_to_cpu(u->d),
+					(unsigned long long)le64_to_cpu(u->a),
+					(unsigned long long)le64_to_cpu(u->b),
+					(unsigned long long)le64_to_cpu(u->c),
+					(unsigned long long)le64_to_cpu(u->d),
 					(unsigned long long)buffer_info->dma,
 					buffer_info->skb);
 			}
@@ -3638,8 +3650,11 @@ void e1000_dump(struct e1000_adapter* ad
 			struct my_u { u64 a; u64 b;};
 			struct my_u *u = (struct my_u *)rx_desc;
 			printk("R[0x%03X]     %016llX %016llX %016llX %p",
-				i, le64_to_cpu(u->a),le64_to_cpu(u->b),
-				(u64)buffer_info->dma, buffer_info->skb);
+				i,
+				(unsigned long long)le64_to_cpu(u->a),
+				(unsigned long long)le64_to_cpu(u->b),
+				(unsigned long long)buffer_info->dma,
+				buffer_info->skb);
 			if(i == rx_ring->next_to_use)
 				printk(" NTU\n");
 			else if(i == rx_ring->next_to_clean)
_

Patches currently in -mm which might be from akpm@osdl.org are

git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
