From: akpm@linux-foundation.org
Subject: + immediate-values-global-modules-list-and-module-mutex.patch added to -mm tree
Date: Thu, 05 Jul 2007 13:21:50 -0700
Message-ID: <200707052021.l65KLo9S017089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51726 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759597AbXGEUWE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 16:22:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     Immediate values: global modules list and module mutex
has been added to the -mm tree.  Its filename is
     immediate-values-global-modules-list-and-module-mutex.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
i386-text-edit-lock.patch
i386-text-edit-lock-alternative-instructions.patch
i386-text-edit-lock-kprobes.patch
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
