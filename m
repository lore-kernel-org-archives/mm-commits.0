Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF101C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B10E76120F
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbhIPTGt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346358AbhIPTGj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C45306120D;
        Thu, 16 Sep 2021 19:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631819118;
        bh=OTyCNaaZdr+c6F6yy0MlUd1rnNU/E+37ms/sxNq4URI=;
        h=Date:From:To:Subject:From;
        b=nPiAd9Eb9o1hRjD84U6fKSe+T0bxyvoy1qvB9VdjssDAMwr7rXsiyFRI6dz19GIwc
         V6gUAVHmjoDGf5zwRtkLNY2VdpMFyctRXIqeTwbdzc4L++8RPdWdmFbeAA57FwHi5J
         9Icw97q3JYLg2+SKhdP1gZxEwMu/qtJtEEqWIEjM=
Date:   Thu, 16 Sep 2021 12:05:17 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        thgarnie@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch
 added to -mm tree
Message-ID: <20210916190517.frHq64c6g%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix mismatch between reconstructed freelist depth and cnt
has been added to the -mm tree.  Its filename is
     mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, slub: fix mismatch between reconstructed freelist depth and cnt

If object's reuse is delayed, it will be excluded from the reconstructed
freelist.  But we forgot to adjust the cnt accordingly.  So there will be
a mismatch between reconstructed freelist depth and cnt.  This will lead
to free_debug_processing() complain about freelist count or a incorrect
slub inuse count.

Link: https://lkml.kernel.org/r/20210916123920.48704-3-linmiaohe@huawei.com
Fixes: c3895391df38 ("kasan, slub: fix handling of kasan_slab_free hook")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt
+++ a/mm/slub.c
@@ -1701,7 +1701,8 @@ static __always_inline bool slab_free_ho
 }
 
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
-					   void **head, void **tail)
+					   void **head, void **tail,
+					   int *cnt)
 {
 
 	void *object;
@@ -1728,6 +1729,12 @@ static inline bool slab_free_freelist_ho
 			*head = object;
 			if (!*tail)
 				*tail = object;
+		} else {
+			/*
+			 * Adjust the reconstructed freelist depth
+			 * accordingly if object's reuse is delayed.
+			 */
+			--(*cnt);
 		}
 	} while (object != old_tail);
 
@@ -3480,7 +3487,7 @@ static __always_inline void slab_free(st
 	 * With KASAN enabled slab_free_freelist_hook modifies the freelist
 	 * to remove objects, whose reuse must be delayed.
 	 */
-	if (slab_free_freelist_hook(s, &head, &tail))
+	if (slab_free_freelist_hook(s, &head, &tail, &cnt))
 		do_slab_free(s, page, head, tail, cnt, addr);
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch
mm-slub-fix-mismatch-between-reconstructed-freelist-depth-and-cnt.patch
mm-slub-fix-potential-memoryleak-in-kmem_cache_open.patch
mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch
mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch
mm-page_allocc-remove-meaningless-vm_bug_on-in-pindex_to_order.patch
mm-page_allocc-simplify-the-code-by-using-macro-k.patch
mm-page_allocc-fix-obsolete-comment-in-free_pcppages_bulk.patch
mm-page_allocc-use-helper-function-zone_spans_pfn.patch
mm-page_allocc-avoid-allocating-highmem-pages-via-alloc_pages_exact.patch
mm-page_isolation-fix-potential-missing-call-to-unset_migratetype_isolate.patch
mm-page_isolation-guard-against-possible-putback-unisolated-page.patch
mm-memory_hotplug-make-hwpoisoned-dirty-swapcache-pages-unmovable.patch
mm-zsmallocc-close-race-window-between-zs_pool_dec_isolated-and-zs_unregister_migration.patch
mm-zsmallocc-combine-two-atomic-ops-in-zs_pool_dec_isolated.patch

