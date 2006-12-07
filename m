From: akpm@osdl.org
Subject: - export-toshiba-smm-support-for-neofb-module.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:38 -0800
Message-ID: <200612072306.kB7N6cqw030281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163810AbWLGXHC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:07:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     export toshiba SMM support for neofb module
has been removed from the -mm tree.  Its filename was
     export-toshiba-smm-support-for-neofb-module.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: export toshiba SMM support for neofb module
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_TOSHIBA=y and CONFIG_FB_NEOMAGIC=m, tosh_smm() needs
to be exported for neofb to use it.

WARNING: "tosh_smm" [drivers/video/neofb.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/toshiba.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/toshiba.c~export-toshiba-smm-support-for-neofb-module drivers/char/toshiba.c
--- a/drivers/char/toshiba.c~export-toshiba-smm-support-for-neofb-module
+++ a/drivers/char/toshiba.c
@@ -249,6 +249,7 @@ int tosh_smm(SMMRegisters *regs)
 
 	return eax;
 }
+EXPORT_SYMBOL(tosh_smm);
 
 
 static int tosh_ioctl(struct inode *ip, struct file *fp, unsigned int cmd,
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

