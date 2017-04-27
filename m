From: akpm@linux-foundation.org
Subject: [alternative-merged] mm-add-additional-consistency-check.patch
 removed from -mm tree
Date: Thu, 27 Apr 2017 15:17:33 -0700
Message-ID: <59026dfd.r+0iMVjqc2qbic7j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36436 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755559AbdD0WRf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2017 18:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, cl@linux.com, iamjoonsoo.kim@lge.com, mpe@ellerman.id.au, penberg@kernel.org, rientjes@google.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.h: add additional consistency check
has been removed from the -mm tree.  Its filename was
     mm-add-additional-consistency-check.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/slab.h: add additional consistency check

As found in PaX, this adds a cheap check on heap consistency, just to
notice if things have gotten corrupted in the page lookup.

Given the kinds of heap attacks I've been seeing, I think this added
consistency check is worth it given how inexpensive it is.  When heap
metadata gets corrupted, we can get into nasty side-effects that can be
attacker-controlled, so better to catch obviously bad states as early as
possible.

Christoph said:

: Ok this only affects kmem_cache_free() and not kfree().  For
: kmem_cache_free() we already have a lot of stuff in the hotpath due to
: cgruops.  If you want this also for kfree() then we need a separate
: patch.
: 
: Also for kmem_cache_free(): Here we always have a slab cache and thus
: we could check the flags that could modify what behavior we want.

Link: http://lkml.kernel.org/r/20170331164028.GA118828@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slab.h~mm-add-additional-consistency-check mm/slab.h
--- a/mm/slab.h~mm-add-additional-consistency-check
+++ a/mm/slab.h
@@ -384,6 +384,7 @@ static inline struct kmem_cache *cache_f
 		return s;
 
 	page = virt_to_head_page(x);
+	BUG_ON(!PageSlab(page));
 	cachep = page->slab_cache;
 	if (slab_equal_or_root(cachep, s))
 		return cachep;
_

Patches currently in -mm which might be from keescook@chromium.org are

mm-remove-rodata_test_data-export-add-pr_fmt.patch
reiserfs-use-designated-initializers.patch
format-security-move-static-strings-to-const.patch

