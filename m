From: akpm@linux-foundation.org
Subject: + ati_pcigart-fix-printk-format-warning.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:31:05 -0800
Message-ID: <201002012231.o11MV5OR016587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072Ab0BAWbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:31:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, airlied@linux.ie, zhenyuw@linux.intel.com


The patch titled
     ati_pcigart: fix printk format warning
has been added to the -mm tree.  Its filename is
     ati_pcigart-fix-printk-format-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
kfifo-fix-kernel-doc-notation.patch
ati_pcigart-fix-printk-format-warning.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh-fix.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

