From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 13 Oct 2014 12:43:25 -0700
Message-ID: <543c2b5d.4nE6I2xXiNDt1I67%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaJMTnZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 15:43:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/include/asm/atomic.h |   20 --------------------
 fs/dcache.c                   |   11 -----------
 2 files changed, 31 deletions(-)

diff -puN arch/arc/include/asm/atomic.h~linux-next-git-rejects arch/arc/include/asm/atomic.h
--- a/arch/arc/include/asm/atomic.h~linux-next-git-rejects
+++ a/arch/arc/include/asm/atomic.h
@@ -97,7 +97,6 @@ static inline void atomic_##op(int i, at
 	atomic_ops_lock(flags);						\
 	v->counter c_op i;						\
 	atomic_ops_unlock(flags);					\
-<<<<<<< HEAD
 }
 
 #define ATOMIC_OP_RETURN(op, c_op)					\
@@ -115,25 +114,6 @@ static inline int atomic_##op##_return(i
 	return temp;							\
 }
 
-=======
-}
-
-#define ATOMIC_OP_RETURN(op, c_op)					\
-static inline int atomic_##op##_return(int i, atomic_t *v)		\
-{									\
-	unsigned long flags;						\
-	unsigned long temp;						\
-									\
-	atomic_ops_lock(flags);						\
-	temp = v->counter;						\
-	temp c_op i;							\
-	v->counter = temp;						\
-	atomic_ops_unlock(flags);					\
-									\
-	return temp;							\
-}
-
->>>>>>> linux-next/akpm-base
 #endif /* !CONFIG_ARC_HAS_LLSC */
 
 #define ATOMIC_OPS(op, c_op, asm_op)					\
diff -puN fs/dcache.c~linux-next-git-rejects fs/dcache.c
--- a/fs/dcache.c~linux-next-git-rejects
+++ a/fs/dcache.c
@@ -253,17 +253,6 @@ static void __d_free(struct rcu_head *he
 	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
 
 	WARN_ON(!hlist_unhashed(&dentry->d_alias));
-<<<<<<< HEAD
-=======
-	kmem_cache_free(dentry_cache, dentry); 
-}
-
-static void __d_free_external(struct rcu_head *head)
-{
-	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
-	WARN_ON(!hlist_unhashed(&dentry->d_alias));
-	kfree(external_name(dentry));
->>>>>>> linux-next/akpm-base
 	kmem_cache_free(dentry_cache, dentry); 
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing-checkpatch-fixes.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kernel-add-support-for-gcc-5-checkpatch-fixes.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-fix-fix.patch
drivers-dma-coherent-add-initialization-from-device-tree-checkpatch-fixes.patch
drivers-dma-contiguous-add-initialization-from-device-tree-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808-fix.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding-checkpatch-fixes.patch
rtc-max77686-use-ffs-to-calculate-tm_wday-fix.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock-v10-fix.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
x86-optimize-resource-lookups-for-ioremap-fix.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable-checkpatch-fixes.patch
lib-string_helpers-introduce-string_escape_mem-fix.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

