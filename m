From: akpm@linux-foundation.org
Subject: +
 kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
 added to -mm tree
Date: Fri, 15 Nov 2013 12:41:48 -0800
Message-ID: <5286870c.XD0AWoHpGhXSo3vq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab3KOUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:41:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, gilad@benyossef.com, fweisbec@gmail.com, cl@linux.com, bitbucket@online.de, akpm@linux-foundation.org

Subject: + kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch added to -mm tree
To: akpm@linux-foundation.org,bitbucket@online.de,cl@linux.com,fweisbec@gmail.com,gilad@benyossef.com,paulmck@linux.vnet.ibm.com,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,vapier@gentoo.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:41:48 -0800


The patch titled
     Subject: kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix
has been added to the -mm tree.  Its filename is
     kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch

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
Subject: kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix

set_cpus_allowed() doesn't exist when CONFIG_CPUMASK_OFFSTACK=y.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kthread.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix kernel/kthread.c
--- a/kernel/kthread.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix
+++ a/kernel/kthread.c
@@ -142,7 +142,7 @@ void *kthread_data(struct task_struct *t
  */
 void set_kthreadd_affinity(void)
 {
-	set_cpus_allowed(current, kthreadd_task->cpus_allowed);
+	set_cpus_allowed_ptr(current, &kthreadd_task->cpus_allowed);
 }
 
 /**
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

