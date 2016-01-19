From: akpm@linux-foundation.org
Subject: [merged] mm-skip-memory-block-registration-for-zone_device.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:13:24 -0800
Message-ID: <569e98e4.zKJ0FVJw11p/e5Ut%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44305 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbcASUNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: skip memory block registration for ZONE_DEVICE
has been removed from the -mm tree.  Its filename was
     mm-skip-memory-block-registration-for-zone_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: skip memory block registration for ZONE_DEVICE

Prevent userspace from trying and failing to online ZONE_DEVICE pages
which are meant to never be onlined.

For example on platforms with a udev rule like the following:

  SUBSYSTEM=="memory", ACTION=="add", ATTR{state}=="offline", ATTR{state}="online"

...will generate futile attempts to online the ZONE_DEVICE sections.
Example kernel messages:

    Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1004747
    Policy zone: Normal
    online_pages [mem 0x248000000-0x24fffffff] failed

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   13 +++++++++++++
 include/linux/mm.h    |   12 ++++++++++++
 2 files changed, 25 insertions(+)

diff -puN drivers/base/memory.c~mm-skip-memory-block-registration-for-zone_device drivers/base/memory.c
--- a/drivers/base/memory.c~mm-skip-memory-block-registration-for-zone_device
+++ a/drivers/base/memory.c
@@ -647,6 +647,13 @@ static int add_memory_block(int base_sec
 	return 0;
 }
 
+static bool is_zone_device_section(struct mem_section *ms)
+{
+	struct page *page;
+
+	page = sparse_decode_mem_map(ms->section_mem_map, __section_nr(ms));
+	return is_zone_device_page(page);
+}
 
 /*
  * need an interface for the VM to add new memory regions,
@@ -657,6 +664,9 @@ int register_new_memory(int nid, struct
 	int ret = 0;
 	struct memory_block *mem;
 
+	if (is_zone_device_section(section))
+		return 0;
+
 	mutex_lock(&mem_sysfs_mutex);
 
 	mem = find_memory_block(section);
@@ -693,6 +703,9 @@ static int remove_memory_section(unsigne
 {
 	struct memory_block *mem;
 
+	if (is_zone_device_section(section))
+		return 0;
+
 	mutex_lock(&mem_sysfs_mutex);
 	mem = find_memory_block(section);
 	unregister_mem_sect_under_nodes(mem, __section_nr(section));
diff -puN include/linux/mm.h~mm-skip-memory-block-registration-for-zone_device include/linux/mm.h
--- a/include/linux/mm.h~mm-skip-memory-block-registration-for-zone_device
+++ a/include/linux/mm.h
@@ -674,6 +674,18 @@ static inline enum zone_type page_zonenu
 	return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
 }
 
+#ifdef CONFIG_ZONE_DEVICE
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return page_zonenum(page) == ZONE_DEVICE;
+}
+#else
+static inline bool is_zone_device_page(const struct page *page)
+{
+	return false;
+}
+#endif
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

dax-add-support-for-fsync-sync-v6-fix.patch

