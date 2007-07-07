From: akpm@linux-foundation.org
Subject: - immediate-values-global-modules-list-and-module-mutex.patch removed from -mm tree
Date: Fri, 06 Jul 2007 17:28:33 -0700
Message-ID: <200707070032.l670Wj2x029795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbXGGAc6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 20:32:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     Immediate values: global modules list and module mutex
has been removed from the -mm tree.  Its filename was
     immediate-values-global-modules-list-and-module-mutex.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: Immediate values: global modules list and module mutex
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Remove "static" from module_mutex and the modules list so it can be used by
other builtin objects in the kernel.  Otherwise, every code depending on the
module list would have to be put in kernel/module.c.  Since the immediate
values depends on the module list but can be considered as logically
different, it makes sense to implement them in their own file.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/module.c~immediate-values-global-modules-list-and-module-mutex kernel/module.c
--- a/kernel/module.c~immediate-values-global-modules-list-and-module-mutex
+++ a/kernel/module.c
@@ -63,8 +63,8 @@ extern int module_sysfs_initialized;
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (add/delete uses stop_machine). */
-static DEFINE_MUTEX(module_mutex);
-static LIST_HEAD(modules);
+DEFINE_MUTEX(module_mutex);
+LIST_HEAD(modules);
 static DECLARE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-promc-remove-undef-printk.patch
immediate-values-global-modules-list-and-module-mutex.patch
immediate-value-architecture-independent-code.patch
immediate-values-non-optimized-architectures.patch
immediate-value-add-kconfig-menus.patch
immediate-values-kprobe-header-fix.patch
immediate-value-i386-optimization.patch
immediate-value-powerpc-optimization.patch
immediate-value-documentation.patch
f00f-bug-fixup-for-i386-use-immediate-values.patch
scheduler-profiling-use-immediate-values.patch
scheduler-profiling-use-immediate-values-fix.patch
cxgb3-vs-immediate-stuff.patch
use-data_data-in-cris.patch
add-missing-data_data-in-powerpc.patch
use-data_data-in-xtensa.patch
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-add-kconfig-menus-for-the-marker-code.patch
linux-kernel-markers-documentation.patch
port-of-blktrace-to-the-linux-kernel-markers.patch
port-of-blktrace-to-the-linux-kernel-markers-fix.patch
