From: akpm@linux-foundation.org
Subject: + userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch added to -mm tree
Date: Mon, 28 Feb 2011 16:34:03 -0800
Message-ID: <201103010034.p210Y3Jf007337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753835Ab1CAAef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 19:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, serge.hallyn@canonical.com


The patch titled
     userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
cpuset-add-a-missing-unlock-in-cpuset_write_resmask-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
userns-user-namespaces-convert-several-capable-calls-checkpatch-fixes.patch
userns-userns-check-user-namespace-for-task-file-uid-equivalence-checks-checkpatch-fixes.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

