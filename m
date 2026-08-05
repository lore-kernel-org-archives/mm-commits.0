Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE733C0A10
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 02:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896812; cv=none; b=H+78T98ZR7FlyTQZyD7I2tlZL/0Uis+l9cdhcTadrXpFZDcwVqEyfaUDxhzh6RaidgJZrPiuYf3RgzTHu8ZZNt74bOt511+WQVE7xEg89T8jQSgIdmhWcuGhDFEFpH6pwKMPwICF3CssK9HdSWYCdOusttxG9/fVymdoX5W0AFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896812; c=relaxed/simple;
	bh=QzuwRB6C2UT5R8KIXPFab4e9DUdE54n51wMnaMpDyn0=;
	h=Date:To:From:Subject:Message-Id; b=qpbjEUNMZO9bnOonAyddcieI2MYDHIf7ArZkVoZquDNqAXH+vD7j8fuTK6TmtP//75wdYaT8Q6YnRn+Oe22KCKIaaqZxiVd+v/6Fo9Qam5XZSzSiaeb7u0tlIbhbym0wMMUDC421p8C+goVGKLEY8wAUPZjyzPVXSYu1qW3hUjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NWEWAcoR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NWEWAcoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E451F00A3A;
	Wed,  5 Aug 2026 02:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896810;
	bh=t3jLs02/V8LOmE46xiN3aSx2Cnp4gB1NNphYKRgfGbM=;
	h=Date:To:From:Subject;
	b=NWEWAcoRr+XU5gAkLG2B6VECvlqTBynGQTYHlfIp0PeXrOddLJPz9aRHfuOEGm+Xu
	 ktRTAFsnUn2P7NNRJq/BzqVkc2VRCv7hvgFMJIH5gkvDVoNNCIFPsh3lMJkV9irRvg
	 LPhW3Gt0FnNbCi74CTl/zxZpTalfDtOpymJ8xBs8=
Date: Tue, 04 Aug 2026 19:26:49 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,ryan.roberts@arm.com,riel@surriel.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,jannh@google.com,harry@kernel.org,david@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch removed from -mm tree
Message-Id: <20260805022650.52E451F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: refactor some code around lazyfree folio unmapping
has been removed from the -mm tree.  Its filename was
     mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: mm/rmap: refactor some code around lazyfree folio unmapping
Date: Thu, 30 Jul 2026 09:45:54 +0000

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

No functional change intended.

Link: https://lore.kernel.org/20260730094559.418003-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   87 ++++++++++++++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

--- a/mm/rmap.c~mm-rmap-refactor-some-code-around-lazyfree-folio-unmapping
+++ a/mm/rmap.c
@@ -2068,6 +2068,50 @@ range_end:
 	return ret;
 }
 
+static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long nr_pages)
+{
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	/*
+	 * Additional references could be due to GUP or speculative lookups.
+	 * GUP users must mark the folio dirty if there was a modification.
+	 * This folio cannot be reclaimed right now either way, so act just
+	 * like nothing happened. We'll come back here later and detect if the
+	 * folio was dirtied when the additional reference is gone.
+	 */
+	if (ref_count != 1 + map_count)
+		return false;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, -nr_pages);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2261,47 +2305,12 @@ static bool try_to_unmap_one(struct foli
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
-					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
+				if (!ttu_anon_lazyfree_folio(vma, folio,
+							     nr_pages)) {
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2359,7 +2368,7 @@ static bool try_to_unmap_one(struct foli
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-memory-move-pte_install_uffd_wp_if_needed-into-memoryc.patch
mm-memory-batch-set-uffd-wp-markers-during-zapping.patch
mm-rmap-batch-unmap-file-folios-belonging-to-uffd-wp-vmas.patch

