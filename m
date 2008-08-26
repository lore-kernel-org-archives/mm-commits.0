From: akpm@linux-foundation.org
Subject: - i386-vmalloc-size-fix.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:44 -0700
Message-ID: <200808261844.m7QIiiDw021335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58154 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757086AbYHZSpf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:45:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386: vmalloc size fix
has been removed from the -mm tree.  Its filename was
     i386-vmalloc-size-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i386: vmalloc size fix
From: Dave Young <hidave.darkstar@gmail.com>

Booting kernel with vmalloc=[any size<=16m] will oops on my pc (i386/1G memory).

BUG_ON in arch/x86/mm/init_32.c triggered:
BUG_ON((unsigned long)high_memory > VMALLOC_START);

It's due to the vm area hole.

In include/asm-x86/pgtable_32.h:
#define VMALLOC_OFFSET	(8 * 1024 * 1024)
#define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
			 & ~(VMALLOC_OFFSET - 1))

There's several related point:
1. MAXMEM :
 (-__PAGE_OFFSET - __VMALLOC_RESERVE).
The space after VMALLOC_END is included as well, I set it to
(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)

2. VMALLOC_OFFSET is not considered in __VMALLOC_RESERVE
fixed by adding VMALLOC_OFFSET to it.

3. VMALLOC_START :
 (((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) & ~(VMALLOC_OFFSET - 1))
So it's not always 8M, bigger than 8M possible.
I set it to ((unsigned long)high_memory + VMALLOC_OFFSET)

4. the VMALLOC_RESERVE is an unused macro, so remove it here.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pgtable_32.c     |    3 ++-
 include/asm-x86/page_32.h    |    3 ---
 include/asm-x86/pgtable_32.h |    5 +++--
 3 files changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/x86/mm/pgtable_32.c~i386-vmalloc-size-fix arch/x86/mm/pgtable_32.c
--- a/arch/x86/mm/pgtable_32.c~i386-vmalloc-size-fix
+++ a/arch/x86/mm/pgtable_32.c
@@ -123,7 +123,8 @@ static int __init parse_vmalloc(char *ar
 	if (!arg)
 		return -EINVAL;
 
-	__VMALLOC_RESERVE = memparse(arg, &arg);
+	/* Add VMALLOC_OFFSET to the parsed value due to vm area guard hole*/
+	__VMALLOC_RESERVE = memparse(arg, &arg) + VMALLOC_OFFSET;
 	return 0;
 }
 early_param("vmalloc", parse_vmalloc);
diff -puN include/asm-x86/page_32.h~i386-vmalloc-size-fix include/asm-x86/page_32.h
--- a/include/asm-x86/page_32.h~i386-vmalloc-size-fix
+++ a/include/asm-x86/page_32.h
@@ -89,9 +89,6 @@ extern int nx_enabled;
 extern unsigned int __VMALLOC_RESERVE;
 extern int sysctl_legacy_va_layout;
 
-#define VMALLOC_RESERVE		((unsigned long)__VMALLOC_RESERVE)
-#define MAXMEM			(-__PAGE_OFFSET - __VMALLOC_RESERVE)
-
 extern void find_low_pfn_range(void);
 extern unsigned long init_memory_mapping(unsigned long start,
 					 unsigned long end);
diff -puN include/asm-x86/pgtable_32.h~i386-vmalloc-size-fix include/asm-x86/pgtable_32.h
--- a/include/asm-x86/pgtable_32.h~i386-vmalloc-size-fix
+++ a/include/asm-x86/pgtable_32.h
@@ -56,8 +56,7 @@ void paging_init(void);
  * area for the same reason. ;)
  */
 #define VMALLOC_OFFSET	(8 * 1024 * 1024)
-#define VMALLOC_START	(((unsigned long)high_memory + 2 * VMALLOC_OFFSET - 1) \
-			 & ~(VMALLOC_OFFSET - 1))
+#define VMALLOC_START	((unsigned long)high_memory + VMALLOC_OFFSET)
 #ifdef CONFIG_X86_PAE
 #define LAST_PKMAP 512
 #else
@@ -73,6 +72,8 @@ void paging_init(void);
 # define VMALLOC_END	(FIXADDR_START - 2 * PAGE_SIZE)
 #endif
 
+#define MAXMEM	(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
+
 /*
  * Define this if things work differently on an i386 and an i486:
  * it will (on an i486) warn about kernel memory accesses that are
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
hci_usb-replace-mb-with-smp_mb.patch

