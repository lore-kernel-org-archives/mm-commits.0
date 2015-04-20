From: akpm@linux-foundation.org
Subject: [merged]
 signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch removed from -mm tree
Date: Mon, 20 Apr 2015 12:19:33 -0700
Message-ID: <55355145.MFDnftoNnq6YeQp6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbbDTTNM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:13:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: remove warning about using SI_TKILL in rt_[tg]sigqueueinfo
has been removed from the -mm tree.  Its filename was
     signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: signal: remove warning about using SI_TKILL in rt_[tg]sigqueueinfo

Sending SI_TKILL from rt_[tg]sigqueueinfo was deprecated, so now we issue
a warning on the first attempt of doing it.  We use WARN_ON_ONCE, which is
not informative and, what is worse, taints the kernel, making the trinity
syscall fuzzer complain false-positively from time to time.

It does not look like we need this warning at all, because the behaviour
changed quite a long time ago (2.6.39), and if an application relies on
the old API, it gets EPERM anyway and can issue a warning by itself.

So let us zap the warning in kernel.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff -puN kernel/signal.c~signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo kernel/signal.c
--- a/kernel/signal.c~signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo
+++ a/kernel/signal.c
@@ -2992,11 +2992,9 @@ static int do_rt_sigqueueinfo(pid_t pid,
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
 	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
-	    (task_pid_vnr(current) != pid)) {
-		/* We used to allow any < 0 si_code */
-		WARN_ON_ONCE(info->si_code < 0);
+	    (task_pid_vnr(current) != pid))
 		return -EPERM;
-	}
+
 	info->si_signo = sig;
 
 	/* POSIX.1b doesn't mention process groups.  */
@@ -3041,12 +3039,10 @@ static int do_rt_tgsigqueueinfo(pid_t tg
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (((info->si_code >= 0 || info->si_code == SI_TKILL)) &&
-	    (task_pid_vnr(current) != pid)) {
-		/* We used to allow any < 0 si_code */
-		WARN_ON_ONCE(info->si_code < 0);
+	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
+	    (task_pid_vnr(current) != pid))
 		return -EPERM;
-	}
+
 	info->si_signo = sig;
 
 	return do_send_specific(tgid, pid, sig, info);
_

Patches currently in -mm which might be from vdavydov@parallels.com are

origin.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

