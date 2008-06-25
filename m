From: akpm@linux-foundation.org
Subject: + signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch added to -mm tree
Date: Wed, 25 Jun 2008 14:30:28 -0700
Message-ID: <200806252130.m5PLUSvb027830@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbYFYVcZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Jun 2008 17:32:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mtk.manpages@googlemail.com, mingo@elte.hu, mtk.manpages@gmail.com, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de


The patch titled
     signals: make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
has been added to the -mm tree.  Its filename is
     signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>

In the switch to configurable HZ in 2.6, the treatment of the si_utime and
si_stime fields that are exposed to userland via the siginfo structure
looks to have been botched.  As things stand, these fields report times in
units of HZ, so that userland gets information that varies depending on
the HZ that the kernel was configured with.  This patch changes the
reported values to use USER_HZ units.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz kernel/signal.c
--- a/kernel/signal.c~signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz
+++ a/kernel/signal.c
@@ -1370,10 +1370,9 @@ void do_notify_parent(struct task_struct
 
 	info.si_uid = tsk->uid;
 
-	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
+	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
 						       tsk->signal->utime));
-	info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
+	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
 						       tsk->signal->stime));
 
 	info.si_status = tsk->exit_code & 0x7f;
@@ -1441,9 +1440,8 @@ static void do_notify_parent_cldstop(str
 
 	info.si_uid = tsk->uid;
 
-	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(tsk->utime);
-	info.si_stime = cputime_to_jiffies(tsk->stime);
+	info.si_utime = cputime_to_clock_t(tsk->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime);
 
  	info.si_code = why;
  	switch (why) {
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

vfs-utimensat-ignore-tv_sec-if-tv_nsec-==-utime_omit-or-utime_now.patch
vfs-utimensat-be-consistent-with-utime-for-immutable-and-append-only-files.patch
vfs-utimensat-fix-error-checking-for-utime_nowutime_omit-case.patch
vfs-utimensat-fix-write-access-check-for-futimens.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
flag-parameters-socket-and-socketpair.patch
flag-parameters-socket-and-socketpair-mips-fix.patch
flag-parameters-paccept.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
flag-parameters-paccept-flag-parameters-paccept-w-out-set_restore_sigmask.patch
flag-parameters-paccept-sys_ni.patch
flag-parameters-anon_inode_getfd-extension.patch
flag-parameters-anon_inode_getfd-extension-fix.patch
flag-parameters-signalfd.patch
flag-parameters-signalfd-fix.patch
flag-parameters-eventfd.patch
flag-parameters-eventfd-fix.patch
flag-parameters-timerfd_create.patch
flag-parameters-epoll_create.patch
flag-parameters-dup2.patch
flag-parameters-pipe.patch
flag-parameters-inotify_init.patch
flag-parameters-inotify_init-fix.patch
flag-parametersi-nonblock-in-anon_inode_getfd.patch
flag-parameters-nonblock-in-socket-and-socketpair.patch
flag-parameters-nonblock-in-signalfd.patch
flag-parameters-nonblock-in-eventfd.patch
flag-parameters-nonblock-in-timerfd_create.patch
flag-parameters-nonblock-in-pipe.patch
flag-parameters-nonblock-in-inotify_init.patch
flag-parameters-check-magic-constants.patch
flag-parameters-check-magic-constants-alpha.patch
flag-parameters-add-on-remove-epoll_create-size-param.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch

