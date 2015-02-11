From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch removed from -mm tree
Date: Wed, 11 Feb 2015 12:23:11 -0800
Message-ID: <54dbba2f./p4ftr72TgUngtrl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbbBKUXM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:23:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.ryabinin@samsung.com, dvyukov@google.com, manfred@colorfullife.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: hugetlb: fix type of hugetlb_treat_as_movable variable
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: mm: hugetlb: fix type of hugetlb_treat_as_movable variable

hugetlb_treat_as_movable declared as unsigned long, but
proc_dointvec() used for parsing it:

static struct ctl_table vm_table[] = {
...
	{
		.procname	= "hugepages_treat_as_movable",
		.data		= &hugepages_treat_as_movable,
		.maxlen		= sizeof(int),
		.mode		= 0644,
		.proc_handler	= proc_dointvec,
	},

This seems harmless, but it's better to use int type here.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 mm/hugetlb.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable
+++ a/include/linux/hugetlb.h
@@ -86,7 +86,7 @@ void free_huge_page(struct page *page);
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
 #endif
 
-extern unsigned long hugepages_treat_as_movable;
+extern int hugepages_treat_as_movable;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages;
 
diff -puN mm/hugetlb.c~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-type-of-hugetlb_treat_as_movable-variable
+++ a/mm/hugetlb.c
@@ -35,7 +35,7 @@
 #include <linux/node.h>
 #include "internal.h"
 
-unsigned long hugepages_treat_as_movable;
+int hugepages_treat_as_movable;
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
_

Patches currently in -mm which might be from a.ryabinin@samsung.com are

origin.patch
proc-pagemap-walk-page-tables-under-pte-lock.patch
module_device_table-fix-some-callsites.patch
compiler-introduce-__aliassymbol-shortcut.patch
add-kernel-address-sanitizer-infrastructure.patch
add-kernel-address-sanitizer-infrastructure-fix.patch
kasan-disable-memory-hotplug.patch
x86_64-add-kasan-support.patch
x86_64-add-kasan-support-fix.patch
mm-page_alloc-add-kasan-hooks-on-alloc-and-free-paths.patch
mm-slub-introduce-virt_to_obj-function.patch
mm-slub-share-object_err-function.patch
mm-slub-introduce-metadata_access_enable-metadata_access_disable.patch
mm-slub-add-kernel-address-sanitizer-support-for-slub-allocator.patch
fs-dcache-manually-unpoison-dname-after-allocation-to-shut-up-kasans-reports.patch
kmemleak-disable-kasan-instrumentation-for-kmemleak.patch
lib-add-kasan-test-module.patch
x86_64-kasan-add-interceptors-for-memset-memmove-memcpy-functions.patch
kasan-enable-stack-instrumentation.patch
mm-vmalloc-add-flag-preventing-guard-hole-allocation.patch
mm-vmalloc-pass-additional-vm_flags-to-__vmalloc_node_range.patch
kernel-add-support-for-init_array-constructors.patch
module-fix-types-of-device-tables-aliases.patch
kasan-enable-instrumentation-of-global-variables.patch
kasan-enable-instrumentation-of-global-variables-fix.patch
kasan-enable-instrumentation-of-global-variables-fix-2.patch
kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch
linux-next.patch

