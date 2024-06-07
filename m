Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94894502BE
	for <mm-commits@vger.kernel.org>; Fri,  7 Jun 2024 22:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717799019; cv=none; b=oywgBeZ8/GCsUnFa4Vhf5CtUnDSAZSSNZBeqnvRFkkRk1yrJHjaPO4fR72rll6B7Jpl0zJwBV6HRMHyDomF/QlK4jYZifU06twT64ZGHareigxP5LRQGwnLYQ64SFsnb9SSGbm7+tog58LmiZMlimtbm8ZI9pyX5KDnE8z6haWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717799019; c=relaxed/simple;
	bh=oqiTAiNLv8I1Nwf7cVDmcaDXHyBPSg6cOZfW8fdTH6k=;
	h=Date:To:From:Subject:Message-Id; b=M0GJ0KqdHFLEj2fVmNDPPfDRQJ7Tgx1krWg9O1C0a+Ts9yyA6wGtXE//enVZhwcpDoOzlYAKtsOuaZBY1hwNV2gv74cGZk6XynD2xkjeDmWkRXKmhvq4dl3v5zINtHIObTwCVYJIyAZjZYFySikcAy/65i0T35FpUQ8Sp8+ihyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UBQ3WbZw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UBQ3WbZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECF8C2BBFC;
	Fri,  7 Jun 2024 22:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717799019;
	bh=oqiTAiNLv8I1Nwf7cVDmcaDXHyBPSg6cOZfW8fdTH6k=;
	h=Date:To:From:Subject:From;
	b=UBQ3WbZwWkh4mKHPm/VlDWdu70EDh9xr678H3D9baZthjO6aur4NcfdpRTkSWLuiP
	 hH82LWD6RJBF0FZvDmE5AQ61XfHyvMgDlvSQnNWKqB/YSMxq0Lyoy66rb9yU6ivGUx
	 cZyEFq177WySBed7KulMUy6H8btQifsAGD0gP1uk=
Date: Fri, 07 Jun 2024 15:23:38 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,wei.liu@kernel.org,sstabellini@kernel.org,rppt@kernel.org,osalvador@suse.de,oleksandr_tyshchenko@epam.com,mst@redhat.com,kys@microsoft.com,jgross@suse.com,jasowang@redhat.com,haiyangz@microsoft.com,glider@google.com,eperezma@redhat.com,elver@google.com,dvyukov@google.com,decui@microsoft.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-meminit_context-to-__free_pages_core.patch added to mm-unstable branch
Message-Id: <20240607222339.2ECF8C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: pass meminit_context to __free_pages_core()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-pass-meminit_context-to-__free_pages_core.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-pass-meminit_context-to-__free_pages_core.patch

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
Subject: mm: pass meminit_context to __free_pages_core()
Date: Fri, 7 Jun 2024 11:09:36 +0200

Patch series "mm/memory_hotplug: use PageOffline() instead of
PageReserved() for !ZONE_DEVICE".

This can be a considered a long-overdue follow-up to some parts of [1]. 
The patches are based on [2], but they are not strictly required -- just
makes it clearer why we can use adjust_managed_page_count() for memory
hotplug without going into details about highmem.

We stop initializing pages with PageReserved() in memory hotplug code --
except when dealing with ZONE_DEVICE for now.  Instead, we use
PageOffline(): all pages are initialized to PageOffline() when onlining a
memory section, and only the ones actually getting exposed to the
system/page allocator will get PageOffline cleared.

This way, we enlighten memory hotplug more about PageOffline() pages and
can cleanup some hacks we have in virtio-mem code.

What about ZONE_DEVICE?  PageOffline() is wrong, but we might just stop
using PageReserved() for them later by simply checking for
is_zone_device_page() at suitable places.  That will be a separate patch
set / proposal.

This primarily affects virtio-mem, HV-balloon and XEN balloon. I only
briefly tested with virtio-mem, which benefits most from these cleanups.

[1] https://lore.kernel.org/all/20191024120938.11237-1-david@redhat.com/
[2] https://lkml.kernel.org/r/20240607083711.62833-1-david@redhat.com


This patch (of 3):

In preparation for further changes, let's teach __free_pages_core() about
the differences of memory hotplug handling.

Move the memory hotplug specific handling from generic_online_page() to
__free_pages_core(), use adjust_managed_page_count() on the memory hotplug
path, and spell out why memory freed via memblock cannot currently use
adjust_managed_page_count().

Link: https://lkml.kernel.org/r/20240607090939.89524-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240607090939.89524-2-david@redhat.com
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

 mm/internal.h       |    3 ++-
 mm/kmsan/init.c     |    2 +-
 mm/memory_hotplug.c |    9 +--------
 mm/mm_init.c        |    4 ++--
 mm/page_alloc.c     |   17 +++++++++++++++--
 5 files changed, 21 insertions(+), 14 deletions(-)

--- a/mm/internal.h~mm-pass-meminit_context-to-__free_pages_core
+++ a/mm/internal.h
@@ -604,7 +604,8 @@ extern void __putback_isolated_page(stru
 				    int mt);
 extern void memblock_free_pages(struct page *page, unsigned long pfn,
 					unsigned int order);
-extern void __free_pages_core(struct page *page, unsigned int order);
+extern void __free_pages_core(struct page *page, unsigned int order,
+		enum meminit_context);
 
 /*
  * This will have no effect, other than possibly generating a warning, if the
--- a/mm/kmsan/init.c~mm-pass-meminit_context-to-__free_pages_core
+++ a/mm/kmsan/init.c
@@ -172,7 +172,7 @@ static void do_collection(void)
 		shadow = smallstack_pop(&collect);
 		origin = smallstack_pop(&collect);
 		kmsan_setup_meta(page, shadow, origin, collect.order);
-		__free_pages_core(page, collect.order);
+		__free_pages_core(page, collect.order, MEMINIT_EARLY);
 	}
 }
 
--- a/mm/memory_hotplug.c~mm-pass-meminit_context-to-__free_pages_core
+++ a/mm/memory_hotplug.c
@@ -630,14 +630,7 @@ EXPORT_SYMBOL_GPL(restore_online_page_ca
 
 void generic_online_page(struct page *page, unsigned int order)
 {
-	/*
-	 * Freeing the page with debug_pagealloc enabled will try to unmap it,
-	 * so we should map it first. This is better than introducing a special
-	 * case in page freeing fast path.
-	 */
-	debug_pagealloc_map_pages(page, 1 << order);
-	__free_pages_core(page, order);
-	totalram_pages_add(1UL << order);
+	__free_pages_core(page, order, MEMINIT_HOTPLUG);
 }
 EXPORT_SYMBOL_GPL(generic_online_page);
 
--- a/mm/mm_init.c~mm-pass-meminit_context-to-__free_pages_core
+++ a/mm/mm_init.c
@@ -1938,7 +1938,7 @@ static void __init deferred_free_range(u
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
 		if (pageblock_aligned(pfn))
 			set_pageblock_migratetype(page, MIGRATE_MOVABLE);
-		__free_pages_core(page, 0);
+		__free_pages_core(page, 0, MEMINIT_EARLY);
 	}
 }
 
@@ -2513,7 +2513,7 @@ void __init memblock_free_pages(struct p
 		}
 	}
 
-	__free_pages_core(page, order);
+	__free_pages_core(page, order, MEMINIT_EARLY);
 }
 
 DEFINE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
--- a/mm/page_alloc.c~mm-pass-meminit_context-to-__free_pages_core
+++ a/mm/page_alloc.c
@@ -1214,7 +1214,8 @@ static void __free_pages_ok(struct page
 	__count_vm_events(PGFREE, 1 << order);
 }
 
-void __free_pages_core(struct page *page, unsigned int order)
+void __free_pages_core(struct page *page, unsigned int order,
+		enum meminit_context context)
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
@@ -1234,7 +1235,19 @@ void __free_pages_core(struct page *page
 	__ClearPageReserved(p);
 	set_page_count(p, 0);
 
-	atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG) &&
+	    unlikely(context == MEMINIT_HOTPLUG)) {
+		/*
+		 * Freeing the page with debug_pagealloc enabled will try to
+		 * unmap it; some archs don't like double-unmappings, so
+		 * map it first.
+		 */
+		debug_pagealloc_map_pages(page, nr_pages);
+		adjust_managed_page_count(page, nr_pages);
+	} else {
+		/* memblock adjusts totalram_pages() ahead of time. */
+		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
+	}
 
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
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

