From: akpm@linux-foundation.org
Subject: + lib-devresc-fix-misplaced-endif.patch added to -mm tree
Date: Mon, 25 Feb 2013 14:34:49 -0800
Message-ID: <20130225223450.3B1635A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:33532 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933Ab3BYWe4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 17:34:56 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so362089vch.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 14:34:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, greg@kroah.com, tj@kernel.org


The patch titled
     Subject: lib/devres.c: fix misplaced #endif
has been added to the -mm tree.  Its filename is
     lib-devresc-fix-misplaced-endif.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
backlight-ams369fg06-make-power_on-call-optional.patch
lib-devresc-fix-misplaced-endif.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
backlight-platform_lcd-remove-unnecessary-ifdefs.patch
rtc-rtc-v3020-use-gpio_request_array.patch
rtc-add-devm_rtc_device_registerunregister.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

