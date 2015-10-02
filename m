From: akpm@linux-foundation.org
Subject: +
 page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch added to -mm tree
Date: Fri, 02 Oct 2015 14:07:16 -0700
Message-ID: <560ef204./wwo3DXNGzkqviIw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbbJBVHR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 17:07:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, cl@linux.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page-flags: do not corrupt caller 'page' in PF_NO_TAIL
has been added to the -mm tree.  Its filename is
     page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch

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
Subject: page-flags: do not corrupt caller 'page' in PF_NO_TAIL

Andrew noticed that PF_NO_TAIL() modifies caller's 'page'.  This doesn't
trigger any bad results, because all users are inline functions which
doesn't use the variable beyond the point.  But still not good.

The patch changes PF_NO_TAIL() to always return head page, regardless
'enforce'.  This makes operations of page flags with PF_NO_TAIL more
symmetrical: modifications and checks goes to head page.  It gives better
chance to recover in case of bug for non-DEBUG_VM kernel.

DEBUG_VM kernel will still trigger VM_BUG_ON() on modifications to tail
pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix include/linux/page-flags.h
--- a/include/linux/page-flags.h~page-flags-introduce-page-flags-policies-wrt-compound-pages-fix
+++ a/include/linux/page-flags.h
@@ -160,9 +160,7 @@ static inline int PageCompound(struct pa
 #define PF_NO_TAIL(page, enforce) ({					\
 		if (enforce)						\
 			VM_BUG_ON_PAGE(PageTail(page), page);		\
-		else							\
-			page = compound_head(page);			\
-		page;})
+		compound_head(page);})
 #define PF_NO_COMPOUND(page, enforce) ({					\
 		if (enforce)						\
 			VM_BUG_ON_PAGE(PageCompound(page), page);	\
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

