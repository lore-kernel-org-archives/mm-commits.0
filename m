From: akpm@linux-foundation.org
Subject: +
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
 added to -mm tree
Date: Fri, 02 Oct 2015 14:09:00 -0700
Message-ID: <560ef26c.48y6dSFqjBjRxv8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbJBVJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 17:09:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, cl@linux.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: add documentation for policies
has been added to the -mm tree.  Its filename is
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch

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
Subject: page-flags: add documentation for policies

The patch adds description for page flags policies.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix
+++ a/include/linux/page-flags.h
@@ -154,7 +154,23 @@ static inline int PageCompound(struct pa
 	return test_bit(PG_head, &page->flags) || PageTail(page);
 }
 
-/* Page flags policies wrt compound pages */
+/*
+ * Page flags policies wrt compound pages
+ *
+ * PF_ANY:
+ *     the page flag is relevant for small, head and tail pages.
+ *
+ * PF_HEAD:
+ *     for compound page all operations related to the page flag applied to
+ *     head page.
+ *
+ * PF_NO_TAIL:
+ *     modifications of the page flag must be done on small or head pages,
+ *     checks can be done on tail pages too.
+ *
+ * PF_NO_COMPOUND:
+ *     the page flag is not relevant for compound pages.
+ */
 #define PF_ANY(page, enforce)	page
 #define PF_HEAD(page, enforce)	compound_head(page)
 #define PF_NO_TAIL(page, enforce) ({					\
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
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
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-support-madvisemadv_free-fix-3.patch

