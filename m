From: akpm@linux-foundation.org
Subject: + mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:35:53 -0700
Message-ID: <200704210035.l3L0ZrAN027481@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745AbXDUAf7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:35:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, greg@kroah.com


The patch titled
     mod_sysfs_setup() doesn't return errno when kobject_add_dir() failure occurs
has been added to the -mm tree.  Its filename is
     mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs kernel/module.c
--- a/kernel/module.c~mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs
+++ a/kernel/module.c
@@ -1222,8 +1222,10 @@ int mod_sysfs_setup(struct module *mod,
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

mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
git-dvb.patch
git-net.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
slob-handle-slab_panic-flag.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
use-slab_panic-flag-cleanup.patch
