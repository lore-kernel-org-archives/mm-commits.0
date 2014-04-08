From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-macros-from-compilerh-instead-of-__attribute__.patch removed from
 -mm tree
Date: Tue, 08 Apr 2014 13:44:27 -0700
Message-ID: <53445fab.be/g/voDhuqXmRxQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbaDHUo1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:44:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gidisrael@gmail.com

Subject: [merged] mm-use-macros-from-compilerh-instead-of-__attribute__.patch removed from -mm tree
To: gidisrael@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:44:27 -0700


The patch titled
     Subject: mm: use macros from compiler.h instead of __attribute__((...))
has been removed from the -mm tree.  Its filename was
     mm-use-macros-from-compilerh-instead-of-__attribute__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gideon Israel Dsouza <gidisrael@gmail.com>
Subject: mm: use macros from compiler.h instead of __attribute__((...))

To increase compiler portability there is <linux/compiler.h> which
provides convenience macros for various gcc constructs.  Eg: __weak for
__attribute__((weak)).  I've replaced all instances of gcc attributes with
the right macro in the memory management (/mm) subsystem.

[akpm@linux-foundation.org: while-we're-there consistency tweaks]
Signed-off-by: Gideon Israel Dsouza <gidisrael@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 mm/nommu.c   |    3 ++-
 mm/sparse.c  |    4 +++-
 mm/util.c    |    5 +++--
 mm/vmalloc.c |    4 +++-
 5 files changed, 13 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-use-macros-from-compilerh-instead-of-__attribute__ mm/hugetlb.c
--- a/mm/hugetlb.c~mm-use-macros-from-compilerh-instead-of-__attribute__
+++ a/mm/hugetlb.c
@@ -13,6 +13,7 @@
 #include <linux/nodemask.h>
 #include <linux/pagemap.h>
 #include <linux/mempolicy.h>
+#include <linux/compiler.h>
 #include <linux/cpuset.h>
 #include <linux/mutex.h>
 #include <linux/bootmem.h>
@@ -3521,7 +3522,7 @@ follow_huge_pud(struct mm_struct *mm, un
 #else /* !CONFIG_ARCH_WANT_GENERAL_HUGETLB */
 
 /* Can be overriden by architectures */
-__attribute__((weak)) struct page *
+struct page * __weak
 follow_huge_pud(struct mm_struct *mm, unsigned long address,
 	       pud_t *pud, int write)
 {
diff -puN mm/nommu.c~mm-use-macros-from-compilerh-instead-of-__attribute__ mm/nommu.c
--- a/mm/nommu.c~mm-use-macros-from-compilerh-instead-of-__attribute__
+++ a/mm/nommu.c
@@ -25,6 +25,7 @@
 #include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
+#include <linux/compiler.h>
 #include <linux/mount.h>
 #include <linux/personality.h>
 #include <linux/security.h>
@@ -460,7 +461,7 @@ EXPORT_SYMBOL_GPL(vm_unmap_aliases);
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
  */
-void  __attribute__((weak)) vmalloc_sync_all(void)
+void __weak vmalloc_sync_all(void)
 {
 }
 
diff -puN mm/sparse.c~mm-use-macros-from-compilerh-instead-of-__attribute__ mm/sparse.c
--- a/mm/sparse.c~mm-use-macros-from-compilerh-instead-of-__attribute__
+++ a/mm/sparse.c
@@ -5,10 +5,12 @@
 #include <linux/slab.h>
 #include <linux/mmzone.h>
 #include <linux/bootmem.h>
+#include <linux/compiler.h>
 #include <linux/highmem.h>
 #include <linux/export.h>
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
+
 #include "internal.h"
 #include <asm/dma.h>
 #include <asm/pgalloc.h>
@@ -461,7 +463,7 @@ static struct page __init *sparse_early_
 }
 #endif
 
-void __attribute__((weak)) __meminit vmemmap_populate_print_last(void)
+void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
diff -puN mm/util.c~mm-use-macros-from-compilerh-instead-of-__attribute__ mm/util.c
--- a/mm/util.c~mm-use-macros-from-compilerh-instead-of-__attribute__
+++ a/mm/util.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/compiler.h>
 #include <linux/export.h>
 #include <linux/err.h>
 #include <linux/sched.h>
@@ -307,7 +308,7 @@ void arch_pick_mmap_layout(struct mm_str
  * If the architecture not support this function, simply return with no
  * page pinned
  */
-int __attribute__((weak)) __get_user_pages_fast(unsigned long start,
+int __weak __get_user_pages_fast(unsigned long start,
 				 int nr_pages, int write, struct page **pages)
 {
 	return 0;
@@ -338,7 +339,7 @@ EXPORT_SYMBOL_GPL(__get_user_pages_fast)
  * callers need to carefully consider what to use. On many architectures,
  * get_user_pages_fast simply falls back to get_user_pages.
  */
-int __attribute__((weak)) get_user_pages_fast(unsigned long start,
+int __weak get_user_pages_fast(unsigned long start,
 				int nr_pages, int write, struct page **pages)
 {
 	struct mm_struct *mm = current->mm;
diff -puN mm/vmalloc.c~mm-use-macros-from-compilerh-instead-of-__attribute__ mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-macros-from-compilerh-instead-of-__attribute__
+++ a/mm/vmalloc.c
@@ -27,7 +27,9 @@
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
 #include <linux/atomic.h>
+#include <linux/compiler.h>
 #include <linux/llist.h>
+
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -2181,7 +2183,7 @@ EXPORT_SYMBOL(remap_vmalloc_range);
  * Implement a stub for vmalloc_sync_all() if the architecture chose not to
  * have one.
  */
-void  __attribute__((weak)) vmalloc_sync_all(void)
+void __weak vmalloc_sync_all(void)
 {
 }
 
_

Patches currently in -mm which might be from gidisrael@gmail.com are

origin.patch

