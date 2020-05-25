From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthp-stop-leaking-unreleased-file-pages.patch added to
 -mm tree
Date: Sun, 24 May 2020 17:08:09 -0700
Message-ID: <20200525000809.7Ttcv_7tp%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388149AbgEYAIK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 20:08:10 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, riel@surriel.com, songliubraving@fb.com, stable@vger.kernel.org


The patch titled
     Subject: mm,thp: stop leaking unreleased file pages
has been added to the -mm tree.  Its filename is
     mmthp-stop-leaking-unreleased-file-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmthp-stop-leaking-unreleased-file-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmthp-stop-leaking-unreleased-file-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp: stop leaking unreleased file pages

When collapse_file() calls try_to_release_page(), it has already isolated
the page: so if releasing buffers happens to fail (as it sometimes does),
remember to putback_lru_page(): otherwise that page is left unreclaimable
and unfreeable, and the file extent uncollapsible.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2005231837500.1766@eggly.anvils
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
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

Patches currently in -mm which might be from hughd@google.com are

mmthp-stop-leaking-unreleased-file-pages.patch
mm-memcontrol-charge-swapin-pages-on-instantiation-fix.patch
mm-vmstat-add-events-for-pmd-based-thp-migration-without-split-fix.patch
