From: akpm@linux-foundation.org
Subject: + lguest-preparation-expose-futex-infrastructure.patch added to -mm tree
Date: Mon, 12 Feb 2007 23:03:20 -0800
Message-ID: <200702130703.l1D73Kdp024534@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56996 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbXBMHD2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Feb 2007 02:03:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de


The patch titled
     lguest preparation: expose futex infrastructure: get_futex_key, get_key_refs and drop_key_refs
has been added to the -mm tree.  Its filename is
     lguest-preparation-expose-futex-infrastructure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest preparation: expose futex infrastructure: get_futex_key, get_key_refs and drop_key_refs
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

diff -puN include/linux/futex.h~lguest-preparation-expose-futex-infrastructure include/linux/futex.h
--- a/include/linux/futex.h~lguest-preparation-expose-futex-infrastructure
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
diff -puN kernel/futex.c~lguest-preparation-expose-futex-infrastructure kernel/futex.c
--- a/kernel/futex.c~lguest-preparation-expose-futex-infrastructure
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
@@ -871,7 +849,7 @@ static int futex_requeue(u32 __user *uad
 				this->lock_ptr = &hb2->lock;
 			}
 			this->key = key2;
-			get_key_refs(&key2);
+			get_futex_key_refs(&key2);
 			drop_count++;
 
 			if (ret - nr_wake >= nr_requeue)
@@ -884,9 +862,9 @@ out_unlock:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 
-	/* drop_key_refs() must be called outside the spinlocks. */
+	/* drop_futex_key_refs() must be called outside the spinlocks. */
 	while (--drop_count >= 0)
-		drop_key_refs(&key1);
+		drop_futex_key_refs(&key1);
 
 out:
 	up_read(&current->mm->mmap_sem);
@@ -904,7 +882,7 @@ queue_lock(struct futex_q *q, int fd, st
 
 	init_waitqueue_head(&q->waiters);
 
-	get_key_refs(&q->key);
+	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
 	q->lock_ptr = &hb->lock;
 
@@ -923,7 +901,7 @@ static inline void
 queue_unlock(struct futex_q *q, struct futex_hash_bucket *hb)
 {
 	spin_unlock(&hb->lock);
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 }
 
 /*
@@ -978,7 +956,7 @@ static int unqueue_me(struct futex_q *q)
 		ret = 1;
 	}
 
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 	return ret;
 }
 
@@ -997,7 +975,7 @@ static void unqueue_me_pi(struct futex_q
 
 	spin_unlock(&hb->lock);
 
-	drop_key_refs(&q->key);
+	drop_futex_key_refs(&q->key);
 }
 
 static int futex_wait(u32 __user *uaddr, u32 val, unsigned long time)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
cleanup-paravirt-unhandled-fallthrough.patch
cleanup-initialize-esp0-properly-all-the-time.patch
cleanup-make-hvc_consolec-compile-on-non-powerpc.patch
cleanup-move-mce_disabled-to-asm-mceh.patch
cleanup-rename-cpu_gdt_descr-and-remove-extern.patch
cleanup-remove-extern-declaration-from.patch
cleanup-make-disable_acpi-valid-w-o-config_acpi.patch
lguest-preparation-export_symbol_gpl-5-functions.patch
lguest-preparation-expose-futex-infrastructure.patch
lguest-kconfig-and-headers.patch
lguest-the-host-code-lgko.patch
lguest-guest-code.patch
lguest-makefile.patch
lguest-trivial-guest-network-driver.patch
lguest-trivial-guest-network-driver-fix.patch
lguest-trivial-guest-console-driver.patch
lguest-trivial-guest-block-driver.patch
lguest-documentatation-and-example-launcher.patch
vmi-versus-hrtimers.patch
