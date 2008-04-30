From: akpm@linux-foundation.org
Subject: - acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:50:44 -0700
Message-ID: <200804300550.m3U5oiF3030149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52926 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759200AbYD3FvF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, lenb@kernel.org, yakui.zhao@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: check a return value correctly in acpi_power_get_context()
has been removed from the -mm tree.  Its filename was
     acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: check a return value correctly in acpi_power_get_context()
From: Li Zefan <lizf@cn.fujitsu.com>

We should check *resource != NULL rather than resource != NULL, which will be
always true.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Zhao Yakui <yakui.zhao@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/power.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/power.c~acpi-check-a-return-value-correctly-in-acpi_power_get_context drivers/acpi/power.c
--- a/drivers/acpi/power.c~acpi-check-a-return-value-correctly-in-acpi_power_get_context
+++ a/drivers/acpi/power.c
@@ -121,7 +121,7 @@ acpi_power_get_context(acpi_handle handl
 	}
 
 	*resource = acpi_driver_data(device);
-	if (!resource)
+	if (!*resource)
 		return -ENODEV;
 
 	return 0;
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
git-acpi.patch

