From: akpm@linux-foundation.org
Subject: + fix-unnecesary-meminit.patch added to -mm tree
Date: Tue, 08 May 2007 11:16:26 -0700
Message-ID: <200705081816.l48IGQFT030256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966741AbXEHSQd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 14:16:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com


The patch titled
     Fix unnecesary meminit
has been added to the -mm tree.  Its filename is
     fix-unnecesary-meminit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix unnecesary meminit
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This is to fix unnecessary __meminit definition.  These are exported for
kernel modules.

I compiled on ia64/x86-64 with memory hotplug on/off.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/numa.c~fix-unnecesary-meminit drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~fix-unnecesary-meminit
+++ a/drivers/acpi/numa.c
@@ -228,7 +228,7 @@ int __init acpi_numa_init(void)
 	return 0;
 }
 
-int __meminit acpi_get_pxm(acpi_handle h)
+int acpi_get_pxm(acpi_handle h)
 {
 	unsigned long pxm;
 	acpi_status status;
@@ -246,7 +246,7 @@ int __meminit acpi_get_pxm(acpi_handle h
 }
 EXPORT_SYMBOL(acpi_get_pxm);
 
-int __meminit acpi_get_node(acpi_handle *handle)
+int acpi_get_node(acpi_handle *handle)
 {
 	int pxm, node = -1;
 
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
fix-section-mismatch-of-memory-hotplug-related-code.patch
add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
fix-unnecesary-meminit.patch
move-free-pages-between-lists-on-steal.patch
create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch
handle-kernelcore=-generic.patch
