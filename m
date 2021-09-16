Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD9CC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5C686120F
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346108AbhIPTGz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:06:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346681AbhIPTGn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2B306120E;
        Thu, 16 Sep 2021 19:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631819122;
        bh=HXn4PCd330jXx/wieVd/xvlj9+E8p7aBEUmbV6/G1Dg=;
        h=Date:From:To:Subject:From;
        b=nWH22VdqEYT7oUnhdw8xGZenIpuEE0nuVz9o/kANUWHa76mULHWYqrGlxWDoOgV37
         cZ/5O8oYYYVue1WBh4B2swH8K1en+NTyGa+uUqsBZmyUgeMUyVN8TihPVISbgI/lgg
         VPOyr6H5w9bHp/T+PCc8cZz9Vlwd63suoAeNPvjA=
Date:   Thu, 16 Sep 2021 12:05:21 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        thgarnie@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch added to
 -mm tree
Message-ID: <20210916190521.8r9q91nTX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix potential use-after-free in slab_debugfs_fops
has been added to the -mm tree.  Its filename is
     mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops.patch

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
Subject: mm, slub: fix potential use-after-free in slab_debugfs_fops

When sysfs_slab_add failed, we shouldn't call debugfs_slab_add() for s
because s will be freed soon.  And slab_debugfs_fops will use s later
leading to a use-after-free.

Link: https://lkml.kernel.org/r/20210916123920.48704-5-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
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

 mm/slub.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/slub.c~mm-slub-fix-potential-use-after-free-in-slab_debugfs_fops
+++ a/mm/slub.c
@@ -4887,13 +4887,15 @@ int __kmem_cache_create(struct kmem_cach
 		return 0;
 
 	err = sysfs_slab_add(s);
-	if (err)
+	if (err) {
 		__kmem_cache_release(s);
+		return err;
+	}
 
 	if (s->flags & SLAB_STORE_USER)
 		debugfs_slab_add(s);
 
-	return err;
+	return 0;
 }
 
 void *__kmalloc_track_caller(size_t size, gfp_t gfpflags, unsigned long caller)
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

