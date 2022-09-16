Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4B4C6FA86
	for <mm-commits@archiver.kernel.org>; Fri, 16 Sep 2022 20:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiIPUHE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Sep 2022 16:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiIPUGz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Sep 2022 16:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710C3B99F5
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 13:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B99C62D76
        for <mm-commits@vger.kernel.org>; Fri, 16 Sep 2022 20:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E36C433C1;
        Fri, 16 Sep 2022 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663358813;
        bh=iChKuBB1Up5upBoAtvoN5mgtB+by/7nI/zlUDAtSCxY=;
        h=Date:To:From:Subject:From;
        b=pTGTPH37HLHZsIAluxQWSfUh631bIsn0mvhpeXb44M9jdZVNsHeGUyXpvqdFJJT4u
         phGHPK36C1wrGZhiLlH06aEPwEtB2GtlwxycOEaTI8Yq75cxIEvfxotY/tckv4Tt2F
         WbcL2Zhe4XlP68CfzV8yw6b7VngiX7AUYgDK8UrE=
Date:   Fri, 16 Sep 2022 13:06:52 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch added to mm-unstable branch
Message-Id: <20220916200653.62E36C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memory_hotplug: remove obsolete generic_free_nodedata()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, memory_hotplug: remove obsolete generic_free_nodedata()
Date: Fri, 16 Sep 2022 15:22:51 +0800

Commit 390511e1476e ("mm, memory_hotplug: drop arch_free_nodedata") drops
the last caller of generic_free_nodedata().  Remove it too.

Link: https://lkml.kernel.org/r/20220916072257.9639-11-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memory_hotplug.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/memory_hotplug.h~mm-memory_hotplug-remove-obsolete-generic_free_nodedata
+++ a/include/linux/memory_hotplug.h
@@ -43,11 +43,6 @@ extern void arch_refresh_nodedata(int ni
 ({								\
 	memblock_alloc(sizeof(*pgdat), SMP_CACHE_BYTES);	\
 })
-/*
- * This definition is just for error path in node hotadd.
- * For node hotremove, we have to replace this.
- */
-#define generic_free_nodedata(pgdat)	kfree(pgdat)
 
 extern pg_data_t *node_data[];
 static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
@@ -63,9 +58,6 @@ static inline pg_data_t *generic_alloc_n
 	BUG();
 	return NULL;
 }
-static inline void generic_free_nodedata(pg_data_t *pgdat)
-{
-}
 static inline void arch_refresh_nodedata(int nid, pg_data_t *pgdat)
 {
 }
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

