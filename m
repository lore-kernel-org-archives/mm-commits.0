From: akpm@osdl.org
Subject: - tifm-fix-null-ptr-and-style.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:43 -0800
Message-ID: <200612072302.kB7N2ht5029886@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51920 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163728AbWLGXDh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     tifm: fix NULL ptr and style
has been removed from the -mm tree.  Its filename was
     tifm-fix-null-ptr-and-style.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tifm: fix NULL ptr and style
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix sparse NULL warning;
drivers/misc/tifm_core.c:223:17: warning: Using plain integer as NULL pointer

Fix style while there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/misc/tifm_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/misc/tifm_core.c~tifm-fix-null-ptr-and-style drivers/misc/tifm_core.c
--- a/drivers/misc/tifm_core.c~tifm-fix-null-ptr-and-style
+++ a/drivers/misc/tifm_core.c
@@ -219,8 +219,9 @@ static int tifm_device_remove(struct dev
 	struct tifm_driver *drv = fm_dev->drv;
 
 	if (drv) {
-		if (drv->remove) drv->remove(fm_dev);
-		fm_dev->drv = 0;
+		if (drv->remove)
+			drv->remove(fm_dev);
+		fm_dev->drv = NULL;
 	}
 
 	put_device(dev);
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

