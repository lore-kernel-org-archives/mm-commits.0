From: akpm@linux-foundation.org
Subject: - hibernation-should-work-ok-with-memory-hotplug.patch removed from -mm tree
Date: Mon, 03 Nov 2008 13:46:42 -0800
Message-ID: <200811032146.mA3LkhEd018236@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbYKCVrP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 16:47:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@suse.cz, haveblue@us.ibm.com, matthew.e.tolentino@intel.com, rjw@sisk.pl, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     hibernation should work ok with memory hotplug
has been removed from the -mm tree.  Its filename was
     hibernation-should-work-ok-with-memory-hotplug.patch

This patch was dropped because it is premature

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hibernation should work ok with memory hotplug
From: Pavel Machek <pavel@suse.cz>

hibernation + memory hotplug was disabled in kconfig because we could
not handle hibernation + sparse mem at some point. It seems to work
now, so I guess we can enable it.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Tolentino <matthew.e.tolentino@intel.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN mm/Kconfig~hibernation-should-work-ok-with-memory-hotplug mm/Kconfig
--- a/mm/Kconfig~hibernation-should-work-ok-with-memory-hotplug
+++ a/mm/Kconfig
@@ -128,12 +128,9 @@ config SPARSEMEM_VMEMMAP
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
-	depends on HOTPLUG && !HIBERNATION && ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on HOTPLUG && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC64 || SUPERH || S390)
 
-comment "Memory hotplug is currently incompatible with Software Suspend"
-	depends on SPARSEMEM && HOTPLUG && HIBERNATION
