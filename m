From: akpm@osdl.org
Subject: + uts-namespace-remove-config_uts_ns.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:58:37 -0800
Message-ID: <200701240358.l0O3wbWf007805@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965647AbXAXEIV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 23:08:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     uts namespace: remove CONFIG_UTS_NS
has been added to the -mm tree.  Its filename is
     uts-namespace-remove-config_uts_ns.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uts namespace: remove CONFIG_UTS_NS
From: Cedric Le Goater <clg@fr.ibm.com>

CONFIG_UTS_NS has very little value as it only deactivates the unshare
of the uts namespace and does not improve performance.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/utsname.h |   19 -------------------
 init/Kconfig            |    8 --------
 kernel/Makefile         |    3 +--
 kernel/sysctl.c         |    3 +--
 4 files changed, 2 insertions(+), 31 deletions(-)

diff -puN include/linux/utsname.h~uts-namespace-remove-config_uts_ns include/linux/utsname.h
--- a/include/linux/utsname.h~uts-namespace-remove-config_uts_ns
+++ a/include/linux/utsname.h
@@ -48,7 +48,6 @@ static inline void get_uts_ns(struct uts
 	kref_get(&ns->kref);
 }
 
-#ifdef CONFIG_UTS_NS
 extern int unshare_utsname(unsigned long unshare_flags,
 				struct uts_namespace **new_uts);
 extern int copy_utsname(int flags, struct task_struct *tsk);
@@ -58,24 +57,6 @@ static inline void put_uts_ns(struct uts
 {
 	kref_put(&ns->kref, free_uts_ns);
 }
-#else
-static inline int unshare_utsname(unsigned long unshare_flags,
-			struct uts_namespace **new_uts)
-{
-	if (unshare_flags & CLONE_NEWUTS)
-		return -EINVAL;
-
-	return 0;
-}
-
-static inline int copy_utsname(int flags, struct task_struct *tsk)
-{
-	return 0;
-}
-static inline void put_uts_ns(struct uts_namespace *ns)
-{
-}
-#endif
 
 static inline struct new_utsname *utsname(void)
 {
diff -puN init/Kconfig~uts-namespace-remove-config_uts_ns init/Kconfig
--- a/init/Kconfig~uts-namespace-remove-config_uts_ns
+++ a/init/Kconfig
@@ -214,14 +214,6 @@ config TASK_DELAY_ACCT
 
 	  Say N if unsure.
 
-config UTS_NS
-	bool "UTS Namespaces"
-	default n
-	help
-	  Support uts namespaces.  This allows containers, i.e.
-	  vservers, to use uts namespaces to provide different
-	  uts info for different servers.  If unsure, say N.
-
 config AUDIT
 	bool "Auditing support"
 	depends on NET
diff -puN kernel/Makefile~uts-namespace-remove-config_uts_ns kernel/Makefile
--- a/kernel/Makefile~uts-namespace-remove-config_uts_ns
+++ a/kernel/Makefile
@@ -8,7 +8,7 @@ obj-y     = sched.o fork.o exec_domain.o
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
-	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o
+	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o utsname.o
 
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
 obj-y += time/
@@ -47,7 +47,6 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RELAY) += relay.o
-obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 
diff -puN kernel/sysctl.c~uts-namespace-remove-config_uts_ns kernel/sysctl.c
--- a/kernel/sysctl.c~uts-namespace-remove-config_uts_ns
+++ a/kernel/sysctl.c
@@ -181,10 +181,9 @@ int sysctl_legacy_va_layout;
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
-#ifdef CONFIG_UTS_NS
 	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
 	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
-#endif
+
 	if (!write)
 		down_read(&uts_sem);
 	else
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
uts-namespace-remove-config_uts_ns.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
