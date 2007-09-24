From: akpm@linux-foundation.org
Subject: + git-block-dasd_eckd-fix.patch added to -mm tree
Date: Mon, 24 Sep 2007 09:40:15 -0700
Message-ID: <200709241640.l8OGeFXQ006972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762792AbXIXQkU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 12:40:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com


The patch titled
     git-block: dasd_eckd fix
has been added to the -mm tree.  Its filename is
     git-block-dasd_eckd-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-block: dasd_eckd fix
From: Cedric Le Goater <clg@fr.ibm.com>

/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c: In function `dasd_eckd_build_cp':
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1181: error: syntax error before "struct"
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: `iter' undeclared (first use in this function)
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: (Each undeclared identifier is reported only once
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: for each function it appears in.)
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: error: `bv' undeclared (first use in this function)
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: left-hand operand of comma expression has no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: statement with no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1209: warning: statement with no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: statement with no effect
/home/clg/linux/2.6.23-rc7-mm1/drivers/s390/block/dasd_eckd.c:1257: warning: statement with no effect
make[3]: *** [drivers/s390/block/dasd_eckd.o] Error 1
make[2]: *** [drivers/s390/block] Error 2

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/block/dasd_eckd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/s390/block/dasd_eckd.c~git-block-dasd_eckd-fix drivers/s390/block/dasd_eckd.c
--- a/drivers/s390/block/dasd_eckd.c~git-block-dasd_eckd-fix
+++ a/drivers/s390/block/dasd_eckd.c
@@ -1176,7 +1176,7 @@ dasd_eckd_build_cp(struct dasd_device * 
 	struct LO_eckd_data *LO_data;
 	struct dasd_ccw_req *cqr;
 	struct ccw1 *ccw;
-	struct req_iterator iter
+	struct req_iterator iter;
 	struct bio_vec *bv;
 	char *dst;
 	unsigned int blksize, blk_per_trk, off;
_

Patches currently in -mm which might be from clg@fr.ibm.com are

git-block-dasd_eckd-fix.patch
oom-move-prototypes-to-appropriate-header-file-fix.patch
handle-the-multi-threaded-inits-exit-properly.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
