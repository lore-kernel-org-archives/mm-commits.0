Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AB12AD24
	for <mm-commits@vger.kernel.org>; Fri, 19 Sep 2025 20:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313167; cv=none; b=Ej630uGsA0/bCCbR+Hbr7FjzVHSq3+bHoXTsLPHYL8GKAvwQAGgYPFk9HP1p6RnRdKDr5BUJ6L2pSYZXoJ3sHd5DKdfhxgVL72pUf+c7rYhrKM15nwgYXKDyRnS/JeHMZ1JaY7QwEqNnN6G7vjqWaPvo6b3WsIlUovDMiu2XCRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313167; c=relaxed/simple;
	bh=RdupOgzIjA2QhKzsIMtoM8XIGXpXGG8SbWefCasq92M=;
	h=Date:To:From:Subject:Message-Id; b=omGXqLAji4u8MN1KMYGnYUm+FwEoobox2fRYCPXYBssJQXzKdaBd3IGucDbMPhst6UzY5U9vXLWshEPWo9ekkst1qkPcOhRtdgqV80r1zA+d2q3Y1zw7elveiuMbG94kXewxr8Kqp117jpfIrs8EHal0h4wtf97dQk8xvULKBrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fIQRGRUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fIQRGRUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72AAC4CEF0;
	Fri, 19 Sep 2025 20:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758313165;
	bh=RdupOgzIjA2QhKzsIMtoM8XIGXpXGG8SbWefCasq92M=;
	h=Date:To:From:Subject:From;
	b=fIQRGRUGEfd82b3EilOY9Jv9DecsgOkC4dkpORnTXHN+zP6CNqVaHghCtJzmp+fCR
	 2x9GZNvh2FdLPPVdpWFH5PsZlFe+oRrjzTkFYd2tdkSkpFDh+jt/f1gBnKm79U/BFy
	 NRmjwGczXQMWsUTh1FpwJmpgpnI8i31RJK5ezFpM=
Date: Fri, 19 Sep 2025 13:19:25 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,hannes@cmpxchg.org,david@redhat.com,baolin.wang@linux.alibaba.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch added to mm-unstable branch
Message-Id: <20250919201925.B72AAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_vma_mapped: track if the page is mapped across page table boundary
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch

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
Subject: mm/page_vma_mapped: track if the page is mapped across page table boundary
Date: Fri, 19 Sep 2025 13:40:32 +0100

Patch series "mm: Improve mlock tracking for large folios", v2.

The patchset includes several fixes and improvements related to mlock
tracking of large folios.

The main objective is to reduce the undercount of Mlocked memory in
/proc/meminfo and improve the accuracy of the statistics.

Patches 1-2:

These patches address a minor race condition in folio_referenced_one()
related to mlock_vma_folio().

Currently, mlock_vma_folio() is called on large folio without the page
table lock, which can result in a race condition with unmap (i.e. 
MADV_DONTNEED).  This can lead to partially mapped folios on the
unevictable LRU list.

While not a significant issue, I do not believe backporting is necessary.

Patch 3:

This patch adds mlocking logic similar to folio_referenced_one() to
try_to_unmap_one(), allowing for mlocking of large folios where possible.

Patch 4:

This patch modifies finish_fault() to fault in the entire folio when
possible, enabling efficient mlocking upon addition to the rmap.

Patch 5:

This patch ensures that rmap mlocks large folios if they are fully mapped,
addressing the primary source of mlock undercount for large folios.


This patch (of 5):

Add a PVMW_PGTABLE_CROSSSED flag that page_vma_mapped_walk() will set if
the page is mapped across page table boundary.  Unlike other PVMW_* flags,
this one is result of page_vma_mapped_walk() and not set by the caller.

folio_referenced_one() will use it detect if it safe to mlock the folio.

Link: https://lkml.kernel.org/r/20250919124036.455709-1-kirill@shutemov.name
Link: https://lkml.kernel.org/r/20250919124036.455709-2-kirill@shutemov.name
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

 include/linux/rmap.h |    5 +++++
 mm/page_vma_mapped.c |    1 +
 2 files changed, 6 insertions(+)

--- a/include/linux/rmap.h~mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary
+++ a/include/linux/rmap.h
@@ -922,6 +922,11 @@ struct page *make_device_exclusive(struc
 /* Look for migration entries rather than present PTEs */
 #define PVMW_MIGRATION		(1 << 1)
 
+/* Result flags */
+
+/* The page is mapped across page boundary */
+#define PVMW_PGTABLE_CROSSSED	(1 << 16)
+
 struct page_vma_mapped_walk {
 	unsigned long pfn;
 	unsigned long nr_pages;
--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary
+++ a/mm/page_vma_mapped.c
@@ -309,6 +309,7 @@ next_pte:
 				}
 				pte_unmap(pvmw->pte);
 				pvmw->pte = NULL;
+				pvmw->flags |= PVMW_PGTABLE_CROSSSED;
 				goto restart;
 			}
 			pvmw->pte++;
_

Patches currently in -mm which might be from kas@kernel.org are

mm-khugepaged-do-not-fail-collapse_pte_mapped_thp-on-scan_pmd_null.patch
mm-page_vma_mapped-track-if-the-page-is-mapped-across-page-table-boundary.patch
mm-rmap-fix-a-mlock-race-condition-in-folio_referenced_one.patch
mm-rmap-mlock-large-folios-in-try_to_unmap_one.patch
mm-fault-try-to-map-the-entire-file-folio-in-finish_fault.patch
mm-rmap-improve-mlock-tracking-for-large-folios.patch

