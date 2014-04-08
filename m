From: akpm@linux-foundation.org
Subject: [folded-merged]
 kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 13:55:56 -0700
Message-ID: <5344625c.jaci+ehPRcUkCWmP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUz5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:55:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vapier@gentoo.org, tj@kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, gilad@benyossef.com, fweisbec@gmail.com, cl@linux.com, bitbucket@online.de, akpm@linux-foundation.org

Subject: [folded-merged] kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,bitbucket@online.de,cl@linux.com,fweisbec@gmail.com,gilad@benyossef.com,paulmck@linux.vnet.ibm.com,rusty@rustcorp.com.au,tglx@linutronix.de,tj@kernel.org,vapier@gentoo.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:55:56 -0700


The patch titled
     Subject: kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix
has been removed from the -mm tree.  Its filename was
     kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch

This patch was dropped because it was folded into kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch

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
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

