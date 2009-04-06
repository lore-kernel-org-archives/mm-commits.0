From: akpm@linux-foundation.org
Subject: [merged] proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:36:07 -0700
Message-ID: <200904061936.n36Ja70M012343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbZDFUPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, adobriyan@gmail.com, clg@fr.ibm.com, mm-commits@vger.kernel.org


The patch titled
     proc_sysctl: use CONFIG_PROC_SYSCTL around ipc and utsname proc_handlers
has been removed from the -mm tree.  Its filename was
     proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc_sysctl: use CONFIG_PROC_SYSCTL around ipc and utsname proc_handlers
From: "Serge E. Hallyn" <serue@us.ibm.com>

As pointed out by Cedric Le Goater (in response to Alexey's original
comment wrt mqns), ipc_sysctl.c and utsname_sysctl.c are using
CONFIG_PROC_FS, not CONFIG_PROC_SYSCTL, to determine whether to define
the proc_handlers.  Change that.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/ipc_sysctl.c        |    2 +-
 kernel/utsname_sysctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN ipc/ipc_sysctl.c~proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers ipc/ipc_sysctl.c
--- a/ipc/ipc_sysctl.c~proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers
+++ a/ipc/ipc_sysctl.c
@@ -26,7 +26,7 @@ static void *get_ipc(ctl_table *table)
 	return which;
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
diff -puN kernel/utsname_sysctl.c~proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~proc_sysctl-use-config_proc_sysctl-around-ipc-and-utsname-proc_handlers
+++ a/kernel/utsname_sysctl.c
@@ -37,7 +37,7 @@ static void put_uts(ctl_table *table, in
 		up_write(&uts_sem);
 }
 
-#ifdef CONFIG_PROC_FS
+#ifdef CONFIG_PROC_SYSCTL
 /*
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
_

Patches currently in -mm which might be from serue@us.ibm.com are

origin.patch
linux-next.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
namespaces-mqueue-ns-move-mqueue_mnt-into-struct-ipc_namespace.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues.patch
namespaces-ipc-namespaces-implement-support-for-posix-msqueues-initialize-init_ipc_nscount-to-1.patch
namespaces-mqueue-namespace-adapt-sysctl.patch
namespaces-mqueue-namespace-adapt-sysctl-update.patch
namespaces-mqueue-namespace-adapt-sysctl-update-fix.patch
reiser4.patch

