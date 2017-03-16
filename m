From: akpm@linux-foundation.org
Subject: +
 mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch added to -mm tree
Date: Thu, 16 Mar 2017 13:51:44 -0700
Message-ID: <58cafae0.KVvEWDUwsSm4WOuO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52956 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753199AbdCPVDt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Mar 2017 17:03:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ZONE_DEVICE/x86: add support for un-addressable device memory
has been added to the -mm tree.  Its filename is
     mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zone_device-x86-add-support-for-un-addressable-device-memory.patch

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
Subject: mm/ZONE_DEVICE/x86: add support for un-addressable device memory

It does not need much, just skip populating kernel linear mapping for
range of un-addressable device memory (it is pick so that there is no
physical memory resource overlapping it).  All the logic is in share mm
code.

Only support x86-64 as this feature doesn't make much sense with
constrained virtual address space of 32bits architecture.

Link: http://lkml.kernel.org/r/1489680335-6594-6-git-send-email-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff -puN arch/x86/mm/init_64.c~mm-zone_device-x86-add-support-for-un-addressable-device-memory arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~mm-zone_device-x86-add-support-for-un-addressable-device-memory
+++ a/arch/x86/mm/init_64.c
@@ -644,7 +644,8 @@ static void  update_end_of_memory_vars(u
 int arch_add_memory(int nid, u64 start, u64 size, int flags)
 {
 	const int supported_flags = MEMORY_DEVICE |
-				    MEMORY_DEVICE_ALLOW_MIGRATE;
+				    MEMORY_DEVICE_ALLOW_MIGRATE |
+				    MEMORY_DEVICE_UNADDRESSABLE;
 	struct pglist_data *pgdat = NODE_DATA(nid);
 	struct zone *zone = pgdat->node_zones +
 		zone_for_memory(nid, start, size, ZONE_NORMAL,
@@ -659,7 +660,17 @@ int arch_add_memory(int nid, u64 start,
 		return -EINVAL;
 	}
 
-	init_memory_mapping(start, start + size);
+	/*
+	 * We get un-addressable memory when some one is adding a ZONE_DEVICE
+	 * to have struct page for a device memory which is not accessible by
+	 * the CPU so it is pointless to have a linear kernel mapping of such
+	 * memory.
+	 *
+	 * Core mm should make sure it never set a pte pointing to such fake
+	 * physical range.
+	 */
+	if (!(flags & MEMORY_DEVICE_UNADDRESSABLE))
+		init_memory_mapping(start, start + size);
 
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
@@ -958,7 +969,8 @@ kernel_physical_mapping_remove(unsigned
 int __ref arch_remove_memory(u64 start, u64 size, int flags)
 {
 	const int supported_flags = MEMORY_DEVICE |
-				    MEMORY_DEVICE_ALLOW_MIGRATE;
+				    MEMORY_DEVICE_ALLOW_MIGRATE |
+				    MEMORY_DEVICE_UNADDRESSABLE;
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct page *page = pfn_to_page(start_pfn);
@@ -979,7 +991,9 @@ int __ref arch_remove_memory(u64 start,
 	zone = page_zone(page);
 	ret = __remove_pages(zone, start_pfn, nr_pages);
 	WARN_ON_ONCE(ret);
-	kernel_physical_mapping_remove(start, start + size);
+
+	if (!(flags & MEMORY_DEVICE_UNADDRESSABLE))
+		kernel_physical_mapping_remove(start, start + size);
 
 	return ret;
 }
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

