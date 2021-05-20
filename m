Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923A0C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 22:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 750D5613C7
	for <mm-commits@archiver.kernel.org>; Thu, 20 May 2021 22:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhETWHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 May 2021 18:07:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhETWHS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 May 2021 18:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD26613C3;
        Thu, 20 May 2021 22:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621548356;
        bh=Y6PHXvoBlG+I8HFiktr8v+H23YKc7wNRlytQvWdwlyI=;
        h=Date:From:To:Subject:From;
        b=m8LwHRkdqecKEMtglHUUb2xL/eh3Q3Vbu5P5zp6utXQaM5Gq/RaOOLbCQOy6ZFPdK
         KTEiFQrRzh7Hw4644nQ0UurEvT4PreK6sF3KVtFeb1ZfHXIda+fxOCOno5Z6Noaxue
         j5c++YLmpl82wY+CeI2hg2UME7zrfC0SOY8qXyxw=
Date:   Thu, 20 May 2021 15:05:55 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  +
 mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch added
 to -mm tree
Message-ID: <20210520220555.QjZ5Sqvxv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: include header for prototype of set_iounmap_nonlazy
has been added to the -mm tree.  Its filename is
     mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/vmalloc: include header for prototype of set_iounmap_nonlazy

make W=1 generates the following warning for mm/vmalloc.c

  mm/vmalloc.c:1599:6: warning: no previous prototype for `set_iounmap_nonlazy' [-Wmissing-prototypes]
   void set_iounmap_nonlazy(void)
        ^~~~~~~~~~~~~~~~~~~

This is an arch-generic function only used by x86.  On other arches, it's
dead code.  Include the header with the definition and make it x86-64
specific.

Link: https://lkml.kernel.org/r/20210520084809.8576-3-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmalloc.c~mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy
+++ a/mm/vmalloc.c
@@ -25,6 +25,7 @@
 #include <linux/notifier.h>
 #include <linux/rbtree.h>
 #include <linux/xarray.h>
+#include <linux/io.h>
 #include <linux/rcupdate.h>
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
@@ -1607,6 +1608,7 @@ static DEFINE_MUTEX(vmap_purge_lock);
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
 
+#ifdef CONFIG_X86_64
 /*
  * called before a call to iounmap() if the caller wants vm_area_struct's
  * immediately freed.
@@ -1615,6 +1617,7 @@ void set_iounmap_nonlazy(void)
 {
 	atomic_long_set(&vmap_lazy_nr, lazy_max_pages()+1);
 }
+#endif /* CONFIG_X86_64 */
 
 /*
  * Purges all lazily-freed vmap areas.
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-split-per-cpu-page-lists-and-zone-stats.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch
mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock.patch
mm-vmstat-convert-numa-statistics-to-basic-numa-counters.patch
mm-vmstat-inline-numa-event-counter-updates.patch
mm-page_alloc-batch-the-accounting-updates-in-the-bulk-allocator.patch
mm-page_alloc-reduce-duration-that-irqs-are-disabled-for-vm-counters.patch
mm-page_alloc-explicitly-acquire-the-zone-lock-in-__free_pages_ok.patch
mm-page_alloc-avoid-conflating-irqs-disabled-with-zone-lock.patch
mm-page_alloc-update-pgfree-outside-the-zone-lock-in-__free_pages_ok.patch
mm-vmscan-remove-kerneldoc-like-comment-from-isolate_lru_pages.patch
mm-vmalloc-include-header-for-prototype-of-set_iounmap_nonlazy.patch
mm-page_alloc-make-should_fail_alloc_page-a-static-function-should_fail_alloc_page-static.patch
mm-mapping_dirty_helpers-remove-double-note-in-kerneldoc.patch
mm-early_ioremap-add-prototype-for-early_memremap_pgprot_adjust.patch
mm-memcontrolc-fix-kerneldoc-comment-for-mem_cgroup_calculate_protection.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__try_online_node.patch
mm-memory_hotplug-fix-kerneldoc-comment-for-__remove_memory.patch
mm-zbud-add-kerneldoc-fields-for-zbud_pool.patch
mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch
mm-swap-make-swap_address_space-an-inline-function.patch
mm-mmap_lock-remove-dead-code-for-config_tracing-configurations.patch
mm-page_alloc-move-prototype-for-find_suitable_fallback.patch
mm-swap-make-node_data-an-inline-function-on-config_flatmem.patch

