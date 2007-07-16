From: akpm@linux-foundation.org
Subject: - reduce-cpusetc-write_lock_irq-to-read_lock.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:34 -0700
Message-ID: <200707162054.l6GKsYkk001836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36477 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759029AbXGPV1O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:27:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Reduce cpuset.c write_lock_irq() to read_lock()
has been removed from the -mm tree.  Its filename was
     reduce-cpusetc-write_lock_irq-to-read_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Reduce cpuset.c write_lock_irq() to read_lock()
From: Paul Menage <menage@google.com>

cpuset.c:update_nodemask() uses a write_lock_irq() on tasklist_lock to
block concurrent forks; a read_lock() suffices and is less intrusive.

Signed-off-by: Paul Menage<menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpuset.c~reduce-cpusetc-write_lock_irq-to-read_lock kernel/cpuset.c
--- a/kernel/cpuset.c~reduce-cpusetc-write_lock_irq-to-read_lock
+++ a/kernel/cpuset.c
@@ -981,10 +981,10 @@ static int update_nodemask(struct cpuset
 		mmarray = kmalloc(ntasks * sizeof(*mmarray), GFP_KERNEL);
 		if (!mmarray)
 			goto done;
-		write_lock_irq(&tasklist_lock);		/* block fork */
+		read_lock(&tasklist_lock);		/* block fork */
 		if (atomic_read(&cs->count) <= ntasks)
 			break;				/* got enough */
-		write_unlock_irq(&tasklist_lock);	/* try again */
+		read_unlock(&tasklist_lock);		/* try again */
 		kfree(mmarray);
 	}
 
@@ -1006,7 +1006,7 @@ static int update_nodemask(struct cpuset
 			continue;
 		mmarray[n++] = mm;
 	} while_each_thread(g, p);
-	write_unlock_irq(&tasklist_lock);
+	read_unlock(&tasklist_lock);
 
 	/*
 	 * Now that we've dropped the tasklist spinlock, we can
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-basic-container-framework.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-basic-container-framework-fix-3.patch
containersv10-basic-container-framework-fix-for-bad-lock-balance-in-containers.patch
containersv10-example-cpu-accounting-subsystem.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-tasks-file-interface-fix-2.patch
containersv10-add-fork-exit-hooks.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface.patch
containersv10-add-procfs-interface-fix.patch
containersv10-make-cpusets-a-client-of-containers.patch
containersv10-make-cpusets-a-client-of-containers-whitespace.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
containersv10-simple-debug-info-subsystem.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
containersv10-support-for-automatic-userspace-release-agents.patch
containersv10-support-for-automatic-userspace-release-agents-whitespace.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
update-getdelays-to-become-containerstats-aware.patch
containers-implement-subsys-post_clone.patch
containers-implement-namespace-tracking-subsystem-v3.patch
