From: akpm@osdl.org
Subject: - sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-2.patch removed from -mm tree
Date: Fri, 08 Dec 2006 01:06:45 -0800
Message-ID: <200612080906.kB896k6b014431@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38984 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425266AbWLHJGs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 04:06:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: ipc fix compilation with CONFIG_SYSCTL_SYSCALL=n
has been removed from the -mm tree.  Its filename was
     sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-2.patch

This patch was dropped because it was folded into sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch

------------------------------------------------------
Subject: sysctl: ipc fix compilation with CONFIG_SYSCTL_SYSCALL=n
From: Eric W. Biederman <ebiederm@xmission.com>

I goofed and failed to handle the CONFIG_SYSCTL_SYSCALL=n
case, with respect to sysctl_ipc_data.  The clean fix is to
provide a dummy stub that returns -ENOSYS....

I'm certain there is a better way but not today.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN kernel/sysctl.c~sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-2 kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-2
+++ a/kernel/sysctl.c
@@ -2742,6 +2742,12 @@ static int sysctl_uts_string(ctl_table *
 {
 	return -ENOSYS;
 }
+static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen, void **context)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 /*
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
fix-linux-banner-utsname-information.patch
add-process_session-helper-routine.patch
rename-struct-namespace-to-struct-mnt_namespace.patch
add-an-identifier-to-nsproxy.patch
rename-struct-pspace-to-struct-pid_namespace.patch
add-pid_namespace-to-nsproxy.patch
use-current-nsproxy-pid_ns.patch
add-child-reaper-to-pid_namespace.patch
sysctl-simplify-sysctl_uts_string.patch
sysctl-implement-sysctl_uts_string.patch
sysctl-simplify-ipc-ns-specific-sysctls.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-2.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls-fix-3.patch

