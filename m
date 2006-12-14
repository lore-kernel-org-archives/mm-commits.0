From: akpm@osdl.org
Subject: - revert-identifier-to-nsproxy.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:02:54 -0800
Message-ID: <200612140602.kBE62sNH001761@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51645 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbWLNGDX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:03:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Revert "[PATCH] identifier to nsproxy"
has been removed from the -mm tree.  Its filename was
     revert-identifier-to-nsproxy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Revert "[PATCH] identifier to nsproxy"
From: Eric W. Biederman <ebiederm@xmission.com>

This reverts commit 373beb35cd6b625e0ba4ad98baace12310a26aa8.

No one is using this identifier yet.  The purpose of this identifier is to
export nsproxy to user space which is wrong.  nsproxy is an internal
implementation optimization, which should keep our fork times from getting
slower as we increase the number of global namespaces you don't have to
share.

Adding a global identifier like this is inappropriate because it makes
namespaces inherently non-recursive, greatly limiting what we can do with
them in the future.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/init_task.h |    1 -
 include/linux/nsproxy.h   |    1 -
 kernel/nsproxy.c          |    4 +---
 3 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/init_task.h~revert-identifier-to-nsproxy include/linux/init_task.h
--- a/include/linux/init_task.h~revert-identifier-to-nsproxy
+++ a/include/linux/init_task.h
@@ -75,7 +75,6 @@ extern struct nsproxy init_nsproxy;
 	.pid_ns		= &init_pid_ns,					\
 	.count		= ATOMIC_INIT(1),				\
 	.nslock		= __SPIN_LOCK_UNLOCKED(nsproxy.nslock),		\
-	.id		= 0,						\
 	.uts_ns		= &init_uts_ns,					\
 	.mnt_ns		= NULL,						\
 	INIT_IPC_NS(ipc_ns)						\
diff -puN include/linux/nsproxy.h~revert-identifier-to-nsproxy include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~revert-identifier-to-nsproxy
+++ a/include/linux/nsproxy.h
@@ -24,7 +24,6 @@ struct pid_namespace;
 struct nsproxy {
 	atomic_t count;
 	spinlock_t nslock;
-	unsigned long id;
 	struct uts_namespace *uts_ns;
 	struct ipc_namespace *ipc_ns;
 	struct mnt_namespace *mnt_ns;
diff -puN kernel/nsproxy.c~revert-identifier-to-nsproxy kernel/nsproxy.c
--- a/kernel/nsproxy.c~revert-identifier-to-nsproxy
+++ a/kernel/nsproxy.c
@@ -46,10 +46,8 @@ static inline struct nsproxy *clone_name
 	struct nsproxy *ns;
 
 	ns = kmemdup(orig, sizeof(struct nsproxy), GFP_KERNEL);
-	if (ns) {
+	if (ns)
 		atomic_set(&ns->count, 1);
-		ns->id = -1;
-	}
 	return ns;
 }
 
_

Patches currently in -mm which might be from ebiederm@xmission.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
usbatm-update-to-use-the-kthread-api.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

