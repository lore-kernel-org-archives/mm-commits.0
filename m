From: akpm@linux-foundation.org
Subject: + mm-add-additional-consistency-check.patch added to -mm tree
Date: Mon, 03 Apr 2017 16:04:16 -0700
Message-ID: <58e2d4f0.dfm7pSoWAfqsAvgD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55660 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbdDCXER (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2017 19:04:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, cl@linux.com, iamjoonsoo.kim@lge.com, mpe@ellerman.id.au, penberg@kernel.org, rientjes@google.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.h: add additional consistency check
has been added to the -mm tree.  Its filename is
     mm-add-additional-consistency-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-additional-consistency-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-additional-consistency-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: http://lkml.kernel.org/r/20170331164028.GA118828@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christoph Lameter <cl@linux.com>
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
mm-add-additional-consistency-check.patch
reiserfs-use-designated-initializers.patch

