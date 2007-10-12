From: akpm@linux-foundation.org
Subject: + tmp-fix.patch added to -mm tree
Date: Fri, 12 Oct 2007 00:14:31 -0700
Message-ID: <200710120714.l9C7EVn3005028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33501 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760145AbXJLHOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Oct 2007 03:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, akpm@linux-foundation.org, sam@ravnborg.org


The patch titled
     Subject: Re: 2.6.23-mm1
has been added to the -mm tree.  Its filename is
     tmp-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Subject: Re: 2.6.23-mm1
From: Cedric Le Goater <clg@fr.ibm.com>

KAMEZAWA Hiroyuki wrote:
> On Thu, 11 Oct 2007 21:31:26 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
>>
>> - I've been largely avoiding applying anything since rc8-mm2 in an attempt
>>   to stabilise things for the 2.6.23 merge.
>>
> On RHEL5/x86_64 environment,
>
> ==
> [kamezawa@hannibal ref-2.6.23-mm1]$ make menuconfig
> Makefile:456: /home/kamezawa/ref-2.6.23-mm1/arch//Makefile: No such file or directory
> make: *** No rule to make target `/home/kamezawa/ref-2.6.23-mm1/arch//Makefile'.  Stop.
> ==
>
> $(ARCH) cannot be detected automatically...
>
> What information is useful for fixing this ?

cross compile work but native compile doesn't anymore :(

Here's a tmp fix.

Thanks,

C.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Makefile~tmp-fix Makefile
--- a/Makefile~tmp-fix
+++ a/Makefile
@@ -191,7 +191,7 @@ SUBARCH := $(shell uname -m | sed -e s/i
 
 # The empty ARCH and CROSS_COMPILE statements exist so it is easy to
 # patch in hardcoded values for ARCH and CROSS_COMPILE
-ARCH		?=
+ARCH           ?= $(SUBARCH)
 CROSS_COMPILE	?=
 
 # Kbuild save the ARCH and CROSS_COMPILE setting in .kbuild
_

Patches currently in -mm which might be from clg@fr.ibm.com are

oom-move-prototypes-to-appropriate-header-file-fix.patch
handle-the-multi-threaded-inits-exit-properly.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
remove-unused-member-from-nsproxy.patch
use-kmem_cache-macro-to-create-the-nsproxy-cache.patch
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
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
tmp-fix.patch
