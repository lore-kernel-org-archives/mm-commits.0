From: akpm@linux-foundation.org
Subject: + kernel-posix-timersc-code-clean-up.patch added to -mm tree
Date: Tue, 06 May 2014 13:47:43 -0700
Message-ID: <53694a6f.9ckQigUJ3pnlVMeO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40849 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbaEFUro (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, fabf@skynet.be

Subject: + kernel-posix-timersc-code-clean-up.patch added to -mm tree
To: fabf@skynet.be,tglx@linutronix.de
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:47:43 -0700


The patch titled
     Subject: kernel/posix-timers.c: code clean-up
has been added to the -mm tree.  Its filename is
     kernel-posix-timersc-code-clean-up.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-posix-timersc-code-clean-up.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-posix-timersc-code-clean-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/posix-timers.c: code clean-up

Fixing some checkpatch warnings:
-Convert printk to pr_foo()
-Remove spaces between function and (
-Split lines > 80 characters

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   57 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 27 deletions(-)

diff -puN kernel/posix-timers.c~kernel-posix-timersc-code-clean-up kernel/posix-timers.c
--- a/kernel/posix-timers.c~kernel-posix-timersc-code-clean-up
+++ a/kernel/posix-timers.c
@@ -71,7 +71,7 @@ static DEFINE_SPINLOCK(hash_lock);
  * SIGEV values.  Here we put out an error if this assumption fails.
  */
 #if SIGEV_THREAD_ID != (SIGEV_THREAD_ID & \
-                       ~(SIGEV_SIGNAL | SIGEV_NONE | SIGEV_THREAD))
+		       ~(SIGEV_SIGNAL | SIGEV_NONE | SIGEV_THREAD))
 #error "SIGEV_THREAD_ID must not share bit with other SIGEV values!"
 #endif
 
@@ -252,7 +252,8 @@ static int posix_get_monotonic_coarse(cl
 	return 0;
 }
 
-static int posix_get_coarse_res(const clockid_t which_clock, struct timespec *tp)
+static int posix_get_coarse_res(const clockid_t which_clock,
+				struct timespec *tp)
 {
 	*tp = ktime_to_timespec(KTIME_LOW_RES);
 	return 0;
@@ -333,14 +334,16 @@ static __init int init_posix_timers(void
 	posix_timers_register_clock(CLOCK_REALTIME, &clock_realtime);
 	posix_timers_register_clock(CLOCK_MONOTONIC, &clock_monotonic);
 	posix_timers_register_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
-	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
-	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_REALTIME_COARSE,
+				    &clock_realtime_coarse);
+	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE,
+				    &clock_monotonic_coarse);
 	posix_timers_register_clock(CLOCK_BOOTTIME, &clock_boottime);
 	posix_timers_register_clock(CLOCK_TAI, &clock_tai);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
-					sizeof (struct k_itimer), 0, SLAB_PANIC,
-					NULL);
+					       sizeof (struct k_itimer), 0,
+					       SLAB_PANIC, NULL);
 	return 0;
 }
 
@@ -494,11 +497,11 @@ static enum hrtimer_restart posix_timer_
 	return ret;
 }
 
-static struct pid *good_sigevent(sigevent_t * event)
+static struct pid *good_sigevent(sigevent_t *event)
 {
 	struct task_struct *rtn = current->group_leader;
 
-	if ((event->sigev_notify & SIGEV_THREAD_ID ) &&
+	if ((event->sigev_notify & SIGEV_THREAD_ID) &&
 		(!(rtn = find_task_by_vpid(event->sigev_notify_thread_id)) ||
 		 !same_thread_group(rtn, current) ||
 		 (event->sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_SIGNAL))
@@ -515,18 +518,18 @@ void posix_timers_register_clock(const c
 				 struct k_clock *new_clock)
 {
 	if ((unsigned) clock_id >= MAX_CLOCKS) {
-		printk(KERN_WARNING "POSIX clock register failed for clock_id %d\n",
+		pr_warn("POSIX clock register failed for clock_id %d\n",
 		       clock_id);
 		return;
 	}
 
 	if (!new_clock->clock_get) {
-		printk(KERN_WARNING "POSIX clock id %d lacks clock_get()\n",
+		pr_warn("POSIX clock id %d lacks clock_get()\n",
 		       clock_id);
 		return;
 	}
 	if (!new_clock->clock_getres) {
-		printk(KERN_WARNING "POSIX clock id %d lacks clock_getres()\n",
+		pr_warn("POSIX clock id %d lacks clock_getres()\n",
 		       clock_id);
 		return;
 	}
@@ -535,7 +538,7 @@ void posix_timers_register_clock(const c
 }
 EXPORT_SYMBOL_GPL(posix_timers_register_clock);
 
-static struct k_itimer * alloc_posix_timer(void)
+static struct k_itimer *alloc_posix_timer(void)
 {
 	struct k_itimer *tmr;
 	tmr = kmem_cache_zalloc(posix_timers_cache, GFP_KERNEL);
@@ -622,7 +625,7 @@ SYSCALL_DEFINE3(timer_create, const cloc
 	new_timer->it_overrun = -1;
 
 	if (timer_event_spec) {
-		if (copy_from_user(&event, timer_event_spec, sizeof (event))) {
+		if (copy_from_user(&event, timer_event_spec, sizeof(event))) {
 			error = -EFAULT;
 			goto out;
 		}
@@ -647,7 +650,7 @@ SYSCALL_DEFINE3(timer_create, const cloc
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
 	if (copy_to_user(created_timer_id,
-			 &new_timer_id, sizeof (new_timer_id))) {
+			 &new_timer_id, sizeof(new_timer_id))) {
 		error = -EFAULT;
 		goto out;
 	}
@@ -748,7 +751,8 @@ common_timer_get(struct k_itimer *timr,
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
 	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
+		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now,
+								   iv);
 
 	remaining = ktime_sub(hrtimer_get_expires(timer), now);
 	/* Return 0 only, when the timer is expired and not pending */
@@ -785,7 +789,7 @@ SYSCALL_DEFINE2(timer_gettime, timer_t,
 
 	unlock_timer(timr, flags);
 
-	if (!ret && copy_to_user(setting, &cur_setting, sizeof (cur_setting)))
+	if (!ret && copy_to_user(setting, &cur_setting, sizeof(cur_setting)))
 		return -EFAULT;
 
 	return ret;
@@ -837,7 +841,7 @@ common_timer_set(struct k_itimer *timr,
 	if (hrtimer_try_to_cancel(timer) < 0)
 		return TIMER_RETRY;
 
-	timr->it_requeue_pending = (timr->it_requeue_pending + 2) & 
+	timr->it_requeue_pending = (timr->it_requeue_pending + 2) &
 		~REQUEUE_PENDING;
 	timr->it_overrun_last = 0;
 
@@ -857,9 +861,8 @@ common_timer_set(struct k_itimer *timr,
 	/* SIGEV_NONE timers are not queued ! See common_timer_get */
 	if (((timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE)) {
 		/* Setup correct expiry time for relative timers */
-		if (mode == HRTIMER_MODE_REL) {
+		if (mode == HRTIMER_MODE_REL)
 			hrtimer_add_expires(timer, timer->base->get_time());
-		}
 		return 0;
 	}
 
@@ -882,7 +885,7 @@ SYSCALL_DEFINE4(timer_settime, timer_t,
 	if (!new_setting)
 		return -EINVAL;
 
-	if (copy_from_user(&new_spec, new_setting, sizeof (new_spec)))
+	if (copy_from_user(&new_spec, new_setting, sizeof(new_spec)))
 		return -EFAULT;
 
 	if (!timespec_valid(&new_spec.it_interval) ||
@@ -901,12 +904,12 @@ retry:
 
 	unlock_timer(timr, flag);
 	if (error == TIMER_RETRY) {
-		rtn = NULL;	// We already got the old time...
+		rtn = NULL;	/* We already got the old time... */
 		goto retry;
 	}
 
 	if (old_setting && !error &&
-	    copy_to_user(old_setting, &old_spec, sizeof (old_spec)))
+	    copy_to_user(old_setting, &old_spec, sizeof(old_spec)))
 		error = -EFAULT;
 
 	return error;
@@ -1008,14 +1011,14 @@ SYSCALL_DEFINE2(clock_settime, const clo
 	if (!kc || !kc->clock_set)
 		return -EINVAL;
 
-	if (copy_from_user(&new_tp, tp, sizeof (*tp)))
+	if (copy_from_user(&new_tp, tp, sizeof(*tp)))
 		return -EFAULT;
 
 	return kc->clock_set(which_clock, &new_tp);
 }
 
 SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
-		struct timespec __user *,tp)
+		struct timespec __user *, tp)
 {
 	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec kernel_tp;
@@ -1026,7 +1029,7 @@ SYSCALL_DEFINE2(clock_gettime, const clo
 
 	error = kc->clock_get(which_clock, &kernel_tp);
 
-	if (!error && copy_to_user(tp, &kernel_tp, sizeof (kernel_tp)))
+	if (!error && copy_to_user(tp, &kernel_tp, sizeof(kernel_tp)))
 		error = -EFAULT;
 
 	return error;
@@ -1067,7 +1070,7 @@ SYSCALL_DEFINE2(clock_getres, const cloc
 
 	error = kc->clock_getres(which_clock, &rtn_tp);
 
-	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof (rtn_tp)))
+	if (!error && tp && copy_to_user(tp, &rtn_tp, sizeof(rtn_tp)))
 		error = -EFAULT;
 
 	return error;
@@ -1096,7 +1099,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const c
 	if (!kc->nsleep)
 		return -ENANOSLEEP_NOTSUP;
 
-	if (copy_from_user(&t, rqtp, sizeof (struct timespec)))
+	if (copy_from_user(&t, rqtp, sizeof(struct timespec)))
 		return -EFAULT;
 
 	if (!timespec_valid(&t))
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-affs-superc-bugfix-double-free.patch
fs-ceph-replace-pr_warning-by-pr_warn.patch
fs-ceph-debugfsc-replace-seq_printf-by-seq_puts.patch
fs-cifs-remove-obsolete-__constant.patch
fs-jfs-jfs_logmgrc-remove-null-assignment-on-static.patch
fs-jfs-superc-remove-0-assignement-to-static-code-clean-up.patch
fs-fscache-convert-printk-to-pr_foo.patch
fs-fscache-replace-seq_printf-by-seq_puts.patch
ntfs-remove-null-value-assignments.patch
fs-squashfs-squashfsh-replace-pr_warning-by-pr_warn.patch
fs-configs-itemc-kernel-doc-fixes-clean-up.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
fs-9p-kerneldoc-fixes.patch
mm-slubc-convert-printk-to-pr_foo.patch
mm-slubc-convert-vnsprintf-static-to-va_format.patch
mm-memory_hotplugc-use-pfn_down.patch
mm-memblockc-use-pfn_down.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
mm-vmallocc-replace-seq_printf-by-seq_puts.patch
mm-mempolicyc-parameter-doc-uniformization.patch
mm-zbudc-make-size-unsigned-like-unique-callsite.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
kernel-cpuc-convert-printk-to-pr_foo.patch
kernel-backtracetestc-replace-no-level-printk-by-pr_info.patch
kernel-capabilityc-code-clean-up.patch
kernel-exec_domainc-code-clean-up.patch
lib-libcrc32cc-use-ptr_err_or_zero.patch
lib-vsprintfc-fix-comparison-to-bool.patch
kernel-compatc-use-sizeof-instead-of-sizeof.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-befs-linuxvfsc-remove-positive-test-on-sector_t.patch
fs-befs-kernel-doc-fixes.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-reiserfs-streec-remove-obsolete-__constant.patch
kernel-cpusetc-kernel-doc-fixes.patch
kernel-cpusetc-convert-printk-to-pr_foo.patch
kernel-kexecc-convert-printk-to-pr_foo.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
fs-pstore-logging-clean-up.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
init-mainc-code-clean-up.patch
ufs-sb-mutex-merge-mutex_destroy.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-latencytopc-convert-seq_printf-to-seq_puts.patch
kernel-posix-timersc-code-clean-up.patch
kernel-profilec-convert-printk-to-pr_foo.patch
kernel-rcu-treec-make-rcu-node-arrays-static-const-char-const.patch

