Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D60C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A8516120D
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346681AbhIPTG6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242895AbhIPTGo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:06:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A83A461216;
        Thu, 16 Sep 2021 19:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631819124;
        bh=EHfRzJtoOe68duHlnupkuLMfoEgCdv21Ffr764TWrks=;
        h=Date:From:To:Subject:From;
        b=hH4pVx7c15i/5kXSAxcqFj9iB0z1TEM5Z2r2Jzn2+w+hzTOvBkq7DLwgKNlcaxsse
         6B7727S/o6TQLUzQZTNykwn8s9Qc8lw5twnIbEZ/TPBYng8KkNGOUh59dTdUMSIKKW
         Whi2povmfSnNCqr2yyYMoMUgrdU7tfaCbnVV0M5Q=
Date:   Thu, 16 Sep 2021 12:05:23 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        thgarnie@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch added to -mm
 tree
Message-ID: <20210916190523.zizQT4A9I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix incorrect memcg slab count for bulk free
has been added to the -mm tree.  Its filename is
     mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free.patch

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
Subject: mm, slub: fix incorrect memcg slab count for bulk free

kmem_cache_free_bulk() will call memcg_slab_free_hook() for all objects
when doing bulk free.  So we shouldn't call memcg_slab_free_hook() again
for bulk free to avoid incorrect memcg slab count.

Link: https://lkml.kernel.org/r/20210916123920.48704-6-linmiaohe@huawei.com
Fixes: d1b2cf6cb84a ("mm: memcg/slab: uncharge during kmem_cache_free_bulk()")
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

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-incorrect-memcg-slab-count-for-bulk-free
+++ a/mm/slub.c
@@ -3420,7 +3420,9 @@ static __always_inline void do_slab_free
 	struct kmem_cache_cpu *c;
 	unsigned long tid;
 
-	memcg_slab_free_hook(s, &head, 1);
+	/* memcg_slab_free_hook() is already called for bulk free. */
+	if (!tail)
+		memcg_slab_free_hook(s, &head, 1);
 redo:
 	/*
 	 * Determine the currently cpus per cpu slab.
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

