From: akpm@linux-foundation.org
Subject: + memory-hotplug-keep-the-request_resource-error-code.patch added to -mm tree
Date: Mon, 04 Jan 2016 13:46:09 -0800
Message-ID: <568ae821.DW6oGtYppWVE1Z3h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbcADVqK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 16:46:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vkuznets@redhat.com, akpm@linux-foundation.org, dan.j.williams@intel.com, david.vrabel@citrix.com, imammedo@redhat.com, lenb@kernel.org, n-horiguchi@ah.jp.nec.com, rientjes@google.com, rjw@rjwysocki.net, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: keep the request_resource() error code
has been added to the -mm tree.  Its filename is
     memory-hotplug-keep-the-request_resource-error-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-keep-the-request_resource-error-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memory-hotplug-keep-the-request_resource-error-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: memory-hotplug: keep the request_resource() error code

Don't overwrite the request_resource() return value with -EEXIST in
register_memory_resource(), just propagate the return value.  As we return
-EBUSY instead of -EEXIST when the desired resource is already occupied
now we need to adapt acpi_memory_enable_device().  -EBUSY is currently the
only possible error returned by request_resource() so this is just a
cleanup, no functional changes intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |    4 ++--
 mm/memory_hotplug.c            |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~memory-hotplug-keep-the-request_resource-error-code drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~memory-hotplug-keep-the-request_resource-error-code
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -232,10 +232,10 @@ static int acpi_memory_enable_device(str
 
 		/*
 		 * If the memory block has been used by the kernel, add_memory()
-		 * returns -EEXIST. If add_memory() returns the other error, it
+		 * returns -EBUSY. If add_memory() returns the other error, it
 		 * means that this memory block is not used by the kernel.
 		 */
-		if (result && result != -EEXIST)
+		if (result && result != -EBUSY)
 			continue;
 
 		result = acpi_bind_memory_blocks(info, mem_device->device);
diff -puN mm/memory_hotplug.c~memory-hotplug-keep-the-request_resource-error-code mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-keep-the-request_resource-error-code
+++ a/mm/memory_hotplug.c
@@ -130,6 +130,7 @@ void mem_hotplug_done(void)
 static struct resource *register_memory_resource(u64 start, u64 size)
 {
 	struct resource *res;
+	int ret;
 	res = kzalloc(sizeof(struct resource), GFP_KERNEL);
 	if (!res)
 		return ERR_PTR(-ENOMEM);
@@ -138,10 +139,11 @@ static struct resource *register_memory_
 	res->start = start;
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-	if (request_resource(&iomem_resource, res) < 0) {
+	ret = request_resource(&iomem_resource, res);
+	if (ret < 0) {
 		pr_debug("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
-		return ERR_PTR(-EEXIST);
+		return ERR_PTR(ret);
 	}
 	return res;
 }
_

Patches currently in -mm which might be from vkuznets@redhat.com are

memory-hotplug-dont-bug-in-register_memory_resource.patch
memory-hotplug-dont-bug-in-register_memory_resource-v2.patch
memory-hotplug-keep-the-request_resource-error-code.patch

