From: akpm@linux-foundation.org
Subject: + fs-afs-possible-cleanups.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:47:11 -0700
Message-ID: <200707302247.l6UMlB6l002489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36558 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755312AbXG3WsE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:48:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de, dhowells@redhat.com


The patch titled
     fs/afs/: possible cleanups
has been added to the -mm tree.  Its filename is
     fs-afs-possible-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fs/afs/: possible cleanups
From: Adrian Bunk <bunk@stusta.de>

This patch contains the following possible cleanups:
- make the following needlessly global functions static:
  - rxrpc.c: afs_send_pages()
  - vlocation.c: afs_vlocation_queue_for_updates()
  - write.c: afs_writepages_region()
- make the following needlessly global variables static:
  - mntpt.c: afs_mntpt_expiry_timeout
  - proc.c: afs_vlocation_states[]
  - server.c: afs_server_timeout
  - vlocation.c: afs_vlocation_timeout
  - vlocation.c: afs_vlocation_update_timeout
- #if 0 the following unused function:
  - cell.c: afs_get_cell_maybe()
- #if 0 the following unused variables:
  - callback.c: afs_vnode_update_timeout
  - cmservice.c: struct afs_cm_workqueue

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/callback.c  |    2 ++
 fs/afs/cell.c      |    2 ++
 fs/afs/cmservice.c |    2 ++
 fs/afs/internal.h  |    1 -
 fs/afs/mntpt.c     |    2 +-
 fs/afs/proc.c      |    2 +-
 fs/afs/rxrpc.c     |    3 ++-
 fs/afs/server.c    |    2 +-
 fs/afs/vlocation.c |    6 +++---
 fs/afs/write.c     |    6 +++---
 10 files changed, 17 insertions(+), 11 deletions(-)

diff -puN fs/afs/callback.c~fs-afs-possible-cleanups fs/afs/callback.c
--- a/fs/afs/callback.c~fs-afs-possible-cleanups
+++ a/fs/afs/callback.c
@@ -20,7 +20,9 @@
 #include <linux/sched.h>
 #include "internal.h"
 
+#if 0
 unsigned afs_vnode_update_timeout = 10;
+#endif  /*  0  */
 
 #define afs_breakring_space(server) \
 	CIRC_SPACE((server)->cb_break_head, (server)->cb_break_tail,	\
diff -puN fs/afs/cell.c~fs-afs-possible-cleanups fs/afs/cell.c
--- a/fs/afs/cell.c~fs-afs-possible-cleanups
+++ a/fs/afs/cell.c
@@ -265,6 +265,7 @@ struct afs_cell *afs_cell_lookup(const c
 	return cell;
 }
 
+#if 0
 /*
  * try and get a cell record
  */
@@ -280,6 +281,7 @@ struct afs_cell *afs_get_cell_maybe(stru
 	write_unlock(&afs_cells_lock);
 	return cell;
 }
+#endif  /*  0  */
 
 /*
  * destroy a cell record
diff -puN fs/afs/cmservice.c~fs-afs-possible-cleanups fs/afs/cmservice.c
--- a/fs/afs/cmservice.c~fs-afs-possible-cleanups
+++ a/fs/afs/cmservice.c
@@ -16,7 +16,9 @@
 #include "internal.h"
 #include "afs_cm.h"
 
+#if 0
 struct workqueue_struct *afs_cm_workqueue;
+#endif  /*  0  */
 
 static int afs_deliver_cb_init_call_back_state(struct afs_call *,
 					       struct sk_buff *, bool);
diff -puN fs/afs/internal.h~fs-afs-possible-cleanups fs/afs/internal.h
--- a/fs/afs/internal.h~fs-afs-possible-cleanups
+++ a/fs/afs/internal.h
@@ -570,7 +570,6 @@ extern int afs_abort_to_error(u32);
  */
 extern const struct inode_operations afs_mntpt_inode_operations;
 extern const struct file_operations afs_mntpt_file_operations;
-extern unsigned long afs_mntpt_expiry_timeout;
 
 extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
 extern void afs_mntpt_kill_timer(void);
diff -puN fs/afs/mntpt.c~fs-afs-possible-cleanups fs/afs/mntpt.c
--- a/fs/afs/mntpt.c~fs-afs-possible-cleanups
+++ a/fs/afs/mntpt.c
@@ -42,7 +42,7 @@ const struct inode_operations afs_mntpt_
 static LIST_HEAD(afs_vfsmounts);
 static DECLARE_DELAYED_WORK(afs_mntpt_expiry_timer, afs_mntpt_expiry_timed_out);
 
-unsigned long afs_mntpt_expiry_timeout = 10 * 60;
+static unsigned long afs_mntpt_expiry_timeout = 10 * 60;
 
 /*
  * check a symbolic link to see whether it actually encodes a mountpoint
diff -puN fs/afs/proc.c~fs-afs-possible-cleanups fs/afs/proc.c
--- a/fs/afs/proc.c~fs-afs-possible-cleanups
+++ a/fs/afs/proc.c
@@ -513,7 +513,7 @@ static void afs_proc_cell_volumes_stop(s
 	up_read(&cell->vl_sem);
 }
 
-const char afs_vlocation_states[][4] = {
+static const char afs_vlocation_states[][4] = {
 	[AFS_VL_NEW]			= "New",
 	[AFS_VL_CREATING]		= "Crt",
 	[AFS_VL_VALID]			= "Val",
diff -puN fs/afs/rxrpc.c~fs-afs-possible-cleanups fs/afs/rxrpc.c
--- a/fs/afs/rxrpc.c~fs-afs-possible-cleanups
+++ a/fs/afs/rxrpc.c
@@ -239,7 +239,8 @@ void afs_flat_call_destructor(struct afs
 /*
  * attach the data from a bunch of pages on an inode to a call
  */
-int afs_send_pages(struct afs_call *call, struct msghdr *msg, struct kvec *iov)
+static int afs_send_pages(struct afs_call *call, struct msghdr *msg,
+			  struct kvec *iov)
 {
 	struct page *pages[8];
 	unsigned count, n, loop, offset, to;
diff -puN fs/afs/server.c~fs-afs-possible-cleanups fs/afs/server.c
--- a/fs/afs/server.c~fs-afs-possible-cleanups
+++ a/fs/afs/server.c
@@ -13,7 +13,7 @@
 #include <linux/slab.h>
 #include "internal.h"
 
-unsigned afs_server_timeout = 10;	/* server timeout in seconds */
+static unsigned afs_server_timeout = 10;	/* server timeout in seconds */
 
 static void afs_reap_server(struct work_struct *);
 
diff -puN fs/afs/vlocation.c~fs-afs-possible-cleanups fs/afs/vlocation.c
--- a/fs/afs/vlocation.c~fs-afs-possible-cleanups
+++ a/fs/afs/vlocation.c
@@ -15,8 +15,8 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
-unsigned afs_vlocation_update_timeout = 10 * 60;
+static unsigned afs_vlocation_timeout = 10;	/* volume location timeout in seconds */
+static unsigned afs_vlocation_update_timeout = 10 * 60;
 
 static void afs_vlocation_reaper(struct work_struct *);
 static void afs_vlocation_updater(struct work_struct *);
@@ -335,7 +335,7 @@ static int afs_vlocation_fill_in_record(
 /*
  * queue a vlocation record for updates
  */
-void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
+static void afs_vlocation_queue_for_updates(struct afs_vlocation *vl)
 {
 	struct afs_vlocation *xvl;
 
diff -puN fs/afs/write.c~fs-afs-possible-cleanups fs/afs/write.c
--- a/fs/afs/write.c~fs-afs-possible-cleanups
+++ a/fs/afs/write.c
@@ -510,9 +510,9 @@ int afs_writepage(struct page *page, str
 /*
  * write a region of pages back to the server
  */
-int afs_writepages_region(struct address_space *mapping,
-			  struct writeback_control *wbc,
-			  pgoff_t index, pgoff_t end, pgoff_t *_next)
+static int afs_writepages_region(struct address_space *mapping,
+				 struct writeback_control *wbc,
+				 pgoff_t index, pgoff_t end, pgoff_t *_next)
 {
 	struct backing_dev_info *bdi = mapping->backing_dev_info;
 	struct afs_writeback *wb;
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
slow-down-printk-during-boot-fix-3.patch
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
make-struct-sony_nc_ids-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
export-v4l2_int_device_unregister.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
fore200e_param_bs_queue-must-be-__devinit.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
git-unionfs.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
fix-gregkh-usb-usb-add-the-concept-of-default-authorization-to-usb-hosts.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
fs-nfsd-exportc-make-3-functions-static.patch
radeon_driver_vblank_do_wait-static.patch
unexport-fb_prepare_logo.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
drivers-scsi-scsi_errorc-should-include.patch
include-linux-kbuild-remove-duplicate-entries.patch
parisc-extern-inline-static-inline.patch
remove-fs-jffs2-ioctlc.patch
drivers-scsi-constantsc-make-2-functions-static.patch
fs-afs-possible-cleanups.patch
ppc-remove-apus-support.patch
lib-ioremapc-should-include-linux-ioh.patch
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
ipc-shmc-make-2-functions-static.patch
kernel-schedc-make-code-static.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
