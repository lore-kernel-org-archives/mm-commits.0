From: akpm@linux-foundation.org
Subject: [merged] posix-timers-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:49 -0800
Message-ID: <20130228201549.B11AE5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:41790 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab3B1UPu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:50 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so245132ves.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: posix-timers: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     posix-timers-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: posix-timers: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-timers.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff -puN kernel/posix-timers.c~posix-timers-convert-to-idr_alloc kernel/posix-timers.c
--- a/kernel/posix-timers.c~posix-timers-convert-to-idr_alloc
+++ a/kernel/posix-timers.c
@@ -552,24 +552,22 @@ SYSCALL_DEFINE3(timer_create, const cloc
 		return -EAGAIN;
 
 	spin_lock_init(&new_timer->it_lock);
- retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
-		error = -EAGAIN;
-		goto out;
-	}
+
+	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
+	error = idr_alloc(&posix_timers_id, new_timer, 0, 0, GFP_NOWAIT);
 	spin_unlock_irq(&idr_lock);
-	if (error) {
-		if (error == -EAGAIN)
-			goto retry;
+	idr_preload_end();
+	if (error < 0) {
 		/*
 		 * Weird looking, but we return EAGAIN if the IDR is
 		 * full (proper POSIX return value for this)
 		 */
-		error = -EAGAIN;
+		if (error == -ENOSPC)
+			error = -EAGAIN;
 		goto out;
 	}
+	new_timer_id = error;
 
 	it_id_set = IT_ID_SET;
 	new_timer->it_id = (timer_t) new_timer_id;
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

