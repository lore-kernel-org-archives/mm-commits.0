From: akpm@linux-foundation.org
Subject: [merged] lib-devresc-fix-misplaced-endif.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:10:29 -0800
Message-ID: <20130228201029.B138031C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:59949 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab3B1UKb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:10:31 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244488vea.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:10:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, greg@kroah.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/devres.c: fix misplaced #endif
has been removed from the -mm tree.  Its filename was
     lib-devresc-fix-misplaced-endif.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: lib/devres.c: fix misplaced #endif

A misplaced #endif causes link errors related to pcim_*() functions.

This is because pcim_*() functions are related to CONFIG_PCI option,
however these are not related to CONFIG_HAS_IOPORT option.  Therefore,
when CONFIG_PCI is enabled and CONFIG_HAS_IOPORT is not enabled, it makes
link errors related to pcim_*() functions as below:

drivers/ata/libata-sff.c:3233: undefined reference to `pcim_iomap_regions'
drivers/ata/libata-sff.c:3238: undefined reference to `pcim_iomap_table'
drivers/built-in.o: In function `ata_pci_sff_init_host':
drivers/ata/libata-sff.c:2318: undefined reference to `pcim_iomap_regions'
drivers/ata/libata-sff.c:2329: undefined reference to `pcim_iomap_table

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Greg KH <greg@kroah.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/devres.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/devres.c~lib-devresc-fix-misplaced-endif lib/devres.c
--- a/lib/devres.c~lib-devresc-fix-misplaced-endif
+++ a/lib/devres.c
@@ -227,6 +227,7 @@ void devm_ioport_unmap(struct device *de
 			       devm_ioport_map_match, (void *)addr));
 }
 EXPORT_SYMBOL(devm_ioport_unmap);
+#endif /* CONFIG_HAS_IOPORT */
 
 #ifdef CONFIG_PCI
 /*
@@ -432,4 +433,3 @@ void pcim_iounmap_regions(struct pci_dev
 }
 EXPORT_SYMBOL(pcim_iounmap_regions);
 #endif /* CONFIG_PCI */
-#endif /* CONFIG_HAS_IOPORT */
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops-fix.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

