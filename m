From: akpm@osdl.org
Subject: - make-fs-jbd-transactionc__journal_temp_unlink_buffer-static.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:14 -0800
Message-ID: <200612072306.kB7N6E9M030231@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163856AbWLGXJ3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:09:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     make fs/jbd/transaction.c:__journal_temp_unlink_buffer() static
has been removed from the -mm tree.  Its filename was
     make-fs-jbd-transactionc__journal_temp_unlink_buffer-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make fs/jbd/transaction.c:__journal_temp_unlink_buffer() static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/jbd/transaction.c |    4 +++-
 include/linux/jbd.h  |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/jbd/transaction.c~make-fs-jbd-transactionc__journal_temp_unlink_buffer-static fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~make-fs-jbd-transactionc__journal_temp_unlink_buffer-static
+++ a/fs/jbd/transaction.c
@@ -27,6 +27,8 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 
+static void __journal_temp_unlink_buffer(struct journal_head *jh);
+
 /*
  * get_transaction: obtain a new transaction_t object.
  *
@@ -1499,7 +1501,7 @@ __blist_del_buffer(struct journal_head *
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
-void __journal_temp_unlink_buffer(struct journal_head *jh)
+static void __journal_temp_unlink_buffer(struct journal_head *jh)
 {
 	struct journal_head **list = NULL;
 	transaction_t *transaction;
diff -puN include/linux/jbd.h~make-fs-jbd-transactionc__journal_temp_unlink_buffer-static include/linux/jbd.h
--- a/include/linux/jbd.h~make-fs-jbd-transactionc__journal_temp_unlink_buffer-static
+++ a/include/linux/jbd.h
@@ -839,7 +839,6 @@ struct journal_s
  */
 
 /* Filing buffers */
-extern void __journal_temp_unlink_buffer(struct journal_head *jh);
 extern void journal_unfile_buffer(journal_t *, struct journal_head *);
 extern void __journal_unfile_buffer(struct journal_head *);
 extern void __journal_refile_buffer(struct journal_head *);
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
make-drivers-acpi-eccec_ecdt-static.patch
drivers-acpi-oslc-fix-a-null-check.patch
git-alsa.patch
git-dvb.patch
fs-dlm-lowcomms-tcpc-remove-2-functions.patch
git-mtd.patch
remove-mtd-jffs2-userh.patch
net-uninline-skb_put-fix.patch
dont-export-device-ids-to-userspace.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_match_scb-static.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
make-qla2x00_reg_remote_port-static.patch
drivers-scsi-wd33c93c-cleanups.patch
usb_rtl8150-must-select-mii.patch
drivers-edac-make-code-static.patch
remove-drivers-pci-searchcpci_find_device_reverse.patch
make-ext2_get_blocks-static.patch
generic-bug-implementation-include-linux-bugh-must-always-include-linux-moduleh.patch
fsstack-introduce-fsstack_copy_attrinode_-fs-stackc-should-include-linux-fs_stackh.patch
i4l-remove-the-broken-hisax_amd7930-option.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
make-drivers-md-dm-snapcksnapd-static.patch
gtod-persistent-clock-support-core-remove-kernel-timercwall_jiffies.patch
gtod-persistent-clock-support-i386-i386-unexport-read_persistent_clock.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie-make-kernel-timerc__next_timer_interrupt-static.patch
updated-i386-convert-to-clock-event-devices-arch-i386-kernel-apicc-make-a-function-static.patch
updated-i386-convert-to-clock-event-devices-remove-arch-i386-kernel-time_hpetchpet_reenable.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slab-cache-shrinker-statistics.patch
debug-shared-irqs-kconfig-fix.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch

