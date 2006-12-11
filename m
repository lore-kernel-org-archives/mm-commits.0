From: akpm@osdl.org
Subject: + revert-identifier-to-nsproxy.patch added to -mm tree
Date: Mon, 11 Dec 2006 12:27:50 -0800
Message-ID: <200612112027.kBBKRo1X006317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34602 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762386AbWLKUiQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Dec 2006 15:38:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com


The patch titled
     Revert "[PATCH] identifier to nsproxy"
has been added to the -mm tree.  Its filename is
     revert-identifier-to-nsproxy.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
revert-identifier-to-nsproxy.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

