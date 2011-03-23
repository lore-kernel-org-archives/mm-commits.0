From: akpm@linux-foundation.org
Subject: [folded] userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Mar 2011 16:24:51 -0700
Message-ID: <201103232324.p2NNOpBQ004660@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932910Ab1CWXZX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 19:25:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch

This patch was dropped because it was folded into userns-user-namespaces-convert-several-capable-calls.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: space prohibited between function name and open parenthesis '('
#159: FILE: ipc/sem.c:820:
+		if (ipcperms (ns, &sma->sem_perm, S_IRUGO))

WARNING: line over 80 characters
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))

WARNING: space prohibited between function name and open parenthesis '('
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))

ERROR: spaces required around that '==' (ctx:VxV)
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 	                                      ^

ERROR: spaces required around that '||' (ctx:VxV)
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 	                                              ^

ERROR: spaces required around that '==' (ctx:VxV)
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 	                                                   ^

ERROR: spaces required around that '?' (ctx:VxV)
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 	                                                            ^

ERROR: spaces required around that ':' (ctx:VxV)
#168: FILE: ipc/sem.c:865:
+	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
 	                                                                    ^

WARNING: space prohibited between function name and open parenthesis '('
#209: FILE: ipc/shm.c:741:
+		if (ipcperms (ns, &shp->shm_perm, S_IRUGO))

WARNING: space prohibited between function name and open parenthesis '('
#266: FILE: ipc/util.c:617:
+int ipcperms (struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)

total: 5 errors, 5 warnings, 337 lines checked

./patches/userns-user-namespaces-convert-several-capable-calls.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Serge E. Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c  |    5 +++--
 ipc/shm.c  |    2 +-
 ipc/util.c |    6 ++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff -puN ipc/sem.c~userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes
+++ a/ipc/sem.c
@@ -817,7 +817,7 @@ static int semctl_nolock(struct ipc_name
 		}
 
 		err = -EACCES;
-		if (ipcperms (ns, &sma->sem_perm, S_IRUGO))
+		if (ipcperms(ns, &sma->sem_perm, S_IRUGO))
 			goto out_unlock;
 
 		err = security_sem_semctl(sma, cmd);
@@ -862,7 +862,8 @@ static int semctl_main(struct ipc_namesp
 	nsems = sma->sem_nsems;
 
 	err = -EACCES;
-	if (ipcperms (ns, &sma->sem_perm, (cmd==SETVAL||cmd==SETALL)?S_IWUGO:S_IRUGO))
+	if (ipcperms(ns, &sma->sem_perm,
+			(cmd == SETVAL || cmd == SETALL) ? S_IWUGO : S_IRUGO))
 		goto out_unlock;
 
 	err = security_sem_semctl(sma, cmd);
diff -puN ipc/shm.c~userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes ipc/shm.c
--- a/ipc/shm.c~userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes
+++ a/ipc/shm.c
@@ -738,7 +738,7 @@ SYSCALL_DEFINE3(shmctl, int, shmid, int,
 			result = 0;
 		}
 		err = -EACCES;
-		if (ipcperms (ns, &shp->shm_perm, S_IRUGO))
+		if (ipcperms(ns, &shp->shm_perm, S_IRUGO))
 			goto out_unlock;
 		err = security_shm_shmctl(shp, cmd);
 		if (err)
diff -puN ipc/util.c~userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes ipc/util.c
--- a/ipc/util.c~userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes
+++ a/ipc/util.c
@@ -612,10 +612,12 @@ void ipc_rcu_putref(void *ptr)
  *
  *	Check user, group, other permissions for access
  *	to ipc resources. return 0 if allowed
+ *
+ * 	@flag will most probably be 0 or S_...UGO from <linux/stat.h>
  */
  
-int ipcperms (struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
-{	/* flag will most probably be 0 or S_...UGO from <linux/stat.h> */
+int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
+{
 	uid_t euid = current_euid();
 	int requested_mode, granted_mode;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fs-adfs-adfsh-fix-unsigned-comparison.patch
memcg-use-native-word-page-statistics-counters.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-security-make-capabilities-relative-to-the-user-namespace.patch
userns-user-namespaces-convert-several-capable-calls.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix.patch
userns-rename-is_owner_or_cap-to-inode_owner_or_capable-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix-fix.patch

