From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2/5] mm,thp: stop leaking unreleased file pages
Date: Wed, 27 May 2020 22:20:43 -0700
Message-ID: <20200528052043.TKW9wStFk%akpm@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgE1FUp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 May 2020 01:20:45 -0400
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, riel@surriel.com, songliubraving@fb.com, stable@vger.kernel.org, torvalds@linux-foundation.org

From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: stop leaking unreleased file pages

When collapse_file() calls try_to_release_page(), it has already isolated
the page: so if releasing buffers happens to fail (as it sometimes does),
remember to putback_lru_page(): otherwise that page is left unreclaimable
and unfreeable, and the file extent uncollapsible.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005231837500.1766@eggly.anvils
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/khugepaged.c~mmthp-stop-leaking-unreleased-file-pages
+++ a/mm/khugepaged.c
@@ -1692,6 +1692,7 @@ static void collapse_file(struct mm_stru
 		if (page_has_private(page) &&
 		    !try_to_release_page(page, GFP_KERNEL)) {
 			result = SCAN_PAGE_HAS_PRIVATE;
+			putback_lru_page(page);
 			goto out_unlock;
 		}
 
_
