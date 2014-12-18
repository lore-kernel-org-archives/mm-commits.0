From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
 removed from -mm tree
Date: Thu, 18 Dec 2014 13:06:01 -0800
Message-ID: <549341b9.J/bSQ+PaUzRgFWKC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56501 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbaLRVGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Dec 2014 16:06:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, isimatu.yasuaki@jp.fujitsu.com, mel@csn.ul.ie, ming.lei@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch

This patch was dropped because it was folded into mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix

pass the correct mask (the mask we actually used) into trace_mm_page_alloc()

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix
+++ a/mm/page_alloc.c
@@ -2865,6 +2865,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
 	unsigned int cpuset_mems_cookie;
 	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
 	int classzone_idx;
+	gfp_t mask;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2898,23 +2899,24 @@ retry_cpuset:
 	classzone_idx = zonelist_zone_idx(preferred_zoneref);
 
 	/* First allocation attempt */
-	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
-			zonelist, high_zoneidx, alloc_flags,
-			preferred_zone, classzone_idx, migratetype);
+	mask = gfp_mask|__GFP_HARDWALL;
+	page = get_page_from_freelist(mask, nodemask, order, zonelist,
+			high_zoneidx, alloc_flags, preferred_zone,
+			classzone_idx, migratetype);
 	if (unlikely(!page)) {
 		/*
 		 * Runtime PM, block IO and its error handling path
 		 * can deadlock because I/O on the device might not
 		 * complete.
 		 */
-		gfp_t mask = memalloc_noio_flags(gfp_mask);
+		mask = memalloc_noio_flags(gfp_mask);
 
 		page = __alloc_pages_slowpath(mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, classzone_idx, migratetype);
 	}
 
-	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
+	trace_mm_page_alloc(page, order, mask, migratetype);
 
 out:
 	/*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation.patch
mailmap-update-akpm-osdlorg.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
tools-testing-selftests-makefile-alphasort-the-targets-list.patch
mm-prevent-endless-growth-of-anon_vma-hierarchy-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper.patch
ocfs2-add-functions-to-add-and-remove-inode-in-orphan-dir.patch
mm.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
task_mmu-add-user-space-support-for-resetting-mm-hiwater_rss-peak-rss-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

