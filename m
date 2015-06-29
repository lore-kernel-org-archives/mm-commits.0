From: akpm@linux-foundation.org
Subject: [merged]
 s390-mm-make-hugepages_supported-a-boot-time-decision.patch removed from
 -mm tree
Date: Mon, 29 Jun 2015 13:39:38 -0700
Message-ID: <5591ad0a.sUZG0j7sr7BCd0ax%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbbF2Ujj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dingel@linux.vnet.ibm.com, borntraeger@de.ibm.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390/mm: make hugepages_supported a boot time decision
has been removed from the -mm tree.  Its filename was
     s390-mm-make-hugepages_supported-a-boot-time-decision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: s390/mm: make hugepages_supported a boot time decision

There is a potential bug with KVM and hugetlbfs if the hardware does not
support hugepages (EDAT1).  We fix this by making EDAT1 a hard requirement
for hugepages and therefore removing and simplifying code.

As s390, with the sw-emulated hugepages, was the only user of
arch_prepare/release_hugepage I also removed theses calls from common and
other architecture code.


This patch (of 5):

By dropping support for hugepages on machines which do not have the
hardware feature EDAT1, we fix a potential s390 KVM bug.

The bug would happen if a guest is backed by hugetlbfs (not supported
currently), but does not get pagetables with PGSTE.  This would lead to
random memory overwrites.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/page.h |    8 ++++----
 arch/s390/kernel/setup.c     |    2 ++
 arch/s390/mm/pgtable.c       |    2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/s390/include/asm/page.h~s390-mm-make-hugepages_supported-a-boot-time-decision arch/s390/include/asm/page.h
--- a/arch/s390/include/asm/page.h~s390-mm-make-hugepages_supported-a-boot-time-decision
+++ a/arch/s390/include/asm/page.h
@@ -17,7 +17,10 @@
 #define PAGE_DEFAULT_ACC	0
 #define PAGE_DEFAULT_KEY	(PAGE_DEFAULT_ACC << 4)
 
-#define HPAGE_SHIFT	20
+#include <asm/setup.h>
+#ifndef __ASSEMBLY__
+
+extern unsigned int HPAGE_SHIFT;
 #define HPAGE_SIZE	(1UL << HPAGE_SHIFT)
 #define HPAGE_MASK	(~(HPAGE_SIZE - 1))
 #define HUGETLB_PAGE_ORDER	(HPAGE_SHIFT - PAGE_SHIFT)
@@ -27,9 +30,6 @@
 #define ARCH_HAS_PREPARE_HUGEPAGE
 #define ARCH_HAS_HUGEPAGE_CLEAR_FLUSH
 
-#include <asm/setup.h>
-#ifndef __ASSEMBLY__
-
 static inline void storage_key_init_range(unsigned long start, unsigned long end)
 {
 #if PAGE_DEFAULT_KEY
diff -puN arch/s390/kernel/setup.c~s390-mm-make-hugepages_supported-a-boot-time-decision arch/s390/kernel/setup.c
--- a/arch/s390/kernel/setup.c~s390-mm-make-hugepages_supported-a-boot-time-decision
+++ a/arch/s390/kernel/setup.c
@@ -880,6 +880,8 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	setup_hwcaps();
 
+	HPAGE_SHIFT = MACHINE_HAS_HPAGE ? 20 : 0;
+
 	/*
 	 * Create kernel page tables and switch to virtual addressing.
 	 */
diff -puN arch/s390/mm/pgtable.c~s390-mm-make-hugepages_supported-a-boot-time-decision arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~s390-mm-make-hugepages_supported-a-boot-time-decision
+++ a/arch/s390/mm/pgtable.c
@@ -31,6 +31,8 @@
 #define ALLOC_ORDER	2
 #define FRAG_MASK	0x03
 
+unsigned int HPAGE_SHIFT;
+
 unsigned long *crst_table_alloc(struct mm_struct *mm)
 {
 	struct page *page = alloc_pages(GFP_KERNEL, ALLOC_ORDER);
_

Patches currently in -mm which might be from dingel@linux.vnet.ibm.com are

origin.patch

