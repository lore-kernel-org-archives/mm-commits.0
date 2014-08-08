From: akpm@linux-foundation.org
Subject: [folded-merged]
 rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch removed from -mm tree
Date: Fri, 08 Aug 2014 13:55:48 -0700
Message-ID: <53e53954./JS/yMu7YwPswttc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:43696 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaHHUzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:55:50 -0400
Received: by mail-vc0-f202.google.com with SMTP id hq11so803177vcb.5
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:55:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: msalter@redhat.com, a.zummo@towertech.it, fenghua.yu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2
has been removed from the -mm tree.  Its filename was
     rtc-ia64-allow-other-architectures-to-use-efi-rtc-v2.patch

This patch was dropped because it was folded into rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch

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

origin.patch
rtc-ia64-allow-other-architectures-to-use-efi-rtc.patch

