From: akpm@linux-foundation.org
Subject: + smpboot-fix-memory-leak-on-error-handling.patch added to -mm
 tree
Date: Mon, 13 Jul 2015 14:55:38 -0700
Message-ID: <55a433da.XPofNygTKBrUdJxd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbbGMVzj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:55:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fweisbec@gmail.com, cmetcalf@ezchip.com, dzickus@redhat.com, peterz@infradead.org, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smpboot: fix memory leak on error handling
has been added to the -mm tree.  Its filename is
     smpboot-fix-memory-leak-on-error-handling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/smpboot-fix-memory-leak-on-error-handling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/smpboot-fix-memory-leak-on-error-handling.patch

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

smpboot-fix-memory-leak-on-error-handling.patch
smpboot-make-cleanup-to-mirror-setup.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch
watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
linux-next.patch

