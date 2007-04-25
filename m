From: akpm@linux-foundation.org
Subject: - sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch removed from -mm tree
Date: Wed, 25 Apr 2007 02:23:17 -0700
Message-ID: <200704250923.l3P9NHCg031715@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992458AbXDYJXy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 05:23:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, pierre.peiffer@bull.net, mm-commits@vger.kernel.org


The patch titled
     get_futex_key() must check proper alignement for 64bit futexes
has been removed from the -mm tree.  Its filename was
     sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch

This patch was dropped because it was folded into sys_futex64-allows-64bit-futexes.patch

------------------------------------------------------
Subject: get_futex_key() must check proper alignement for 64bit futexes
From: Eric Dumazet <dada1@cosmosbay.com>

get_futex_key() does an alignment check against sizeof(u32) regardless of
futex being 64bits or not.

So it is possible a 64bit futex spans two pages of memory, and some
malicious user code can trigger data corruption.

We must add a 'fsize' parameter to get_futex_key(), telling it the size of
the futex (4 or 8 bytes)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |    2 -
 kernel/futex.c        |   78 ++++++++++++++++++++++++++--------------
 2 files changed, 52 insertions(+), 28 deletions(-)

diff -puN include/linux/futex.h~sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes include/linux/futex.h
--- a/include/linux/futex.h~sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes
+++ a/include/linux/futex.h
@@ -135,7 +135,7 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(void __user *uaddr, union futex_key *key);
+int get_futex_key(void __user *uaddr, int size, union futex_key *key);
 void get_futex_key_refs(union futex_key *key);
 void drop_futex_key_refs(union futex_key *key);
 
diff -puN kernel/futex.c~sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes kernel/futex.c
--- a/kernel/futex.c~sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes
+++ a/kernel/futex.c
@@ -189,19 +189,22 @@ static inline int match_futex(union fute
 		&& key1->both.offset == key2->both.offset);
 }
 
-/*
- * Get parameters which are the keys for a futex.
+/**
+ * get_futex_key - Get parameters which are the keys for a futex.
+ * @uaddr: virtual address of the futex
+ * @size: size of futex (4 or 8)
+ * @key: address where result is stored.
+ *
+ * Returns a negative error code or 0
+ * The key words are stored in *key on success.
  *
  * For shared mappings, it's (page->index, vma->vm_file->f_path.dentry->d_inode,
  * offset_within_page).  For private mappings, it's (uaddr, current->mm).
  * We can usually work out the index without swapping in the page.
  *
- * Returns: 0, or negative error code.
- * The key words are stored in *key on success.
- *
  * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
  */
-int get_futex_key(void __user *uaddr, union futex_key *key)
+int get_futex_key(void __user *uaddr, int size, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -213,7 +216,7 @@ int get_futex_key(void __user *uaddr, un
 	 * The futex address must be "naturally" aligned.
 	 */
 	key->both.offset = address % PAGE_SIZE;
-	if (unlikely((key->both.offset % sizeof(u32)) != 0))
+	if (unlikely((key->both.offset & (size - 1)) != 0))
 		return -EINVAL;
 	address -= key->both.offset;
 
@@ -705,17 +708,18 @@ double_lock_hb(struct futex_hash_bucket 
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(unsigned long __user *uaddr, int nr_wake)
+static int futex_wake(unsigned long __user *uaddr, int futex64, int nr_wake)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	struct plist_head *head;
 	union futex_key key;
 	int ret;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, fsize, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -817,6 +821,7 @@ futex_requeue_pi(unsigned long __user *u
 	struct rt_mutex_waiter *waiter, *top_waiter = NULL;
 	struct rt_mutex *lock2 = NULL;
 	int ret, drop_count = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -827,10 +832,10 @@ retry:
 	 */
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1005,14 +1010,15 @@ futex_wake_op(unsigned long __user *uadd
 	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retryfull:
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1125,14 +1131,15 @@ futex_requeue(unsigned long __user *uadd
 	struct plist_head *head1;
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
  retry:
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr1, &key1);
+	ret = get_futex_key(uaddr1, fsize, &key1);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, &key2);
+	ret = get_futex_key(uaddr2, fsize, &key2);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1390,9 +1397,15 @@ static int fixup_pi_state_owner(unsigned
 	return ret;
 }
 
+/*
+ * In case we must use restart_block to restart a futex_wait,
+ * we encode in the 'arg3' futex64 capability
+ */
+#define ARG3_FUTEX64 1
+
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait(unsigned long __user *uaddr, unsigned long val,
-		      ktime_t *abs_time, int futex64)
+static int futex_wait(unsigned long __user *uaddr, int futex64,
+		      unsigned long val, ktime_t *abs_time)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1402,12 +1415,13 @@ static int futex_wait(unsigned long __us
 	int ret;
 	struct hrtimer_sleeper t, *to = NULL;
 	int rem = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	q.pi_state = NULL;
  retry:
 	down_read(&curr->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, fsize, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1597,7 +1611,11 @@ static int futex_wait(unsigned long __us
 		restart->arg0 = (unsigned long)uaddr;
 		restart->arg1 = val;
 		restart->arg2 = (unsigned long)abs_time;
-		restart->arg3 = (unsigned long)futex64;
+		restart->arg3 = 0;
+#ifdef CONFIG_64BIT
+		if (futex64)
+			restart->arg3 |= ARG3_FUTEX64;
+#endif
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1615,10 +1633,14 @@ static long futex_wait_restart(struct re
 	unsigned long __user *uaddr = (unsigned long __user *)restart->arg0;
 	unsigned long val = restart->arg1;
 	ktime_t *abs_time = (ktime_t *)restart->arg2;
-	int futex64 = (int)restart->arg3;
+	int futex64 = 0;
 
+#ifdef CONFIG_64BIT
+	if (restart->arg3 & ARG3_FUTEX64)
+		futex64 = 1;
+#endif
 	restart->fn = do_no_restart_syscall;
-	return (long)futex_wait(uaddr, val, abs_time, futex64);
+	return (long)futex_wait(uaddr, futex64, val, abs_time);
 }
 
 
@@ -1682,6 +1704,7 @@ static int futex_lock_pi(unsigned long _
 	unsigned long uval, newval, curval;
 	struct futex_q q;
 	int ret, lock_held, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 	if (refill_pi_state_cache())
 		return -ENOMEM;
@@ -1697,7 +1720,7 @@ static int futex_lock_pi(unsigned long _
  retry:
 	down_read(&curr->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &q.key);
+	ret = get_futex_key(uaddr, fsize, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
 
@@ -1907,6 +1930,7 @@ static int futex_unlock_pi(unsigned long
 	struct plist_head *head;
 	union futex_key key;
 	int ret, attempt = 0;
+	int fsize = futex64 ? sizeof(u64) : sizeof(u32);
 
 retry:
 	if (futex_get_user(&uval, uaddr, futex64))
@@ -1921,7 +1945,7 @@ retry:
 	 */
 	down_read(&current->mm->mmap_sem);
 
-	ret = get_futex_key(uaddr, &key);
+	ret = get_futex_key(uaddr, fsize, &key);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -2094,7 +2118,7 @@ static int futex_fd(u32 __user *uaddr, i
 	q->pi_state = NULL;
 
 	down_read(&current->mm->mmap_sem);
-	err = get_futex_key(uaddr, &q->key);
+	err = get_futex_key(uaddr, sizeof(u32), &q->key);
 
 	if (unlikely(err != 0)) {
 		up_read(&current->mm->mmap_sem);
@@ -2238,7 +2262,7 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake((unsigned long __user *)uaddr, 1);
+				futex_wake((unsigned long __user *)uaddr, 0, 1);
 		}
 	}
 	return 0;
@@ -2329,10 +2353,10 @@ long do_futex(unsigned long __user *uadd
 
 	switch (op) {
 	case FUTEX_WAIT:
-		ret = futex_wait(uaddr, val, timeout, fut64);
+		ret = futex_wait(uaddr, fut64, val, timeout);
 		break;
 	case FUTEX_WAKE:
-		ret = futex_wake(uaddr, val);
+		ret = futex_wake(uaddr, fut64, val);
 		break;
 	case FUTEX_FD:
 		if (fut64)
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

git-net.patch
x86_64-move-__vgetcpu_mode-__jiffies-to-the-vsyscall_2-zone.patch
x86_64-set-node_possible_map-at-runtime.patch
x86_64-set-node_possible_map-at-runtime-fix.patch
slab-x86_64-skip-cache_free_alien-on-non-numa.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
slab-dont-allocate-empty-shared-caches.patch
slab-numa-kmem_cache-diet.patch
optimize-timespec_trunc.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
vfs-delay-the-dentry-name-generation-on-sockets-and.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
time-smp-friendly-alignment-of-struct-clocksource.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
make-static-counters-in-new_inode-and-iunique-be-32-bits.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sys_futex64-allows-64bit-futexes.patch
sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
futex-new-private-futexes.patch
lguest-the-host-code-vs-sys_futex64-allows-64bit-futexes-get_futex_key-must-check-proper-alignement-for-64bit-futexes.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
