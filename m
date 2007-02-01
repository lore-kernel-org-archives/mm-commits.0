From: akpm@osdl.org
Subject: - user_ns-handle-file-sigio-fix.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:15:56 -0800
Message-ID: <200702010116.l111GsJK032474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030533AbXBABSX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:18:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     user_ns: handle file sigio (fix)
has been removed from the -mm tree.  Its filename was
     user_ns-handle-file-sigio-fix.patch

This patch was dropped because it was folded into user_ns-handle-file-sigio.patch

------------------------------------------------------
Subject: user_ns: handle file sigio (fix)
From: Cedric Le Goater <clg@fr.ibm.com>

get_user_ns() returns NULL when CONFIG_USER_NS=n and this breaks
sigio_perm() which does not expect NULL values for ->user_ns.

I would fix this with the following patch.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/user_namespace.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/user_namespace.h~user_ns-handle-file-sigio-fix include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~user_ns-handle-file-sigio-fix
+++ a/include/linux/user_namespace.h
@@ -48,7 +48,7 @@ static inline int clone_mnt_userns_permi
 
 static inline struct user_namespace *get_user_ns(struct user_namespace *ns)
 {
-	return NULL;
+	return &init_user_ns;
 }
 
 static inline int copy_user_ns(int flags, struct task_struct *tsk)
_

Patches currently in -mm which might be from clg@fr.ibm.com are

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
mxser-remove-useless-fields.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
rename-attach_pid-to-find_attach_pid.patch
attach_pid-with-struct-pid-parameter.patch
remove-find_attach_pid.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
uts-namespace-remove-config_uts_ns.patch
ipc-namespace-remove-config_ipc_ns.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix.patch
ipc-namespace-remove-config_ipc_ns-linkage-fix-fix.patch
statistics-replace-inode-ugeneric_ip-with-i_private.patch
