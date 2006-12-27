From: akpm@osdl.org
Subject: + module-fix-mod_sysfs_setup-return-value.patch added to -mm tree
Date: Wed, 27 Dec 2006 00:06:48 -0800
Message-ID: <200612270806.kBR86mqa005164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38558 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932974AbWL0IGv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 03:06:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, greg@kroah.com


The patch titled
     module: fix mod_sysfs_setup() return value
has been added to the -mm tree.  Its filename is
     module-fix-mod_sysfs_setup-return-value.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: module: fix mod_sysfs_setup() return value
From: Akinobu Mita <akinobu.mita@gmail.com>

mod_sysfs_setup() doesn't return error when kobject_add_dir() failed.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/module.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN kernel/module.c~module-fix-mod_sysfs_setup-return-value kernel/module.c
--- a/kernel/module.c~module-fix-mod_sysfs_setup-return-value
+++ a/kernel/module.c
@@ -1132,8 +1132,10 @@ static int mod_sysfs_setup(struct module
 		goto out;
 
 	mod->drivers_dir = kobject_add_dir(&mod->mkobj.kobj, "drivers");
-	if (!mod->drivers_dir)
+	if (!mod->drivers_dir) {
+		err = -ENOMEM;
 		goto out_unreg;
+	}
 
 	err = module_param_sysfs_setup(mod, kparam, num_params);
 	if (err)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

module-fix-mod_sysfs_setup-return-value.patch
powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
ehca-avoid-crash-on-kthread_create-failure.patch
return-error-on-create_comp_task-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

