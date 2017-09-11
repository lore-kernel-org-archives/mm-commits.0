From: akpm@linux-foundation.org
Subject: [merged]
 mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
 removed from -mm tree
Date: Mon, 11 Sep 2017 12:39:03 -0700
Message-ID: <20170911193903.39GGsQKNB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbdIKTjF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, liubo95@huawei.com, mhairgrove@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, SCheung@nvidia.com, sgutti@nvidia.com, vdavydov.dev@gmail.com


The patch titled
     Subject: mm/ZONE_DEVICE: special case put_page() for device private pages
has been removed from the -mm tree.  Its filename was
     mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/ZONE_DEVICE: special case put_page() for device private pages

A ZONE_DEVICE page that reach a refcount of 1 is free ie no longer have
any user.  For device private pages this is important to catch and thus we
need to special case put_page() for this.

Link: http://lkml.kernel.org/r/20170817000548.32038-9-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   13 +++++++++++++
 include/linux/mm.h       |   31 ++++++++++++++++++++++---------
 kernel/memremap.c        |   25 ++++++++++++++++++++++++-
 mm/hmm.c                 |    8 ++++++++
 4 files changed, 67 insertions(+), 10 deletions(-)

diff -puN include/linux/memremap.h~mm-zone_device-special-case-put_page-for-device-private-pages-v4 include/linux/memremap.h
--- a/include/linux/memremap.h~mm-zone_device-special-case-put_page-for-device-private-pages-v4
+++ a/include/linux/memremap.h
@@ -126,6 +126,14 @@ struct dev_pagemap {
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap);
 struct dev_pagemap *find_dev_pagemap(resource_size_t phys);
+
+static inline bool is_zone_device_page(const struct page *page);
+
+static inline bool is_device_private_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page->pgmap->type == MEMORY_DEVICE_PRIVATE;
+}
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct resource *res, struct percpu_ref *ref,
@@ -144,6 +152,11 @@ static inline struct dev_pagemap *find_d
 {
 	return NULL;
 }
+
+static inline bool is_device_private_page(const struct page *page)
+{
+	return false;
+}
 #endif
 
 /**
diff -puN include/linux/mm.h~mm-zone_device-special-case-put_page-for-device-private-pages-v4 include/linux/mm.h
--- a/include/linux/mm.h~mm-zone_device-special-case-put_page-for-device-private-pages-v4
+++ a/include/linux/mm.h
@@ -23,6 +23,7 @@
 #include <linux/page_ext.h>
 #include <linux/err.h>
 #include <linux/page_ref.h>
+#include <linux/memremap.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -792,25 +793,25 @@ static inline bool is_zone_device_page(c
 {
 	return page_zonenum(page) == ZONE_DEVICE;
 }
-
-static inline bool is_device_private_page(const struct page *page)
-{
-	/* See MEMORY_DEVICE_PRIVATE in include/linux/memory_hotplug.h */
-	return ((page_zonenum(page) == ZONE_DEVICE) &&
-		(page->pgmap->type == MEMORY_DEVICE_PRIVATE));
-}
 #else
 static inline bool is_zone_device_page(const struct page *page)
 {
 	return false;
 }
+#endif
 
-static inline bool is_device_private_page(const struct page *page)
+#ifdef CONFIG_DEVICE_PRIVATE
+void put_zone_device_private_page(struct page *page);
+#else
+static inline void put_zone_device_private_page(struct page *page)
 {
-	return false;
 }
 #endif
 
+static inline bool is_device_private_page(const struct page *page);
+
+DECLARE_STATIC_KEY_FALSE(device_private_key);
+
 static inline void get_page(struct page *page)
 {
 	page = compound_head(page);
@@ -826,6 +827,18 @@ static inline void put_page(struct page
 {
 	page = compound_head(page);
 
+	/*
+	 * For private device pages we need to catch refcount transition from
+	 * 2 to 1, when refcount reach one it means the private device page is
+	 * free and we need to inform the device driver through callback. See
+	 * include/linux/memremap.h and HMM for details.
+	 */
+	if (static_branch_unlikely(&device_private_key) &&
+	    unlikely(is_device_private_page(page))) {
+		put_zone_device_private_page(page);
+		return;
+	}
+
 	if (put_page_testzero(page))
 		__put_page(page);
 }
diff -puN kernel/memremap.c~mm-zone_device-special-case-put_page-for-device-private-pages-v4 kernel/memremap.c
--- a/kernel/memremap.c~mm-zone_device-special-case-put_page-for-device-private-pages-v4
+++ a/kernel/memremap.c
@@ -11,7 +11,6 @@
  * General Public License for more details.
  */
 #include <linux/radix-tree.h>
-#include <linux/memremap.h>
 #include <linux/device.h>
 #include <linux/types.h>
 #include <linux/pfn_t.h>
@@ -500,3 +499,27 @@ struct vmem_altmap *to_vmem_altmap(unsig
 	return pgmap ? pgmap->altmap : NULL;
 }
 #endif /* CONFIG_ZONE_DEVICE */
+
+
+#ifdef CONFIG_DEVICE_PRIVATE
+void put_zone_device_private_page(struct page *page)
+{
+	int count = page_ref_dec_return(page);
+
+	/*
+	 * If refcount is 1 then page is freed and refcount is stable as nobody
+	 * holds a reference on the page.
+	 */
+	if (count == 1) {
+		/* Clear Active bit in case of parallel mark_page_accessed */
+		__ClearPageActive(page);
+		__ClearPageWaiters(page);
+
+		page->mapping = NULL;
+
+		page->pgmap->page_free(page, page->pgmap->data);
+	} else if (!count)
+		__put_page(page);
+}
+EXPORT_SYMBOL(put_zone_device_private_page);
+#endif /* CONFIG_DEVICE_PRIVATE */
diff -puN mm/hmm.c~mm-zone_device-special-case-put_page-for-device-private-pages-v4 mm/hmm.c
--- a/mm/hmm.c~mm-zone_device-special-case-put_page-for-device-private-pages-v4
+++ a/mm/hmm.c
@@ -25,9 +25,17 @@
 #include <linux/sched.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
+#include <linux/jump_label.h>
 #include <linux/mmu_notifier.h>
 
 
+/*
+ * Device private memory see HMM (Documentation/vm/hmm.txt) or hmm.h
+ */
+DEFINE_STATIC_KEY_FALSE(device_private_key);
+EXPORT_SYMBOL(device_private_key);
+
+
 #ifdef CONFIG_HMM
 static const struct mmu_notifier_ops hmm_mmu_notifier_ops;
 
_

Patches currently in -mm which might be from jglisse@redhat.com are


