From: akpm@osdl.org
Subject: - user-namespace-add-the-framework-fix.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:14:52 -0800
Message-ID: <200702010115.l111Fo8o032442@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35374 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030565AbXBABTl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:19:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: serue@us.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, mm-commits@vger.kernel.org


The patch titled
     user namespace: add the framework fix
has been removed from the -mm tree.  Its filename was
     user-namespace-add-the-framework-fix.patch

This patch was dropped because it was folded into user-namespace-add-the-framework.patch

------------------------------------------------------
Subject: user namespace: add the framework fix
From: "Serge E. Hallyn" <serue@us.ibm.com>

For i386, an include of utsname.h by asm/elf.h hides the fact that
user_namespace needs sched.h.  To fix compilation for x86_64, just include
sched.h explicitly.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/user_namespace.h |    1 +
 1 files changed, 1 insertion(+)

diff -puN include/linux/user_namespace.h~user-namespace-add-the-framework-fix include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user-namespace-add-the-framework-fix
+++ a/include/linux/user_namespace.h
@@ -3,6 +3,7 @@
 
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
+#include <linux/sched.h>
 
 #define UIDHASH_BITS	(CONFIG_BASE_SMALL ? 3 : 8)
 #define UIDHASH_SZ	(1 << UIDHASH_BITS)
_

Patches currently in -mm which might be from serue@us.ibm.com are

implement-file-posix-capabilities.patch
file-capabilities-dont-do-file-caps-if-mnt_nosuid.patch
file-capabilities-honor-secure_noroot.patch
introduce-and-use-get_task_mnt_ns.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-namespace-add-the-framework-fixes.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-add-user_namespace-ptr-to-vfsmount-fixes.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user-ns-implement-shared-mounts-fixes.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user_ns-handle-file-sigio-fix-2.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch
integrity-service-api-and-dummy-provider-fix.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
