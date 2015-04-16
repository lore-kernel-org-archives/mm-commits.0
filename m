From: akpm@linux-foundation.org
Subject: [merged]
 mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:51:27 -0700
Message-ID: <552fe88f.DA5liDAY3wy5iL7P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42606 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700AbbDPQp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: avoid tail page refcounting on non-THP compound pages
has been removed from the -mm tree.  Its filename was
     mm-avoid-tail-page-refcounting-on-non-thp-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: avoid tail page refcounting on non-THP compound pages

THP uses tail page refcounting to be able to split huge pages at any time.
 Tail page refcounting is not needed for other users of compound pages and
it's harmful because of overhead.

We try to exclude non-THP pages from tail page refcounting using
__compound_tail_refcounted() check.  It excludes most common non-THP
compound pages: SL*B and hugetlb, but it doesn't catch rest of __GFP_COMP
users -- drivers.

And it's not only about overhead.

Drivers might want to use compound pages to get refcounting semantics
suitable for mapping high-order pages to userspace.  But tail page
refcounting breaks it.

Tail page refcounting uses ->_mapcount in tail pages to store GUP pins on
them.  It means GUP pins would affect page_mapcount() for tail pages. 
It's not a problem for THP, because it never maps tail pages.  But unlike
THP, drivers map parts of compound pages with PTEs and it makes
page_mapcount() be called for tail pages.

In particular, GUP pins would shift PSS up and affect /proc/kpagecount for
such pages.  But, I'm not aware about anything which can lead to crash or
other serious misbehaviour.

Since currently all THP pages are anonymous and all drivers pages are not,
we can fix the __compound_tail_refcounted() check by requiring PageAnon()
to enable tail page refcounting.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-avoid-tail-page-refcounting-on-non-thp-compound-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-avoid-tail-page-refcounting-on-non-thp-compound-pages
+++ a/include/linux/mm.h
@@ -496,7 +496,7 @@ static inline int page_count(struct page
 
 static inline bool __compound_tail_refcounted(struct page *page)
 {
-	return !PageSlab(page) && !PageHeadHuge(page);
+	return PageAnon(page) && !PageSlab(page) && !PageHeadHuge(page);
 }
 
 /*
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-on-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
linux-next.patch

