From: akpm@linux-foundation.org
Subject: - ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:29:46 -0700
Message-ID: <200710190429.l9J4Tk8b015133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36285 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966444AbXJSEaU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:30:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, Nadia.Derbey@bull.net, mm-commits@vger.kernel.org


The patch titled
     ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
has been removed from the -mm tree.  Its filename was
     ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch

This patch was dropped because it was folded into ipc-integrate-ipc_checkid-into-ipc_lock.patch

------------------------------------------------------
Subject: ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2 ipc/util.c
--- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-2
+++ a/ipc/util.c
@@ -295,7 +295,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
-	rcu_read_lock();
 	spin_lock(&new->lock);
 	return id;
 }
@@ -691,7 +690,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
-
+	rcu_read_unlock();
 	return out;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
