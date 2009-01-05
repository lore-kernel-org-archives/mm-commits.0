From: akpm@linux-foundation.org
Subject: - workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch removed from -mm tree
Date: Mon, 05 Jan 2009 12:12:08 -0800
Message-ID: <200901052012.n05KC8NY013378@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753530AbZAEUM7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 15:12:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: valdis.kletnieks@vt.edu, oleg@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix
has been removed from the -mm tree.  Its filename was
     workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix
From: Valdis.Kletnieks@vt.edu

In mmotm1230, there was an apparent mismerge that left a spare '&' on
a variable, causing this compiler warning:

kernel/workqueue.c: In function 'wq_cpu_map':
kernel/workqueue.c:94: warning: pointer type mismatch in conditional expression

so let's fix that up.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix kernel/workqueue.c
--- a/kernel/workqueue.c~workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix
+++ a/kernel/workqueue.c
@@ -91,7 +91,7 @@ static inline int is_wq_single_threaded(
 static const struct cpumask *wq_cpu_map(struct workqueue_struct *wq)
 {
 	return is_wq_single_threaded(wq)
-		 ? get_cpu_mask(singlethread_cpu) : &cpu_populated_map;
+		 ? get_cpu_mask(singlethread_cpu) : cpu_populated_map;
 }
 
 static
_

Patches currently in -mm which might be from valdis.kletnieks@vt.edu are

drivers-acpi-hardware-hwsleepc-fix-warning-msg.patch
workqueues-kill-cpu_singlethread_map-use-get_cpu_mask-instead-fix.patch

