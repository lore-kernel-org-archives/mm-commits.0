From: akpm@linux-foundation.org
Subject: + posix-timers-annotate-lock_timer.patch added to -mm tree
Date: Wed, 06 Oct 2010 15:12:08 -0700
Message-ID: <201010062212.o96MC8X1025237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756288Ab0JFWMO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Oct 2010 18:12:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, tglx@linutronix.de


The patch titled
     posix-timers: annotate lock_timer()
has been added to the -mm tree.  Its filename is
     posix-timers-annotate-lock_timer.patch

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
Subject: posix-timers: annotate lock_timer()
From: Namhyung Kim <namhyung@gmail.com>

lock_timer() conditionally grabs it_lock in case of returning non-NULL but
unlock_timer() releases it unconditionally.  This leads sparse to complain
about the lock context imbalance.  Rename and wrap lock_timer using
__cond_lock() macro to make sparse happy.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-annotate-lock_timer kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-annotate-lock_timer
+++ a/kernel/posix-timers.c
@@ -145,7 +145,13 @@ static int common_timer_del(struct k_iti
 
 static enum hrtimer_restart posix_timer_fn(struct hrtimer *data);
 
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags);
+static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
+
+#define lock_timer(tid, flags)						   \
+({	struct k_itimer *__timr;					   \
+	__cond_lock(&__timr->it_lock, __timr = __lock_timer(tid, flags));  \
+	__timr;								   \
+})
 
 static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 {
@@ -619,7 +625,7 @@ out:
  * the find to the timer lock.  To avoid a dead lock, the timer id MUST
  * be release with out holding the timer lock.
  */
-static struct k_itimer *lock_timer(timer_t timer_id, unsigned long *flags)
+static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 {
 	struct k_itimer *timr;
 	/*
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch
posix-timers-annotate-lock_timer.patch
vfs-remove-a-warning-on-open_fmode.patch
vfs-add-__fmode_exec.patch
mm-remove-temporary-variable-on-generic_file_direct_write.patch
mm-add-casts-to-from-gfp_t-in-gfp_to_alloc_flags.patch
mm-wrap-get_locked_pte-using-__cond_lock.patch
mm-add-lock-release-annotation-on-do_wp_page.patch
mm-wrap-follow_pte-using-__cond_lock.patch
rmap-annotate-lock-context-change-on-page_lock_anon_vma.patch
rmap-wrap-page_check_address-using-__cond_lock.patch
rmap-make-anon_vma_free-static.patch
vmalloc-rename-temporary-variable-in-__insert_vmap_area.patch
vmalloc-annotate-lock-context-change-on-s_start-stop.patch
mm-declare-some-external-symbols.patch
vmstat-include-compactionh-when-config_compaction.patch
vmstat-include-compactionh-when-config_compaction-fix.patch
mm-fix-sparse-warnings-on-gfp_zone_table-bad.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
ptrace-annotate-lock-context-change-on-exit_ptrace.patch
ptrace-change-signature-of-sys_ptrace-and-friends.patch
ptrace-cleanup-ptrace_request.patch
ptrace-change-signature-of-arch_ptrace.patch
ptrace-cleanup-arch_ptrace-on-x86.patch
ptrace-cleanup-arch_ptrace-on-arm.patch
ptrace-cleanup-arch_ptrace-on-avr32.patch
ptrace-cleanup-arch_ptrace-and-friends-on-blackfin.patch
ptrace-cleanup-arch_ptrace-on-cris.patch
ptrace-cleanup-arch_ptrace-on-frv.patch
ptrace-cleanup-arch_ptrace-on-h8300.patch
ptrace-cleanup-arch_ptrace-on-m32r.patch
ptrace-cleanup-arch_ptrace-on-m68k.patch
ptrace-cleanup-arch_ptrace-on-m68knommu.patch
ptrace-cleanup-arch_ptrace-on-microblaze.patch
ptrace-cleanup-arch_ptrace-on-mips.patch
ptrace-cleanup-arch_ptrace-on-mn10300.patch
ptrace-cleanup-arch_ptrace-on-parisc.patch
ptrace-cleanup-arch_ptrace-on-powerpc.patch
ptrace-cleanup-arch_ptrace-on-score.patch
ptrace-cleanup-arch_ptrace-on-sh.patch
ptrace-cleanup-arch_ptrace-on-sparc.patch
ptrace-cleanup-arch_ptrace-on-tile.patch
ptrace-cleanup-arch_ptrace-on-um.patch
ptrace-cleanup-arch_ptrace-on-xtensa.patch
signals-annotate-lock_task_sighand.patch
signals-annotate-lock-context-change-on-ptrace_stop.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

