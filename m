From: akpm@linux-foundation.org
Subject: - module-return-error-when-mod_sysfs_init-failed.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:53 -0700
Message-ID: <200710180701.l9I71rAk031212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761276AbXJRH07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     module: return error when mod_sysfs_init() failed
has been removed from the -mm tree.  Its filename was
     module-return-error-when-mod_sysfs_init-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~module-return-error-when-mod_sysfs_init-failed kernel/module.c
--- a/kernel/module.c~module-return-error-when-mod_sysfs_init-failed
+++ a/kernel/module.c
@@ -1881,7 +1881,8 @@ static struct module *load_module(void _
 	module_unload_init(mod);
 
 	/* Initialize kobject, so we can reference it. */
-	if (mod_sysfs_init(mod) != 0)
+	err = mod_sysfs_init(mod);
+	if (err)
 		goto cleanup;
 
 	/* Set up license info based on the info section */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-x86.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
