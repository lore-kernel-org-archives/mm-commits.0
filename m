From: akpm@linux-foundation.org
Subject: [merged] thp-add-debugfs-handle-to-split-all-huge-pages.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:12:14 -0800
Message-ID: <569e989e.y247MALObD9i0Nu8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354AbcASUMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:12:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: add debugfs handle to split all huge pages
has been removed from the -mm tree.  Its filename was
     thp-add-debugfs-handle-to-split-all-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: add debugfs handle to split all huge pages

Writing 1 into 'split_huge_pages' will try to find and split all huge
pages in the system.  This is useful for debuging.

[akpm@linux-foundation.org: fix printk text, per Vlastimil]
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   59 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff -puN mm/huge_memory.c~thp-add-debugfs-handle-to-split-all-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-add-debugfs-handle-to-split-all-huge-pages
+++ a/mm/huge_memory.c
@@ -23,6 +23,7 @@
 #include <linux/freezer.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
+#include <linux/debugfs.h>
 #include <linux/migrate.h>
 #include <linux/hashtable.h>
 #include <linux/userfaultfd_k.h>
@@ -3350,3 +3351,61 @@ static struct shrinker deferred_split_sh
 	.scan_objects = deferred_split_scan,
 	.seeks = DEFAULT_SEEKS,
 };
+
+#ifdef CONFIG_DEBUG_FS
+static int split_huge_pages_set(void *data, u64 val)
+{
+	struct zone *zone;
+	struct page *page;
+	unsigned long pfn, max_zone_pfn;
+	unsigned long total = 0, split = 0;
+
+	if (val != 1)
+		return -EINVAL;
+
+	for_each_populated_zone(zone) {
+		max_zone_pfn = zone_end_pfn(zone);
+		for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++) {
+			if (!pfn_valid(pfn))
+				continue;
+
+			page = pfn_to_page(pfn);
+			if (!get_page_unless_zero(page))
+				continue;
+
+			if (zone != page_zone(page))
+				goto next;
+
+			if (!PageHead(page) || !PageAnon(page) ||
+					PageHuge(page))
+				goto next;
+
+			total++;
+			lock_page(page);
+			if (!split_huge_page(page))
+				split++;
+			unlock_page(page);
+next:
+			put_page(page);
+		}
+	}
+
+	pr_info("%lu of %lu THP split", split, total);
+
+	return 0;
+}
+DEFINE_SIMPLE_ATTRIBUTE(split_huge_pages_fops, NULL, split_huge_pages_set,
+		"%llu\n");
+
+static int __init split_huge_pages_debugfs(void)
+{
+	void *ret;
+
+	ret = debugfs_create_file("split_huge_pages", 0644, NULL, NULL,
+			&split_huge_pages_fops);
+	if (!ret)
+		pr_warn("Failed to create split_huge_pages in debugfs");
+	return 0;
+}
+late_initcall(split_huge_pages_debugfs);
+#endif
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

