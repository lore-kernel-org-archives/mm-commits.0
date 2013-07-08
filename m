From: akpm@linux-foundation.org
Subject: [merged] mm-change-normal-message-to-use-pr_debug.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:25:50 -0700
Message-ID: <51db123e.CVBuVNcPHMcIQXx+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3GHTZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com

Subject: [merged] mm-change-normal-message-to-use-pr_debug.patch removed from -mm tree
To: toshi.kani@hp.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:50 -0700


The patch titled
     Subject: mm/memory_hotplug.c: change normal message to use pr_debug
has been removed from the -mm tree.  Its filename was
     mm-change-normal-message-to-use-pr_debug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Toshi Kani <toshi.kani@hp.com>
Subject: mm/memory_hotplug.c: change normal message to use pr_debug

During early boot-up, iomem_resource is set up from the boot descriptor
table, such as EFI Memory Table and e820.  Later, acpi_memory_device_add()
calls add_memory() for each ACPI memory device object as it enumerates
ACPI namespace.  This add_memory() call is expected to fail in
register_memory_resource() at boot since iomem_resource has been set up
from EFI/e820.  As a result, add_memory() returns -EEXIST, which
acpi_memory_device_add() handles as the normal case.

This scheme works fine, but the following error message is
logged for every ACPI memory device object during boot-up.

  "System RAM resource %pR cannot be added\n"

This patch changes register_memory_resource() to use pr_debug() for the
message as it shows up under the normal case.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-change-normal-message-to-use-pr_debug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-change-normal-message-to-use-pr_debug
+++ a/mm/memory_hotplug.c
@@ -75,7 +75,7 @@ static struct resource *register_memory_
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	if (request_resource(&iomem_resource, res) < 0) {
-		printk("System RAM resource %pR cannot be added\n", res);
+		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
 		res = NULL;
 	}
_

Patches currently in -mm which might be from toshi.kani@hp.com are

origin.patch
mm-sparsec-put-clear_hwpoisoned_pages-within-config_memory_hotremove.patch

