From: akpm@linux-foundation.org
Subject: + module-return-error-when-mod_sysfs_init-failed.patch added to -mm tree
Date: Thu, 04 Oct 2007 12:14:31 -0700
Message-ID: <200710041914.l94JEVvu024568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47687 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756307AbXJDTOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 15:14:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de, rusty@rustcorp.com.au


The patch titled
     module: return error when mod_sysfs_init() failed
has been added to the -mm tree.  Its filename is
     module-return-error-when-mod_sysfs_init-failed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: module: return error when mod_sysfs_init() failed
From: Akinobu Mita <akinobu.mita@gmail.com>

load_module() returns zero when mod_sysfs_init() fails, then the module
loading will succeed accidentally.

This patch makes load_module() return error correctly in that case.

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/module.c~module-return-error-when-mod_sysfs_init-failed kernel/module.c
--- a/kernel/module.c~module-return-error-when-mod_sysfs_init-failed
+++ a/kernel/module.c
@@ -1782,7 +1782,8 @@ static struct module *load_module(void _
 	module_unload_init(mod);
 
 	/* Initialize kobject, so we can reference it. */
-	if (mod_sysfs_init(mod) != 0)
+	err = mod_sysfs_init(mod);
+	if (err)
 		goto cleanup;
 
 	/* Set up license info based on the info section */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

module-return-error-when-mod_sysfs_init-failed.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
