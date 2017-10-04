From: akpm@linux-foundation.org
Subject: + mm-arch-remove-empty_bad_page.patch added to -mm tree
Date: Wed, 04 Oct 2017 15:11:01 -0700
Message-ID: <59d55c75.8Mxn0TlbAe3QkAOM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44246 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdJDWLC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:11:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, dalias@libc.org, dhowells@redhat.com, jdike@addtoit.com, mingo@kernel.org, ralf@linux-mips.org, richard@nod.at, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, arch: remove empty_bad_page*
has been added to the -mm tree.  Its filename is
     mm-arch-remove-empty_bad_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-arch-remove-empty_bad_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-arch-remove-empty_bad_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, arch: remove empty_bad_page*

empty_bad_page() and empty_bad_pte_table() seem to be relics from old days
which is not used by any code for a long time.  I have tried to find when
exactly but this is not really all that straightforward due to many code
movements - traces disappear around 2.4 times.

Anyway no code really references neither empty_bad_page nor
empty_bad_pte_table.  We only allocate the storage which is not used by
anybody so remove them.

Link: http://lkml.kernel.org/r/20171004150045.30755-1-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/init.c                 |   14 --------------
 arch/h8300/mm/init.c               |   13 -------------
 arch/mips/include/asm/pgtable-64.h |    8 +-------
 arch/mn10300/kernel/head.S         |    8 --------
 arch/sh/kernel/head_64.S           |    8 --------
 arch/um/kernel/mem.c               |    3 ---
 include/linux/page-flags.h         |    2 +-
 7 files changed, 2 insertions(+), 54 deletions(-)

diff -puN arch/frv/mm/init.c~mm-arch-remove-empty_bad_page arch/frv/mm/init.c
--- a/arch/frv/mm/init.c~mm-arch-remove-empty_bad_page
+++ a/arch/frv/mm/init.c
@@ -42,21 +42,9 @@
 #undef DEBUG
 
 /*
- * BAD_PAGE is the page that is used for page faults when linux
- * is out-of-memory. Older versions of linux just did a
- * do_exit(), but using this instead means there is less risk
- * for a process dying in kernel mode, possibly leaving a inode
- * unused etc..
- *
- * BAD_PAGETABLE is the accompanying page-table: it is initialized
- * to point to BAD_PAGE entries.
- *
  * ZERO_PAGE is a special page that is used for zero-initialized
  * data and COW.
  */
-static unsigned long empty_bad_page_table;
-static unsigned long empty_bad_page;
-
 unsigned long empty_zero_page;
 EXPORT_SYMBOL(empty_zero_page);
 
@@ -72,8 +60,6 @@ void __init paging_init(void)
 	unsigned long zones_size[MAX_NR_ZONES] = {0, };
 
 	/* allocate some pages for kernel housekeeping tasks */
-	empty_bad_page_table	= (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
-	empty_bad_page		= (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
 	empty_zero_page		= (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
 
 	memset((void *) empty_zero_page, 0, PAGE_SIZE);
diff -puN arch/h8300/mm/init.c~mm-arch-remove-empty_bad_page arch/h8300/mm/init.c
--- a/arch/h8300/mm/init.c~mm-arch-remove-empty_bad_page
+++ a/arch/h8300/mm/init.c
@@ -39,20 +39,9 @@
 #include <asm/sections.h>
 
 /*
- * BAD_PAGE is the page that is used for page faults when linux
- * is out-of-memory. Older versions of linux just did a
- * do_exit(), but using this instead means there is less risk
- * for a process dying in kernel mode, possibly leaving a inode
- * unused etc..
- *
- * BAD_PAGETABLE is the accompanying page-table: it is initialized
- * to point to BAD_PAGE entries.
- *
  * ZERO_PAGE is a special page that is used for zero-initialized
  * data and COW.
  */
-static unsigned long empty_bad_page_table;
-static unsigned long empty_bad_page;
 unsigned long empty_zero_page;
 
 /*
@@ -77,8 +66,6 @@ void __init paging_init(void)
 	 * Initialize the bad page table and bad page to point
 	 * to a couple of allocated pages.
 	 */
-	empty_bad_page_table = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
-	empty_bad_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 	empty_zero_page = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 	memset((void *)empty_zero_page, 0, PAGE_SIZE);
 
diff -puN arch/mips/include/asm/pgtable-64.h~mm-arch-remove-empty_bad_page arch/mips/include/asm/pgtable-64.h
--- a/arch/mips/include/asm/pgtable-64.h~mm-arch-remove-empty_bad_page
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -31,12 +31,7 @@
  * tables. Each page table is also a single 4K page, giving 512 (==
  * PTRS_PER_PTE) 8 byte ptes. Each pud entry is initialized to point to
  * invalid_pmd_table, each pmd entry is initialized to point to
- * invalid_pte_table, each pte is initialized to 0. When memory is low,
- * and a pmd table or a page table allocation fails, empty_bad_pmd_table
- * and empty_bad_page_table is returned back to higher layer code, so
- * that the failure is recognized later on. Linux does not seem to
- * handle these failures very well though. The empty_bad_page_table has
- * invalid pte entries in it, to force page faults.
+ * invalid_pte_table, each pte is initialized to 0.
  *
  * Kernel mappings: kernel mappings are held in the swapper_pg_table.
  * The layout is identical to userspace except it's indexed with the
@@ -175,7 +170,6 @@
 	printk("%s:%d: bad pgd %016lx.\n", __FILE__, __LINE__, pgd_val(e))
 
 extern pte_t invalid_pte_table[PTRS_PER_PTE];
-extern pte_t empty_bad_page_table[PTRS_PER_PTE];
 
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
diff -puN arch/mn10300/kernel/head.S~mm-arch-remove-empty_bad_page arch/mn10300/kernel/head.S
--- a/arch/mn10300/kernel/head.S~mm-arch-remove-empty_bad_page
+++ a/arch/mn10300/kernel/head.S
@@ -434,14 +434,6 @@ ENTRY(empty_zero_page)
 	.space PAGE_SIZE
 
 	.balign PAGE_SIZE
-ENTRY(empty_bad_page)
-	.space PAGE_SIZE
-
-	.balign PAGE_SIZE
-ENTRY(empty_bad_pte_table)
-	.space PAGE_SIZE
-
-	.balign PAGE_SIZE
 ENTRY(large_page_table)
 	.space PAGE_SIZE
 
diff -puN arch/sh/kernel/head_64.S~mm-arch-remove-empty_bad_page arch/sh/kernel/head_64.S
--- a/arch/sh/kernel/head_64.S~mm-arch-remove-empty_bad_page
+++ a/arch/sh/kernel/head_64.S
@@ -101,14 +101,6 @@ empty_zero_page:
 mmu_pdtp_cache:
 	.space PAGE_SIZE, 0
 
-	.global empty_bad_page
-empty_bad_page:
-	.space PAGE_SIZE, 0
-
-	.global empty_bad_pte_table
-empty_bad_pte_table:
-	.space PAGE_SIZE, 0
-
 	.global	fpu_in_use
 fpu_in_use:	.quad	0
 
diff -puN arch/um/kernel/mem.c~mm-arch-remove-empty_bad_page arch/um/kernel/mem.c
--- a/arch/um/kernel/mem.c~mm-arch-remove-empty_bad_page
+++ a/arch/um/kernel/mem.c
@@ -22,8 +22,6 @@
 /* allocated in paging_init, zeroed in mem_init, and unchanged thereafter */
 unsigned long *empty_zero_page = NULL;
 EXPORT_SYMBOL(empty_zero_page);
-/* allocated in paging_init and unchanged thereafter */
-static unsigned long *empty_bad_page = NULL;
 
 /*
  * Initialized during boot, and readonly for initializing page tables
@@ -146,7 +144,6 @@ void __init paging_init(void)
 	int i;
 
 	empty_zero_page = (unsigned long *) alloc_bootmem_low_pages(PAGE_SIZE);
-	empty_bad_page = (unsigned long *) alloc_bootmem_low_pages(PAGE_SIZE);
 	for (i = 0; i < ARRAY_SIZE(zones_size); i++)
 		zones_size[i] = 0;
 
diff -puN include/linux/page-flags.h~mm-arch-remove-empty_bad_page include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-arch-remove-empty_bad_page
+++ a/include/linux/page-flags.h
@@ -17,7 +17,7 @@
  * Various page->flags bits:
  *
  * PG_reserved is set for special pages, which can never be swapped out. Some
- * of them might not even exist (eg empty_bad_page)...
+ * of them might not even exist...
  *
  * The PG_private bitflag is set on pagecache pages if they contain filesystem
  * specific data (which is normally at page->private). It can be used by
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-memory_hotplug-do-not-back-off-draining-pcp-free-pages-from-kworker-context.patch
mm-memory_hotplug-do-not-fail-offlining-too-early.patch
mm-memory_hotplug-remove-timeout-from-__offline_memory.patch
mm-hugetlb-drop-hugepages_treat_as_movable-sysctl.patch
mm-arch-remove-empty_bad_page.patch

