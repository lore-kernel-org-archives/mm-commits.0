Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010C136F914
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027652; cv=none; b=qRszPhCvNnssEeLgVU+yqAMVzGn3racdGys4BltwLDcGrw/P5MeJAPXd8sQfi8k7fQ4F6wnHjGnYl0OZ492LyJ+4/hfkxnO1/siuLNlSbxE/39LFupBojazLNPcDX603lLPVcG28kexicNz8uLY8eyPlxewE7R8NhmSUokfn+lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027652; c=relaxed/simple;
	bh=182qCe6IbUgtJIFdgfCXLdXGaIwF0QPt6gfCfgMm4hU=;
	h=Date:To:From:Subject:Message-Id; b=fcAILU6Q0O2aw1htsOrglGDYYn6crLwkhtgRRdD71xHCLplRs3drEH1hEeTBVR5r+duYp+813/b7Oem6/aEPILMOH8vw1LEPpqeUi6pij+44wooJ93dVAYdk2Tax7d7P9kIsh/jN0lu5GAKRCz+CCZb0eC+BymVkWdBatH3c41E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2EYSvRYD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2EYSvRYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836861F00898;
	Fri, 29 May 2026 04:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027650;
	bh=Jf7a2j8ylBSN++svzFVjHVFCgayXknseEammlXsSJOk=;
	h=Date:To:From:Subject;
	b=2EYSvRYDnXmRCJygt3MQeDdbesExPVaM8Sk2R2Zzm0zTiWfpwpSzImftu3QK4ZJ7Q
	 Cp5mg81bgBrjhSApcdZ0CRehQYW04VOftceW3Dzy44rl6fWcDUJxI+mfWX+0ity4Kc
	 tAwLJBrf4aum6oSL3FXKiTfqd1yjBvSNqCl6QWHQ=
Date: Thu, 28 May 2026 21:07:30 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,willy@infradead.org,vbabka@kernel.org,surenb@google.com,song@kernel.org,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,memxor@gmail.com,martin.lau@linux.dev,ljs@kernel.org,liam@infradead.org,jolsa@kernel.org,jannh@google.com,harry@kernel.org,glaubitz@physik.fu-berlin.de,eddyz87@gmail.com,dalias@libc.org,ast@kernel.org,andrii@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_mapped.patch removed from -mm tree
Message-Id: <20260529040730.836861F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_mapped()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_mapped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm: remove page_mapped()
Date: Mon, 27 Apr 2026 13:43:16 +0200

Let's replace the last user of page_mapped() by folio_mapped() so we can
get rid of page_mapped().

Replace the remaining occurrences of page_mapped() in rmap documentation
by folio_mapped().

Link: https://lore.kernel.org/20260427-page_mapped-v1-3-e89c3592c74c@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Eduard Zingerman <eddyz87@gmail.com>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Song Liu <song@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Yonghong Song <yonghong.song@linux.dev>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ----------
 mm/memory.c        |    2 +-
 mm/rmap.c          |    8 ++++----
 3 files changed, 5 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-remove-page_mapped
+++ a/include/linux/mm.h
@@ -1888,16 +1888,6 @@ static inline bool folio_mapped(const st
 	return folio_mapcount(folio) >= 1;
 }
 
-/*
- * Return true if this page is mapped into pagetables.
- * For compound page it returns true if any sub-page of compound page is mapped,
- * even if this particular sub-page is not itself mapped by any PTE or PMD.
- */
-static inline bool page_mapped(const struct page *page)
-{
-	return folio_mapped(page_folio(page));
-}
-
 static inline struct page *virt_to_head_page(const void *x)
 {
 	struct page *page = virt_to_page(x);
--- a/mm/memory.c~mm-remove-page_mapped
+++ a/mm/memory.c
@@ -5482,7 +5482,7 @@ static vm_fault_t __do_fault(struct vm_f
 	if (unlikely(PageHWPoison(vmf->page))) {
 		vm_fault_t poisonret = VM_FAULT_HWPOISON;
 		if (ret & VM_FAULT_LOCKED) {
-			if (page_mapped(vmf->page))
+			if (folio_mapped(folio))
 				unmap_mapping_folio(folio);
 			/* Retry if a clean folio was removed from the cache. */
 			if (mapping_evict_folio(folio->mapping, folio))
--- a/mm/rmap.c~mm-remove-page_mapped
+++ a/mm/rmap.c
@@ -571,7 +571,7 @@ void __init anon_vma_init(void)
  * In case it was remapped to a different anon_vma, the new anon_vma will be a
  * child of the old anon_vma, and the anon_vma lifetime rules will therefore
  * ensure that any anon_vma obtained from the page will still be valid for as
- * long as we observe page_mapped() [ hence all those page_mapped() tests ].
+ * long as we observe folio_mapped() [ hence all those folio_mapped() tests ].
  *
  * All users of this function must be very careful when walking the anon_vma
  * chain and verify that the page in question is indeed mapped in it
@@ -1999,7 +1999,7 @@ static bool try_to_unmap_one(struct foli
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
-	 * try_to_unmap() may return before page_mapped() has become false,
+	 * try_to_unmap() may return before folio_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
@@ -2428,7 +2428,7 @@ static bool try_to_migrate_one(struct fo
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
-	 * try_to_migrate() may return before page_mapped() has become false,
+	 * try_to_migrate() may return before folio_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
@@ -2929,7 +2929,7 @@ static struct anon_vma *rmap_walk_anon_l
 
 	/*
 	 * Note: remove_migration_ptes() cannot use folio_lock_anon_vma_read()
-	 * because that depends on page_mapped(); but not all its usages
+	 * because that depends on folio_mapped(); but not all its usages
 	 * are holding mmap_lock. Users without mmap_lock are required to
 	 * take a reference count to prevent the anon_vma disappearing
 	 */
_

Patches currently in -mm which might be from david@kernel.org are

sparc-mm-remove-register_page_bootmem_info.patch
mm-bootmem_info-drop-initialization-of-page-lru.patch
mm-bootmem_info-stop-using-pg_private.patch
mm-bootmem_info-remove-call-to-kmemleak_free_part_phys.patch
mm-bootmem_info-stop-marking-the-pgdat-as-node_info.patch
mm-bootmem_info-stop-marking-mem_section_usage-as-mix_section_info.patch
s390-mm-use-free_reserved_page-in-vmem_free_pages.patch
powerpc-mm-remove-config_have_bootmem_info_node.patch

