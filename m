From: akpm@osdl.org
Subject: - i2o-fix-i2o_config-without-adaptec-extension.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:08 -0800
Message-ID: <200612072306.kB7N68Ds030219@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52666 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163918AbWLGXGl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:06:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, Markus.Lidel@shadowconnect.com, mm-commits@vger.kernel.org


The patch titled
     I2O: fix I2O_CONFIG without Adaptec extension
has been removed from the -mm tree.  Its filename was
     i2o-fix-i2o_config-without-adaptec-extension.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: I2O: fix I2O_CONFIG without Adaptec extension
From: Randy Dunlap <randy.dunlap@oracle.com>

With I2O_CONFIG=y and I2O_EXT_ADAPTEC=n, kernel build gets:

drivers/message/i2o/i2o_config.c:1115: error: 'i2o_cfg_compat_ioctl' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/message/i2o/i2o_config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/i2o_config.c~i2o-fix-i2o_config-without-adaptec-extension drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~i2o-fix-i2o_config-without-adaptec-extension
+++ a/drivers/message/i2o/i2o_config.c
@@ -520,7 +520,6 @@ static int i2o_cfg_evt_get(unsigned long
 	return 0;
 }
 
-#ifdef CONFIG_I2O_EXT_ADAPTEC
 #ifdef CONFIG_COMPAT
 static int i2o_cfg_passthru32(struct file *file, unsigned cmnd,
 			      unsigned long arg)
@@ -763,6 +762,7 @@ static long i2o_cfg_compat_ioctl(struct 
 
 #endif
 
+#ifdef CONFIG_I2O_EXT_ADAPTEC
 static int i2o_cfg_passthru(unsigned long arg)
 {
 	struct i2o_cmd_passthru __user *cmd =
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

