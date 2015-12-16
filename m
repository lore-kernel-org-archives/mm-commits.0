From: akpm@linux-foundation.org
Subject: + list-introduce-list_del_poison.patch added to -mm tree
Date: Tue, 15 Dec 2015 16:17:12 -0800
Message-ID: <5670ad88.BEw477nn4Bx6OInI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbbLPARN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2015 19:17:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: list: introduce list_del_poison()
has been added to the -mm tree.  Its filename is
     list-introduce-list_del_poison.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/list-introduce-list_del_poison.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/list-introduce-list_del_poison.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: list: introduce list_del_poison()

ZONE_DEVICE pages always have an elevated count and will never be on an
lru reclaim list.  That space in 'struct page' can be redirected for other
uses, but for safety introduce a poison value that will always trip
__list_add() to assert.  This allows half of the struct list_head storage
to be reclaimed with some assurance to back up the assumption that the
page count never goes to zero and a list_add() is never attempted.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   17 +++++++++++++++++
 lib/list_debug.c     |    4 ++++
 2 files changed, 21 insertions(+)

diff -puN include/linux/list.h~list-introduce-list_del_poison include/linux/list.h
--- a/include/linux/list.h~list-introduce-list_del_poison
+++ a/include/linux/list.h
@@ -108,9 +108,26 @@ static inline void list_del(struct list_
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
+
+#define list_del_poison list_del
 #else
 extern void __list_del_entry(struct list_head *entry);
 extern void list_del(struct list_head *entry);
+extern struct list_head list_force_poison;
+
+/**
+ * list_del_poison - poison an entry to always assert on list_add
+ * @entry: the element to delete and poison
+ *
+ * Note: the assertion on list_add() only occurs when CONFIG_DEBUG_LIST=y,
+ * otherwise this is identical to list_del()
+ */
+static inline void list_del_poison(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->next = &list_force_poison;
+	entry->prev = &list_force_poison;
+}
 #endif
 
 /**
diff -puN lib/list_debug.c~list-introduce-list_del_poison lib/list_debug.c
--- a/lib/list_debug.c~list-introduce-list_del_poison
+++ a/lib/list_debug.c
@@ -12,6 +12,8 @@
 #include <linux/kernel.h>
 #include <linux/rculist.h>
 
+struct list_head list_force_poison;
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
@@ -23,6 +25,8 @@ void __list_add(struct list_head *new,
 			      struct list_head *prev,
 			      struct list_head *next)
 {
+	WARN(new->next == &list_force_poison || new->prev == &list_force_poison,
+		"list_add attempted on force-poisoned entry\n");
 	WARN(next->prev != prev,
 		"list_add corruption. next->prev should be "
 		"prev (%p), but was %p. (next=%p).\n",
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

scatterlist-fix-sg_phys-masking.patch
pmem-dax-clean-up-clear_pmem.patch
dax-increase-granularity-of-dax_clear_blocks-operations.patch
dax-guarantee-page-aligned-results-from-bdev_direct_access.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic.patch
dax-fix-lifetime-of-in-kernel-dax-mappings-with-dax_map_atomic-v3.patch
um-kill-pfn_t.patch
kvm-rename-pfn_t-to-kvm_pfn_t.patch
mm-dax-pmem-introduce-pfn_t.patch
mm-dax-pmem-introduce-pfn_t-v3.patch
mm-introduce-find_dev_pagemap.patch
x86-mm-introduce-vmem_altmap-to-augment-vmemmap_populate.patch
libnvdimm-pfn-pmem-allocate-memmap-array-in-persistent-memory.patch
avr32-convert-to-asm-generic-memory_modelh.patch
hugetlb-fix-compile-error-on-tile.patch
frv-fix-compiler-warning-from-definition-of-__pmd.patch
x86-mm-introduce-_page_devmap.patch
mm-dax-gpu-convert-vm_insert_mixed-to-pfn_t.patch
mm-dax-convert-vmf_insert_pfn_pmd-to-pfn_t.patch
list-introduce-list_del_poison.patch
libnvdimm-pmem-move-request_queue-allocation-earlier-in-probe.patch
mm-dax-pmem-introduce-getput_dev_pagemap-for-dax-gup.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd.patch
mm-x86-get_user_pages-for-dax-mappings.patch
dax-provide-diagnostics-for-pmd-mapping-failures.patch
dax-re-enable-dax-pmd-mappings.patch

