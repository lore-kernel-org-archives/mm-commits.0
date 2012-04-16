From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-efic-fix-section-mismatch-warning.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:26 -0700
Message-ID: <20120416201526.6095DA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:62613 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2DPUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:28 -0400
Received: by bkcjm19 with SMTP id jm19so257591bkc.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Apr 2012 13:15:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@suse.com, a.zummo@towertech.it, jbeulich@suse.com, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-efi.c: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-efic-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

Patches currently in -mm which might be from JBeulich@suse.com are


