From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Mon, 03 Apr 2017 12:07:07 -0700
Message-ID: <58e29d5b.cqFeK8zEhmWTWvkN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40606 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751468AbdDCTHJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 15:07:09 -0400
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

 arch/x86/kernel/cpu/mcheck/mce.c |  262 -----------------------------
 1 file changed, 262 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/mce.c~linux-next-git-rejects arch/x86/kernel/cpu/mcheck/mce.c
--- a/arch/x86/kernel/cpu/mcheck/mce.c~linux-next-git-rejects
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -54,21 +54,7 @@
 
 #include "mce-internal.h"
 
-<<<<<<< HEAD
-static DEFINE_MUTEX(mce_chrdev_read_mutex);
-
-static int mce_chrdev_open_count;	/* #times opened */
-
-#define mce_log_get_idx_check(p) \
-({ \
-	RCU_LOCKDEP_WARN(!rcu_read_lock_sched_held() && \
-			 !lockdep_is_held(&mce_chrdev_read_mutex), \
-			 "suspicious mce_log_get_idx_check() usage"); \
-	smp_load_acquire(&(p)); \
-})
-=======
 static DEFINE_MUTEX(mce_log_mutex);
->>>>>>> linux-next/akpm-base
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
@@ -1829,254 +1815,6 @@ void mcheck_cpu_clear(struct cpuinfo_x86
 
 }
 
-<<<<<<< HEAD
-/*
- * mce_chrdev: Character device /dev/mcelog to read and clear the MCE log.
- */
-
-static DEFINE_SPINLOCK(mce_chrdev_state_lock);
-static int mce_chrdev_open_exclu;	/* already open exclusive? */
-
-static int mce_chrdev_open(struct inode *inode, struct file *file)
-{
-	spin_lock(&mce_chrdev_state_lock);
-
-	if (mce_chrdev_open_exclu ||
-	    (mce_chrdev_open_count && (file->f_flags & O_EXCL))) {
-		spin_unlock(&mce_chrdev_state_lock);
-
-		return -EBUSY;
-	}
-
-	if (file->f_flags & O_EXCL)
-		mce_chrdev_open_exclu = 1;
-	mce_chrdev_open_count++;
-
-	spin_unlock(&mce_chrdev_state_lock);
-
-	return nonseekable_open(inode, file);
-}
-
-static int mce_chrdev_release(struct inode *inode, struct file *file)
-{
-	spin_lock(&mce_chrdev_state_lock);
-
-	mce_chrdev_open_count--;
-	mce_chrdev_open_exclu = 0;
-
-	spin_unlock(&mce_chrdev_state_lock);
-
-	return 0;
-}
-
-static void collect_tscs(void *data)
-{
-	unsigned long *cpu_tsc = (unsigned long *)data;
-
-	cpu_tsc[smp_processor_id()] = rdtsc();
-}
-
-static int mce_apei_read_done;
-
-/* Collect MCE record of previous boot in persistent storage via APEI ERST. */
-static int __mce_read_apei(char __user **ubuf, size_t usize)
-{
-	int rc;
-	u64 record_id;
-	struct mce m;
-
-	if (usize < sizeof(struct mce))
-		return -EINVAL;
-
-	rc = apei_read_mce(&m, &record_id);
-	/* Error or no more MCE record */
-	if (rc <= 0) {
-		mce_apei_read_done = 1;
-		/*
-		 * When ERST is disabled, mce_chrdev_read() should return
-		 * "no record" instead of "no device."
-		 */
-		if (rc == -ENODEV)
-			return 0;
-		return rc;
-	}
-	rc = -EFAULT;
-	if (copy_to_user(*ubuf, &m, sizeof(struct mce)))
-		return rc;
-	/*
-	 * In fact, we should have cleared the record after that has
-	 * been flushed to the disk or sent to network in
-	 * /sbin/mcelog, but we have no interface to support that now,
-	 * so just clear it to avoid duplication.
-	 */
-	rc = apei_clear_mce(record_id);
-	if (rc) {
-		mce_apei_read_done = 1;
-		return rc;
-	}
-	*ubuf += sizeof(struct mce);
-
-	return 0;
-}
-
-static ssize_t mce_chrdev_read(struct file *filp, char __user *ubuf,
-				size_t usize, loff_t *off)
-{
-	char __user *buf = ubuf;
-	unsigned long *cpu_tsc;
-	unsigned prev, next;
-	int i, err;
-
-	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
-	if (!cpu_tsc)
-		return -ENOMEM;
-
-	mutex_lock(&mce_chrdev_read_mutex);
-
-	if (!mce_apei_read_done) {
-		err = __mce_read_apei(&buf, usize);
-		if (err || buf != ubuf)
-			goto out;
-	}
-
-	next = mce_log_get_idx_check(mcelog.next);
-
-	/* Only supports full reads right now */
-	err = -EINVAL;
-	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce))
-		goto out;
-
-	err = 0;
-	prev = 0;
-	do {
-		for (i = prev; i < next; i++) {
-			unsigned long start = jiffies;
-			struct mce *m = &mcelog.entry[i];
-
-			while (!m->finished) {
-				if (time_after_eq(jiffies, start + 2)) {
-					memset(m, 0, sizeof(*m));
-					goto timeout;
-				}
-				cpu_relax();
-			}
-			smp_rmb();
-			err |= copy_to_user(buf, m, sizeof(*m));
-			buf += sizeof(*m);
-timeout:
-			;
-		}
-
-		memset(mcelog.entry + prev, 0,
-		       (next - prev) * sizeof(struct mce));
-		prev = next;
-		next = cmpxchg(&mcelog.next, prev, 0);
-	} while (next != prev);
-
-	synchronize_sched();
-
-	/*
-	 * Collect entries that were still getting written before the
-	 * synchronize.
-	 */
-	on_each_cpu(collect_tscs, cpu_tsc, 1);
-
-	for (i = next; i < MCE_LOG_LEN; i++) {
-		struct mce *m = &mcelog.entry[i];
-
-		if (m->finished && m->tsc < cpu_tsc[m->cpu]) {
-			err |= copy_to_user(buf, m, sizeof(*m));
-			smp_rmb();
-			buf += sizeof(*m);
-			memset(m, 0, sizeof(*m));
-		}
-	}
-
-	if (err)
-		err = -EFAULT;
-
-out:
-	mutex_unlock(&mce_chrdev_read_mutex);
-	kfree(cpu_tsc);
-
-	return err ? err : buf - ubuf;
-}
-
-static unsigned int mce_chrdev_poll(struct file *file, poll_table *wait)
-{
-	poll_wait(file, &mce_chrdev_wait, wait);
-	if (READ_ONCE(mcelog.next))
-		return POLLIN | POLLRDNORM;
-	if (!mce_apei_read_done && apei_check_mce())
-		return POLLIN | POLLRDNORM;
-	return 0;
-}
-
-static long mce_chrdev_ioctl(struct file *f, unsigned int cmd,
-				unsigned long arg)
-{
-	int __user *p = (int __user *)arg;
-
-	if (!capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	switch (cmd) {
-	case MCE_GET_RECORD_LEN:
-		return put_user(sizeof(struct mce), p);
-	case MCE_GET_LOG_LEN:
-		return put_user(MCE_LOG_LEN, p);
-	case MCE_GETCLEAR_FLAGS: {
-		unsigned flags;
-
-		do {
-			flags = mcelog.flags;
-		} while (cmpxchg(&mcelog.flags, flags, 0) != flags);
-
-		return put_user(flags, p);
-	}
-	default:
-		return -ENOTTY;
-	}
-}
-
-static ssize_t (*mce_write)(struct file *filp, const char __user *ubuf,
-			    size_t usize, loff_t *off);
-
-void register_mce_write_callback(ssize_t (*fn)(struct file *filp,
-			     const char __user *ubuf,
-			     size_t usize, loff_t *off))
-{
-	mce_write = fn;
-}
-EXPORT_SYMBOL_GPL(register_mce_write_callback);
-
-static ssize_t mce_chrdev_write(struct file *filp, const char __user *ubuf,
-				size_t usize, loff_t *off)
-{
-	if (mce_write)
-		return mce_write(filp, ubuf, usize, off);
-	else
-		return -EINVAL;
-}
-
-static const struct file_operations mce_chrdev_ops = {
-	.open			= mce_chrdev_open,
-	.release		= mce_chrdev_release,
-	.read			= mce_chrdev_read,
-	.write			= mce_chrdev_write,
-	.poll			= mce_chrdev_poll,
-	.unlocked_ioctl		= mce_chrdev_ioctl,
-	.llseek			= no_llseek,
-};
-
-static struct miscdevice mce_chrdev_device = {
-	MISC_MCELOG_MINOR,
-	"mcelog",
-	&mce_chrdev_ops,
-};
-
-=======
->>>>>>> linux-next/akpm-base
 static void __mce_disable_bank(void *arg)
 {
 	int bank = *((int *)arg);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-move-madv_free-pages-into-lru_inactive_file-list-checkpatch-fixes.patch
mm-use-is_migrate_highatomic-to-simplify-the-code-fix.patch
mm-introduce-memalloc_nofs_saverestore-api-fix.patch
jbd2-mark-the-transaction-context-with-the-scope-gfp_nofs-context-fix.patch
jbd2-make-the-whole-kjournald2-kthread-nofs-safe-checkpatch-fixes.patch
mm-page_alloc-count-movable-pages-when-stealing-from-pageblock-fix.patch
swap-add-warning-if-swap-slots-cache-failed-to-initialize-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix.patch
checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions-fix-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix.patch
taskstats-add-e-u-stime-for-tgid-command-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
drivers-net-ethernet-mellanox-mlx5-core-en_mainc-fix-build-with-gcc-444.patch
drivers-net-ethernet-mellanox-mlx5-core-en_ethtoolc-fix-build-with-gcc-444.patch
drm-use-set_memoryh-header-fix.patch
drivers-staging-media-atomisp-pci-atomisp2-use-set_memoryh.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

