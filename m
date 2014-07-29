From: akpm@linux-foundation.org
Subject: + rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch
 added to -mm tree
Date: Tue, 29 Jul 2014 15:13:40 -0700
Message-ID: <53d81c94.njpWCmJJgqBxxGw0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:49685 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaG2WNl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jul 2014 18:13:41 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so51870yha.2
        for <mm-commits@vger.kernel.org>; Tue, 29 Jul 2014 15:13:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, a.zummo@towertech.it, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2
has been added to the -mm tree.  Its filename is
     rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Salter <msalter@redhat.com>
Subject: rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2

This is v2 of the patch to fix a boot problem with kernels building in
rtc-efi but not being booted via EFI. In that case, runtime services are
not available so there is no point in registering the platform device.

Signed-off-by: Mark Salter <msalter@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-efi-platform.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-efi-platform.c~rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2 drivers/rtc/rtc-efi-platform.c
--- a/drivers/rtc/rtc-efi-platform.c~rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2
+++ a/drivers/rtc/rtc-efi-platform.c
@@ -21,8 +21,9 @@ static struct platform_device rtc_efi_de
 
 static int __init rtc_init(void)
 {
-	if (platform_device_register(&rtc_efi_dev) < 0)
-		pr_err("unable to register rtc device...\n");
+	if (efi_enabled(EFI_RUNTIME_SERVICES))
+		if (platform_device_register(&rtc_efi_dev) < 0)
+			pr_err("unable to register rtc device...\n");
 
 	/* not necessarily an error */
 	return 0;
_

Patches currently in -mm which might be from msalter@redhat.com are

rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch
rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch
linux-next.patch

