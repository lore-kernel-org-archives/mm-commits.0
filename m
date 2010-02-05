From: akpm@linux-foundation.org
Subject: [merged] ati_pcigart-fix-printk-format-warning.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:24 -0800
Message-ID: <201002051958.o15JwODO017868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52784 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933832Ab0BET6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, airlied@linux.ie, zhenyuw@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     ati_pcigart: fix printk format warning
has been removed from the -mm tree.  Its filename was
     ati_pcigart-fix-printk-format-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ati_pcigart: fix printk format warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ati_pcigart printk format warning:

drivers/gpu/drm/ati_pcigart.c:115: warning: format '%Lx' expects type 'long long unsigned int', but argument 3 has type 'dma_addr_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/ati_pcigart.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/ati_pcigart.c~ati_pcigart-fix-printk-format-warning drivers/gpu/drm/ati_pcigart.c
--- a/drivers/gpu/drm/ati_pcigart.c~ati_pcigart-fix-printk-format-warning
+++ a/drivers/gpu/drm/ati_pcigart.c
@@ -113,7 +113,7 @@ int drm_ati_pcigart_init(struct drm_devi
 
 		if (pci_set_dma_mask(dev->pdev, gart_info->table_mask)) {
 			DRM_ERROR("fail to set dma mask to 0x%Lx\n",
-				  gart_info->table_mask);
+				  (unsigned long long)gart_info->table_mask);
 			ret = 1;
 			goto done;
 		}
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
msi-laptop-depends-on-rfkill.patch
libertas-if_spi-needs-linux-semaphoreh.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

