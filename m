From: akpm@linux-foundation.org
Subject: + mm-slab-fix-stale-code-comment.patch added to -mm tree
Date: Tue, 26 Jan 2016 21:30:15 -0800
Message-ID: <56a855e7.FhSlWbxhJVdy/K66%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbcA0FaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix stale code comment
has been added to the -mm tree.  Its filename is
     mm-slab-fix-stale-code-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-fix-stale-code-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-fix-stale-code-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slab: fix stale code comment

This patchset implements new freed object management way, that is,
OBJFREELIST_SLAB.  Purpose of it is to reduce memory overhead in SLAB.

SLAB needs a array to manage freed objects in a slab.  If there is
leftover after objects are packed into a slab, we can use it as a
management array, and, in this case, there is no memory waste.  But, in
the other cases, we need to allocate extra memory for a management array
or utilize dedicated internal memory in a slab for it.  Both cases causes
memory waste so it's not good.

With this patchset, freed object itself can be used for a management
array.  So, memory waste could be reduced.  Detailed idea and numbers are
described in last patch's commit description.  Please refer it.

In fact, I tested another idea implementing OBJFREELIST_SLAB with
extendable linked array through another freed object.  It can remove
memory waste completely but it causes more computational overhead in
critical lock path and it seems that overhead outweigh benefit.  So, this
patchset doesn't include it.  I will attach prototype just for a
reference.



This patch (of 16):

We use freelist_idx_t type for free object management whose size would be
smaller than size of unsigned int.  Fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-fix-stale-code-comment mm/slab.c
--- a/mm/slab.c~mm-slab-fix-stale-code-comment
+++ a/mm/slab.c
@@ -537,7 +537,7 @@ static void cache_estimate(unsigned long
 	 * on it. For the latter case, the memory allocated for a
 	 * slab is used for:
 	 *
-	 * - One unsigned int for each object
+	 * - One freelist_idx_t for each object
 	 * - Padding to respect alignment of @align
 	 * - @buffer_size bytes for each object
 	 *
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch

