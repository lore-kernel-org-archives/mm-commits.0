From: akpm@google.com
Subject: + brlocks-lglocks-clean-up-code-checkpatch-fixes.patch added to -mm tree
Date: Thu, 29 Sep 2011 15:45:18 -0700
Message-ID: <201109292245.p8TMjIGH009544@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:21026 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab1I2Wpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2011 18:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@google.com, ak@linux.intel.com, npiggin@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     Subject: brlocks-lglocks-clean-up-code-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     brlocks-lglocks-clean-up-code-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@google.com>
Subject: brlocks-lglocks-clean-up-code-checkpatch-fixes

Cc: Al Viro <viro@zeniv.linux.org.uk>

ERROR: trailing whitespace
#768: FILE: include/linux/lglock.h:54:
+#endif $

WARNING: line over 80 characters
#772: FILE: include/linux/lglock.h:58:
+	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock) = __ARCH_SPIN_LOCK_UNLOCKED; \

ERROR: trailing whitespace
#917: FILE: kernel/lglock.c:5:
+void lg_lock_init(struct lglock *lg, char *name) $

ERROR: trailing whitespace
#923: FILE: kernel/lglock.c:11:
+void lg_local_lock(struct lglock *lg) $

ERROR: trailing whitespace
#933: FILE: kernel/lglock.c:21:
+void lg_local_unlock(struct lglock *lg) $

ERROR: trailing whitespace
#943: FILE: kernel/lglock.c:31:
+void lg_local_lock_cpu(struct lglock *lg, int cpu) $

ERROR: trailing whitespace
#953: FILE: kernel/lglock.c:41:
+void lg_local_unlock_cpu(struct lglock *lg, int cpu) $

ERROR: trailing whitespace
#963: FILE: kernel/lglock.c:51:
+void lg_global_lock_online(struct lglock *lg) $

total: 7 errors, 1 warnings, 893 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/brlocks-lglocks-clean-up-code.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 kernel/lglock.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN kernel/lglock.c~brlocks-lglocks-clean-up-code-checkpatch-fixes kernel/lglock.c
--- a/kernel/lglock.c~brlocks-lglocks-clean-up-code-checkpatch-fixes
+++ a/kernel/lglock.c
@@ -2,13 +2,13 @@
 #include <linux/module.h>
 #include <linux/lglock.h>
 
-void lg_lock_init(struct lglock *lg, char *name) 
+void lg_lock_init(struct lglock *lg, char *name)
 {
 	LOCKDEP_INIT_MAP(&lg->lock_dep_map, name, &lg->lock_key, 0);
 }
 EXPORT_SYMBOL(lg_lock_init);
 
-void lg_local_lock(struct lglock *lg) 
+void lg_local_lock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 	preempt_disable();
@@ -18,7 +18,7 @@ void lg_local_lock(struct lglock *lg) 
 }
 EXPORT_SYMBOL(lg_local_lock);
 
-void lg_local_unlock(struct lglock *lg) 
+void lg_local_unlock(struct lglock *lg)
 {
 	arch_spinlock_t *lock;
 	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
@@ -28,7 +28,7 @@ void lg_local_unlock(struct lglock *lg) 
 }
 EXPORT_SYMBOL(lg_local_unlock);
 
-void lg_local_lock_cpu(struct lglock *lg, int cpu) 
+void lg_local_lock_cpu(struct lglock *lg, int cpu)
 {
 	arch_spinlock_t *lock;
 	preempt_disable();
@@ -38,7 +38,7 @@ void lg_local_lock_cpu(struct lglock *lg
 }
 EXPORT_SYMBOL(lg_local_lock_cpu);
 
-void lg_local_unlock_cpu(struct lglock *lg, int cpu) 
+void lg_local_unlock_cpu(struct lglock *lg, int cpu)
 {
 	arch_spinlock_t *lock;
 	rwlock_release(&lg->lock_dep_map, 1, _RET_IP_);
@@ -48,7 +48,7 @@ void lg_local_unlock_cpu(struct lglock *
 }
 EXPORT_SYMBOL(lg_local_unlock_cpu);
 
-void lg_global_lock_online(struct lglock *lg) 
+void lg_global_lock_online(struct lglock *lg)
 {
 	int i;
 	preempt_disable();
_
Subject: Subject: brlocks-lglocks-clean-up-code-checkpatch-fixes

Patches currently in -mm which might be from akpm@google.com are

linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
treewide-use-__printf-not-__attribute__formatprintf-fix.patch

