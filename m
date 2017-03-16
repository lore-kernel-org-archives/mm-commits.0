From: akpm@linux-foundation.org
Subject: +
 mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch added to -mm tree
Date: Thu, 16 Mar 2017 13:51:31 -0700
Message-ID: <58cafad3.MIMy5/GGSK6Vs+Ac%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752253AbdCPVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, benh@kernel.crashing.org, cmetcalf@mellanox.com, dalias@libc.org, heiko.carstens@de.ibm.com, hpa@zytor.com, linux@armlinux.org.uk, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, schwidefsky@de.ibm.com, tglx@linutronix.de, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory/hotplug: convert device bool to int to allow for more flags
has been added to the -mm tree.  Its filename is
     mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3.patch

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
Subject: mm/memory/hotplug: convert device bool to int to allow for more flags

Patch series "HMM (Heterogeneous Memory Management)", v18.


This patch (of 16):

When hotpluging memory we want more informations on the type of memory and
its properties.  Replace the device boolean flag by an int and define a
set of flags.

New property for device memory is an opt-in flag to allow page migration
from and to a ZONE_DEVICE.  Existing user of ZONE_DEVICE are not expecting
page migration to work for their pages.  New changes to page migration i
changing that and we now need a flag to explicitly opt-in page migration.

Link: http://lkml.kernel.org/r/1489680335-6594-2-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c            |   23 ++++++++++++++++++++---
 arch/powerpc/mm/mem.c          |   23 +++++++++++++++++++----
 arch/s390/mm/init.c            |   10 ++++++++--
 arch/sh/mm/init.c              |   22 +++++++++++++++++++---
 arch/tile/mm/init.c            |   10 ++++++++--
 arch/x86/mm/init_32.c          |   23 ++++++++++++++++++++---
 arch/x86/mm/init_64.c          |   23 ++++++++++++++++++++---
 include/linux/memory_hotplug.h |   24 ++++++++++++++++++++++--
 include/linux/memremap.h       |   13 +++++++++++++
 kernel/memremap.c              |    5 +++--
 mm/memory_hotplug.c            |    4 ++--
 11 files changed, 154 insertions(+), 26 deletions(-)

diff -puN arch/ia64/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/ia64/mm/init.c
@@ -646,18 +646,27 @@ mem_init (void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	pg_data_t *pgdat;
 	struct zone *zone;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	pgdat = NODE_DATA(nid);
 
 	zone = pgdat->node_zones +
-		zone_for_memory(nid, start, size, ZONE_NORMAL, for_device);
+		zone_for_memory(nid, start, size, ZONE_NORMAL,
+				flags & MEMORY_DEVICE);
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 
 	if (ret)
@@ -668,13 +677,21 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
+int arch_remove_memory(u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotremove unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	zone = page_zone(pfn_to_page(start_pfn));
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	if (ret)
diff -puN arch/powerpc/mm/mem.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/powerpc/mm/mem.c
--- a/arch/powerpc/mm/mem.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/powerpc/mm/mem.c
@@ -126,16 +126,23 @@ int __weak remove_section_mapping(unsign
 	return -ENODEV;
 }
 
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	struct pglist_data *pgdata;
 	struct zone *zone;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int rc;
 
-	resize_hpt_for_hotplug(memblock_phys_mem_size());
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
 
+	resize_hpt_for_hotplug(memblock_phys_mem_size());
 	pgdata = NODE_DATA(nid);
 
 	start = (unsigned long)__va(start);
@@ -149,19 +156,27 @@ int arch_add_memory(int nid, u64 start,
 
 	/* this should work for most non-highmem platforms */
 	zone = pgdata->node_zones +
-		zone_for_memory(nid, start, size, 0, for_device);
+		zone_for_memory(nid, start, size, 0, flags & MEMORY_DEVICE);
 
 	return __add_pages(nid, zone, start_pfn, nr_pages);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
+int arch_remove_memory(u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotremove unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	zone = page_zone(pfn_to_page(start_pfn));
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	if (ret)
diff -puN arch/s390/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/s390/mm/init.c
--- a/arch/s390/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/s390/mm/init.c
@@ -161,7 +161,7 @@ unsigned long memory_block_size_bytes(vo
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
 	unsigned long zone_start_pfn, zone_end_pfn, nr_pages;
 	unsigned long start_pfn = PFN_DOWN(start);
@@ -170,6 +170,12 @@ int arch_add_memory(int nid, u64 start,
 	struct zone *zone;
 	int rc, i;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	rc = vmem_add_mapping(start, size);
 	if (rc)
 		return rc;
@@ -204,7 +210,7 @@ int arch_add_memory(int nid, u64 start,
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
+int arch_remove_memory(u64 start, u64 size, int flags)
 {
 	/*
 	 * There is no hardware or firmware interface which could trigger a
diff -puN arch/sh/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/sh/mm/init.c
@@ -485,19 +485,27 @@ void free_initrd_mem(unsigned long start
 #endif
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	pg_data_t *pgdat;
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	pgdat = NODE_DATA(nid);
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
 	ret = __add_pages(nid, pgdat->node_zones +
 			zone_for_memory(nid, start, size, ZONE_NORMAL,
-			for_device),
+					flags & MEMORY_DEVICE),
 			start_pfn, nr_pages);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
@@ -516,13 +524,21 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 #endif
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
+int arch_remove_memory(u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	unsigned long start_pfn = PFN_DOWN(start);
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotremove unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	zone = page_zone(pfn_to_page(start_pfn));
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	if (unlikely(ret))
diff -puN arch/tile/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/tile/mm/init.c
@@ -863,13 +863,19 @@ void __init mem_init(void)
  * memory to the highmem for now.
  */
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-int arch_add_memory(u64 start, u64 size, bool for_device)
+int arch_add_memory(u64 start, u64 size, int flags)
 {
 	struct pglist_data *pgdata = &contig_page_data;
 	struct zone *zone = pgdata->node_zones + MAX_NR_ZONES-1;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	return __add_pages(zone, start_pfn, nr_pages);
 }
 
@@ -879,7 +885,7 @@ int remove_memory(u64 start, u64 size)
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
+int arch_remove_memory(u64 start, u64 size, int flags)
 {
 	/* TODO */
 	return -EBUSY;
diff -puN arch/x86/mm/init_32.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/x86/mm/init_32.c
@@ -816,24 +816,41 @@ void __init mem_init(void)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	struct pglist_data *pgdata = NODE_DATA(nid);
 	struct zone *zone = pgdata->node_zones +
-		zone_for_memory(nid, start, size, ZONE_HIGHMEM, for_device);
+		zone_for_memory(nid, start, size, ZONE_HIGHMEM,
+				flags & MEMORY_DEVICE);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	return __add_pages(nid, zone, start_pfn, nr_pages);
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-int arch_remove_memory(u64 start, u64 size)
+int arch_remove_memory(u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct zone *zone;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotremove unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	zone = page_zone(pfn_to_page(start_pfn));
 	return __remove_pages(zone, start_pfn, nr_pages);
 }
diff -puN arch/x86/mm/init_64.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/arch/x86/mm/init_64.c
@@ -641,15 +641,24 @@ static void  update_end_of_memory_vars(u
  * Memory is added always to NORMAL zone. This means you will never get
  * additional DMA/DMA32 memory.
  */
-int arch_add_memory(int nid, u64 start, u64 size, bool for_device)
+int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *zone = pgdat->node_zones +
-		zone_for_memory(nid, start, size, ZONE_NORMAL, for_device);
+		zone_for_memory(nid, start, size, ZONE_NORMAL,
+				flags & MEMORY_DEVICE);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotplug unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	init_memory_mapping(start, start + size);
 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
@@ -946,8 +955,10 @@ kernel_physical_mapping_remove(unsigned
 	remove_pagetable(start, end, true);
 }
 
-int __ref arch_remove_memory(u64 start, u64 size)
+int __ref arch_remove_memory(u64 start, u64 size, int flags)
 {
+	const int supported_flags = MEMORY_DEVICE |
+				    MEMORY_DEVICE_ALLOW_MIGRATE;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct page *page = pfn_to_page(start_pfn);
@@ -955,6 +966,12 @@ int __ref arch_remove_memory(u64 start,
 	struct zone *zone;
 	int ret;
 
+	/* Each flag need special handling so error out on un-supported flag */
+	if (flags & (~supported_flags)) {
+		pr_err("hotremove unsupported memory type 0x%08x\n", flags);
+		return -EINVAL;
+	}
+
 	/* With altmap the first mapped page is offset from @start */
 	altmap = to_vmem_altmap((unsigned long) page);
 	if (altmap)
diff -puN include/linux/memory_hotplug.h~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/include/linux/memory_hotplug.h
@@ -104,7 +104,7 @@ extern bool memhp_auto_online;
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
 extern bool is_pageblock_removable_nolock(struct page *page);
-extern int arch_remove_memory(u64 start, u64 size);
+extern int arch_remove_memory(u64 start, u64 size, int flags);
 extern int __remove_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
@@ -276,7 +276,27 @@ extern int add_memory(int nid, u64 start
 extern int add_memory_resource(int nid, struct resource *resource, bool online);
 extern int zone_for_memory(int nid, u64 start, u64 size, int zone_default,
 		bool for_device);
-extern int arch_add_memory(int nid, u64 start, u64 size, bool for_device);
+
+/*
+ * When hotpluging memory with arch_add_memory() we want more informations on
+ * the type of memory and its properties. The flags parameter allow to provide
+ * more informations on the memory which is being addedd.
+ *
+ * Provide an opt-in flag for struct page migration. Persistent device memory
+ * never relied on struct page migration so far and new user of might also
+ * prefer avoiding struct page migration.
+ *
+ * New non device memory specific flags can be added if ever needed.
+ *
+ * MEMORY_REGULAR: regular system memory
+ * DEVICE_MEMORY: device memory create a ZONE_DEVICE zone for it
+ * DEVICE_MEMORY_ALLOW_MIGRATE: page in that device memory ca be migrated
+ */
+#define MEMORY_NORMAL 0
+#define MEMORY_DEVICE (1 << 0)
+#define MEMORY_DEVICE_ALLOW_MIGRATE (1 << 1)
+
+extern int arch_add_memory(int nid, u64 start, u64 size, int flags);
 extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages);
 extern bool is_memblock_offlined(struct memory_block *mem);
 extern void remove_memory(int nid, u64 start, u64 size);
diff -puN include/linux/memremap.h~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 include/linux/memremap.h
--- a/include/linux/memremap.h~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/include/linux/memremap.h
@@ -41,18 +41,26 @@ static inline struct vmem_altmap *to_vme
  * @res: physical address range covered by @ref
  * @ref: reference count that pins the devm_memremap_pages() mapping
  * @dev: host device of the mapping for debug
+ * @flags: memory flags see MEMORY_* in memory_hotplug.h
  */
 struct dev_pagemap {
 	struct vmem_altmap *altmap;
 	const struct resource *res;
 	struct percpu_ref *ref;
 	struct device *dev;
+	int flags;
 };
 
 #ifdef CONFIG_ZONE_DEVICE
 void *devm_memremap_pages(struct device *dev, struct resource *res,
 		struct percpu_ref *ref, struct vmem_altmap *altmap);
 struct dev_pagemap *find_dev_pagemap(resource_size_t phys);
+
+static inline bool dev_page_allow_migrate(const struct page *page)
+{
+	return ((page_zonenum(page) == ZONE_DEVICE) &&
+		(page->pgmap->flags & MEMORY_DEVICE_ALLOW_MIGRATE));
+}
 #else
 static inline void *devm_memremap_pages(struct device *dev,
 		struct resource *res, struct percpu_ref *ref,
@@ -71,6 +79,11 @@ static inline struct dev_pagemap *find_d
 {
 	return NULL;
 }
+
+static inline bool dev_page_allow_migrate(const struct page *page)
+{
+	return false;
+}
 #endif
 
 /**
diff -puN kernel/memremap.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 kernel/memremap.c
--- a/kernel/memremap.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/kernel/memremap.c
@@ -248,7 +248,7 @@ static void devm_memremap_pages_release(
 	align_size = ALIGN(resource_size(res), SECTION_SIZE);
 
 	mem_hotplug_begin();
-	arch_remove_memory(align_start, align_size);
+	arch_remove_memory(align_start, align_size, MEMORY_DEVICE);
 	mem_hotplug_done();
 
 	untrack_pfn(NULL, PHYS_PFN(align_start), align_size);
@@ -326,6 +326,7 @@ void *devm_memremap_pages(struct device
 	}
 	pgmap->ref = ref;
 	pgmap->res = &page_map->res;
+	pgmap->flags = MEMORY_DEVICE;
 
 	mutex_lock(&pgmap_lock);
 	error = 0;
@@ -363,7 +364,7 @@ void *devm_memremap_pages(struct device
 		goto err_pfn_remap;
 
 	mem_hotplug_begin();
-	error = arch_add_memory(nid, align_start, align_size, true);
+	error = arch_add_memory(nid, align_start, align_size, MEMORY_DEVICE);
 	mem_hotplug_done();
 	if (error)
 		goto err_add_memory;
diff -puN mm/memory_hotplug.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3 mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory-hotplug-convert-device-bool-to-int-to-allow-for-more-flags-v3
+++ a/mm/memory_hotplug.c
@@ -1385,7 +1385,7 @@ int __ref add_memory_resource(int nid, s
 	}
 
 	/* call arch's memory hotadd */
-	ret = arch_add_memory(nid, start, size, false);
+	ret = arch_add_memory(nid, start, size, MEMORY_NORMAL);
 
 	if (ret < 0)
 		goto error;
@@ -2189,7 +2189,7 @@ void __ref remove_memory(int nid, u64 st
 	memblock_free(start, size);
 	memblock_remove(start, size);
 
-	arch_remove_memory(start, size);
+	arch_remove_memory(start, size, MEMORY_NORMAL);
 
 	try_offline_node(nid);
 
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

