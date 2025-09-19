Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85A42AD24
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313171; cv=none; b=FGN45231VcQ8PWKbspcQXXuyBPltao1AnTpnerFKnjThLQhPPojzG+5O5I9zw3brYNzSXihAwCwyEv61/Es/4i7pWZk1VK1tdlt8vbnuTIPca/yLlmOQ/LxwNhHcc00vTpZLShV1OFeA9zPiOdph48AnhciXX46z6KdOj65RQGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313171; c=relaxed/simple;
	bh=4l45XWF6bb9rp4ouB0VoZrkDodliegSwpOyibvGDWXg=;
	h=Date:To:From:Subject:Message-Id; b=qEeUk+Qqr3qIk6wSQfx3WDX+fSKby9JLXcRh9yw5exo6ZconnFx6L1wAaeZIHdEzhbPjNQMKkCJ/j44WnV/6agqnaoLLb6z9WbkJxwd07DadKsh3cNc9OXp0d8G2JPVSaFHivNgduJOJDeBGVRVZ/HckjmZEC+IYJSV3k3BahXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qjo8im3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qjo8im3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C25C4CEF0;
	Fri, 19 Sep 2025 20:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758313170;
	bh=4l45XWF6bb9rp4ouB0VoZrkDodliegSwpOyibvGDWXg=;
	h=Date:To:From:Subject:From;
	b=Qjo8im3JEi6Lwt1vFJpc6QA2ClWU0I5j5NxekGDowUz5Z8jnVYniUJ8qb1tfpTPvA
	 ydGH3yXdj5uu/2gsjoEh23qiDqXc1503D/+LuMYCV4GfxQAADYCWAU2jV/XPWCZVrC
	 +4N1197S6u9qHWmhZTG2WgjB05E1QioC2PTpweSo=
Date: Fri, 19 Sep 2025 13:19:29 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch added to mm-unstable branch
Message-Id: <20250919201930.65C25C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: mlock large folios in try_to_unmap_one()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch

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
From: Kiryl Shutsemau <kas@kernel.org>
Subject: mm/rmap: mlock large folios in try_to_unmap_one()
Date: Fri, 19 Sep 2025 13:40:34 +0100

Currently, try_to_unmap_once() only tries to mlock small folios.

Use logic similar to folio_referenced_one() to mlock large folios: only do
this for fully mapped folios and under page table lock that protects all
page table entries.

Link: https://lkml.kernel.org/r/20250919124036.455709-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

--- a/mm/rmap.c~mm-rmap-mlock-large-folios-in-try_to_unmap_one
+++ a/mm/rmap.c
@@ -1870,6 +1870,7 @@ static bool try_to_unmap_one(struct foli
 	unsigned long nr_pages = 1, end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
+	int ptes = 0;
 
 	/*
 	 * When racing against e.g. zap_pte_range() on another cpu,
@@ -1910,10 +1911,26 @@ static bool try_to_unmap_one(struct foli
 		 */
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
+			ptes++;
+			ret = false;
+
+			/* Only mlock fully mapped pages */
+			if (pvmw.pte && ptes != pvmw.nr_pages)
+				continue;
+
+			/*
+			 * All PTEs must be protected by page table lock in
+			 * order to mlock the page.
+			 *
+			 * If page table boundary has been cross, current ptl
+			 * only protect part of ptes.
+			 */
+			if (pvmw.flags & PVMW_PGTABLE_CROSSSED)
+				goto walk_done;
+
 			/* Restore the mlock which got missed */
-			if (!folio_test_large(folio))
-				mlock_vma_folio(folio, vma);
-			goto walk_abort;
+			mlock_vma_folio(folio, vma);
+			goto walk_done;
 		}
 
 		if (!pvmw.pte) {
_

Patches currently in -mm which might be from kas@kernel.org are

mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

