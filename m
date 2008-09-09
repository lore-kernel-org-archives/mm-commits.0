From: akpm@linux-foundation.org
Subject: + mm-cleanup-to-make-remove_memory-arch-neutral.patch added to -mm tree
Date: Mon, 08 Sep 2008 17:56:26 -0700
Message-ID: <200809090056.m890uQxP018892@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068AbYIIA6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 20:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com, benh@kernel.crashing.org, garyhade@us.ibm.com, heiko.carstens@de.ibm.com, mel@csn.ul.ie, paulus@samba.org, schwidefsky@de.ibm.com, tony.luck@intel.com, y-goto@jp.fujitsu.com


The patch titled
     mm: cleanup to make remove_memory() arch-neutral
has been added to the -mm tree.  Its filename is
     mm-cleanup-to-make-remove_memory-arch-neutral.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: cleanup to make remove_memory() arch-neutral
From: Badari Pulavarty <pbadari@us.ibm.com>

There is nothing architecture specific about remove_memory(). 
remove_memory() function is common for all architectures which support
hotplug memory remove.  Instead of duplicating it in every architecture,
collapse them into arch neutral function.

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Gary Hade <garyhade@us.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c   |   17 -----------------
 arch/powerpc/mm/mem.c |   17 -----------------
 arch/s390/mm/init.c   |   11 -----------
 mm/memory_hotplug.c   |   10 ++++++++++
 4 files changed, 10 insertions(+), 45 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-cleanup-to-make-remove_memory-arch-neutral arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-cleanup-to-make-remove_memory-arch-neutral
+++ a/arch/ia64/mm/init.c
@@ -701,23 +701,6 @@ int arch_add_memory(int nid, u64 start, 
 
 	return ret;
 }
-#ifdef CONFIG_MEMORY_HOTREMOVE
-int remove_memory(u64 start, u64 size)
-{
-	unsigned long start_pfn, end_pfn;
-	unsigned long timeout = 120 * HZ;
-	int ret;
-	start_pfn = start >> PAGE_SHIFT;
-	end_pfn = start_pfn + (size >> PAGE_SHIFT);
-	ret = offline_pages(start_pfn, end_pfn, timeout);
-	if (ret)
-		goto out;
-	/* we can free mem_map at this point */
-out:
-	return ret;
-}
-EXPORT_SYMBOL_GPL(remove_memory);
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif
 
 /*
diff -puN arch/powerpc/mm/mem.c~mm-cleanup-to-make-remove_memory-arch-neutral arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-cleanup-to-make-remove_memory-arch-neutral
+++ a/arch/powerpc/mm/mem.c
@@ -135,23 +135,6 @@ int arch_add_memory(int nid, u64 start, 
 
 	return __add_pages(zone, start_pfn, nr_pages);
 }
-
-#ifdef CONFIG_MEMORY_HOTREMOVE
-int remove_memory(u64 start, u64 size)
-{
-	unsigned long start_pfn, end_pfn;
-	int ret;
-
-	start_pfn = start >> PAGE_SHIFT;
-	end_pfn = start_pfn + (size >> PAGE_SHIFT);
-	ret = offline_pages(start_pfn, end_pfn, 120 * HZ);
-	if (ret)
-		goto out;
-	/* Arch-specific calls go here - next patch */
-out:
-	return ret;
-}
-#endif /* CONFIG_MEMORY_HOTREMOVE */
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 /*
diff -puN arch/s390/mm/init.c~mm-cleanup-to-make-remove_memory-arch-neutral arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-cleanup-to-make-remove_memory-arch-neutral
+++ a/arch/s390/mm/init.c
@@ -189,14 +189,3 @@ int arch_add_memory(int nid, u64 start, 
 	return rc;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
-
-#ifdef CONFIG_MEMORY_HOTREMOVE
-int remove_memory(u64 start, u64 size)
-{
-	unsigned long start_pfn, end_pfn;
-
-	start_pfn = PFN_DOWN(start);
-	end_pfn = start_pfn + PFN_DOWN(size);
-	return offline_pages(start_pfn, end_pfn, 120 * HZ);
-}
-#endif /* CONFIG_MEMORY_HOTREMOVE */
diff -puN mm/memory_hotplug.c~mm-cleanup-to-make-remove_memory-arch-neutral mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-cleanup-to-make-remove_memory-arch-neutral
+++ a/mm/memory_hotplug.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
+#include <linux/pfn.h>
 
 #include <asm/tlbflush.h>
 
@@ -849,6 +850,15 @@ failed_removal:
 
 	return ret;
 }
+
+int remove_memory(u64 start, u64 size)
+{
+	unsigned long start_pfn, end_pfn;
+
+	start_pfn = PFN_DOWN(start);
+	end_pfn = start_pfn + PFN_DOWN(size);
+	return offline_pages(start_pfn, end_pfn, 120 * HZ);
+}
 #else
 int remove_memory(u64 start, u64 size)
 {
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

mm-cleanup-to-make-remove_memory-arch-neutral.patch

