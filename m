From: akpm@linux-foundation.org
Subject: - get_futex_key-get_key_refs-and-drop_key_refs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:59 -0700
Message-ID: <200705090246.l492kxgQ008919@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934468AbXEICrH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     futex: get_futex_key, get_key_refs and drop_key_refs
has been removed from the -mm tree.  Its filename was
     get_futex_key-get_key_refs-and-drop_key_refs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: futex: get_futex_key, get_key_refs and drop_key_refs
From: Rusty Russell <rusty@rustcorp.com.au>

lguest uses the convenient futex infrastructure for inter-domain I/O, so
expose get_futex_key, get_key_refs (renamed get_futex_key_refs) and
drop_key_refs (renamed drop_futex_key_refs).  Also means we need to expose the
union that these use.

No code changes.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |   29 +++++++++++++++++++++++
 kernel/futex.c        |   50 +++++++++++-----------------------------
 2 files changed, 43 insertions(+), 36 deletions(-)

diff -puN include/linux/futex.h~get_futex_key-get_key_refs-and-drop_key_refs include/linux/futex.h
--- a/include/linux/futex.h~get_futex_key-get_key_refs-and-drop_key_refs
+++ a/include/linux/futex.h
@@ -100,6 +100,35 @@ long do_futex(u32 __user *uaddr, int op,
 extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
 
+/*
+ * Futexes are matched on equal values of this key.
+ * The key type depends on whether it's a shared or private mapping.
+ * Don't rearrange members without looking at hash_futex().
+ *
+ * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
+ * We set bit 0 to indicate if it's an inode-based key.
+ */
+union futex_key {
+	struct {
+		unsigned long pgoff;
+		struct inode *inode;
+		int offset;
+	} shared;
+	struct {
+		unsigned long address;
+		struct mm_struct *mm;
+		int offset;
+	} private;
+	struct {
+		unsigned long word;
+		void *ptr;
+		int offset;
+	} both;
+};
+int get_futex_key(u32 __user *uaddr, union futex_key *key);
+void get_futex_key_refs(union futex_key *key);
+void drop_futex_key_refs(union futex_key *key);
+
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
diff -puN kernel/futex.c~get_futex_key-get_key_refs-and-drop_key_refs kernel/futex.c
--- a/kernel/futex.c~get_futex_key-get_key_refs-and-drop_key_refs
+++ a/kernel/futex.c
@@ -48,6 +48,7 @@
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
 #include <linux/signal.h>
+#include <linux/module.h>
 #include <asm/futex.h>
 
 #include "rtmutex_common.h"
@@ -55,32 +56,6 @@
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
 /*
- * Futexes are matched on equal values of this key.
- * The key type depends on whether it's a shared or private mapping.
- * Don't rearrange members without looking at hash_futex().
- *
- * offset is aligned to a multiple of sizeof(u32) (== 4) by definition.
- * We set bit 0 to indicate if it's an inode-based key.
- */
-union futex_key {
-	struct {
-		unsigned long pgoff;
-		struct inode *inode;
-		int offset;
-	} shared;
-	struct {
-		unsigned long address;
-		struct mm_struct *mm;
-		int offset;
-	} private;
-	struct {
-		unsigned long word;
-		void *ptr;
-		int offset;
-	} both;
-};
-
-/*
  * Priority Inheritance state:
  */
 struct futex_pi_state {
@@ -175,7 +150,7 @@ static inline int match_futex(union fute
  *
  * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
  */
-static int get_futex_key(u32 __user *uaddr, union futex_key *key)
+int get_futex_key(u32 __user *uaddr, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -246,6 +221,7 @@ static int get_futex_key(u32 __user *uad
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(get_futex_key);
 
 /*
  * Take a reference to the resource addressed by a key.
@@ -254,7 +230,7 @@ static int get_futex_key(u32 __user *uad
  * NOTE: mmap_sem MUST be held between get_futex_key() and calling this
  * function, if it is called at all.  mmap_sem keeps key->shared.inode valid.
  */
-static inline void get_key_refs(union futex_key *key)
+inline void get_futex_key_refs(union futex_key *key)
 {
 	if (key->both.ptr != 0) {
 		if (key->both.offset & 1)
@@ -263,12 +239,13 @@ static inline void get_key_refs(union fu
 			atomic_inc(&key->private.mm->mm_count);
 	}
 }
+EXPORT_SYMBOL_GPL(get_futex_key_refs);
 
 /*
  * Drop a reference to the resource addressed by a key.
  * The hash bucket spinlock must not be held.
  */
-static void drop_key_refs(union futex_key *key)
+void drop_futex_key_refs(union futex_key *key)
 {
 	if (key->both.ptr != 0) {
 		if (key->both.offset & 1)
@@ -277,6 +254,7 @@ static void drop_key_refs(union futex_ke
 			mmdrop(key->private.mm);
 	}
 }
+EXPORT_SYMBOL_GPL(drop_futex_key_refs);
 
 static inline int get_futex_value_locked(u32 *dest, u32 __user *from)
 {
@@ -873,7 +851,7 @@ static int futex_requeue(u32 __user *uad
 				this->lock_ptr = &hb2->lock;
 			}
 			this->key = key2;
-			get_key_refs(&key2);
+			get_futex_key_refs(&key2);
 			drop_count++;
 
 			if (ret - nr_wake >= nr_requeue)
@@ -886,9 +864,9 @@ out_unlock:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 
-	/* drop_key_refs() must be called outside the spinlocks. */
+	/* drop_futex_key_refs() must be called outside the spinlocks. */
 	while (--drop_count >= 0)
-		drop_key_refs(&key1);
+		drop_futex_key_refs(&key1);
 
 out:
 	up_read(&current->mm->mmap_sem);
@@ -906,7 +884,7 @@ queue_lock(struct futex_q *q, int fd, st
 
 	init_waitqueue_head(&q->waiters);
 
-	get_key_refs(&q->key);
+	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
@@ -925,7 +903,7 @@ static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	spin_unlock(&hb->lock);
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 }
 
 /*
@@ -980,7 +958,7 @@ static int unqueue_me(struct futex_q *q)
 		ret = 1;
 	}
 
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 	return ret;
 }
 
@@ -999,7 +977,7 @@ static void unqueue_me_pi(struct futex_q
 
 	spin_unlock(&hb->lock);
 
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 }
 
 static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
xfs-clean-up-shrinker-games.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
____call_usermodehelper-dont-flush_signals.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
futex-new-private-futexes.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda-lguest-2621-mm1-update.patch
lguest-the-guest-code-update-lguests-patch-code-for-new-paravirt-patch.patch
lguest-the-guest-code-handle-new-paravirt-lazy-mode-fix-userspace.patch
lguest-the-guest-code-dont-use-paravirt_probe-its-dying.patch
lguest-the-host-code.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-fix-lguest-oops-when-guest-dies-while-receiving-i-o.patch
lguest-the-host-code-simplification-dont-pin-guest-trap-handlers.patch
lguest-the-host-code-properly-kill-guest-userspace-programs-accessing-kernel-mem.patch
lguest-the-host-code-remove-put_user-etc-warnings-add-bloat.patch
lguest-the-host-code-fix-obscure-but-nasty-cow-bug.patch
lguest-the-host-code-lguest-use-standard-bootloader-format-fix-badly-sized.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-net-driver-lguest-2621-mm1-update-lguest-net-stats-inlinepatch.patch
lguest-the-net-driver-two-net-bugfixes.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-lguest-documentation-error.patch
lguest-documentation-and-example-updates.patch
lguest-the-documentation-example-launcher-dont-use-paravirt_probe-its-dying-doc.patch
lguest-use-standard-bootloader-format-fix-badly-sized-doc.patch
lguest-two-net-bugfixes-doc.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
compiler-introduce-__used-and-__maybe_unused.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
