From: akpm@linux-foundation.org
Subject: + proper-prototype-for-signals_init.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:51:47 -0800
Message-ID: <200711090451.lA94pmLZ030168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49984 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760099AbXKIEwE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:52:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org


The patch titled
     proper prototype for signals_init()
has been added to the -mm tree.  Its filename is
     proper-prototype-for-signals_init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proper prototype for signals_init()
From: Adrian Bunk <bunk@kernel.org>

Add a proper prototype for signals_init() in include/linux/signal.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 ++
 init/main.c            |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/signal.h~proper-prototype-for-signals_init include/linux/signal.h
--- a/include/linux/signal.h~proper-prototype-for-signals_init
+++ a/include/linux/signal.h
@@ -371,6 +371,8 @@ int unhandled_signal(struct task_struct 
 	(!siginmask(signr, SIG_KERNEL_IGNORE_MASK|SIG_KERNEL_STOP_MASK) && \
 	 (t)->sighand->action[(signr)-1].sa.sa_handler == SIG_DFL)
 
+void signals_init(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_SIGNAL_H */
diff -puN init/main.c~proper-prototype-for-signals_init init/main.c
--- a/init/main.c~proper-prototype-for-signals_init
+++ a/init/main.c
@@ -57,6 +57,7 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/sched.h>
+#include <linux/signal.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -83,7 +84,6 @@ extern void init_IRQ(void);
 extern void fork_init(unsigned long);
 extern void mca_init(void);
 extern void sbus_init(void);
-extern void signals_init(void);
 extern void pidhash_init(void);
 extern void pidmap_init(void);
 extern void prio_tree_init(void);
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
