From: akpm@linux-foundation.org
Subject: + mm-change-normal-message-to-use-pr_debug.patch added to -mm
 tree
Date: Tue, 28 May 2013 15:31:39 -0700
Message-ID: <51a5304b.9Es1UFLPYl4iWITi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959Ab3E1Wbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 18:31:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com

Subject: + mm-change-normal-message-to-use-pr_debug.patch added to -mm tree
To: toshi.kani@hp.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 15:31:39 -0700


The patch titled
     Subject: mm/memory_hotplug.c: change normal message to use pr_debug
has been added to the -mm tree.  Its filename is
     mm-change-normal-message-to-use-pr_debug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
mm-change-normal-message-to-use-pr_debug.patch

