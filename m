Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0851B1FE44A
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 12:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777292311; cv=none; b=XMcpRWrmmhDRQVan/tXVmaGK3EpklNo0zSPH7vBNWxqBcAUOayLIoRX1RYgTM8peWcFWBy6A8NHzX1gV/W0WAG0UDR+Sj4m/2eH2OpecddQn4y+pHx/SM6AqCcRTmwxLT3NZnMaSIpjPG9POXIwWTfTsuFEA6KuNPt75JFRSTR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777292311; c=relaxed/simple;
	bh=guF1Np8SKQ6pvDnIlfG6rOcZJUwXeXAal220W/s/0Wc=;
	h=Date:To:From:Subject:Message-Id; b=aYkguaPB4vivIJ0EZnz6zFSEYb/4S2UC5PMVOjUpGjZrpiIIZmDR3YHwCZ2lG8yA9cn/y2O3YtooIsEH5eaT0pgRumyfugLnx1Pwgrr02FkiTuSn5L3gp+J7B03WeTERhNyDb8ercpXgd+1YT0CS63Sb87kBNucOKKwJ/3y2xoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VhUcMGTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VhUcMGTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92968C19425;
	Mon, 27 Apr 2026 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777292310;
	bh=guF1Np8SKQ6pvDnIlfG6rOcZJUwXeXAal220W/s/0Wc=;
	h=Date:To:From:Subject:From;
	b=VhUcMGTIquiF37wCwgyBirNZF6EZEWEqrMgQ4B/AkO5+CWp0X/79aVA96e3t4JRIV
	 Ud9MXoByjs+raqiMGW0rmIXHsU7JCiIsz/f3uAtMfLY9tESF5TMlnyRoEtwafDM0VK
	 PdvmGPAvrGKrx7ieHavZwUHXWOQV8+QsPARgQgjg=
Date: Mon, 27 Apr 2026 05:18:29 -0700
To: mm-commits@vger.kernel.org,ysato@users.sourceforge.jp,yonghong.song@linux.dev,willy@infradead.org,vbabka@kernel.org,surenb@google.com,song@kernel.org,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,memxor@gmail.com,martin.lau@linux.dev,ljs@kernel.org,liam@infradead.org,jolsa@kernel.org,jannh@google.com,harry@kernel.org,glaubitz@physik.fu-berlin.de,eddyz87@gmail.com,dalias@libc.org,ast@kernel.org,andrii@kernel.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_mapped.patch added to mm-new branch
Message-Id: <20260427121830.92968C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_mapped()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-page_mapped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_mapped.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
@@ -5466,7 +5466,7 @@ static vm_fault_t __do_fault(struct vm_f
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
@@ -2426,7 +2426,7 @@ static bool try_to_migrate_one(struct fo
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
 	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
-	 * try_to_migrate() may return before page_mapped() has become false,
+	 * try_to_migrate() may return before folio_mapped() has become false,
 	 * if page table locking is skipped: use TTU_SYNC to wait for that.
 	 */
 	if (flags & TTU_SYNC)
@@ -2927,7 +2927,7 @@ static struct anon_vma *rmap_walk_anon_l
 
 	/*
 	 * Note: remove_migration_ptes() cannot use folio_lock_anon_vma_read()
-	 * because that depends on page_mapped(); but not all its usages
+	 * because that depends on folio_mapped(); but not all its usages
 	 * are holding mmap_lock. Users without mmap_lock are required to
 	 * take a reference count to prevent the anon_vma disappearing
 	 */
_

Patches currently in -mm which might be from david@kernel.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free.patch
sh-use-folio_mapped-instead-of-page_mapped-in-sh4_flush_cache_page.patch
bpf-arena-use-page_ref_count-instead-of-page_mapped-in-arena_free_pages.patch
mm-remove-page_mapped.patch

