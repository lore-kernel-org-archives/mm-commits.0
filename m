From: akpm@linux-foundation.org
Subject: + mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
 added to -mm tree
Date: Thu, 16 Mar 2017 13:51:38 -0700
Message-ID: <58cafada.nIk4rkTxfr6uAgVS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54906 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbdCPVRU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:17:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, dan.j.williams@intel.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ZONE_DEVICE/free-page: callback when page is freed
has been added to the -mm tree.  Its filename is
     mm-zone_device-free-page-callback-when-page-is-freed-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zone_device-free-page-callback-when-page-is-freed-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/ZONE_DEVICE/free-page: callback when page is freed

When a ZONE_DEVICE page refcount reach 1 it means it is free and nobody
is holding a reference on it (only device to which the memory belong do).
Add a callback and call it when that happen so device driver can implement
their own free page management.

Link: http://lkml.kernel.org/r/1489680335-6594-4-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    6 ++++++
 kernel/memremap.c        |   11 ++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN include/linux/memremap.h~mm-zone_device-free-page-callback-when-page-is-freed-v3 include/linux/memremap.h
--- a/include/linux/memremap.h~mm-zone_device-free-page-callback-when-page-is-freed-v3
+++ a/include/linux/memremap.h
@@ -35,19 +35,25 @@ static inline struct vmem_altmap *to_vme
 }
 #endif
 
+typedef void (*dev_page_free_t)(struct page *page, void *data);
+
 /**
  * struct dev_pagemap - metadata for ZONE_DEVICE mappings
+ * @page_free: free page callback when page refcount reach 1
  * @altmap: pre-allocated/reserved memory for vmemmap allocations
  * @res: physical address range covered by @ref
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @dev: host device of the mapping for debug
+ * @data: privata data pointer for page_free
  * @flags: memory flags see MEMORY_* in memory_hotplug.h
  */
 struct dev_pagemap {
+	dev_page_free_t page_free;
 	struct vmem_altmap *altmap;
 	const struct resource *res;
 	struct percpu_ref *ref;
 	struct device *dev;
+	void *data;
 	int flags;
 };
 
diff -puN kernel/memremap.c~mm-zone_device-free-page-callback-when-page-is-freed-v3 kernel/memremap.c
--- a/kernel/memremap.c~mm-zone_device-free-page-callback-when-page-is-freed-v3
+++ a/kernel/memremap.c
@@ -190,7 +190,14 @@ EXPORT_SYMBOL(get_zone_device_page);
 
 void put_zone_device_page(struct page *page)
 {
-	page_ref_dec(page);
+	int count = page_ref_dec_return(page);
+
+	/*
+	 * If refcount is 1 then page is freed and refcount is stable as nobody
+	 * holds a reference on the page.
+	 */
+	if (page->pgmap->page_free && count == 1)
+		page->pgmap->page_free(page, page->pgmap->data);
 
 	put_dev_pagemap(page->pgmap);
 }
@@ -329,6 +336,8 @@ void *devm_memremap_pages(struct device
 	pgmap->ref = ref;
 	pgmap->res = &page_map->res;
 	pgmap->flags = MEMORY_DEVICE;
+	pgmap->page_free = NULL;
+	pgmap->data = NULL;
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
_

Patches currently in -mm which might be from jglisse@redhat.com are

mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
mm-put_page-move-ref-decrement-to-put_zone_device_page.patch
mm-zone_device-free-page-callback-when-page-is-freed-v3.patch
mm-zone_device-unaddressable-add-support-for-un-addressable-device-memory-v3.patch
mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
mm-migrate-add-new-boolean-copy-flag-to-migratepage-callback.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v4.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v2.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-hmm-migrate-support-un-addressable-zone_device-page-in-migration.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v2.patch

