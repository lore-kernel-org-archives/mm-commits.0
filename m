From: akpm@linux-foundation.org
Subject: - fix-unnecesary-meminit.patch removed from -mm tree
Date: Wed, 09 May 2007 01:42:32 -0700
Message-ID: <200705090842.l498gWXq018214@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754711AbXEIImh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix unnecesary meminit
has been removed from the -mm tree.  Its filename was
     fix-unnecesary-meminit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
move-free-pages-between-lists-on-steal.patch
create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch
handle-kernelcore=-generic.patch
