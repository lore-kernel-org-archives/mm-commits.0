From: akpm@linux-foundation.org
Subject: - kill-vmalloc_earlyreserve.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:49:33 -0700
Message-ID: <200707162049.l6GKnXY6001170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985AbXGPVTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     kill vmalloc_earlyreserve
has been removed from the -mm tree.  Its filename was
     kill-vmalloc_earlyreserve.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kill vmalloc_earlyreserve
From: "Jan Beulich" <jbeulich@novell.com>

This symbol got orphaned quite a while ago.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/pgtable.h |    2 +-
 include/linux/mm.h         |    1 -
 mm/memory.c                |    2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

diff -puN include/asm-i386/pgtable.h~kill-vmalloc_earlyreserve include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~kill-vmalloc_earlyreserve
+++ a/include/asm-i386/pgtable.h
@@ -79,7 +79,7 @@ void paging_init(void);
  * area for the same reason. ;)
  */
 #define VMALLOC_OFFSET	(8*1024*1024)
-#define VMALLOC_START	(((unsigned long) high_memory + vmalloc_earlyreserve + \
+#define VMALLOC_START	(((unsigned long) high_memory + \
 			2*VMALLOC_OFFSET-1) & ~(VMALLOC_OFFSET-1))
 #ifdef CONFIG_HIGHMEM
 # define VMALLOC_END	(PKMAP_BASE-2*PAGE_SIZE)
diff -puN include/linux/mm.h~kill-vmalloc_earlyreserve include/linux/mm.h
--- a/include/linux/mm.h~kill-vmalloc_earlyreserve
+++ a/include/linux/mm.h
@@ -27,7 +27,6 @@ extern unsigned long max_mapnr;
 
 extern unsigned long num_physpages;
 extern void * high_memory;
-extern unsigned long vmalloc_earlyreserve;
 extern int page_cluster;
 
 #ifdef CONFIG_SYSCTL
diff -puN mm/memory.c~kill-vmalloc_earlyreserve mm/memory.c
--- a/mm/memory.c~kill-vmalloc_earlyreserve
+++ a/mm/memory.c
@@ -78,11 +78,9 @@ unsigned long num_physpages;
  * and ZONE_HIGHMEM.
  */
 void * high_memory;
-unsigned long vmalloc_earlyreserve;
 
 EXPORT_SYMBOL(num_physpages);
 EXPORT_SYMBOL(high_memory);
-EXPORT_SYMBOL(vmalloc_earlyreserve);
 
 int randomize_va_space __read_mostly = 1;
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

origin.patch
modpost-white-list-pattern-adjustment.patch
more-fix-x86_64-mm-xen-xen-smp-guest-support.patch
i386-minor-nx-handling-adjustment.patch
x86-smp-alt-once-option-is-only-useful-with-hotplug_cpu.patch
x86-64-remove-unused-variable-maxcpus.patch
