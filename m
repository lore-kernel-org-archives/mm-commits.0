From: akpm@linux-foundation.org
Subject: - ipc-uninline-some-code-from-utilh.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:13:08 -0800
Message-ID: <200802082012.m18KCnsL010239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754181AbYBHUwq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:52:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc: uninline some code from util.h
has been removed from the -mm tree.  Its filename was
     ipc-uninline-some-code-from-utilh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: uninline some code from util.h
From: Pavel Emelyanov <xemul@openvz.org>

ipc_lock_check_down(), ipc_lock_check() and ipcget() seem too large to be
inline.  Besides, they give no optimization being inline as they perform
calls inside in any case.

Moving them into ipc/util.c saves 500 bytes of vmlinux and shortens IPC
internal API.

$ ./scripts/bloat-o-meter vmlinux-orig vmlinux
add/remove: 3/2 grow/shrink: 0/10 up/down: 490/-989 (-499)
function                                     old     new   delta
ipcget                                         -     392    +392
ipc_lock_check_down                            -      49     +49
ipc_lock_check                                 -      49     +49
sys_semget                                   119     105     -14
sys_shmget                                   108      86     -22
sys_msgget                                   100      78     -22
do_msgsnd                                    665     631     -34
do_msgrcv                                    680     644     -36
do_shmat                                     771     733     -38
sys_msgctl                                  1302    1229     -73
ipcget_new                                    80       -     -80
sys_semtimedop                              1534    1452     -82
sys_semctl                                  2034    1922    -112
sys_shmctl                                  1919    1765    -154
ipcget_public                                322       -    -322

The ipcget() growth is the result of gcc inlining of currently static
ipcget_new/_public.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   55 +++++++++++++++++++++++++++++++++++++++++++++-
 ipc/util.h |   60 +++------------------------------------------------
 2 files changed, 57 insertions(+), 58 deletions(-)

diff -puN ipc/util.c~ipc-uninline-some-code-from-utilh ipc/util.c
--- a/ipc/util.c~ipc-uninline-some-code-from-utilh
+++ a/ipc/util.c
@@ -248,7 +248,7 @@ int ipc_addid(struct ipc_ids* ids, struc
  *	This routine is called by sys_msgget, sys_semget() and sys_shmget()
  *	when the key is IPC_PRIVATE.
  */
-int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
+static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
@@ -312,7 +312,7 @@ static int ipc_check_perms(struct kern_i
  *
  *	On success, the ipc id is returned.
  */
-int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
+static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	struct kern_ipc_perm *ipcp;
@@ -710,6 +710,57 @@ struct kern_ipc_perm *ipc_lock_down(stru
 	return out;
 }
 
+struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out;
+
+	out = ipc_lock_down(ids, id);
+	if (IS_ERR(out))
+		return out;
+
+	if (ipc_checkid(out, id)) {
+		ipc_unlock(out);
+		return ERR_PTR(-EIDRM);
+	}
+
+	return out;
+}
+
+struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id)
+{
+	struct kern_ipc_perm *out;
+
+	out = ipc_lock(ids, id);
+	if (IS_ERR(out))
+		return out;
+
+	if (ipc_checkid(out, id)) {
+		ipc_unlock(out);
+		return ERR_PTR(-EIDRM);
+	}
+
+	return out;
+}
+
+/**
+ * ipcget - Common sys_*get() code
+ * @ns : namsepace
+ * @ids : IPC identifier set
+ * @ops : operations to be called on ipc object creation, permission checks
+ *        and further checks
+ * @params : the parameters needed by the previous operations.
+ *
+ * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
+ */
+int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
+			struct ipc_ops *ops, struct ipc_params *params)
+{
+	if (params->key == IPC_PRIVATE)
+		return ipcget_new(ns, ids, ops, params);
+	else
+		return ipcget_public(ns, ids, ops, params);
+}
+
 #ifdef __ARCH_WANT_IPC_PARSE_VERSION
 
 
diff -puN ipc/util.h~ipc-uninline-some-code-from-utilh ipc/util.h
--- a/ipc/util.h~ipc-uninline-some-code-from-utilh
+++ a/ipc/util.h
@@ -131,10 +131,6 @@ int ipc_parse_version (int *cmd);
 extern void free_msg(struct msg_msg *msg);
 extern struct msg_msg *load_msg(const void __user *src, int len);
 extern int store_msg(void __user *dest, struct msg_msg *msg, int len);
-extern int ipcget_new(struct ipc_namespace *, struct ipc_ids *,
-			struct ipc_ops *, struct ipc_params *);
-extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
-			struct ipc_ops *, struct ipc_params *);
 
 static inline int ipc_buildid(int id, int seq)
 {
@@ -163,57 +159,9 @@ static inline void ipc_unlock(struct ker
 	rcu_read_unlock();
 }
 
-static inline struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids,
-						int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock_down(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
-
-static inline struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids,
-						int id)
-{
-	struct kern_ipc_perm *out;
-
-	out = ipc_lock(ids, id);
-	if (IS_ERR(out))
-		return out;
-
-	if (ipc_checkid(out, id)) {
-		ipc_unlock(out);
-		return ERR_PTR(-EIDRM);
-	}
-
-	return out;
-}
-
-/**
- * ipcget - Common sys_*get() code
- * @ns : namsepace
- * @ids : IPC identifier set
- * @ops : operations to be called on ipc object creation, permission checks
- *        and further checks
- * @params : the parameters needed by the previous operations.
- *
- * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
- */
-static inline int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
-			struct ipc_ops *ops, struct ipc_params *params)
-{
-	if (params->key == IPC_PRIVATE)
-		return ipcget_new(ns, ids, ops, params);
-	else
-		return ipcget_public(ns, ids, ops, params);
-}
+struct kern_ipc_perm *ipc_lock_check_down(struct ipc_ids *ids, int id);
+struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids, int id);
+int ipcget(struct ipc_namespace *ns, struct ipc_ids *ids,
+			struct ipc_ops *ops, struct ipc_params *params);
 
 #endif
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
