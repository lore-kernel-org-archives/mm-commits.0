Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FC7155327
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 22:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717799029; cv=none; b=SmB0+/VgfyWdpLM8JdPKB2EjIfcjsEOj/GJQAsE+6m9YMFInzCsEsTv6f3IXrvYgIArirnX3/mbRyBuQ26XLkoKIMf75GJgLH9kYzdKM3z4Rb5aNoMJ00bliL6bC9YoGoubpK4zRZupSEvaBjXKtqLxr8BdZ6SU1IxVPHjWGPhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717799029; c=relaxed/simple;
	bh=t94nNrA0jU2SkkJzp+BVsEyiItD7zb0MWVhXttC4mQ4=;
	h=Date:To:From:Subject:Message-Id; b=UsX2pUswlej1PyAIEVth36HiAa8Ncv46U+UOiSeaBA4R99mNsKWd+ELFHANrDbzaesZlzjIDu4EZEA85+uI+olFKNxGGTxy2nUpsLZitXS04j4HOxa0VptE7TzrBnLYuVhtCGGZC5dBZbEzFANxThZ3P7ILeLFDE7y8AB+49joI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B1Wq6gL4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B1Wq6gL4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1DF6C2BBFC;
	Fri,  7 Jun 2024 22:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717799029;
	bh=t94nNrA0jU2SkkJzp+BVsEyiItD7zb0MWVhXttC4mQ4=;
	h=Date:To:From:Subject:From;
	b=B1Wq6gL4L/dSEgy7zBB/HdgHeUj2M+B0fieZzgIDTFtmLhWhGksUz2WPxe95gagMa
	 G0x/kHSLZw/j8ShpviAedi3Iab2mA3LknPMNZJnX4NSvkhUhfbdIOhBwhgyDzObQN1
	 5tAlfHFH7Ohx1Fu9quvwzdBDUmPSRcM9nf0u+7A8=
Date: Fri, 07 Jun 2024 15:23:48 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,sstabellini@kernel.org,rppt@kernel.org,osalvador@suse.de,oleksandr_tyshchenko@epam.com,mst@redhat.com,kys@microsoft.com,jgross@suse.com,jasowang@redhat.com,haiyangz@microsoft.com,glider@google.com,eperezma@redhat.com,elver@google.com,dvyukov@google.com,decui@microsoft.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch added to mm-unstable branch
Message-Id: <20240607222348.F1DF6C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory_hotplug: skip adjust_managed_page_count() for PageOffline() pages when offlining
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -1024,11 +1024,15 @@ PAGE_TYPE_OPS(Buddy, buddy, buddy)
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
@@ -1941,7 +1941,7 @@ int __ref offline_pages(unsigned long st
 			struct zone *zone, struct memory_group *group)
 {
 	const unsigned long end_pfn = start_pfn + nr_pages;
-	unsigned long pfn, system_ram_pages = 0;
+	unsigned long pfn, managed_pages, system_ram_pages = 0;
 	const int node = zone_to_nid(zone);
 	unsigned long flags;
 	struct memory_notify arg;
@@ -2062,7 +2062,7 @@ int __ref offline_pages(unsigned long st
 	} while (ret);
 
 	/* Mark all sections offline and remove free pages from the buddy. */
-	__offline_isolated_pages(start_pfn, end_pfn);
+	managed_pages = __offline_isolated_pages(start_pfn, end_pfn);
 	pr_debug("Offlined Pages %ld\n", nr_pages);
 
 	/*
@@ -2078,7 +2078,7 @@ int __ref offline_pages(unsigned long st
 	zone_pcp_enable(zone);
 
 	/* removal success */
-	adjust_managed_page_count(pfn_to_page(start_pfn), -nr_pages);
+	adjust_managed_page_count(pfn_to_page(start_pfn), -managed_pages);
 	adjust_present_page_count(pfn_to_page(start_pfn), group, -nr_pages);
 
 	/* reinitialise watermarks and update pcp limits */
--- a/mm/page_alloc.c~mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining
+++ a/mm/page_alloc.c
@@ -6713,14 +6713,19 @@ void zone_pcp_reset(struct zone *zone)
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
@@ -6742,6 +6747,7 @@ void __offline_isolated_pages(unsigned l
 		if (PageOffline(page)) {
 			BUG_ON(page_count(page));
 			BUG_ON(PageBuddy(page));
+			already_offline++;
 			pfn++;
 			continue;
 		}
@@ -6754,6 +6760,8 @@ void __offline_isolated_pages(unsigned l
 		pfn += (1 << order);
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
+
+	return end_pfn - start_pfn - already_offline;
 }
 #endif
 
_

Patches currently in -mm which might be from david@redhat.com are

revert-mm-init_mlocked_on_free_v3.patch
mm-memory-move-page_count-check-into-validate_page_before_insert.patch
mm-memory-cleanly-support-zeropage-in-vm_insert_page-vm_map_pages-and-vmf_insert_mixed.patch
mm-rmap-sanity-check-that-zeropages-are-not-passed-to-rmap.patch
mm-update-_mapcount-and-page_type-documentation.patch
mm-allow-reuse-of-the-lower-16-bit-of-the-page-type-with-an-actual-type.patch
mm-zsmalloc-use-a-proper-page-type.patch
mm-page_alloc-clear-pagebuddy-using-__clearpagebuddy-for-bad-pages.patch
mm-filemap-reinitialize-folio-_mapcount-directly.patch
mm-mm_init-initialize-page-_mapcount-directly-in-__init_single_page.patch
fs-proc-task_mmu-indicate-pm_file-for-pmd-mapped-file-thp.patch
fs-proc-task_mmu-dont-indicate-pm_mmap_exclusive-without-pm_present.patch
fs-proc-task_mmu-properly-detect-pm_mmap_exclusive-per-page-of-pmd-mapped-thps.patch
fs-proc-task_mmu-account-non-present-entries-as-maybe-shared-but-no-idea-how-often.patch
fs-proc-move-page_mapcount-to-fs-proc-internalh.patch
documentation-admin-guide-mm-pagemaprst-drop-using-pagemap-to-do-something-useful.patch
mm-pass-meminit_context-to-__free_pages_core.patch
mm-pass-meminit_context-to-__free_pages_core-fix.patch
mm-memory_hotplug-initialize-memmap-of-zone_device-with-pageoffline-instead-of-pagereserved.patch
mm-memory_hotplug-skip-adjust_managed_page_count-for-pageoffline-pages-when-offlining.patch

