From: akpm@linux-foundation.org
Subject: + ia64-specify-amount-of-kernel-memory-at-boot-time-fix.patch added to -mm tree
Date: Fri, 13 Apr 2007 13:48:07 -0700
Message-ID: <200704132048.l3DKm7hg009064@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50622 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965337AbXDMUsV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:48:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: y-goto@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     ia64: fix parsing kernelcore boot option
has been added to the -mm tree.  Its filename is
     ia64-specify-amount-of-kernel-memory-at-boot-time-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ia64: fix parsing kernelcore boot option
From: Yasunori Goto <y-goto@jp.fujitsu.com>

cmdline_parse_kernelcore() should return the next pointer of boot option
like memparse() doing.  If not, it is cause of eternal loop on ia64 box. 

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    2 +-
 include/linux/mm.h     |    2 +-
 mm/page_alloc.c        |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/efi.c~ia64-specify-amount-of-kernel-memory-at-boot-time-fix arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-specify-amount-of-kernel-memory-at-boot-time-fix
+++ a/arch/ia64/kernel/efi.c
@@ -424,7 +424,7 @@ efi_init (void)
 		} else if (memcmp(cp, "max_addr=", 9) == 0) {
 			max_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else if (memcmp(cp, "kernelcore=",11) == 0) {
-			cmdline_parse_kernelcore(cp+11);
+			cmdline_parse_kernelcore(cp+11, &cp);
 		} else if (memcmp(cp, "min_addr=", 9) == 0) {
 			min_addr = GRANULEROUNDDOWN(memparse(cp + 9, &cp));
 		} else {
diff -puN include/linux/mm.h~ia64-specify-amount-of-kernel-memory-at-boot-time-fix include/linux/mm.h
--- a/include/linux/mm.h~ia64-specify-amount-of-kernel-memory-at-boot-time-fix
+++ a/include/linux/mm.h
@@ -988,7 +988,7 @@ extern unsigned long find_max_pfn_with_a
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
 extern void sparse_memory_present_with_active_regions(int nid);
-extern int cmdline_parse_kernelcore(char *p);
+extern int cmdline_parse_kernelcore(char *p, char **retp);
 #ifndef CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID
 extern int early_pfn_to_nid(unsigned long pfn);
 #endif /* CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID */
diff -puN mm/page_alloc.c~ia64-specify-amount-of-kernel-memory-at-boot-time-fix mm/page_alloc.c
--- a/mm/page_alloc.c~ia64-specify-amount-of-kernel-memory-at-boot-time-fix
+++ a/mm/page_alloc.c
@@ -3528,13 +3528,13 @@ void __init free_area_init_nodes(unsigne
  * kernelcore=size sets the amount of memory for use for allocations that
  * cannot be reclaimed or migrated.
  */
-int __init cmdline_parse_kernelcore(char *p)
+int __init cmdline_parse_kernelcore(char *p, char **retp)
 {
 	unsigned long long coremem;
 	if (!p)
 		return -EINVAL;
 
-	coremem = memparse(p, &p);
+	coremem = memparse(p, retp);
 	required_kernelcore = coremem >> PAGE_SHIFT;
 
 	/* Paranoid check that UL is enough for required_kernelcore */
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
ia64-specify-amount-of-kernel-memory-at-boot-time-fix.patch
fix-section-mismatch-of-memory-hotplug-related-code.patch
add-white-list-into-modpostc-for-memory-hotplug-code-and-ia64s-machvec-section.patch
