Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB9FBC07E99
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:50:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3045613C2
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jul 2021 22:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIWxF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jul 2021 18:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGIWxE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Jul 2021 18:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEC1361167;
        Fri,  9 Jul 2021 22:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625871020;
        bh=KJN1N9/bgm47gNEIjSEMdD2YkrV0GRLxD76DeqlR2uQ=;
        h=Date:From:To:Subject:From;
        b=nzrm2wOxx7q5QAaUWumFWjqQmUcAGZgODHqz/4ztwSWtl2EWUOOjkVdbBhF5yhH0d
         NeLcE28tgCpi3WGqQji/AzzTb3POh27bRxWnhTFcWo2V+lmWx9dl8dOGfQMVtTzBvR
         4PzMp5TQbIcOr5Rz2ex5Y1XfxiU90NA/crLZHj1s=
Date:   Fri, 09 Jul 2021 15:50:20 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, skhan@linuxfoundation.org,
        Qiang.Zhang@windriver.com, desmondcheongzx@gmail.com,
        aquini@redhat.com, mgorman@techsingularity.net
Subject:  +
 mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held.patch
 added to -mm tree
Message-ID: <20210709225020.l9KFc%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: avoid page allocator recursion with pagesets.lock held
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held.patch

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
Subject: mm/page_alloc: avoid page allocator recursion with pagesets.lock held

Syzbot is reporting potential deadlocks due to pagesets.lock when
PAGE_OWNER is enabled.  One example from Desmond Cheong Zhi Xi is as
follows

  __alloc_pages_bulk()
    local_lock_irqsave(&pagesets.lock, flags) <---- outer lock here
    prep_new_page():
      post_alloc_hook():
        set_page_owner():
          __set_page_owner():
            save_stack():
              stack_depot_save():
                alloc_pages():
                  alloc_page_interleave():
                    __alloc_pages():
                      get_page_from_freelist():
                        rm_queue():
                          rm_queue_pcplist():
                            local_lock_irqsave(&pagesets.lock, flags);
                            *** DEADLOCK ***

Zhang, Qiang also reported

  BUG: sleeping function called from invalid context at mm/page_alloc.c:5179
  in_atomic(): 0, irqs_disabled(): 1, non_block: 0, pid: 1, name: swapper/0
  .....
  __dump_stack lib/dump_stack.c:79 [inline]
  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:96
  ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9153
  prepare_alloc_pages+0x3da/0x580 mm/page_alloc.c:5179
  __alloc_pages+0x12f/0x500 mm/page_alloc.c:5375
  alloc_page_interleave+0x1e/0x200 mm/mempolicy.c:2147
  alloc_pages+0x238/0x2a0 mm/mempolicy.c:2270
  stack_depot_save+0x39d/0x4e0 lib/stackdepot.c:303
  save_stack+0x15e/0x1e0 mm/page_owner.c:120
  __set_page_owner+0x50/0x290 mm/page_owner.c:181
  prep_new_page mm/page_alloc.c:2445 [inline]
  __alloc_pages_bulk+0x8b9/0x1870 mm/page_alloc.c:5313
  alloc_pages_bulk_array_node include/linux/gfp.h:557 [inline]
  vm_area_alloc_pages mm/vmalloc.c:2775 [inline]
  __vmalloc_area_node mm/vmalloc.c:2845 [inline]
  __vmalloc_node_range+0x39d/0x960 mm/vmalloc.c:2947
  __vmalloc_node mm/vmalloc.c:2996 [inline]
  vzalloc+0x67/0x80 mm/vmalloc.c:3066

There are a number of ways it could be fixed.  The page owner code could
be audited to strip GFP flags that allow sleeping but it'll impair the
functionality of PAGE_OWNER if allocations fail.  The bulk allocator could
add a special case to release/reacquire the lock for prep_new_page and
lookup PCP after the lock is reacquired at the cost of performance.  The
patches requiring prep could be tracked using the least significant bit
and looping through the array although it is more complicated for the list
interface.  The options are relatively complex and the second one still
incurs a performance penalty when PAGE_OWNER is active so this patch takes
the simple approach -- disable bulk allocation of PAGE_OWNER is active. 
The caller will be forced to allocate one page at a time incurring a
performance penalty but PAGE_OWNER is already a performance penalty.

Link: https://lkml.kernel.org/r/20210708081434.GV3840@techsingularity.net
Fixes: dbbee9d5cd83 ("mm/page_alloc: convert per-cpu list protection to local_lock")
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reported-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Reported-by: "Zhang, Qiang" <Qiang.Zhang@windriver.com>
Reported-by: syzbot+127fd7828d6eeb611703@syzkaller.appspotmail.com
Tested-by: syzbot+127fd7828d6eeb611703@syzkaller.appspotmail.com
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held
+++ a/mm/page_alloc.c
@@ -5239,6 +5239,18 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	if (nr_pages - nr_populated == 1)
 		goto failed;
 
+#ifdef CONFIG_PAGE_OWNER
+	/*
+	 * PAGE_OWNER may recurse into the allocator to allocate space to
+	 * save the stack with pagesets.lock held. Releasing/reacquiring
+	 * removes much of the performance benefit of bulk allocation so
+	 * force the caller to allocate one page at a time as it'll have
+	 * similar performance to added complexity to the bulk allocator.
+	 */
+	if (static_branch_unlikely(&page_owner_inited))
+		goto failed;
+#endif
+
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	alloc_gfp = gfp;
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-revert-pahole-zero-sized-workaround.patch
mm-page_alloc-avoid-page-allocator-recursion-with-pagesetslock-held.patch

