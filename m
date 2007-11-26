From: akpm@linux-foundation.org
Subject: - drivers-net-chelsio-if-0-unused-functions.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:00 -0800
Message-ID: <200711262149.lAQLn0u8024649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbXKZV6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     drivers/net/chelsio/: #if 0 unused functions
has been removed from the -mm tree.  Its filename was
     drivers-net-chelsio-if-0-unused-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/net/chelsio/: #if 0 unused functions
From: Adrian Bunk <bunk@kernel.org>

This patch #if 0's the following unused functions:
- espi.c:t1_espi_set_misc_ctrl()
- sge.c:t1_sched_set_max_avail_bytes()
- sge.c:t1_sched_set_drain_bits_per_us()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/chelsio/espi.c |    2 ++
 drivers/net/chelsio/espi.h |    1 -
 drivers/net/chelsio/sge.c  |    4 ++++
 drivers/net/chelsio/sge.h  |    2 --
 4 files changed, 6 insertions(+), 3 deletions(-)

diff -puN drivers/net/chelsio/espi.c~drivers-net-chelsio-if-0-unused-functions drivers/net/chelsio/espi.c
--- a/drivers/net/chelsio/espi.c~drivers-net-chelsio-if-0-unused-functions
+++ a/drivers/net/chelsio/espi.c
@@ -297,6 +297,7 @@ struct peespi *t1_espi_create(adapter_t 
 	return espi;
 }
 
+#if 0
 void t1_espi_set_misc_ctrl(adapter_t *adapter, u32 val)
 {
 	struct peespi *espi = adapter->espi;
@@ -309,6 +310,7 @@ void t1_espi_set_misc_ctrl(adapter_t *ad
 	writel(espi->misc_ctrl, adapter->regs + A_ESPI_MISC_CONTROL);
 	spin_unlock(&espi->lock);
 }
+#endif  /*  0  */
 
 u32 t1_espi_get_mon(adapter_t *adapter, u32 addr, u8 wait)
 {
diff -puN drivers/net/chelsio/espi.h~drivers-net-chelsio-if-0-unused-functions drivers/net/chelsio/espi.h
--- a/drivers/net/chelsio/espi.h~drivers-net-chelsio-if-0-unused-functions
+++ a/drivers/net/chelsio/espi.h
@@ -62,7 +62,6 @@ void t1_espi_intr_disable(struct peespi 
 int t1_espi_intr_handler(struct peespi *);
 const struct espi_intr_counts *t1_espi_get_intr_counts(struct peespi *espi);
 
-void t1_espi_set_misc_ctrl(adapter_t *adapter, u32 val);
 u32 t1_espi_get_mon(adapter_t *adapter, u32 addr, u8 wait);
 int t1_espi_get_mon_t204(adapter_t *, u32 *, u8);
 
diff -puN drivers/net/chelsio/sge.c~drivers-net-chelsio-if-0-unused-functions drivers/net/chelsio/sge.c
--- a/drivers/net/chelsio/sge.c~drivers-net-chelsio-if-0-unused-functions
+++ a/drivers/net/chelsio/sge.c
@@ -330,6 +330,8 @@ unsigned int t1_sched_update_parms(struc
 	return max_avail_segs * (p->mtu - 40);
 }
 
+#if 0
+
 /*
  * t1_sched_max_avail_bytes() tells the scheduler the maximum amount of
  * data that can be pushed per port.
@@ -357,6 +359,8 @@ void t1_sched_set_drain_bits_per_us(stru
 	t1_sched_update_parms(sge, port, 0, 0);
 }
 
+#endif  /*  0  */
+
 
 /*
  * get_clock() implements a ns clock (see ktime_get)
diff -puN drivers/net/chelsio/sge.h~drivers-net-chelsio-if-0-unused-functions drivers/net/chelsio/sge.h
--- a/drivers/net/chelsio/sge.h~drivers-net-chelsio-if-0-unused-functions
+++ a/drivers/net/chelsio/sge.h
@@ -89,8 +89,6 @@ void t1_sge_intr_disable(struct sge *);
 void t1_sge_intr_clear(struct sge *);
 const struct sge_intr_counts *t1_sge_get_intr_counts(const struct sge *sge);
 void t1_sge_get_port_stats(const struct sge *sge, int port, struct sge_port_stats *);
-void t1_sched_set_max_avail_bytes(struct sge *, unsigned int);
-void t1_sched_set_drain_bits_per_us(struct sge *, unsigned int, unsigned int);
 unsigned int t1_sched_update_parms(struct sge *, unsigned int, unsigned int,
 			   unsigned int);
 
_

Patches currently in -mm which might be from bunk@kernel.org are

m68k-export-atari_keyb_init.patch
git-acpi.patch
git-avr32.patch
git-cifs.patch
git-dvb.patch
remove-saa7134-oss.patch
git-gfs2-nmw.patch
git-libata-all.patch
git-mtd.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
git-battery.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
remove-additional-pci_scan_child_bus-prototype.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
git-x86.patch
git-xtensa.patch
xtensa-kernel-setupc-remove-dead-code.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
nubus-kill-drivers-nubus-nubus_symsc.patch
m68k-kill-arch-m68k-mac-mac_ksymsc.patch
m68k-kill-arch-m68k-hp300-ksymsc.patch
m68k-kill-arch-m68k-amiga-amiga_ksymsc.patch
m68k-kill-arch-m68k-atari-atari_ksymsc.patch
m68k-kill-arch-m68k-mvme16x-mvme16x_ksymsc.patch
kill-udffs_dateversion.patch
make-ipc-utilcsysvipc_find_ipc-static.patch
cleanup-after-apus-removal.patch
remove-mm_ptovvtop.patch
remove-__attribute_used__.patch
remove-__attribute_used__-checkpatch-fixes.patch
proper-show_interrupts-prototype.patch
scheduled-oss-driver-removal.patch
linux-inith-simplify-__meminitexit-dependencies.patch
proper-prototype-for-signals_init.patch
kernel-ptracec-should-include-linux-syscallsh.patch
make-srcu_readers_active-static.patch
kernel-notifierc-should-include-linux-rebooth.patch
proper-prototype-for-get_filesystem_list.patch
fs-utimesc-should-include-linux-syscallsh.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
proper-prototype-for-vty_init.patch
drivers-misc-lkdtmc-cleanups.patch
fs-ecryptfs-possible-cleanups.patch
make-video-geode-lxfb_corecgeode_modedb-static.patch
video-hpfbc-section-fix.patch
ext4-superc-fix-ifdefs.patch
make-jbd-journalc__journal_abort_hard-static.patch
move-edactxt-two-levels-up.patch
remove-documentation-smptxt.patch
kernel-cgroupc-remove-dead-code.patch
kernel-cgroupc-make-2-functions-static.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
fix-m32r-__xchg.patch
reiser4.patch
