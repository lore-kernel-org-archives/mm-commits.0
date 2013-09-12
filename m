From: akpm@linux-foundation.org
Subject: [folded-merged]
 thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch
 removed from -mm tree
Date: Thu, 12 Sep 2013 15:04:35 -0700
Message-ID: <52323a73.rervTrzpEyWuOaOr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3ILWEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 18:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, quning@google.com, mgorman@suse.de, dave.hansen@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [folded-merged] thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,dave.hansen@linux.intel.com,mgorman@suse.de,quning@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 15:04:35 -0700


The patch titled
     Subject: mm: fix accounting on page_remove_rmap()
has been removed from the -mm tree.  Its filename was
     thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch

This patch was dropped because it was folded into thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix accounting on page_remove_rmap()

There's typo in page_remove_rmap(): we increase NR_ANON_PAGES counter
instead of decreasing it. Let's fix this.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Ning Qu <quning@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix mm/rmap.c
--- a/mm/rmap.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix
+++ a/mm/rmap.c
@@ -1152,7 +1152,7 @@ void page_remove_rmap(struct page *page)
 			__dec_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
 		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
-				hpage_nr_pages(page));
+				-hpage_nr_pages(page));
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
truncate-drop-oldsize-truncate_pagecache-parameter.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch

