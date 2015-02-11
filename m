From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 15:13:21 -0800
Message-ID: <54dbe211.Q5FD4LcYydFvc4aH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43119 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642AbbBKXNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 18:13:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, aarcange@redhat.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2
has been removed from the -mm tree.  Its filename was
     mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch

This patch was dropped because it was folded into mm-more-checks-on-free_pages_prepare-for-tail-pages.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2

Oops. I wanted this return code to be accounted into 'bad' in
free_pages_prepare() instead. Incremental patch:

Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2
+++ a/mm/page_alloc.c
@@ -795,7 +795,7 @@ static bool free_pages_prepare(struct pa
 	bad += free_pages_check(page);
 	for (i = 1; i < (1 << order); i++) {
 		if (compound)
-			free_tail_pages_check(page, page + i);
+			bad += free_tail_pages_check(page, page + i);
 		bad += free_pages_check(page + i);
 	}
 	if (bad)
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch

