From: akpm@linux-foundation.org
Subject: [merged] thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:27:46 -0800
Message-ID: <20121214232746.CFD2882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60090 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab2LNX1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:27:48 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so409696vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:27:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, ak@linux.intel.com, hpa@linux.intel.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: introduce sysfs knob to disable huge zero page
has been removed from the -mm tree.  Its filename was
     thp-introduce-sysfs-knob-to-disable-huge-zero-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: introduce sysfs knob to disable huge zero page

By default kernel tries to use huge zero page on read page fault.  It's
possible to disable huge zero page by writing 0 or enable it back by
writing 1:

echo 0 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
echo 1 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/transhuge.txt |    7 +++++++
 include/linux/huge_mm.h        |    4 ++++
 mm/huge_memory.c               |   21 +++++++++++++++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

diff -puN Documentation/vm/transhuge.txt~thp-introduce-sysfs-knob-to-disable-huge-zero-page Documentation/vm/transhuge.txt
--- a/Documentation/vm/transhuge.txt~thp-introduce-sysfs-knob-to-disable-huge-zero-page
+++ a/Documentation/vm/transhuge.txt
@@ -116,6 +116,13 @@ echo always >/sys/kernel/mm/transparent_
 echo madvise >/sys/kernel/mm/transparent_hugepage/defrag
 echo never >/sys/kernel/mm/transparent_hugepage/defrag
 
+By default kernel tries to use huge zero page on read page fault.
+It's possible to disable huge zero page by writing 0 or enable it
+back by writing 1:
+
+echo 0 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
+echo 1 >/sys/kernel/mm/transparent_hugepage/khugepaged/use_zero_page
+
 khugepaged will be automatically started when
 transparent_hugepage/enabled is set to "always" or "madvise, and it'll
 be automatically shutdown if it's set to "never".
diff -puN include/linux/huge_mm.h~thp-introduce-sysfs-knob-to-disable-huge-zero-page include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-introduce-sysfs-knob-to-disable-huge-zero-page
+++ a/include/linux/huge_mm.h
@@ -39,6 +39,7 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
+	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
 #ifdef CONFIG_DEBUG_VM
 	TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG,
 #endif
@@ -78,6 +79,9 @@ extern bool is_vma_temporary_stack(struc
 	 (transparent_hugepage_flags &					\
 	  (1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG) &&		\
 	  (__vma)->vm_flags & VM_HUGEPAGE))
+#define transparent_hugepage_use_zero_page()				\
+	(transparent_hugepage_flags &					\
+	 (1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG))
 #ifdef CONFIG_DEBUG_VM
 #define transparent_hugepage_debug_cow()				\
 	(transparent_hugepage_flags &					\
diff -puN mm/huge_memory.c~thp-introduce-sysfs-knob-to-disable-huge-zero-page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-introduce-sysfs-knob-to-disable-huge-zero-page
+++ a/mm/huge_memory.c
@@ -39,7 +39,8 @@ unsigned long transparent_hugepage_flags
 	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
 #endif
 	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_FLAG)|
-	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG);
+	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
+	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
 
 /* default scan 8*512 pte (or vmas) every 30 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly = HPAGE_PMD_NR*8;
@@ -357,6 +358,20 @@ static ssize_t defrag_store(struct kobje
 static struct kobj_attribute defrag_attr =
 	__ATTR(defrag, 0644, defrag_show, defrag_store);
 
+static ssize_t use_zero_page_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	return single_flag_show(kobj, attr, buf,
+				TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
+}
+static ssize_t use_zero_page_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	return single_flag_store(kobj, attr, buf, count,
+				 TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
+}
+static struct kobj_attribute use_zero_page_attr =
+	__ATTR(use_zero_page, 0644, use_zero_page_show, use_zero_page_store);
 #ifdef CONFIG_DEBUG_VM
 static ssize_t debug_cow_show(struct kobject *kobj,
 				struct kobj_attribute *attr, char *buf)
@@ -378,6 +393,7 @@ static struct kobj_attribute debug_cow_a
 static struct attribute *hugepage_attr[] = {
 	&enabled_attr.attr,
 	&defrag_attr.attr,
+	&use_zero_page_attr.attr,
 #ifdef CONFIG_DEBUG_VM
 	&debug_cow_attr.attr,
 #endif
@@ -779,7 +795,8 @@ int do_huge_pmd_anonymous_page(struct mm
 			return VM_FAULT_OOM;
 		if (unlikely(khugepaged_enter(vma)))
 			return VM_FAULT_OOM;
-		if (!(flags & FAULT_FLAG_WRITE)) {
+		if (!(flags & FAULT_FLAG_WRITE) &&
+				transparent_hugepage_use_zero_page()) {
 			pgtable_t pgtable;
 			unsigned long zero_pfn;
 			pgtable = pte_alloc_one(mm, haddr);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
linux-next.patch
x86-convert-update_mmu_cache-and-update_mmu_cache_pmd-to-functions.patch

