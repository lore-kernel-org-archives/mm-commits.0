From: akpm@linux-foundation.org
Subject: - sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:48:14 -0800
Message-ID: <200702150848.l1F8mEBA025035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965385AbXBOIsg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, neilb@cse.unsw.edu.au, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     sysctl: move CTL_SUNRPC to sysctl.h where it belongs
has been removed from the -mm tree.  Its filename was
     sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: move CTL_SUNRPC to sysctl.h where it belongs
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sunrpc/debug.h |    1 -
 include/linux/sysctl.h       |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/sunrpc/debug.h~sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs include/linux/sunrpc/debug.h
--- a/include/linux/sunrpc/debug.h~sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs
+++ a/include/linux/sunrpc/debug.h
@@ -78,7 +78,6 @@ void		rpc_unregister_sysctl(void);
  * module currently registers its sysctl table dynamically, the sysctl path
  * for module FOO is <CTL_SUNRPC, CTL_FOODEBUG>.
  */
-#define CTL_SUNRPC	7249	/* arbitrary and hopefully unused */
 
 enum {
 	CTL_RPCDEBUG = 1,
diff -puN include/linux/sysctl.h~sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs
+++ a/include/linux/sysctl.h
@@ -69,7 +69,8 @@ enum
 	CTL_DEV=7,		/* Devices */
 	CTL_BUS=8,		/* Busses */
 	CTL_ABI=9,		/* Binary emulation */
-	CTL_CPU=10		/* CPU stuff (speed scaling, etc) */
+	CTL_CPU=10,		/* CPU stuff (speed scaling, etc) */
+	CTL_SUNRPC=7249,	/* sunrpc debug */
 };
 
 /* CTL_BUS names: */
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
