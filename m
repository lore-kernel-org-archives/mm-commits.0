From: akpm@linux-foundation.org
Subject: + kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch added to -mm tree
Date: Fri, 14 Aug 2015 13:49:42 -0700
Message-ID: <55ce5466.2CVKB9L4sXJpleVn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbbHNUto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Aug 2015 16:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cl@linux.com, oleg@redhat.com, riel@redhat.com, rusty@rustcorp.com.au, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kmod: remove unecessary explicit wide CPU affinity setting
has been added to the -mm tree.  Its filename is
     kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: kmod: remove unecessary explicit wide CPU affinity setting

Khelper is affine to all CPUs.  Now since it creates the
call_usermodehelper_exec_[a]sync() kernel threads, those inherit the wide
affinity.

As such explicitly forcing a wide affinity from those kernel threads
is like a no-op.

Just remove it. It's needless and it breaks CPU isolation users who
rely on workqueue affinity tuning.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/kmod.c~kmod-remove-unecessary-explicit-wide-cpu-affinity-setting kernel/kmod.c
--- a/kernel/kmod.c~kmod-remove-unecessary-explicit-wide-cpu-affinity-setting
+++ a/kernel/kmod.c
@@ -224,9 +224,6 @@ static int call_usermodehelper_exec_asyn
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
-
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
 	 * Avoid propagating that into the userspace child.
_

Patches currently in -mm which might be from fweisbec@gmail.com are

smpboot-fix-memory-leak-on-error-handling.patch
smpboot-make-cleanup-to-mirror-setup.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration-fix.patch
watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
watchdog-introduce-watchdog_park_threads-and-watchdog_unpark_threads.patch
watchdog-introduce-watchdog_suspend-and-watchdog_resume.patch
watchdog-use-park-unpark-functions-in-update_watchdog_all_cpus.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug.patch
watchdog-use-suspend-resume-interface-in-fixup_ht_bug-fix-2.patch
watchdog-rename-watchdog_suspend-and-watchdog_resume.patch
kmod-bunch-of-internal-functions-renames.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-use-system_unbound_wq-instead-of-khelper.patch
kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch
linux-next.patch

