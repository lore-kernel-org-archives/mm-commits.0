From: akpm@linux-foundation.org
Subject: + cx88-mpegc-make-4-functions-static.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:18:22 -0800
Message-ID: <200711090418.lA94INsC028934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbXKIESr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:18:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, mchehab@infradead.org


The patch titled
     cx88-mpeg.c: make 4 functions static
has been added to the -mm tree.  Its filename is
     cx88-mpegc-make-4-functions-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cx88-mpeg.c: make 4 functions static
From: Adrian Bunk <bunk@kernel.org>

Make the following needlessly global functions static:

- cx8802_init_common()
- cx8802_fini_common()
- cx8802_suspend_common()
- cx8802_resume_common()

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/cx88/cx88-mpeg.c |   14 ++++----------
 drivers/media/video/cx88/cx88.h      |    6 ------
 2 files changed, 4 insertions(+), 16 deletions(-)

diff -puN drivers/media/video/cx88/cx88-mpeg.c~cx88-mpegc-make-4-functions-static drivers/media/video/cx88/cx88-mpeg.c
--- a/drivers/media/video/cx88/cx88-mpeg.c~cx88-mpegc-make-4-functions-static
+++ a/drivers/media/video/cx88/cx88-mpeg.c
@@ -437,10 +437,7 @@ static irqreturn_t cx8802_irq(int irq, v
 	return IRQ_RETVAL(handled);
 }
 
-/* ----------------------------------------------------------- */
-/* exported stuff                                              */
-
-int cx8802_init_common(struct cx8802_dev *dev)
+static int cx8802_init_common(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
 	int err;
@@ -488,7 +485,7 @@ int cx8802_init_common(struct cx8802_dev
 	return 0;
 }
 
-void cx8802_fini_common(struct cx8802_dev *dev)
+static void cx8802_fini_common(struct cx8802_dev *dev)
 {
 	dprintk( 2, "cx8802_fini_common\n" );
 	cx8802_stop_dma(dev);
@@ -504,7 +501,7 @@ void cx8802_fini_common(struct cx8802_de
 
 /* ----------------------------------------------------------- */
 
-int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
+static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
@@ -530,7 +527,7 @@ int cx8802_suspend_common(struct pci_dev
 	return 0;
 }
 
-int cx8802_resume_common(struct pci_dev *pci_dev)
+static int cx8802_resume_common(struct pci_dev *pci_dev)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
@@ -874,9 +871,6 @@ EXPORT_SYMBOL(cx8802_buf_prepare);
 EXPORT_SYMBOL(cx8802_buf_queue);
 EXPORT_SYMBOL(cx8802_cancel_buffers);
 
-EXPORT_SYMBOL(cx8802_init_common);
-EXPORT_SYMBOL(cx8802_fini_common);
-
 EXPORT_SYMBOL(cx8802_register_driver);
 EXPORT_SYMBOL(cx8802_unregister_driver);
 EXPORT_SYMBOL(cx8802_get_driver);
diff -puN drivers/media/video/cx88/cx88.h~cx88-mpegc-make-4-functions-static drivers/media/video/cx88/cx88.h
--- a/drivers/media/video/cx88/cx88.h~cx88-mpegc-make-4-functions-static
+++ a/drivers/media/video/cx88/cx88.h
@@ -633,12 +633,6 @@ int cx8802_buf_prepare(struct videobuf_q
 void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf);
 void cx8802_cancel_buffers(struct cx8802_dev *dev);
 
-int cx8802_init_common(struct cx8802_dev *dev);
-void cx8802_fini_common(struct cx8802_dev *dev);
-
-int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state);
-int cx8802_resume_common(struct pci_dev *pci_dev);
-
 /* ----------------------------------------------------------- */
 /* cx88-video.c*/
 extern const u32 cx88_user_ctrls[];
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
lguest_userc-fix-memory-leak.patch
video-sis-fix-negative-array-index.patch
dvb-bt8xx-dstc-make-code-static.patch
dvb-usb-gp8pskc-if-0-gp8psk_bcm4500_reload.patch
dvb-usb-vp702xc-cleanups.patch
dvb-usb-make-some-debug-vars-static.patch
media-common-ir-functionsc-make-a-function-static.patch
cx88-mpegc-make-4-functions-static.patch
media-video-et61x251-make-5-functions-static.patch
git-hwmon.patch
fs-dlm-proper-prototypes.patch
make-jffs2_get_acl-static.patch
make-sunrpc-xprtsockcxs_setup_udptcp-static.patch
git-netdev-all.patch
drivers-net-chelsio-if-0-unused-functions.patch
drivers-bluetooth-bpa10xc-fix-memleak.patch
drivers-bluetooth-btsdioc-fix-double-free.patch
git-nfs-make-nfs_wb_page_priority-static.patch
fs-nfs-dirc-should-include-internalh.patch
proper-prototype-for-kernel-schedcmigration_init.patch
git-scsi-misc.patch
scsi-advansysc-make-3-functions-static.patch
scsi-qla2xxx-possible-cleanups.patch
usb-mon-mon_binc-cleanups.patch
xtensa-iss_net_setup-must-be-__init.patch
xtensa-kernel-setupc-remove-dead-code.patch
sunrpc-xprtrdma-transportc-fix-use-after-free.patch
fix-mm-utilckrealloc.patch
fuse_file_alloc-fix-null-dereferences.patch
pidns-place-under-config_experimental.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
feature-removal-schedule-remove-sa_-flags-entry.patch
kernel-taskstatsc-fix-bogus-nlmsg_free.patch
mm-hugetlbc-make-a-function-static.patch
mm-page-writebackc-make-a-function-static.patch
make-__vmalloc_area_node-static.patch
blackfin-remove-dump_thread.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
kernel-power-move-function-prototypes-to-header.patch
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
power_supply_ledssysfsc-should-include-power_supplyh.patch
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
