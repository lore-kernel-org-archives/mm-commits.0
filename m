From: akpm@linux-foundation.org
Subject: + git-net-vs-git-nfs.patch added to -mm tree
Date: Sun, 16 Sep 2007 01:36:43 -0700
Message-ID: <200709160836.l8G8ahEp007563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbXIPIgq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 04:36:46 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8G8ah6w001773
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 16 Sep 2007 01:36:44 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-net-vs-git-nfs
has been added to the -mm tree.  Its filename is
     git-net-vs-git-nfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-net-vs-git-nfs
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtsock.c |   67 +++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 18 deletions(-)

diff -puN net/sunrpc/xprtsock.c~git-net-vs-git-nfs net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~git-net-vs-git-nfs
+++ a/net/sunrpc/xprtsock.c
@@ -1334,41 +1334,72 @@ static int xs_bind6(struct sock_xprt *tr
 static struct lock_class_key xs_key[2];
 static struct lock_class_key xs_slock_key[2];
 
-static inline void xs_reclassify_socket(struct socket *sock)
+static inline void xs_reclassify_socket4(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
+
 	BUG_ON(sock_owned_by_user(sk));
-	switch (sk->sk_family) {
-	case AF_INET:
-		sock_lock_init_class_and_name(sk, "slock-AF_INET-NFS",
-			&xs_slock_key[0], "sk_lock-AF_INET-NFS", &xs_key[0]);
-		break;
+	sock_lock_init_class_and_name(sk, "slock-AF_INET-RPC",
+		&xs_slock_key[0], "sk_lock-AF_INET-RPC", &xs_key[0]);
+}
 
-	case AF_INET6:
-		sock_lock_init_class_and_name(sk, "slock-AF_INET6-NFS",
-			&xs_slock_key[1], "sk_lock-AF_INET6-NFS", &xs_key[1]);
-		break;
+static inline void xs_reclassify_socket6(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
 
-	default:
-		BUG();
-	}
+	BUG_ON(sock_owned_by_user(sk));
+	sock_lock_init_class_and_name(sk, "slock-AF_INET6-RPC",
+		&xs_slock_key[1], "sk_lock-AF_INET6-RPC", &xs_key[1]);
 }
 #else
-static inline void xs_reclassify_socket(struct socket *sock)
+static inline void xs_reclassify_socket4(struct socket *sock)
+{
+}
+
+static inline void xs_reclassify_socket6(struct socket *sock)
 {
 }
 #endif
 
+static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
+{
+	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+
+	if (!transport->inet) {
+		struct sock *sk = sock->sk;
+
+		write_lock_bh(&sk->sk_callback_lock);
+
+		sk->sk_user_data = xprt;
+		transport->old_data_ready = sk->sk_data_ready;
+		transport->old_state_change = sk->sk_state_change;
+		transport->old_write_space = sk->sk_write_space;
+		sk->sk_data_ready = xs_udp_data_ready;
+		sk->sk_write_space = xs_udp_write_space;
+		sk->sk_no_check = UDP_CSUM_NORCV;
+		sk->sk_allocation = GFP_ATOMIC;
+
+		xprt_set_connected(xprt);
+
+		/* Reset to new socket */
+		transport->sock = sock;
+		transport->inet = sk;
+
+		write_unlock_bh(&sk->sk_callback_lock);
+	}
+	xs_udp_do_set_buffer_size(xprt);
+}
+
 /**
- * xs_udp_connect_worker - set up a UDP socket
+ * xs_udp_connect_worker4 - set up a UDP socket
  * @work: RPC transport to connect
  *
  * Invoked by a work queue tasklet.
  */
-static void xs_udp_connect_worker(struct work_struct *work)
+static void xs_udp_connect_worker4(struct work_struct *work)
 {
-	struct sock_xprt *transport =
-		container_of(work, struct sock_xprt, connect_worker.work);
+  	struct sock_xprt *transport =
+  		container_of(work, struct sock_xprt, connect_worker.work);
 	struct rpc_xprt *xprt = &transport->xprt;
 	struct socket *sock = transport->sock;
 	int err, status = -EIO;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-dac960-driver-on-machines-which-dont-support-64-bit-dma-fix.patch
atyfb-force-29mhz-xtal-on-g3-powerbooks.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
alsa-procfs-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
i2c-i801-smbus-patch-for-intel-tolapai-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
ata-add-the-sw-ncq-support-to-sata_nv-for-mcp51-mcp55-mcp61patch.patch
ide-arm-hack.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
git-mmc.patch
git-mmc-fixup2.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-net.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-backlight-build-fix.patch
git-backlight-dependency-fix.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
irq-irq-and-pci_ids-patch-for-intel-tolapai-fix.patch
git-s390.patch
git-scsi-misc.patch
advansys-printk-fix.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
git-kgdb-fixup-2.patch
i386-apic-fix-4-bit-apicid-assumption-of-mach-default.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
dir_index-error-out-instead-of-bug-on-corrupt-dx-dirs.patch
modpost-detect-unterminated-device-id-lists-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
