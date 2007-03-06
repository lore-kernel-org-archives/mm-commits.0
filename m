From: akpm@linux-foundation.org
Subject: - x86_64-map-fake-nodes-to-real-nodes-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:53:07 -0800
Message-ID: <200703061053.l26Ar7WU020326@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964893AbXCFKxa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:53:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: fake numa cmdline flag fix
has been removed from the -mm tree.  Its filename was
     x86_64-map-fake-nodes-to-real-nodes-fix.patch

This patch was dropped because it was folded into x86_64-map-fake-nodes-to-real-nodes.patch

------------------------------------------------------
Subject: x86_64: fake numa cmdline flag fix
From: David Rientjes <rientjes@google.com>

Make sure we only reference 'cmdline' on CONFIG_NUMA_EMU.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/numa.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff -puN arch/x86_64/mm/numa.c~x86_64-map-fake-nodes-to-real-nodes-fix arch/x86_64/mm/numa.c
--- a/arch/x86_64/mm/numa.c~x86_64-map-fake-nodes-to-real-nodes-fix
+++ a/arch/x86_64/mm/numa.c
@@ -519,22 +519,28 @@ void __init numa_initmem_init(unsigned l
 { 
 	unsigned long start_addr = start_pfn << PAGE_SHIFT;
 	unsigned long end_addr = end_pfn << PAGE_SHIFT;
+	int numa_fake = 0;
 	int i;
 
+#ifdef CONFIG_NUMA_EMU
+	/* Determine if we have a numa=fake command line */
+	if (cmdline != 0)
+		numa_fake = 1;
+#endif
+
 #ifdef CONFIG_ACPI_NUMA
-	if (!numa_off && !cmdline && !acpi_scan_nodes(start_addr, end_addr))
+	if (!numa_off && !numa_fake && !acpi_scan_nodes(start_addr, end_addr))
  		return;
 #endif
 
 #ifdef CONFIG_K8_NUMA
-	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, cmdline != 0))
-		if (cmdline == 0)
+	if (!numa_off && !k8_scan_nodes(start_addr, end_addr, numa_fake))
+		if (!numa_fake)
 			return;
 #endif
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline)
-	{
+	if (numa_fake) {
 		numa_emu = !numa_emulation(start_pfn, end_pfn);
 		if (numa_emu)
 			return;
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86_64-configurable-fake-numa-node-sizes.patch
x86_64-split-remaining-fake-nodes-equally.patch
x86_64-fixed-size-remaining-fake-nodes.patch
x86_64-map-fake-nodes-to-real-nodes.patch
x86_64-map-fake-nodes-to-real-nodes-fix.patch
x86_64-disable-alien-cache-for-fake-numa.patch
x86_64-export-physnode-mapping-to-userspace.patch
x86_64-fake-numa-for-cpusets-document.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-docs.patch
