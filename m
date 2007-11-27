From: akpm@linux-foundation.org
Subject: + ipc-uninline-some-code-from-utilh.patch added to -mm tree
Date: Mon, 26 Nov 2007 20:18:34 -0800
Message-ID: <200711270418.lAR4IYaR026458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191AbXK0ETL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 23:19:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, Nadia.Derbey@bull.net


The patch titled
     ipc: uninline some code from util.h
has been added to the -mm tree.  Its filename is
     ipc-uninline-some-code-from-utilh.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch
isolate-the-uts-namespaces-domainname-and-hostname-back.patch
the-namespaces-compatibility-list.patch
git-net.patch
dont-forget-to-unlock-uids_mutex-on-error-paths.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-proper-pidns-handling-for-proc-self.patch
proc-fix-the-threaded-proc-self.patch
ipc-uninline-some-code-from-utilh.patch
reiser4.patch
