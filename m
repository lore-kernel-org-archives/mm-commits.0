From: akpm@linux-foundation.org
Subject: + oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch added to -mm tree
Date: Wed, 26 Sep 2007 13:11:03 -0700
Message-ID: <200709262011.l8QKB30j001810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44973 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbXIZULw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 16:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, andrea@suse.de, clameter@sgi.com


The patch titled
     oom: convert zone_scan_lock from mutex to spinlock
has been added to the -mm tree.  Its filename is
     oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: oom: convert zone_scan_lock from mutex to spinlock
From: David Rientjes <rientjes@google.com>

There's no reason to sleep in try_set_zone_oom() or clear_zonelist_oom() if
the lock can't be acquired; it will be available soon enough once the zonelist
scanning is done.  All other threads waiting for the OOM killer are also
contingent on the exiting task being able to acquire the lock in
clear_zonelist_oom() so it doesn't make sense to put it to sleep.

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN mm/oom_kill.c~oom-convert-zone_scan_lock-from-mutex-to-spinlock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-convert-zone_scan_lock-from-mutex-to-spinlock
+++ a/mm/oom_kill.c
@@ -28,7 +28,7 @@
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
-static DEFINE_MUTEX(zone_scan_mutex);
+static DEFINE_SPINLOCK(zone_scan_mutex);
 /* #define DEBUG */
 
 /**
@@ -396,7 +396,7 @@ int try_set_zone_oom(struct zonelist *zo
 
 	z = zonelist->zones;
 
-	mutex_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_mutex);
 	do {
 		if (zone_is_oom_locked(*z)) {
 			ret = 0;
@@ -413,7 +413,7 @@ int try_set_zone_oom(struct zonelist *zo
 		zone_set_flag(*z, ZONE_OOM_LOCKED);
 	} while (*(++z) != NULL);
 out:
-	mutex_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_mutex);
 	return ret;
 }
 
@@ -428,11 +428,11 @@ void clear_zonelist_oom(struct zonelist 
 
 	z = zonelist->zones;
 
-	mutex_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_mutex);
 	do {
 		zone_clear_flag(*z, ZONE_OOM_LOCKED);
 	} while (*(++z) != NULL);
-	mutex_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_mutex);
 }
 
 /**
_

Patches currently in -mm which might be from rientjes@google.com are

maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-prototypes-to-appropriate-header-file-fix.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
