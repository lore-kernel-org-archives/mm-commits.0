From: akpm@linux-foundation.org
Subject: - mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:51:29 -0700
Message-ID: <200704281051.l3SApTba019984@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965645AbXD1Kvm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:51:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     mod_sysfs_setup() doesn't return errno when kobject_add_dir() failure occurs
has been removed from the -mm tree.  Its filename was
     mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mod_sysfs_setup() doesn't return errno when kobject_add_dir() failure occurs
From: Akinobu Mita <akinobu.mita@gmail.com>

mod_sysfs_setup() doesn't return an errno when kobject_add_dir() for module
"holders" directory fails.  So caller of mod_sysfs_setup() will keep going
and get oops.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs kernel/module.c
--- a/kernel/module.c~mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs
+++ a/kernel/module.c
@@ -1145,8 +1145,10 @@ int mod_sysfs_setup(struct module *mod,
 		goto out;
 
 	mod->holders_dir = kobject_add_dir(&mod->mkobj.kobj, "holders");
-	if (!mod->holders_dir)
+	if (!mod->holders_dir) {
+		err = -ENOMEM;
 		goto out_unreg;
+	}
 
 	err = module_param_sysfs_setup(mod, kparam, num_params);
 	if (err)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
git-alsa.patch
git-dvb.patch
git-ieee1394.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
