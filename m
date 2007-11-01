From: akpm@linux-foundation.org
Subject: + x86-fix-uml-init-do_mountsh-build-failure.patch added to -mm tree
Date: Thu, 01 Nov 2007 13:34:23 -0700
Message-ID: <200711012034.lA1KYNEf014286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbXKAUfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Nov 2007 16:35:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, jdike@addtoit.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix UML init/do_mounts.h build failure
has been added to the -mm tree.  Its filename is
     x86-fix-uml-init-do_mountsh-build-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: fix UML init/do_mounts.h build failure
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Fix stat.h to not use __i386__, but use BITS_PER_LONG.  The UML
architecture in turn includes this file.  This helps resolve one build
failure in the current UML code

Before the fix, the failure was

In file included from init/do_mounts.c:19:
init/do_mounts.h: In function 'bstat':
init/do_mounts.h:25: error: storage size of 'stat' isn't known
init/do_mounts.h:25: warning: unused variable 'stat'
init/do_mounts.h:33: warning: control reaches end of non-void function
make[1]: *** [init/do_mounts.o] Error 1
make: *** [init/do_mounts.o] Error 2

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/stat.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/stat.h~x86-fix-uml-init-do_mountsh-build-failure include/asm-x86/stat.h
--- a/include/asm-x86/stat.h~x86-fix-uml-init-do_mountsh-build-failure
+++ a/include/asm-x86/stat.h
@@ -1,9 +1,11 @@
 #ifndef _ASM_X86_STAT_H
 #define _ASM_X86_STAT_H
 
+#include <asm/types.h>
+
 #define STAT_HAVE_NSEC 1
 
-#ifdef __i386__
+#if BITS_PER_LONG == 32
 struct stat {
 	unsigned long  st_dev;
 	unsigned long  st_ino;
@@ -63,7 +65,7 @@ struct stat64 {
 	unsigned long long	st_ino;
 };
 
-#else /* __i386__ */
+#else /* BITS_PER_LONG == 32 */
 
 struct stat {
 	unsigned long	st_dev;
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

origin.patch
swap-delay-accounting-include-lock_page-delays.patch
x86-fix-uml-init-do_mountsh-build-failure.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memory-controller-make-charging-gfp-mask-aware-fix.patch
memory-controller-bug_on.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force-empty-at-rmdir.patch
