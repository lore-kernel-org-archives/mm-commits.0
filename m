From: akpm@linux-foundation.org
Subject: + mm-document-is_page_cache_freeable.patch added to -mm tree
Date: Wed, 12 Aug 2009 15:57:10 -0700
Message-ID: <200908122257.n7CMvAPX021763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbZHLW5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Aug 2009 18:57:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, cl@linux-foundation.org


The patch titled
     mm: document is_page_cache_freeable()
has been added to the -mm tree.  Its filename is
     mm-document-is_page_cache_freeable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: document is_page_cache_freeable()
From: Johannes Weiner <hannes@cmpxchg.org>

Enlighten the reader of this code about what reference count makes a page
cache page freeable.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN mm/vmscan.c~mm-document-is_page_cache_freeable mm/vmscan.c
--- a/mm/vmscan.c~mm-document-is_page_cache_freeable
+++ a/mm/vmscan.c
@@ -286,6 +286,11 @@ static inline int page_mapping_inuse(str
 
 static inline int is_page_cache_freeable(struct page *page)
 {
+	/*
+	 * A freeable page cache page is referenced only by the caller
+	 * that isolated the page, the page cache radix tree and
+	 * optional buffer heads at page->private.
+	 */
 	return page_count(page) - page_has_private(page) == 2;
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
vfs-make-get_sb_pseudo-set-s_maxbytes-to-value-that-can-be-cast-to-signed.patch
linux-next.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch

