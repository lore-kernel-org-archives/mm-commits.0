From: akpm@linux-foundation.org
Subject: - futex-prevent-stale-futex-owner-when-interrupted-timeout.patch removed from -mm tree
Date: Sun, 13 Jan 2008 03:33:32 -0800
Message-ID: <200801131133.m0DBXCTo009828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55789 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751381AbYAMLdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jan 2008 06:33:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, roland.westrelin@sun.com, mm-commits@vger.kernel.org


The patch titled
     futex: prevent stale futex owner when interrupted/timeout
has been removed from the -mm tree.  Its filename was
     futex-prevent-stale-futex-owner-when-interrupted-timeout.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: prevent stale futex owner when interrupted/timeout
From: Thomas Gleixner <tglx@linutronix.de>

Roland Westrelin did a great analysis of a long standing thinko in the
return path of futex_lock_pi.

While we fixed the lock steal case long ago, which was easy to trigger, we
never had a test case which exposed this problem and stupidly never thought
about the reverse lock stealing scenario and the return to user space with
a stale state.

When a blocked task returns from rt_mutex_timed_locked without holding the
rt_mutex (due to a signal or timeout) and at the same time the task holding
the futex is releasing the futex and assigning the ownership of the futex
to the returning task, then it might happen that a third task acquires the
rt_mutex before the final rt_mutex_trylock() of the returning task happens
under the futex hash bucket lock.  The returning task returns to user space
with ETIMEOUT or EINTR, but the user space futex value is assigned to this
task.  The task which acquired the rt_mutex fixes the user space futex
value right after the hash bucket lock has been released by the returning
task, but for a short period of time the user space value is wrong.

Detailed description is available at:

   https://bugzilla.redhat.com/show_bug.cgi?id=400541

The fix for this is the same as we do when the rt_mutex was acquired by a
higher priority task via lock stealing from the designated new owner.  In
that case we already fix the user space value and the internal pi_state up
before we return.  This mechanism can be used to fixup the above corner
case as well.  When the returning task, which failed to acquire the
rt_mutex, notices that it is the designated owner of the futex, then it
fixes up the stale user space value and the pi_state, before returning to
user space.  This happens with the futex hash bucket lock held, so the task
which acquired the rt_mutex is guaranteed to be blocked on the hash bucket
lock.  We can access the rt_mutex owner, which gives us the pid of the new
owner, safely here as the owner is not able to modify (release) it while
waiting on the hash bucket lock.

Rename the "curr" argument of fixup_pi_state_owner() to "newowner" to avoid
confusion with current and add the check for the stale state into the
failure path of rt_mutex_trylock() in the return path of unlock_futex_pi().
 If the situation is detected use fixup_pi_state_owner() to assign
everything to the owner of the rt_mutex.

Pointed-out-by: Roland Westrelin <roland.westrelin@sun.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Roland Westrelin <roland.westrelin@sun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   51 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 10 deletions(-)

diff -puN kernel/futex.c~futex-prevent-stale-futex-owner-when-interrupted-timeout kernel/futex.c
--- a/kernel/futex.c~futex-prevent-stale-futex-owner-when-interrupted-timeout
+++ a/kernel/futex.c
@@ -1097,15 +1097,15 @@ static void unqueue_me_pi(struct futex_q
 }
 
 /*
- * Fixup the pi_state owner with current.
+ * Fixup the pi_state owner with the new owner.
  *
  * Must be called with hash bucket lock held and mm->sem held for non
  * private futexes.
  */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *curr)
+				struct task_struct *newowner)
 {
-	u32 newtid = task_pid_vnr(curr) | FUTEX_WAITERS;
+	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
 	u32 uval, curval, newval;
 	int ret;
@@ -1119,12 +1119,12 @@ static int fixup_pi_state_owner(u32 __us
 	} else
 		newtid |= FUTEX_OWNER_DIED;
 
-	pi_state->owner = curr;
+	pi_state->owner = newowner;
 
-	spin_lock_irq(&curr->pi_lock);
+	spin_lock_irq(&newowner->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
-	list_add(&pi_state->list, &curr->pi_state_list);
-	spin_unlock_irq(&curr->pi_lock);
+	list_add(&pi_state->list, &newowner->pi_state_list);
+	spin_unlock_irq(&newowner->pi_lock);
 
 	/*
 	 * We own it, so we have to replace the pending owner
@@ -1508,9 +1508,40 @@ static int futex_lock_pi(u32 __user *uad
 		 * when we were on the way back before we locked the
 		 * hash bucket.
 		 */
-		if (q.pi_state->owner == curr &&
-		    rt_mutex_trylock(&q.pi_state->pi_mutex)) {
-			ret = 0;
+		if (q.pi_state->owner == curr) {
+			/*
+			 * Try to get the rt_mutex now. This might
+			 * fail as some other task acquired the
+			 * rt_mutex after we removed ourself from the
+			 * rt_mutex waiters list.
+			 */
+			if (rt_mutex_trylock(&q.pi_state->pi_mutex))
+				ret = 0;
+			else {
+				/*
+				 * pi_state is incorrect, some other
+				 * task did a lock steal and we
+				 * returned due to timeout or signal
+				 * without taking the rt_mutex. Too
+				 * late. We can access the
+				 * rt_mutex_owner without locking, as
+				 * the other task is now blocked on
+				 * the hash bucket lock. Fix the state
+				 * up.
+				 */
+				struct task_struct *owner;
+				int res;
+
+				owner = rt_mutex_owner(&q.pi_state->pi_mutex);
+				res = fixup_pi_state_owner(uaddr, &q, owner);
+
+				WARN_ON(rt_mutex_owner(&q.pi_state->pi_mutex) !=
+					owner);
+
+				/* propagate -EFAULT, if the fixup failed */
+				if (res)
+					ret = res;
+			}
 		} else {
 			/*
 			 * Paranoia check. If we did not take the lock
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
kick-cpus-that-might-be-sleeping-in-cpus_idle_wait.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-arm.patch
git-hrt.patch
revert-git-hrt.patch
pci-disable-decoding-during-sizing-of-bars.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
git-x86.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
serverworks-irq-routing-needs-no-_p.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-cryptodev-fixup.patch
fix-rtc_aie-with-config_hpet_emulate_rtc.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
time-fix-sysfs_show_availablecurrent_clocksources-buffer-overflow-problem.patch
proc-loadavg-reading-race.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
avoid-overflows-in-kernel-timec.patch
make-sys_poll-wait-at-least-timeout-ms.patch
system-timer-fix-crash-in-100hz-system-timer.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
asic3-driver.patch
asic3-driver-update.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
itimer_real-convert-to-use-struct-pid.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-fix.patch
efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
