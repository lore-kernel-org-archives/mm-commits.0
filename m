From: akpm@linux-foundation.org
Subject: [merged] smpboot-fix-memory-leak-on-error-handling.patch removed
 from -mm tree
Date: Tue, 08 Sep 2015 11:02:57 -0700
Message-ID: <55ef22d1.vYRF7D2ClL2J2PTd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbIHSC6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:02:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@ezchip.com, dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: fix memory leak on error handling
has been removed from the -mm tree.  Its filename was
     smpboot-fix-memory-leak-on-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: smpboot: fix memory leak on error handling

The cpumask is allocated before threads get created. If the latter step
fails, we need to free the cpumask.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/smpboot.c~smpboot-fix-memory-leak-on-error-handling kernel/smpboot.c
--- a/kernel/smpboot.c~smpboot-fix-memory-leak-on-error-handling
+++ a/kernel/smpboot.c
@@ -301,6 +301,7 @@ int smpboot_register_percpu_thread(struc
 		ret = __smpboot_create_thread(plug_thread, cpu);
 		if (ret) {
 			smpboot_destroy_threads(plug_thread);
+			free_cpumask_var(plug_thread->cpumask);
 			goto out;
 		}
 		smpboot_unpark_thread(plug_thread, cpu);
_

Patches currently in -mm which might be from fweisbec@gmail.com are

kmod-bunch-of-internal-functions-renames.patch
kmod-remove-unecessary-explicit-wide-cpu-affinity-setting.patch
kmod-add-up-to-date-explanations-on-the-purpose-of-each-asynchronous-levels.patch
kmod-use-system_unbound_wq-instead-of-khelper.patch
kmod-handle-umh_wait_proc-from-system-unbound-workqueue.patch

