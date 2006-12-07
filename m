From: akpm@osdl.org
Subject: - fs-lockd-hostc-make-2-functions-static.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:18 -0800
Message-ID: <200612072306.kB7N6IPc030243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52974 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163857AbWLGXJe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:09:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@stusta.de, mm-commits@vger.kernel.org


The patch titled
     fs/lockd/host.c: make 2 functions static
has been removed from the -mm tree.  Its filename was
     fs-lockd-hostc-make-2-functions-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/lockd/host.c: make 2 functions static
From: Adrian Bunk <bunk@stusta.de>

Make the following needlessly global functions static:

- nlm_lookup_host()
- nsm_find()

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/lockd/host.c             |   53 +++++++++++++++++-----------------
 include/linux/lockd/lockd.h |    2 -
 2 files changed, 28 insertions(+), 27 deletions(-)

diff -puN fs/lockd/host.c~fs-lockd-hostc-make-2-functions-static fs/lockd/host.c
--- a/fs/lockd/host.c~fs-lockd-hostc-make-2-functions-static
+++ a/fs/lockd/host.c
@@ -36,34 +36,14 @@ static DEFINE_MUTEX(nlm_host_mutex);
 static void			nlm_gc_hosts(void);
 static struct nsm_handle *	__nsm_find(const struct sockaddr_in *,
 					const char *, int, int);
-
-/*
- * Find an NLM server handle in the cache. If there is none, create it.
- */
-struct nlm_host *
-nlmclnt_lookup_host(const struct sockaddr_in *sin, int proto, int version,
-			const char *hostname, int hostname_len)
-{
-	return nlm_lookup_host(0, sin, proto, version,
-			       hostname, hostname_len);
-}
-
-/*
- * Find an NLM client handle in the cache. If there is none, create it.
- */
-struct nlm_host *
-nlmsvc_lookup_host(struct svc_rqst *rqstp,
-			const char *hostname, int hostname_len)
-{
-	return nlm_lookup_host(1, &rqstp->rq_addr,
-			       rqstp->rq_prot, rqstp->rq_vers,
-			       hostname, hostname_len);
-}
+static struct nsm_handle *	nsm_find(const struct sockaddr_in *sin,
+					 const char *hostname,
+					 int hostname_len);
 
 /*
  * Common host lookup routine for server & client
  */
-struct nlm_host *
+static struct nlm_host *
 nlm_lookup_host(int server, const struct sockaddr_in *sin,
 					int proto, int version,
 					const char *hostname,
@@ -195,6 +175,29 @@ nlm_destroy_host(struct nlm_host *host)
 }
 
 /*
+ * Find an NLM server handle in the cache. If there is none, create it.
+ */
+struct nlm_host *
+nlmclnt_lookup_host(const struct sockaddr_in *sin, int proto, int version,
+			const char *hostname, int hostname_len)
+{
+	return nlm_lookup_host(0, sin, proto, version,
+			       hostname, hostname_len);
+}
+
+/*
+ * Find an NLM client handle in the cache. If there is none, create it.
+ */
+struct nlm_host *
+nlmsvc_lookup_host(struct svc_rqst *rqstp,
+			const char *hostname, int hostname_len)
+{
+	return nlm_lookup_host(1, &rqstp->rq_addr,
+			       rqstp->rq_prot, rqstp->rq_vers,
+			       hostname, hostname_len);
+}
+
+/*
  * Create the NLM RPC client for an NLM peer
  */
 struct rpc_clnt *
@@ -495,7 +498,7 @@ out:
 	return nsm;
 }
 
-struct nsm_handle *
+static struct nsm_handle *
 nsm_find(const struct sockaddr_in *sin, const char *hostname, int hostname_len)
 {
 	return __nsm_find(sin, hostname, hostname_len, 1);
diff -puN include/linux/lockd/lockd.h~fs-lockd-hostc-make-2-functions-static include/linux/lockd/lockd.h
--- a/include/linux/lockd/lockd.h~fs-lockd-hostc-make-2-functions-static
+++ a/include/linux/lockd/lockd.h
@@ -164,14 +164,12 @@ void		  nlmclnt_next_cookie(struct nlm_c
  */
 struct nlm_host * nlmclnt_lookup_host(const struct sockaddr_in *, int, int, const char *, int);
 struct nlm_host * nlmsvc_lookup_host(struct svc_rqst *, const char *, int);
-struct nlm_host * nlm_lookup_host(int server, const struct sockaddr_in *, int, int, const char *, int);
 struct rpc_clnt * nlm_bind_host(struct nlm_host *);
 void		  nlm_rebind_host(struct nlm_host *);
 struct nlm_host * nlm_get_host(struct nlm_host *);
 void		  nlm_release_host(struct nlm_host *);
 void		  nlm_shutdown_hosts(void);
 extern void	  nlm_host_rebooted(const struct sockaddr_in *, const char *, int, u32);
-struct nsm_handle *nsm_find(const struct sockaddr_in *, const char *, int);
 void		  nsm_release(struct nsm_handle *);
 
 
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

