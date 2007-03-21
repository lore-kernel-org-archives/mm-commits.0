From: akpm@linux-foundation.org
Subject: + sys_futex64-allows-64bit-futexes.patch added to -mm tree
Date: Wed, 21 Mar 2007 15:46:56 -0700
Message-ID: <200703212246.l2LMkuI5005958@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57326 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbXCUWra (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Mar 2007 18:47:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pierre.peiffer@bull.net, drepper@redhat.com, mingo@elte.hu


The patch titled
     sys_futex64: allows 64bit futexes
has been added to the -mm tree.  Its filename is
     sys_futex64-allows-64bit-futexes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sys_futex64: allows 64bit futexes
From: Pierre Peiffer <pierre.peiffer@bull.net>

This last patch is an adaptation of the sys_futex64 syscall provided in -rt
patch (originally written by Ingo Molnar).  It allows the use of 64-bit futex.

I have re-worked most of the code to avoid the duplication of the code.

It does not provide the functionality for all architectures (only for x64 for
now).

Signed-off-by: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/futex.h  |  113 ++++++++++++++
 include/asm-x86_64/unistd.h |    4 
 include/linux/futex.h       |    9 -
 include/linux/syscalls.h    |    3 
 kernel/futex.c              |  264 +++++++++++++++++++++++-----------
 kernel/futex_compat.c       |    3 
 kernel/sys_ni.c             |    1 
 7 files changed, 313 insertions(+), 84 deletions(-)

diff -puN include/asm-x86_64/futex.h~sys_futex64-allows-64bit-futexes include/asm-x86_64/futex.h
--- a/include/asm-x86_64/futex.h~sys_futex64-allows-64bit-futexes
+++ a/include/asm-x86_64/futex.h
@@ -41,6 +41,39 @@
 	  "=&r" (tem)						\
 	: "r" (oparg), "i" (-EFAULT), "m" (*uaddr), "1" (0))
 
+#define __futex_atomic_op1_64(insn, ret, oldval, uaddr, oparg) \
+  __asm__ __volatile (						\
+"1:	" insn "\n"						\
+"2:	.section .fixup,\"ax\"\n\
+3:	movq	%3, %1\n\
+	jmp	2b\n\
+	.previous\n\
+	.section __ex_table,\"a\"\n\
+	.align	8\n\
+	.quad	1b,3b\n\
+	.previous"						\
+	: "=r" (oldval), "=r" (ret), "=m" (*uaddr)		\
+	: "i" (-EFAULT), "m" (*uaddr), "0" (oparg), "1" (0))
+
+#define __futex_atomic_op2_64(insn, ret, oldval, uaddr, oparg) \
+  __asm__ __volatile (						\
+"1:	movq	%2, %0\n\
+	movq	%0, %3\n"					\
+	insn "\n"						\
+"2:	" LOCK_PREFIX "cmpxchgq %3, %2\n\
+	jnz	1b\n\
+3:	.section .fixup,\"ax\"\n\
+4:	movq	%5, %1\n\
+	jmp	3b\n\
+	.previous\n\
+	.section __ex_table,\"a\"\n\
+	.align	8\n\
+	.quad	1b,4b,2b,4b\n\
+	.previous"						\
+	: "=&a" (oldval), "=&r" (ret), "=m" (*uaddr),		\
+	  "=&r" (tem)						\
+	: "r" (oparg), "i" (-EFAULT), "m" (*uaddr), "1" (0))
+
 static inline int
 futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
 {
@@ -95,6 +128,60 @@ futex_atomic_op_inuser (int encoded_op, 
 }
 
 static inline int
+futex_atomic_op_inuser64 (int encoded_op, u64 __user *uaddr)
+{
+	int op = (encoded_op >> 28) & 7;
+	int cmp = (encoded_op >> 24) & 15;
+	u64 oparg = (encoded_op << 8) >> 20;
+	u64 cmparg = (encoded_op << 20) >> 20;
+	u64 oldval = 0, ret, tem;
+
+	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28))
+		oparg = 1 << oparg;
+
+	if (! access_ok (VERIFY_WRITE, uaddr, sizeof(u64)))
+		return -EFAULT;
+
+	inc_preempt_count();
+
+	switch (op) {
+	case FUTEX_OP_SET:
+		__futex_atomic_op1_64("xchgq %0, %2", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ADD:
+		__futex_atomic_op1_64(LOCK_PREFIX "xaddq %0, %2", ret, oldval,
+				   uaddr, oparg);
+		break;
+	case FUTEX_OP_OR:
+		__futex_atomic_op2_64("orq %4, %3", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP_ANDN:
+		__futex_atomic_op2_64("andq %4, %3", ret, oldval, uaddr, ~oparg);
+		break;
+	case FUTEX_OP_XOR:
+		__futex_atomic_op2_64("xorq %4, %3", ret, oldval, uaddr, oparg);
+		break;
+	default:
+		ret = -ENOSYS;
+	}
+
+	dec_preempt_count();
+
+	if (!ret) {
+		switch (cmp) {
+		case FUTEX_OP_CMP_EQ: ret = (oldval == cmparg); break;
+		case FUTEX_OP_CMP_NE: ret = (oldval != cmparg); break;
+		case FUTEX_OP_CMP_LT: ret = (oldval < cmparg); break;
+		case FUTEX_OP_CMP_GE: ret = (oldval >= cmparg); break;
+		case FUTEX_OP_CMP_LE: ret = (oldval <= cmparg); break;
+		case FUTEX_OP_CMP_GT: ret = (oldval > cmparg); break;
+		default: ret = -ENOSYS;
+		}
+	}
+	return ret;
+}
+
+static inline int
 futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
 {
 	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(int)))
@@ -121,5 +208,31 @@ futex_atomic_cmpxchg_inatomic(int __user
 	return oldval;
 }
 
+static inline u64
+futex_atomic_cmpxchg_inatomic64(u64 __user *uaddr, u64 oldval, u64 newval)
+{
+	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u64)))
+		return -EFAULT;
+
+	__asm__ __volatile__(
+		"1:	" LOCK_PREFIX "cmpxchgq %3, %1		\n"
+
+		"2:	.section .fixup, \"ax\"			\n"
+		"3:	mov     %2, %0				\n"
+		"	jmp     2b				\n"
+		"	.previous				\n"
+
+		"	.section __ex_table, \"a\"		\n"
+		"	.align  8				\n"
+		"	.quad   1b,3b				\n"
+		"	.previous				\n"
+
+		: "=a" (oldval), "=m" (*uaddr)
+		: "i" (-EFAULT), "r" (newval), "0" (oldval)
+		: "memory"
+	);
+
+	return oldval;
+}
 #endif
 #endif
diff -puN include/asm-x86_64/unistd.h~sys_futex64-allows-64bit-futexes include/asm-x86_64/unistd.h
--- a/include/asm-x86_64/unistd.h~sys_futex64-allows-64bit-futexes
+++ a/include/asm-x86_64/unistd.h
@@ -619,8 +619,10 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_futex64		280
+__SYSCALL(__NR_futex64, sys_futex64)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max __NR_futex64
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff -puN include/linux/futex.h~sys_futex64-allows-64bit-futexes include/linux/futex.h
--- a/include/linux/futex.h~sys_futex64-allows-64bit-futexes
+++ a/include/linux/futex.h
@@ -101,8 +101,9 @@ struct robust_list_head {
 #define ROBUST_LIST_LIMIT	2048
 
 #ifdef __KERNEL__
-long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-	      u32 __user *uaddr2, u32 val2, u32 val3);
+long do_futex(unsigned long __user *uaddr, int op, unsigned long val,
+	      ktime_t *timeout, unsigned long __user *uaddr2,
+	      unsigned long val2, unsigned long val3, int futex64);
 
 extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
@@ -116,7 +117,7 @@ handle_futex_death(u32 __user *uaddr, st
  * We set bit 0 to indicate if it's an inode-based key.
  */
 union futex_key {
-	u32 __user *uaddr;
+	unsigned long __user *uaddr;
 	struct {
 		unsigned long pgoff;
 		struct inode *inode;
@@ -133,7 +134,7 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(u32 __user *uaddr, union futex_key *key);
+int get_futex_key(void __user *uaddr, union futex_key *key);
 void get_futex_key_refs(union futex_key *key);
 void drop_futex_key_refs(union futex_key *key);
 
diff -puN include/linux/syscalls.h~sys_futex64-allows-64bit-futexes include/linux/syscalls.h
--- a/include/linux/syscalls.h~sys_futex64-allows-64bit-futexes
+++ a/include/linux/syscalls.h
@@ -178,6 +178,9 @@ asmlinkage long sys_set_tid_address(int 
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 			struct timespec __user *utime, u32 __user *uaddr2,
 			u32 val3);
+asmlinkage long sys_futex64(u64 __user *uaddr, int op, u64 val,
+			struct timespec __user *utime, u64 __user *uaddr2,
+			u64 val3);
 
 asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 				const char __user *uargs);
diff -puN kernel/futex.c~sys_futex64-allows-64bit-futexes kernel/futex.c
--- a/kernel/futex.c~sys_futex64-allows-64bit-futexes
+++ a/kernel/futex.c
@@ -61,6 +61,44 @@
 
 #define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
 
+#ifdef CONFIG_64BIT
+static inline unsigned long
+futex_cmpxchg_inatomic(unsigned long __user *uaddr, unsigned long oldval,
+		       unsigned long newval, int futex64)
+{
+	if (futex64)
+		return futex_atomic_cmpxchg_inatomic64((u64 __user *)uaddr,
+						       oldval, newval);
+	else {
+		u32 ov = oldval, nv = newval;
+		return futex_atomic_cmpxchg_inatomic((int __user *)uaddr, ov,
+						     nv);
+	}
+}
+
+static inline int
+futex_get_user(unsigned long *val, unsigned long __user *uaddr, int futex64)
+{
+	int ret;
+
+	if (futex64)
+		ret = get_user(*val, uaddr);
+	else {
+		u32 __user *addr = (u32 __user *)uaddr;
+
+		ret = get_user(*val, addr);
+	}
+	return ret;
+}
+
+#else
+#define futex_cmpxchg_inatomic(uaddr, oldval, newval, futex64)	\
+	futex_atomic_cmpxchg_inatomic((u32*)uaddr, oldval, newval)
+
+#define futex_get_user(val, uaddr, futex64) get_user(*val, uaddr)
+
+#endif
+
 /*
  * Priority Inheritance state:
  */
@@ -140,6 +178,7 @@ static struct futex_hash_bucket *hash_fu
 	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
 }
 
+
 /*
  * Return 1 if two futex_keys are equal, 0 otherwise.
  */
@@ -162,7 +201,7 @@ static inline int match_futex(union fute
  *
  * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
  */
-int get_futex_key(u32 __user *uaddr, union futex_key *key)
+int get_futex_key(void __user *uaddr, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -271,13 +310,30 @@ void drop_futex_key_refs(union futex_key
 }
 EXPORT_SYMBOL_GPL(drop_futex_key_refs);
 
-static inline int get_futex_value_locked(u32 *dest, u32 __user *from)
+static inline int
+get_futex_value_locked(unsigned long *dest, unsigned long __user *from,
+		       int futex64)
 {
 	int ret;
 
+#ifdef CONFIG_64BIT
+	if (futex64) {
+		pagefault_disable();
+		ret = __copy_from_user_inatomic(dest, from, sizeof(u64));
+		pagefault_enable();
+	} else {
+		u32 d;
+		pagefault_disable();
+		ret = __copy_from_user_inatomic(&d, from, sizeof(u32));
+		pagefault_enable();
+
+		*dest = d;
+	}
+#else
 	pagefault_disable();
 	ret = __copy_from_user_inatomic(dest, from, sizeof(u32));
 	pagefault_enable();
+#endif
 
 	return ret ? -EFAULT : 0;
 }
@@ -550,11 +606,12 @@ static void wake_futex(struct futex_q *q
 	q->lock_ptr = NULL;
 }
 
-static int wake_futex_pi(u32 __user *uaddr, u32 uval, struct futex_q *this)
+static int wake_futex_pi(unsigned long __user *uaddr, unsigned long uval,
+			 struct futex_q *this, int futex64)
 {
 	struct task_struct *new_owner;
 	struct futex_pi_state *pi_state = this->pi_state;
-	u32 curval, newval;
+	unsigned long curval, newval;
 
 	if (!pi_state)
 		return -EINVAL;
@@ -582,7 +639,7 @@ static int wake_futex_pi(u32 __user *uad
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
 
 		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
+		curval = futex_cmpxchg_inatomic(uaddr, uval, newval, futex64);
 		pagefault_enable();
 		if (curval == -EFAULT)
 			return -EFAULT;
@@ -607,16 +664,17 @@ static int wake_futex_pi(u32 __user *uad
 	return 0;
 }
 
-static int unlock_futex_pi(u32 __user *uaddr, u32 uval)
+static int unlock_futex_pi(unsigned long __user *uaddr, unsigned long uval,
+			   int futex64)
 {
-	u32 oldval;
+	unsigned long oldval;
 
 	/*
 	 * There is no waiter, so we unlock the futex. The owner died
 	 * bit has not to be preserved here. We are the owner:
 	 */
 	pagefault_disable();
-	oldval = futex_atomic_cmpxchg_inatomic(uaddr, uval, 0);
+	oldval = futex_cmpxchg_inatomic(uaddr, uval, 0, futex64);
 	pagefault_enable();
 
 	if (oldval == -EFAULT)
@@ -647,7 +705,7 @@ double_lock_hb(struct futex_hash_bucket 
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(u32 __user *uaddr, int nr_wake)
+static int futex_wake(unsigned long __user *uaddr, int nr_wake)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -690,18 +748,19 @@ out:
  * or create a new one without owner.
  */
 static inline int
-lookup_pi_state_for_requeue(u32 __user *uaddr, struct futex_hash_bucket *hb,
+lookup_pi_state_for_requeue(unsigned long __user *uaddr,
+			    struct futex_hash_bucket *hb,
 			    union futex_key *key,
-			    struct futex_pi_state **pi_state)
+			    struct futex_pi_state **pi_state, int futex64)
 {
-	u32 curval, uval, newval;
+	unsigned long curval, uval, newval;
 
 retry:
 	/*
 	 * We can't handle a fault cleanly because we can't
 	 * release the locks here. Simply return the fault.
 	 */
-	if (get_futex_value_locked(&curval, uaddr))
+	if (get_futex_value_locked(&curval, uaddr, futex64))
 		return -EFAULT;
 
 	/* set the flags FUTEX_WAITERS and FUTEX_WAITER_REQUEUED */
@@ -715,7 +774,7 @@ retry:
 		newval = uval | FUTEX_WAITERS | FUTEX_WAITER_REQUEUED;
 
 		pagefault_disable();
-		curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
+		curval = futex_cmpxchg_inatomic(uaddr, uval, newval, futex64);
 		pagefault_enable();
 
 		if (unlikely(curval == -EFAULT))
@@ -746,8 +805,9 @@ retry:
  * and requeue the next nr_requeue waiters following hashed on
  * one physical page to another physical page (PI-futex uaddr2)
  */
-static int futex_requeue_pi(u32 __user *uaddr1, u32 __user *uaddr2,
-			    int nr_wake, int nr_requeue, u32 *cmpval)
+static int
+futex_requeue_pi(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
+		 int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -780,9 +840,9 @@ retry:
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
-		u32 curval;
+		unsigned long curval;
 
-		ret = get_futex_value_locked(&curval, uaddr1);
+		ret = get_futex_value_locked(&curval, uaddr1, futex64);
 
 		if (unlikely(ret)) {
 			spin_unlock(&hb1->lock);
@@ -795,7 +855,7 @@ retry:
 			 */
 			up_read(&current->mm->mmap_sem);
 
-			ret = get_user(curval, uaddr1);
+			ret = futex_get_user(&curval, uaddr1, futex64);
 
 			if (!ret)
 				goto retry;
@@ -822,7 +882,8 @@ retry:
 				int s;
 				/* do this only the first time we requeue someone */
 				s = lookup_pi_state_for_requeue(uaddr2, hb2,
-								&key2, &pi_state2);
+								&key2, &pi_state2,
+								futex64);
 				if (s) {
 					ret = s;
 					goto out_unlock;
@@ -936,8 +997,8 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(u32 __user *uaddr1, u32 __user *uaddr2,
-	      int nr_wake, int nr_wake2, int op)
+futex_wake_op(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
+	      int nr_wake, int nr_wake2, int op, int futex64)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -961,9 +1022,16 @@ retryfull:
 retry:
 	double_lock_hb(hb1, hb2);
 
-	op_ret = futex_atomic_op_inuser(op, uaddr2);
+#ifdef CONFIG_64BIT
+	if (futex64)
+		op_ret = futex_atomic_op_inuser64(op, (u64 __user *)uaddr2);
+	else
+		op_ret = futex_atomic_op_inuser(op, (int __user *)uaddr2);
+#else
+	op_ret = futex_atomic_op_inuser(op, (int __user *)uaddr2);
+#endif
 	if (unlikely(op_ret < 0)) {
-		u32 dummy;
+		unsigned long dummy;
 
 		spin_unlock(&hb1->lock);
 		if (hb1 != hb2)
@@ -1005,7 +1073,7 @@ retry:
 		 */
 		up_read(&current->mm->mmap_sem);
 
-		ret = get_user(dummy, uaddr2);
+		ret = futex_get_user(&dummy, uaddr2, futex64);
 		if (ret)
 			return ret;
 
@@ -1048,8 +1116,9 @@ out:
  * Requeue all waiters hashed on one physical page to another
  * physical page.
  */
-static int futex_requeue(u32 __user *uaddr1, u32 __user *uaddr2,
-			 int nr_wake, int nr_requeue, u32 *cmpval)
+static int
+futex_requeue(unsigned long __user *uaddr1, unsigned long __user *uaddr2,
+	      int nr_wake, int nr_requeue, unsigned long *cmpval, int futex64)
 {
 	union futex_key key1, key2;
 	struct futex_hash_bucket *hb1, *hb2;
@@ -1073,9 +1142,9 @@ static int futex_requeue(u32 __user *uad
 	double_lock_hb(hb1, hb2);
 
 	if (likely(cmpval != NULL)) {
-		u32 curval;
+		unsigned long curval;
 
-		ret = get_futex_value_locked(&curval, uaddr1);
+		ret = get_futex_value_locked(&curval, uaddr1, futex64);
 
 		if (unlikely(ret)) {
 			spin_unlock(&hb1->lock);
@@ -1088,7 +1157,7 @@ static int futex_requeue(u32 __user *uad
 			 */
 			up_read(&current->mm->mmap_sem);
 
-			ret = get_user(curval, uaddr1);
+			ret = futex_get_user(&curval, uaddr1, futex64);
 
 			if (!ret)
 				goto retry;
@@ -1273,13 +1342,13 @@ static void unqueue_me_pi(struct futex_q
  * The cur->mm semaphore must be  held, it is released at return of this
  * function.
  */
-static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+static int fixup_pi_state_owner(unsigned long  __user *uaddr, struct futex_q *q,
 				struct futex_hash_bucket *hb,
-				struct task_struct *curr)
+				struct task_struct *curr, int futex64)
 {
-	u32 newtid = curr->pid | FUTEX_WAITERS;
+	unsigned long newtid = curr->pid | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
-	u32 uval, curval, newval;
+	unsigned long uval, curval, newval;
 	int ret;
 
 	/* Owner died? */
@@ -1306,12 +1375,12 @@ static int fixup_pi_state_owner(u32 __us
 	 * TID. This must be atomic as we have preserve the
 	 * owner died bit here.
 	 */
-	ret = get_user(uval, uaddr);
+	ret = futex_get_user(&uval, uaddr, futex64);
 	while (!ret) {
 		newval = (uval & FUTEX_OWNER_DIED) | newtid;
 		newval |= (uval & FUTEX_WAITER_REQUEUED);
-		curval = futex_atomic_cmpxchg_inatomic(uaddr,
-						       uval, newval);
+		curval = futex_cmpxchg_inatomic(uaddr,uval,
+						newval, futex64);
 		if (curval == -EFAULT)
  			ret = -EFAULT;
 		if (curval == uval)
@@ -1322,13 +1391,14 @@ static int fixup_pi_state_owner(u32 __us
 }
 
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait(u32 __user *uaddr, u32 val, ktime_t *abs_time)
+static int futex_wait(unsigned long __user *uaddr, unsigned long val,
+		      ktime_t *abs_time, int futex64)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
 	struct futex_hash_bucket *hb;
 	struct futex_q q;
-	u32 uval;
+	unsigned long uval;
 	int ret;
 	struct hrtimer_sleeper t, *to = NULL;
 	int rem = 0;
@@ -1363,7 +1433,7 @@ static int futex_wait(u32 __user *uaddr,
 	 * We hold the mmap semaphore, so the mapping cannot have changed
 	 * since we looked it up in get_futex_key.
 	 */
-	ret = get_futex_value_locked(&uval, uaddr);
+	ret = get_futex_value_locked(&uval, uaddr, futex64);
 
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
@@ -1373,8 +1443,7 @@ static int futex_wait(u32 __user *uaddr,
 		 * start all over again.
 		 */
 		up_read(&curr->mm->mmap_sem);
-
-		ret = get_user(uval, uaddr);
+		ret = futex_get_user(&uval, uaddr, futex64);
 
 		if (!ret)
 			goto retry;
@@ -1486,7 +1555,7 @@ static int futex_wait(u32 __user *uaddr,
 
 			/* mmap_sem and hash_bucket lock are unlocked at
 			   return of this function */
-			ret = fixup_pi_state_owner(uaddr, &q, hb, curr);
+			ret = fixup_pi_state_owner(uaddr, &q, hb, curr, futex64);
 		} else {
 			/*
 			 * Catch the rare case, where the lock was released
@@ -1526,8 +1595,9 @@ static int futex_wait(u32 __user *uaddr,
 		restart = &current_thread_info()->restart_block;
 		restart->fn = futex_wait_restart;
 		restart->arg0 = (unsigned long)uaddr;
-		restart->arg1 = (unsigned long)val;
+		restart->arg1 = val;
 		restart->arg2 = (unsigned long)abs_time;
+		restart->arg3 = (unsigned long)futex64;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1542,12 +1612,13 @@ static int futex_wait(u32 __user *uaddr,
 
 static long futex_wait_restart(struct restart_block *restart)
 {
-	u32 __user *uaddr = (u32 __user *)restart->arg0;
-	u32 val = (u32)restart->arg1;
+	unsigned long __user *uaddr = (unsigned long __user *)restart->arg0;
+	unsigned long val = restart->arg1;
 	ktime_t *abs_time = (ktime_t *)restart->arg2;
+	int futex64 = (int)restart->arg3;
 
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait(uaddr, val, abs_time);
+	return (long)futex_wait(uaddr, val, abs_time, futex64);
 }
 
 
@@ -1602,13 +1673,13 @@ static void set_pi_futex_owner(struct fu
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int detect, ktime_t *time,
-			 int trylock)
+static int futex_lock_pi(unsigned long __user *uaddr, int detect, ktime_t *time,
+			 int trylock, int futex64)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
 	struct task_struct *curr = current;
 	struct futex_hash_bucket *hb;
-	u32 uval, newval, curval;
+	unsigned long uval, newval, curval;
 	struct futex_q q;
 	int ret, lock_held, attempt = 0;
 
@@ -1643,7 +1714,7 @@ static int futex_lock_pi(u32 __user *uad
 	newval = current->pid;
 
 	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, 0, newval);
+	curval = futex_cmpxchg_inatomic(uaddr, 0, newval, futex64);
 	pagefault_enable();
 
 	if (unlikely(curval == -EFAULT))
@@ -1688,7 +1759,7 @@ static int futex_lock_pi(u32 __user *uad
 		newval = curval | FUTEX_WAITERS;
 
 	pagefault_disable();
-	curval = futex_atomic_cmpxchg_inatomic(uaddr, uval, newval);
+	curval = futex_cmpxchg_inatomic(uaddr, uval, newval, futex64);
 	pagefault_enable();
 
 	if (unlikely(curval == -EFAULT))
@@ -1725,8 +1796,8 @@ static int futex_lock_pi(u32 __user *uad
 				FUTEX_OWNER_DIED | FUTEX_WAITERS;
 
 			pagefault_disable();
-			curval = futex_atomic_cmpxchg_inatomic(uaddr,
-							       uval, newval);
+			curval = futex_cmpxchg_inatomic(uaddr, uval,
+							newval, futex64);
 			pagefault_enable();
 
 			if (unlikely(curval == -EFAULT))
@@ -1770,7 +1841,7 @@ static int futex_lock_pi(u32 __user *uad
 	 */
 	if (!ret && q.pi_state->owner != curr)
 		/* mmap_sem is unlocked at return of this function */
-		ret = fixup_pi_state_owner(uaddr, &q, hb, curr);
+		ret = fixup_pi_state_owner(uaddr, &q, hb, curr, futex64);
 	else {
 		/*
 		 * Catch the rare case, where the lock was released
@@ -1816,7 +1887,7 @@ static int futex_lock_pi(u32 __user *uad
 	queue_unlock(&q, hb);
 	up_read(&curr->mm->mmap_sem);
 
-	ret = get_user(uval, uaddr);
+	ret = futex_get_user(&uval, uaddr, futex64);
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
@@ -1828,17 +1899,17 @@ static int futex_lock_pi(u32 __user *uad
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr)
+static int futex_unlock_pi(unsigned long __user *uaddr, int futex64)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
-	u32 uval;
+	unsigned long uval;
 	struct plist_head *head;
 	union futex_key key;
 	int ret, attempt = 0;
 
 retry:
-	if (get_user(uval, uaddr))
+	if (futex_get_user(&uval, uaddr, futex64))
 		return -EFAULT;
 	/*
 	 * We release only a lock we actually own:
@@ -1865,7 +1936,7 @@ retry_locked:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
 		pagefault_disable();
-		uval = futex_atomic_cmpxchg_inatomic(uaddr, current->pid, 0);
+		uval = futex_cmpxchg_inatomic(uaddr, current->pid, 0, futex64);
 		pagefault_enable();
 	}
 
@@ -1887,7 +1958,7 @@ retry_locked:
 	plist_for_each_entry_safe(this, next, head, list) {
 		if (!match_futex (&this->key, &key))
 			continue;
-		ret = wake_futex_pi(uaddr, uval, this);
+		ret = wake_futex_pi(uaddr, uval, this, futex64);
 		/*
 		 * The atomic access to the futex value
 		 * generated a pagefault, so retry the
@@ -1901,7 +1972,7 @@ retry_locked:
 	 * No waiters - kernel unlocks the futex:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED)) {
-		ret = unlock_futex_pi(uaddr, uval);
+		ret = unlock_futex_pi(uaddr, uval, futex64);
 		if (ret == -EFAULT)
 			goto pi_faulted;
 	}
@@ -1931,7 +2002,7 @@ pi_faulted:
 	spin_unlock(&hb->lock);
 	up_read(&current->mm->mmap_sem);
 
-	ret = get_user(uval, uaddr);
+	ret = futex_get_user(&uval, uaddr, futex64);
 	if (!ret && (uval != -EFAULT))
 		goto retry;
 
@@ -2167,7 +2238,7 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake(uaddr, 1);
+				futex_wake((unsigned long __user *)uaddr, 1);
 		}
 	}
 	return 0;
@@ -2223,7 +2294,8 @@ void exit_robust_list(struct task_struct
 		return;
 
 	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip);
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
 
 	while (entry != &head->list) {
 		/*
@@ -2249,42 +2321,46 @@ void exit_robust_list(struct task_struct
 	}
 }
 
-long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
-		u32 __user *uaddr2, u32 val2, u32 val3)
+long do_futex(unsigned long __user *uaddr, int op, unsigned long val,
+	      ktime_t *timeout, unsigned long __user *uaddr2,
+	      unsigned long val2, unsigned long val3, int fut64)
 {
 	int ret;
 
 	switch (op) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, val, timeout);
+		ret = futex_wait(uaddr, val, timeout, fut64);
 		break;
 	case FUTEX_WAKE:
 		ret = futex_wake(uaddr, val);
 		break;
 	case FUTEX_FD:
-		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
-		ret = futex_fd(uaddr, val);
+		if (fut64)
+			ret = -ENOSYS;
+		else
+			/* non-zero val means F_SETOWN(getpid())&F_SETSIG(val) */
+			ret = futex_fd((u32 __user *)uaddr, val);
 		break;
 	case FUTEX_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, NULL, fut64);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3);
+		ret = futex_requeue(uaddr, uaddr2, val, val2, &val3, fut64);
 		break;
 	case FUTEX_WAKE_OP:
-		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3);
+		ret = futex_wake_op(uaddr, uaddr2, val, val2, val3, fut64);
 		break;
 	case FUTEX_LOCK_PI:
-		ret = futex_lock_pi(uaddr, val, timeout, 0);
+		ret = futex_lock_pi(uaddr, val, timeout, 0, fut64);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret = futex_unlock_pi(uaddr);
+		ret = futex_unlock_pi(uaddr, fut64);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret = futex_lock_pi(uaddr, 0, timeout, 1);
+		ret = futex_lock_pi(uaddr, 0, timeout, 1, fut64);
 		break;
 	case FUTEX_CMP_REQUEUE_PI:
-		ret = futex_requeue_pi(uaddr, uaddr2, val, val2, &val3);
+		ret = futex_requeue_pi(uaddr, uaddr2, val, val2, &val3, fut64);
 		break;
 	default:
 		ret = -ENOSYS;
@@ -2292,6 +2368,37 @@ long do_futex(u32 __user *uaddr, int op,
 	return ret;
 }
 
+#ifdef CONFIG_64BIT
+
+asmlinkage long
+sys_futex64(u64 __user *uaddr, int op, u64 val,
+	    struct timespec __user *utime, u64 __user *uaddr2, u64 val3)
+{
+	struct timespec ts;
+	ktime_t t, *tp = NULL;
+	u64 val2 = 0;
+
+	if (utime && (op == FUTEX_WAIT || op == FUTEX_LOCK_PI)) {
+		if (copy_from_user(&ts, utime, sizeof(ts)) != 0)
+			return -EFAULT;
+		if (!timespec_valid(&ts))
+			return -EINVAL;
+		if (op == FUTEX_WAIT)
+			t = ktime_add(ktime_get(), timespec_to_ktime(ts));
+		tp = &t;
+	}
+	/*
+	 * requeue parameter in 'utime' if op == FUTEX_REQUEUE.
+	 */
+	if (op == FUTEX_REQUEUE || op == FUTEX_CMP_REQUEUE
+	    || op == FUTEX_CMP_REQUEUE_PI)
+		val2 = (unsigned long) utime;
+
+	return do_futex((unsigned long __user*)uaddr, op, val, tp,
+			(unsigned long __user*)uaddr2, val2, val3, 1);
+}
+
+#endif
 
 asmlinkage long sys_futex(u32 __user *uaddr, int op, u32 val,
 			  struct timespec __user *utime, u32 __user *uaddr2,
@@ -2317,7 +2424,8 @@ asmlinkage long sys_futex(u32 __user *ua
 	    || op == FUTEX_CMP_REQUEUE_PI)
 		val2 = (u32) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
+	return do_futex((unsigned long __user*)uaddr, op, val, tp,
+			(unsigned long __user*)uaddr2, val2, val3, 0);
 }
 
 static int futexfs_get_sb(struct file_system_type *fs_type,
diff -puN kernel/futex_compat.c~sys_futex64-allows-64bit-futexes kernel/futex_compat.c
--- a/kernel/futex_compat.c~sys_futex64-allows-64bit-futexes
+++ a/kernel/futex_compat.c
@@ -158,5 +158,6 @@ asmlinkage long compat_sys_futex(u32 __u
 	    || op == FUTEX_CMP_REQUEUE_PI)
 		val2 = (int) (unsigned long) utime;
 
-	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
+	return do_futex((unsigned long __user*)uaddr, op, val, tp,
+			(unsigned long __user*)uaddr2, val2, val3, 0);
 }
diff -puN kernel/sys_ni.c~sys_futex64-allows-64bit-futexes kernel/sys_ni.c
--- a/kernel/sys_ni.c~sys_futex64-allows-64bit-futexes
+++ a/kernel/sys_ni.c
@@ -41,6 +41,7 @@ cond_syscall(sys_sendmsg);
 cond_syscall(sys_recvmsg);
 cond_syscall(sys_socketcall);
 cond_syscall(sys_futex);
+cond_syscall(sys_futex64);
 cond_syscall(compat_sys_futex);
 cond_syscall(sys_set_robust_list);
 cond_syscall(compat_sys_set_robust_list);
_

Patches currently in -mm which might be from pierre.peiffer@bull.net are

futex-priority-based-wakeup.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
futex_requeue_pi-optimization.patch
sys_futex64-allows-64bit-futexes.patch
