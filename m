From: akpm@linux-foundation.org
Subject: - sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:20 -0800
Message-ID: <200702150848.l1F8mKmF025041@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965389AbXBOIsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:48:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, neilb@cse.unsw.edu.au, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sysctl: sunrpc: don't unnecessarily set ctl_table->de
has been removed from the -mm tree.  Its filename was
     sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: sunrpc: don't unnecessarily set ctl_table->de
From: Eric W. Biederman <ebiederm@xmission.com>

We don't need this to prevent module unload races so remove the unnecessary
code.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/sysctl.c   |    8 +-------
 net/sunrpc/xprtsock.c |    7 +------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN net/sunrpc/sysctl.c~sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de net/sunrpc/sysctl.c
--- a/net/sunrpc/sysctl.c~sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de
+++ a/net/sunrpc/sysctl.c
@@ -35,14 +35,8 @@ static ctl_table		sunrpc_table[];
 void
 rpc_register_sysctl(void)
 {
-	if (!sunrpc_table_header) {
+	if (!sunrpc_table_header)
 		sunrpc_table_header = register_sysctl_table(sunrpc_table, 0);
-#ifdef CONFIG_PROC_FS
-		if (sunrpc_table[0].de)
-			sunrpc_table[0].de->owner = THIS_MODULE;
-#endif
-	}
-
 }
 
 void
diff -puN net/sunrpc/xprtsock.c~sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de net/sunrpc/xprtsock.c
--- a/net/sunrpc/xprtsock.c~sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de
+++ a/net/sunrpc/xprtsock.c
@@ -1635,13 +1635,8 @@ struct rpc_xprt *xs_setup_tcp(struct soc
 int init_socket_xprt(void)
 {
 #ifdef RPC_DEBUG
-	if (!sunrpc_table_header) {
+	if (!sunrpc_table_header)
 		sunrpc_table_header = register_sysctl_table(sunrpc_table, 0);
-#ifdef CONFIG_PROC_FS
-		if (sunrpc_table[0].de)
-			sunrpc_table[0].de->owner = THIS_MODULE;
-#endif
-	}
 #endif
 
 	return 0;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
