From: akpm@linux-foundation.org
Subject: +
 thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch added
 to -mm tree
Date: Tue, 10 Sep 2013 16:59:29 -0700
Message-ID: <522fb261.KWyE4Fw8M4oFCzIX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3IJX7a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Sep 2013 19:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, quning@google.com, mgorman@suse.de, dave.hansen@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: + thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,dave.hansen@linux.intel.com,mgorman@suse.de,quning@google.com
From: akpm@linux-foundation.org
Date: Tue, 10 Sep 2013 16:59:29 -0700


The patch titled
     Subject: mm: fix accounting on page_remove_rmap()
has been added to the -mm tree.  Its filename is
     thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-fix-potential-null-pointer-dereference.patch
thp-mm-locking-tail-page-is-a-bug.patch
thp-mm-locking-tail-page-is-a-bug-fix.patch
truncate-drop-oldsize-truncate_pagecache-parameter.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages-fix.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-thp-count-thp_fault_fallback-anytime-thp-fault-fails.patch

