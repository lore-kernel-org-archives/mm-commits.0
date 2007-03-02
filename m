From: akpm@linux-foundation.org
Subject: + acpi-fan-after-suspend-to-mem-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:49:08 -0800
Message-ID: <200703020249.l222n8ob030437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36530 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422716AbXCBCu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:50:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tommi.kyntola@ray.fi, lenb@kernel.org


The patch titled
     acpi: fan after suspend-to-mem fix
has been added to the -mm tree.  Its filename is
     acpi-fan-after-suspend-to-mem-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: fan after suspend-to-mem fix
From: Tommi Kyntola <tommi.kyntola@ray.fi>

acpi_fan_suspend should probably set state to ACPI_D3, rather than ACPI_D0.
 With this change the fan works after S3 suspend atleast on HP nw8000
laptop, for which the suspended fan has been broken since sword-and-stone.

Why this was ACPI_D0 beats me, but it's been that way since the
_suspend/_resume functios got added in the commit
0feabb01d93e5801d1127416a66cfc3963280bca (2.6.18-rc1, I think).

The fan hasn't worked on my HP nw8000 laptop after an S3 suspend ever, but
fixing that to ACPI_D3 there finally makes it work as expected.

If there was some hidden reason why that was set to ACPI_D0, then perhaps a
config option for some ICH4 or HP laptops is called for.

Signed-off-by: Tommi Kyntola <tommi.kyntola@ray.fi>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/fan.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/fan.c~acpi-fan-after-suspend-to-mem-fix drivers/acpi/fan.c
--- a/drivers/acpi/fan.c~acpi-fan-after-suspend-to-mem-fix
+++ a/drivers/acpi/fan.c
@@ -241,7 +241,7 @@ static int acpi_fan_suspend(struct acpi_
 	if (!device)
 		return -EINVAL;
 
-	acpi_bus_set_power(device->handle, ACPI_STATE_D0);
+	acpi_bus_set_power(device->handle, ACPI_STATE_D3);
 
 	return AE_OK;
 }
_

Patches currently in -mm which might be from tommi.kyntola@ray.fi are

acpi-fan-after-suspend-to-mem-fix.patch
