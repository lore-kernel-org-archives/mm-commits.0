From: akpm@linux-foundation.org
Subject: + pid-namespaces-allow-signalling-container-init.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:22 -0700
Message-ID: <200708142005.l7EK5M1q018705@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42661 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbXHNUGk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:06:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, xemul@openvz.org


The patch titled
     pid namespaces: allow signalling container-init
has been added to the -mm tree.  Its filename is
     pid-namespaces-allow-signalling-container-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: allow signalling container-init
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Only the global-init process must be special - any other container-init
process must be killable to prevent run-away processes in the system.

TODO: 	Ideally we should allow killing the container-init only from parent
	container and prevent it being killed from within the container.
	But that is a more complex change and will be addressed by a follow-on
	patch. For now allow the container-init to be terminated by any process
	with sufficient privileges.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/signal.c~pid-namespaces-allow-signalling-container-init kernel/signal.c
--- a/kernel/signal.c~pid-namespaces-allow-signalling-container-init
+++ a/kernel/signal.c
@@ -1841,11 +1841,9 @@ relock:
 			continue;
 
 		/*
-		 * Init of a pid space gets no signals it doesn't want from
-		 * within that pid space. It can of course get signals from
-		 * its parent pid space.
+		 * Global init gets no signals it doesn't want.
 		 */
-		if (current == task_child_reaper(current))
+		if (is_global_init(current))
 			continue;
 
 		if (sig_kernel_stop(signr)) {
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
