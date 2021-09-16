Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5182AC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 266B86121F
	for <mm-commits@archiver.kernel.org>; Thu, 16 Sep 2021 19:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbhIPTGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Sep 2021 15:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344027AbhIPTGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Sep 2021 15:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E961461207;
        Thu, 16 Sep 2021 19:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631819115;
        bh=Yjr0w9Wjk4D0hMSaqCb4t9B/DpjaUjxaFAaLzDbCJqE=;
        h=Date:From:To:Subject:From;
        b=YwcUzZbfjh7mtLavTjgp02vPI4eB4SGElWuLfHlKdKWNNpMgxnYHBrlsiuoq8eQxf
         p7PW6wP+jefxw0DYznTXPomrRmZoTd5T+kDOJbCA83/eYRb0VCfelVcpvfZbDkKh4t
         6CKiFfkeDKNU/UpILXXXJFO3KBSz3nmmdOrfaNxA=
Date:   Thu, 16 Sep 2021 12:05:14 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bharata@linux.ibm.com, cl@linux.com,
        faiyazm@codeaurora.org, gregkh@linuxfoundation.org, guro@fb.com,
        iamjoonsoo.kim@lge.com, keescook@chromium.org,
        linmiaohe@huawei.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, ryabinin.a.a@gmail.com,
        thgarnie@google.com, vbabka@suse.cz
Subject:  + mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch
 added to -mm tree
Message-ID: <20210916190514.GHsk-cOfV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: fix two bugs in slab_debug_trace_open()
has been added to the -mm tree.  Its filename is
     mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-fix-two-bugs-in-slab_debug_trace_open.patch

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
Subject: mm, slub: fix two bugs in slab_debug_trace_open()

Patch series "Fixups for slub".

This series contains various bug fixes for slub.  We fix memoryleak,
use-afer-free, NULL pointer dereferencing and so on in slub.  More details
can be found in the respective changelogs.


This patch (of 5):

It's possible that __seq_open_private() will return NULL.  So we should
check t before using lest dereferencing NULL pointer.  And in error paths,
we forgot to release private buffer via seq_release_private().  Memory
will leak in these paths.

Link: https://lkml.kernel.org/r/20210916123920.48704-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210916123920.48704-2-linmiaohe@huawei.com
Fixes: 64dd68497be7 ("mm: slub: move sysfs slab alloc/free interfaces to debugfs")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Faiyaz Mohammed <faiyazm@codeaurora.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Thomas Garnier <thgarnie@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-two-bugs-in-slab_debug_trace_open
+++ a/mm/slub.c
@@ -6108,9 +6108,14 @@ static int slab_debug_trace_open(struct
 	struct kmem_cache *s = file_inode(filep)->i_private;
 	unsigned long *obj_map;
 
+	if (!t)
+		return -ENOMEM;
+
 	obj_map = bitmap_alloc(oo_objects(s->oo), GFP_KERNEL);
-	if (!obj_map)
+	if (!obj_map) {
+		seq_release_private(inode, filep);
 		return -ENOMEM;
+	}
 
 	if (strcmp(filep->f_path.dentry->d_name.name, "alloc_traces") == 0)
 		alloc = TRACK_ALLOC;
@@ -6119,6 +6124,7 @@ static int slab_debug_trace_open(struct
 
 	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL)) {
 		bitmap_free(obj_map);
+		seq_release_private(inode, filep);
 		return -ENOMEM;
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

