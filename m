From: akpm@linux-foundation.org
Subject: + net-unix-af_unixc-make-code-static.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:07:00 -0700
Message-ID: <200707302207.l6UM70kR000414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41647 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S939039AbXG3WHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     From: Adrian Bunk <bunk@stusta.de>
has been added to the -mm tree.  Its filename is
     net-unix-af_unixc-make-code-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: From: Adrian Bunk <bunk@stusta.de>


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
git-acpi.patch
drivers-acpi-sbsc-remove-dead-code.patch
make-drivers-acpi-eventcacpi_event_seqnum-static.patch
git-alsa.patch
kernel-auditscc-fix-an-off-by-one.patch
drivers-base-power-make-2-functions-static.patch
git-drm.patch
git-dvb.patch
drivers-i2c-i2c-corec-make-code-static.patch
git-hwmon.patch
git-kvm.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
git-mmc.patch
git-mtd.patch
drivers-net-cxgb3-xgmacc-remove-dead-code.patch
fore200e_param_bs_queue-must-be-__devinit.patch
git-ocfs2.patch
cpqphp_ctrlc-remove-dead-code.patch
drivers-scsi-pcmcia-nsp_csc-remove-kernel-24-code.patch
nsp32_restart_autoscsi-remove-error-check.patch
git-unionfs.patch
git-v9fs.patch
git-ipwireless_cs.patch
arch-i386-kernel-smpbootcsetup_trampoline-must-be.patch
i386-remove-maccumulate-outgoing-args.patch
arch-i386-mach-generic-probec-make-struct-apic_probe.patch
arch-i386-mach-es7000-es7000platc-cleanups.patch
i386-alternativec-really-stop-mces-during-code.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
usb_serial_suspend-buggy-code.patch
slubcearly_kmem_cache_node_alloc-shouldnt-be.patch
maps2-add-proc-kpagemap-interface.patch
hugetlbfs-read-support-fix-2.patch
fs-reiserfs-cleanups.patch
anon_inodes-shouldnt-be-user-visible.patch
remove-unsafe-from-module-struct.patch
introduce-i_sync-fix.patch
ext2-reservations.patch
radeon_driver_vblank_do_wait-static.patch
intel-iommu-intel-iommu-driver.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
the-next-round-of-scheduled-oss-code-removal.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
mutex-subsystem-synchro-test-module.patch
kernel-rtmutex-debugc-cleanups.patch
fs-nfsd-exportc-make-3-functions-static.patch
mm-page_allocc-make-code-static.patch
make-struct-sony_nc_ids-static.patch
make-pktgencget_ipsec_sa-static-and-non-inline.patch
make-nf_ct_ipv6_skip_exthdr-static.patch
net-unix-af_unixc-make-code-static.patch
drivers-usb-serial-sierrac-make-3-functions-static.patch
backlight-make-2-structs-static.patch
unexport-pm_power_off_prepare.patch
unexport-fb_prepare_logo.patch
