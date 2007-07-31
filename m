From: akpm@linux-foundation.org
Subject: - net-unix-af_unixc-make-code-static.patch removed from -mm tree
Date: Mon, 30 Jul 2007 22:01:23 -0700
Message-ID: <200707310501.l6V51NGv016548@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51256 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968745AbXGaFBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 01:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     net/unix/af_unix.c: make code static
has been removed from the -mm tree.  Its filename was
     net-unix-af_unixc-make-code-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net/unix/af_unix.c: make code static


The following code can now become static:
- struct unix_socket_table
- unix_table_lock

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/af_unix.h |   29 -----------------------------
 net/unix/af_unix.c    |   30 ++++++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 31 deletions(-)

diff -puN include/net/af_unix.h~net-unix-af_unixc-make-code-static include/net/af_unix.h
--- a/include/net/af_unix.h~net-unix-af_unixc-make-code-static
+++ a/include/net/af_unix.h
@@ -12,37 +12,8 @@ extern void unix_gc(void);
 
 #define UNIX_HASH_SIZE	256
 
-extern struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
-extern spinlock_t unix_table_lock;
-
 extern atomic_t unix_tot_inflight;
 
-static inline struct sock *first_unix_socket(int *i)
-{
-	for (*i = 0; *i <= UNIX_HASH_SIZE; (*i)++) {
-		if (!hlist_empty(&unix_socket_table[*i]))
-			return __sk_head(&unix_socket_table[*i]);
-	}
-	return NULL;
-}
-
-static inline struct sock *next_unix_socket(int *i, struct sock *s)
-{
-	struct sock *next = sk_next(s);
-	/* More in this chain? */
-	if (next)
-		return next;
-	/* Look for next non-empty chain. */
-	for ((*i)++; *i <= UNIX_HASH_SIZE; (*i)++) {
-		if (!hlist_empty(&unix_socket_table[*i]))
-			return __sk_head(&unix_socket_table[*i]);
-	}
-	return NULL;
-}
-
-#define forall_unix_sockets(i, s) \
-	for (s = first_unix_socket(&(i)); s; s = next_unix_socket(&(i),(s)))
-
 struct unix_address {
 	atomic_t	refcnt;
 	int		len;
diff -puN net/unix/af_unix.c~net-unix-af_unixc-make-code-static net/unix/af_unix.c
--- a/net/unix/af_unix.c~net-unix-af_unixc-make-code-static
+++ a/net/unix/af_unix.c
@@ -118,14 +118,40 @@
 
 int sysctl_unix_max_dgram_qlen __read_mostly = 10;
 
-struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
-DEFINE_SPINLOCK(unix_table_lock);
+static struct hlist_head unix_socket_table[UNIX_HASH_SIZE + 1];
+static DEFINE_SPINLOCK(unix_table_lock);
 static atomic_t unix_nr_socks = ATOMIC_INIT(0);
 
 #define unix_sockets_unbound	(&unix_socket_table[UNIX_HASH_SIZE])
 
 #define UNIX_ABSTRACT(sk)	(unix_sk(sk)->addr->hash != UNIX_HASH_SIZE)
 
+static struct sock *first_unix_socket(int *i)
+{
+	for (*i = 0; *i <= UNIX_HASH_SIZE; (*i)++) {
+		if (!hlist_empty(&unix_socket_table[*i]))
+			return __sk_head(&unix_socket_table[*i]);
+	}
+	return NULL;
+}
+
+static struct sock *next_unix_socket(int *i, struct sock *s)
+{
+	struct sock *next = sk_next(s);
+	/* More in this chain? */
+	if (next)
+		return next;
+	/* Look for next non-empty chain. */
+	for ((*i)++; *i <= UNIX_HASH_SIZE; (*i)++) {
+		if (!hlist_empty(&unix_socket_table[*i]))
+			return __sk_head(&unix_socket_table[*i]);
+	}
+	return NULL;
+}
+
+#define forall_unix_sockets(i, s) \
+	for (s = first_unix_socket(&(i)); s; s = next_unix_socket(&(i),(s)))
+
 #ifdef CONFIG_SECURITY_NETWORK
 static void unix_get_secdata(struct scm_cookie *scm, struct sk_buff *skb)
 {
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
remove-the-arm26-port.patch
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
include-linux-kbuild-remove-duplicate-entries.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
mtd-onenand_simc-make-struct-info-static.patch
remove-fs-jffs2-ioctlc.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
e1000-if-0-two-functions.patch
git-net.patch
fore200e_param_bs_queue-must-be-__devinit.patch
backlight-make-2-structs-static.patch
git-ocfs2.patch
parisc-extern-inline-static-inline.patch
cpqphp_ctrlc-remove-dead-code.patch
kernel-schedc-make-code-static.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
make-scsi_host_link_pm_policy-static.patch
drivers-scsi-scsi_errorc-should-include.patch
drivers-scsi-constantsc-make-2-functions-static.patch
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
i386-no-need-to-make-enable_cpu_hotplug-a-variable.patch
arch-i386-mm-discontigc-make-some-variables-static.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
acpi_ec_remove-fix-use-after-free.patch
acpi_battery_add-use-after-free.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
mm-page_allocc-make-code-static.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
mm-shmemc-make-3-functions-static.patch
mm-migratec-cleanups.patch
mm-mempolicyc-cleanups.patch
mm-vmstatc-cleanups.patch
cleanup-arch-alpha-makefile.patch
unexport-pm_power_off_prepare.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
kernel-rtmutex-debugc-cleanups.patch
fs-afs-possible-cleanups.patch
lib-ioremapc-should-include-linux-ioh.patch
ipc-shmc-make-2-functions-static.patch
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
