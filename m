From: akpm@linux-foundation.org
Subject: + lib-devresc-fix-misplaced-endif.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:45:12 -0800
Message-ID: <20130222214512.972015A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f202.google.com ([209.85.128.202]:47921 "EHLO
	mail-ve0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab3BVVpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:45:14 -0500
Received: by mail-ve0-f202.google.com with SMTP id m1so110070ves.1
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:45:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, greg@kroah.com


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

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Greg KH <greg@kroah.com>
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
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

