From: akpm@linux-foundation.org
Subject: + git-net-sctp-build-fix.patch added to -mm tree
Date: Mon, 24 Sep 2007 09:43:02 -0700
Message-ID: <200709241643.l8OGh2QM007162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34944 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763159AbXIXQnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Sep 2007 12:43:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, davem@davemloft.net


The patch titled
     git-net: sctp build fix
has been added to the -mm tree.  Its filename is
     git-net-sctp-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-net: sctp build fix
From: Cedric Le Goater <clg@fr.ibm.com>

Cedric Le Goater wrote:
> Andrew Morton wrote:
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
>
> I also get this compile error on s390. 'linux/scatterlist.h' has disappeared
> from the #include pile but where ?
>
> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c: In function `sctp_auth_calculate_hmac':
> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: error: storage size of 'sg' isn't known
> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: warning: unused variable `sg'

The following patch works of course but it seems to simplistic for s390.

Cheers,

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sctp/auth.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN net/sctp/auth.c~git-net-sctp-build-fix net/sctp/auth.c
--- a/net/sctp/auth.c~git-net-sctp-build-fix
+++ a/net/sctp/auth.c
@@ -36,6 +36,7 @@
 
 #include <linux/types.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <net/sctp/sctp.h>
 #include <net/sctp/auth.h>
 
_

Patches currently in -mm which might be from clg@fr.ibm.com are

git-net-sctp-build-fix.patch
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
