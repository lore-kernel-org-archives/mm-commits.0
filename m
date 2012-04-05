From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-efic-fix-section-mismatch-warning.patch added to -mm tree
Date: Thu, 05 Apr 2012 16:39:23 -0700
Message-ID: <20120405233923.5E362A04F2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:40907 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab2DEXjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Apr 2012 19:39:25 -0400
Received: by wibhj13 with SMTP id hj13so5280wib.1
        for <mm-commits@vger.kernel.org>; Thu, 05 Apr 2012 16:39:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@suse.com, a.zummo@towertech.it, jbeulich@suse.com, mjg@redhat.com


The patch titled
     Subject: drivers/rtc/rtc-efi.c: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-efic-fix-section-mismatch-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Jan Beulich" <JBeulich@suse.com>
Subject: drivers/rtc/rtc-efi.c: fix section mismatch warning

efi_rtc_init() uses platform_driver_probe(), so there's no need to also
set efi_rtc_driver's probe member (as it won't be used anyway).  This
fixes a modpost section mismatch warning (as efi_rtc_probe() validly is
__init).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/rtc/rtc-efi.c~drivers-rtc-rtc-efic-fix-section-mismatch-warning drivers/rtc/rtc-efi.c
--- a/drivers/rtc/rtc-efi.c~drivers-rtc-rtc-efic-fix-section-mismatch-warning
+++ a/drivers/rtc/rtc-efi.c
@@ -213,7 +213,6 @@ static struct platform_driver efi_rtc_dr
 		.name = "rtc-efi",
 		.owner = THIS_MODULE,
 	},
-	.probe = efi_rtc_probe,
 	.remove = __exit_p(efi_rtc_remove),
 };
 
_
Subject: Subject: drivers/rtc/rtc-efi.c: fix section mismatch warning

Patches currently in -mm which might be from JBeulich@suse.com are

linux-next.patch
drivers-rtc-rtc-efic-fix-section-mismatch-warning.patch

