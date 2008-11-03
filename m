From: akpm@linux-foundation.org
Subject: + hibernation-should-work-ok-with-memory-hotplug.patch added to -mm tree
Date: Mon, 03 Nov 2008 12:52:37 -0800
Message-ID: <200811032052.mA3KqbJ8026179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbYKCUx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Nov 2008 15:53:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, haveblue@us.ibm.com, matthew.e.tolentino@intel.com, rjw@sisk.pl, y-goto@jp.fujitsu.com


The patch titled
     hibernation should work ok with memory hotplug
has been added to the -mm tree.  Its filename is
     hibernation-should-work-ok-with-memory-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
