From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-use-__paginginit-instead-of-__init.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 12:42:35 -0700
Message-ID: <5232192b.OJFFSc3HVB1t9jbv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTmf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: [merged] mm-page_allocc-use-__paginginit-instead-of-__init.patch removed from -mm tree
To: gang.chen@asianux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:35 -0700


The patch titled
     Subject: mm/page_alloc.c: use '__paginginit' instead of '__init'
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-use-__paginginit-instead-of-__init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/page_alloc.c: use '__paginginit' instead of '__init'

set_pageblock_order() may be called when memory hotplug, so need use
'__paginginit' instead of '__init'.

The related warning:

  The function __meminit .free_area_init_node() references
  a function __init .set_pageblock_order().
  If .set_pageblock_order is only used by .free_area_init_node then
  annotate .set_pageblock_order with a matching annotation.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-use-__paginginit-instead-of-__init mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-use-__paginginit-instead-of-__init
+++ a/mm/page_alloc.c
@@ -4586,7 +4586,7 @@ static inline void setup_usemap(struct p
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+void __paginginit set_pageblock_order(void)
 {
 	unsigned int order;
 
@@ -4614,7 +4614,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+void __paginginit set_pageblock_order(void)
 {
 }
 
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
h8300-kernel-timer-timer8c-add-missing-semicolon.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

