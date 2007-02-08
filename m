From: akpm@linux-foundation.org
Subject: - net-wanrouter-wanmainc-cleanups.patch removed from -mm tree
Date: Thu, 08 Feb 2007 13:52:32 -0800
Message-ID: <200702082152.l18LqWId027645@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41627 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423483AbXBHVzq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 16:55:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     net/wanrouter/wanmain.c: cleanups
has been removed from the -mm tree.  Its filename was
     net-wanrouter-wanmainc-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/wanrouter/wanmain.c: cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following cleanups:
- make the following needlessly global functions static:
  - lock_adapter_irq()
  - unlock_adapter_irq()
- #if 0 the following unused global functions:
  - wanrouter_encapsulate()
  - wanrouter_type_trans()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wanrouter.h |    8 --------
 net/wanrouter/wanmain.c   |   17 ++++++++---------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff -puN include/linux/wanrouter.h~net-wanrouter-wanmainc-cleanups include/linux/wanrouter.h
--- a/include/linux/wanrouter.h~net-wanrouter-wanmainc-cleanups
+++ a/include/linux/wanrouter.h
@@ -516,9 +516,6 @@ struct wan_device {
 /* Public functions available for device drivers */
 extern int register_wan_device(struct wan_device *wandev);
 extern int unregister_wan_device(char *name);
-__be16 wanrouter_type_trans(struct sk_buff *skb, struct net_device *dev);
-int wanrouter_encapsulate(struct sk_buff *skb, struct net_device *dev,
-			  unsigned short type);
 
 /* Proc interface functions. These must not be called by the drivers! */
 extern int wanrouter_proc_init(void);
@@ -527,11 +524,6 @@ extern int wanrouter_proc_add(struct wan
 extern int wanrouter_proc_delete(struct wan_device *wandev);
 extern int wanrouter_ioctl( struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg);
 
-extern void lock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags);
-extern void unlock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags);
-
-
-
 /* Public Data */
 /* list of registered devices */
 extern struct wan_device *wanrouter_router_devlist;
diff -puN net/wanrouter/wanmain.c~net-wanrouter-wanmainc-cleanups net/wanrouter/wanmain.c
--- a/net/wanrouter/wanmain.c~net-wanrouter-wanmainc-cleanups
+++ a/net/wanrouter/wanmain.c
@@ -86,8 +86,8 @@ static int wanrouter_device_del_if(struc
 
 static struct wan_device *wanrouter_find_device(char *name);
 static int wanrouter_delete_interface(struct wan_device *wandev, char *name);
-void lock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags);
-void unlock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags);
+static void lock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags);
+static void unlock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags);
 
 
 
@@ -104,8 +104,8 @@ struct wan_device* wanrouter_router_devl
  *	Organize Unique Identifiers for encapsulation/decapsulation
  */
 
-static unsigned char wanrouter_oui_ether[] = { 0x00, 0x00, 0x00 };
 #if 0
+static unsigned char wanrouter_oui_ether[] = { 0x00, 0x00, 0x00 };
 static unsigned char wanrouter_oui_802_2[] = { 0x00, 0x80, 0xC2 };
 #endif
 
@@ -246,6 +246,8 @@ int unregister_wan_device(char *name)
 	return 0;
 }
 
+#if 0
+
 /*
  *	Encapsulate packet.
  *
@@ -341,6 +343,7 @@ __be16 wanrouter_type_trans(struct sk_bu
 	return ethertype;
 }
 
+#endif  /*  0  */
 
 /*
  *	WAN device IOCTL.
@@ -799,23 +802,19 @@ static int wanrouter_delete_interface(st
 	return 0;
 }
 
-void lock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags)
+static void lock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags)
 {
        	spin_lock_irqsave(lock, *smp_flags);
 }
 
 
-void unlock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags)
+static void unlock_adapter_irq(spinlock_t *lock, unsigned long *smp_flags)
 {
 	spin_unlock_irqrestore(lock, *smp_flags);
 }
 
 EXPORT_SYMBOL(register_wan_device);
 EXPORT_SYMBOL(unregister_wan_device);
-EXPORT_SYMBOL(wanrouter_encapsulate);
-EXPORT_SYMBOL(wanrouter_type_trans);
-EXPORT_SYMBOL(lock_adapter_irq);
-EXPORT_SYMBOL(unlock_adapter_irq);
 
 MODULE_LICENSE("GPL");
 
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
v9fs_vfs_mkdir-fix-a-double-free.patch
ifdef-acpi_future_usage-acpi_os_readable.patch
git-alsa.patch
cpu_freq_table-shouldnt-be-a-def_tristate.patch
drivers-char-drm-drm_mmc-remove-unused-exports.patch
git-dvb.patch
git-ieee1394.patch
git-libata-all.patch
mips-remove-smp_tune_scheduling.patch
mtd_ck804xrom-must-depend-on-pci.patch
git-ubi.patch
git-net.patch
net-uninline-skb_put-fix.patch
git-ocfs2.patch
git-scsi-misc.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
git-unionfs.patch
usb_rtl8150-must-select-mii.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
lumpy-reclaim-cleanup.patch
remove-include-linux-byteorder-pdp_endianh.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
drivers-char-vc_screenc-proper-prototypes.patch
add-taint_user-and-ability-to-set-taint-flags-from-userspace-fix.patch
schedule-obsolete-oss-drivers-for-removal-3rd-round.patch
cleanup-linux-byteorder-swabbh.patch
cleanup-include-linux-xattrh.patch
cleanup-include-linux-reiserfs_xattrh.patch
remove-dead-kernel-config-option-aedsp16_mpu401.patch
debug-shared-irqs-kconfig-fix.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
clockevents-i383-drivers.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
make-ext2_get_blocks-static.patch
drivers-edac-make-code-static.patch
drivers-isdn-pcbit-proper-prototypes.patch
drivers-isdn-hisax-proper-prototypes.patch
drivers-isdn-sc-proper-prototypes.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
ecryptfs-generalize-metadata-read-write-fs-ecryptfs-make-code-static.patch
readahead-events-accounting-make-readahead_debug_level-static.patch
reiser4-export-remove_from_page_cache-fix.patch
fs-reiser4-possible-cleanups.patch
reiser4-possible-cleanups-2.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
remove-broken-video-drivers-v4.patch
remove-bogus-con_is_present-prototypes.patch
proper-prototype-for-tosh_smm.patch
remove-the-broken-fb_s3trio-driver.patch
slim-main-patch-security-slim-slm_mainc-make-2-functions-static.patch
slim-debug-output-slm_set_taskperm-remove-horrible-error-handling-code.patch
sysctl-reimplement-the-sysctl-proc-support-fix-3.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
