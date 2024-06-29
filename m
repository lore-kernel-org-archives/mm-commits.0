Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083AA7494
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628211; cv=none; b=hSllBgQVM5MbUoJcjMvnDNK8tndtQJjHUvmW/ffhaFfwfmEMnlHU25raIbCqs6CWGfuMmuj52LuFBB49VJWs2weW0yd69EmtTFhUdGtzRgafQOuz14DCX8dYMzPrAFy08Uo25jQtDocFxABLVbkRqOi03dJl2IhXyi0RlI4LYyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628211; c=relaxed/simple;
	bh=y03doohkdVJSMBdmNzwM8K/599Y3IitRYOxXm36z4zg=;
	h=Date:To:From:Subject:Message-Id; b=JrYZdeN/k7WSn1xBJ95xNFHr6PbkBsFEe1NJS4cmTU+DQtQyMzvsJepH/bPDwdhAaHTPZfswF1RWSA2E0CfvWkGn9xBPb61YzXjTttwq/3c84XNCPPQdUjV2wP9YhsZBKvtxlYqORdMXfvHAwJAFoeZW6h0+PZW8KAHjGydTvV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q5TX3YGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q5TX3YGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898EEC32786;
	Sat, 29 Jun 2024 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628209;
	bh=y03doohkdVJSMBdmNzwM8K/599Y3IitRYOxXm36z4zg=;
	h=Date:To:From:Subject:From;
	b=q5TX3YGcKpvCjD2Qe/+aVI7Un06MZ44WQQVql4unEj+30TZR5XxoIUc11yEEjngFx
	 nXJ0j2CcKXFq9uwmhjhzpQTKT5GtEjSyObn2DgsjzfP9qQ4Pr5GzXs63IYMtP9XbMy
	 Om8LFX1sNRCuDm416Fs8MgwQFWhDw8gsOZsmIb1c=
Date: Fri, 28 Jun 2024 19:30:09 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,sstabellini@kernel.org,rppt@kernel.org,osalvador@suse.de,oleksandr_tyshchenko@epam.com,mst@redhat.com,kys@microsoft.com,jgross@suse.com,jasowang@redhat.com,haiyangz@microsoft.com,glider@google.com,eperezma@redhat.com,elver@google.com,dvyukov@google.com,decui@microsoft.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch removed from -mm tree
Message-Id: <20240629023009.898EEC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory_hotplug: skip adjust_managed_page_count() for PageOffline() pages when offlining
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory_hotplug: skip adjust_managed_page_count() for PageOffline() pages when offlining
Date: Fri, 7 Jun 2024 11:09:38 +0200

We currently have a hack for virtio-mem in place to handle memory
offlining with PageOffline pages for which we already adjusted the managed
page count.

Let's enlighten memory offlining code so we can get rid of that hack, and
document the situation.

Link: https://lkml.kernel.org/r/20240607090939.89524-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Marco Elver <elver@google.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_mem.c    |   11 ++---------
 include/linux/memory_hotplug.h |    4 ++--
 include/linux/page-flags.h     |    8 ++++++--
 mm/memory_hotplug.c            |    6 +++---
 mm/page_alloc.c                |   12 ++++++++++--
 5 files changed, 23 insertions(+), 18 deletions(-)

--- a/drivers/virtio/virtio_mem.c~mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining
+++ a/drivers/virtio/virtio_mem.c
@@ -1269,12 +1269,6 @@ static void virtio_mem_fake_offline_goin
 	struct page *page;
 	unsigned long i;
 
-	/*
-	 * Drop our reference to the pages so the memory can get offlined
-	 * and add the unplugged pages to the managed page counters (so
-	 * offlining code can correctly subtract them again).
-	 */
-	adjust_managed_page_count(pfn_to_page(pfn), nr_pages);
 	/* Drop our reference to the pages so the memory can get offlined. */
 	for (i = 0; i < nr_pages; i++) {
 		page = pfn_to_page(pfn + i);
@@ -1293,10 +1287,9 @@ static void virtio_mem_fake_offline_canc
 	unsigned long i;
 
 	/*
-	 * Get the reference we dropped when going offline and subtract the
-	 * unplugged pages from the managed page counters.
+	 * Get the reference again that we dropped via page_ref_dec_and_test()
+	 * when going offline.
 	 */
-	adjust_managed_page_count(pfn_to_page(pfn), -nr_pages);
 	for (i = 0; i < nr_pages; i++)
 		page_ref_inc(pfn_to_page(pfn + i));
 }
--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining
+++ a/include/linux/memory_hotplug.h
@@ -175,8 +175,8 @@ extern int mhp_init_memmap_on_memory(uns
 extern void mhp_deinit_memmap_on_memory(unsigned long pfn, unsigned long nr_pages);
 extern int online_pages(unsigned long pfn, unsigned long nr_pages,
 			struct zone *zone, struct memory_group *group);
-extern void __offline_isolated_pages(unsigned long start_pfn,
-				     unsigned long end_pfn);
+extern unsigned long __offline_isolated_pages(unsigned long start_pfn,
+		unsigned long end_pfn);
 
 typedef void (*online_page_callback_t)(struct page *page, unsigned int order);
 
--- a/include/linux/page-flags.h~mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining
+++ a/include/linux/page-flags.h
@@ -1023,11 +1023,15 @@ PAGE_TYPE_OPS(Buddy, buddy, buddy)
  * putting them back to the buddy, it can do so via the memory notifier by
  * decrementing the reference count in MEM_GOING_OFFLINE and incrementing the
  * reference count in MEM_CANCEL_OFFLINE. When offlining, the PageOffline()
- * pages (now with a reference count of zero) are treated like free pages,
- * allowing the containing memory block to get offlined. A driver that
+ * pages (now with a reference count of zero) are treated like free (unmanaged)
+ * pages, allowing the containing memory block to get offlined. A driver that
  * relies on this feature is aware that re-onlining the memory block will
  * require not giving them to the buddy via generic_online_page().
  *
+ * Memory offlining code will not adjust the managed page count for any
+ * PageOffline() pages, treating them like they were never exposed to the
+ * buddy using generic_online_page().
+ *
  * There are drivers that mark a page PageOffline() and expect there won't be
  * any further access to page content. PFN walkers that read content of random
  * pages should check PageOffline() and synchronize with such drivers using
--- a/mm/memory_hotplug.c~mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining
+++ a/mm/memory_hotplug.c
@@ -1942,7 +1942,7 @@ int __ref offline_pages(unsigned long st
 			struct zone *zone, struct memory_group *group)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn, system_ram_pages = 0;
+	unsigned long pfn, managed_pages, system_ram_pages = 0;
 	const int node = zone_to_nid(zone);
 	unsigned long flags;
 	struct memory_notify arg;
@@ -2063,7 +2063,7 @@ int __ref offline_pages(unsigned long st
 	} while (ret);
 
 	/* Mark all sections offline and remove free pages from the buddy. */
-	__offline_isolated_pages(start_pfn, end_pfn);
+	managed_pages = __offline_isolated_pages(start_pfn, end_pfn);
 	pr_debug("Offlined Pages %ld\n", nr_pages);
 
 	/*
@@ -2079,7 +2079,7 @@ int __ref offline_pages(unsigned long st
 	zone_pcp_enable(zone);
 
 	/* removal success */
-	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
+	adjust_managed_page_count(pfn_to_page(start_pfn), -managed_pages);
 	adjust_present_page_count(pfn_to_page(start_pfn), group, -nr_pages);
 
 	/* reinitialise watermarks and update pcp limits */
--- a/mm/page_alloc.c~mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining
+++ a/mm/page_alloc.c
@@ -6715,14 +6715,19 @@ void zone_pcp_reset(struct zone *zone)
 /*
  * All pages in the range must be in a single zone, must not contain holes,
  * must span full sections, and must be isolated before calling this function.
+ *
+ * Returns the number of managed (non-PageOffline()) pages in the range: the
+ * number of pages for which memory offlining code must adjust managed page
+ * counters using adjust_managed_page_count().
  */
-void __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
+unsigned long __offline_isolated_pages(unsigned long start_pfn,
+		unsigned long end_pfn)
 {
+	unsigned long already_offline = 0, flags;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
 	unsigned int order;
-	unsigned long flags;
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
@@ -6744,6 +6749,7 @@ void __offline_isolated_pages(unsigned l
 		if (PageOffline(page)) {
 			BUG_ON(page_count(page));
 			BUG_ON(PageBuddy(page));
+			already_offline++;
 			pfn++;
 			continue;
 		}
@@ -6756,6 +6762,8 @@ void __offline_isolated_pages(unsigned l
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
+
+	return end_pfn - start_pfn - already_offline;
 }
 #endif
 
_

Patches currently in -mm which might be from david@redhat.com are


