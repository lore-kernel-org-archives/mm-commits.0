Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EE2FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 18:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbiEJS7e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 14:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344041AbiEJS7d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 14:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4831F56FBB
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 11:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3C1C60C71
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 18:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34174C385A6;
        Tue, 10 May 2022 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652209171;
        bh=SQXsYWtg++AItbOi7lsVtVAN0rxptKWR9XfOHI1zn4U=;
        h=Date:To:From:Subject:From;
        b=VGGvlnAN2FN+VxCb8SUsFIDSIbKYUpUfC8gvfcJHZKiIvjpA0pJybh7mKXUcdUxH7
         D4yo4qmo14N6atRvdEiMjTXBGWylYUIChm3dN2muHr0nxOufafrR7KHfSoHgv2gFV7
         iNdkYn10qr79DBnn9tdFH33cwv/TPb9gFyVtUYfs=
Date:   Tue, 10 May 2022 11:59:30 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        akinobu.mita@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-missing-handler-for-__gfp_nowarn.patch added to mm-unstable branch
Message-Id: <20220510185931.34174C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix missing handler for __GFP_NOWARN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-missing-handler-for-__gfp_nowarn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-missing-handler-for-__gfp_nowarn.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: fix missing handler for __GFP_NOWARN

We expect no warnings to be issued when we specify __GFP_NOWARN, but
currently in paths like alloc_pages() and kmalloc(), there are still some
warnings printed, fix it.

Link: https://lkml.kernel.org/r/20220510113809.80626-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fault-inject.h |    2 ++
 lib/fault-inject.c           |    3 +++
 mm/failslab.c                |    3 +++
 mm/internal.h                |   11 +++++++++++
 mm/page_alloc.c              |   18 ++++++++++--------
 5 files changed, 29 insertions(+), 8 deletions(-)

--- a/include/linux/fault-inject.h~mm-fix-missing-handler-for-__gfp_nowarn
+++ a/include/linux/fault-inject.h
@@ -20,6 +20,7 @@ struct fault_attr {
 	atomic_t space;
 	unsigned long verbose;
 	bool task_filter;
+	bool no_warn;
 	unsigned long stacktrace_depth;
 	unsigned long require_start;
 	unsigned long require_end;
@@ -39,6 +40,7 @@ struct fault_attr {
 		.ratelimit_state = RATELIMIT_STATE_INIT_DISABLED,	\
 		.verbose = 2,						\
 		.dname = NULL,						\
+		.no_warn = false,					\
 	}
 
 #define DECLARE_FAULT_ATTR(name) struct fault_attr name = FAULT_ATTR_INITIALIZER
--- a/lib/fault-inject.c~mm-fix-missing-handler-for-__gfp_nowarn
+++ a/lib/fault-inject.c
@@ -41,6 +41,9 @@ EXPORT_SYMBOL_GPL(setup_fault_attr);
 
 static void fail_dump(struct fault_attr *attr)
 {
+	if (attr->no_warn)
+		return;
+
 	if (attr->verbose > 0 && __ratelimit(&attr->ratelimit_state)) {
 		printk(KERN_NOTICE "FAULT_INJECTION: forcing a failure.\n"
 		       "name %pd, interval %lu, probability %lu, "
--- a/mm/failslab.c~mm-fix-missing-handler-for-__gfp_nowarn
+++ a/mm/failslab.c
@@ -30,6 +30,9 @@ bool __should_failslab(struct kmem_cache
 	if (failslab.cache_filter && !(s->flags & SLAB_FAILSLAB))
 		return false;
 
+	if (gfpflags & __GFP_NOWARN)
+		failslab.attr.no_warn = true;
+
 	return should_fail(&failslab.attr, s->object_size);
 }
 
--- a/mm/internal.h~mm-fix-missing-handler-for-__gfp_nowarn
+++ a/mm/internal.h
@@ -35,6 +35,17 @@ struct folio_batch;
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
+#define WARN_ON_ONCE_GFP(cond, gfp)	({				\
+	static bool __section(".data.once") __warned;			\
+	int __ret_warn_once = !!(cond);					\
+									\
+	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
+		__warned = true;					\
+		WARN_ON(1);						\
+	}								\
+	unlikely(__ret_warn_once);					\
+})
+
 void page_writeback_init(void);
 
 static inline void *folio_raw_mapping(struct folio *folio)
--- a/mm/page_alloc.c~mm-fix-missing-handler-for-__gfp_nowarn
+++ a/mm/page_alloc.c
@@ -3712,7 +3712,7 @@ struct page *rmqueue(struct zone *prefer
 	 * We most definitely don't want callers attempting to
 	 * allocate greater than order-1 page units with __GFP_NOFAIL.
 	 */
-	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
+	WARN_ON_ONCE_GFP((gfp_flags & __GFP_NOFAIL) && (order > 1), gfp_flags);
 
 	do {
 		page = NULL;
@@ -3789,6 +3789,9 @@ static bool __should_fail_alloc_page(gfp
 			(gfp_mask & __GFP_DIRECT_RECLAIM))
 		return false;
 
+	if (gfp_mask & __GFP_NOWARN)
+		fail_page_alloc.attr.no_warn = true;
+
 	return should_fail(&fail_page_alloc.attr, 1 << order);
 }
 
@@ -4337,7 +4340,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	 */
 
 	/* Exhausted what can be done so it's blame time */
-	if (out_of_memory(&oc) || WARN_ON_ONCE(gfp_mask & __GFP_NOFAIL)) {
+	if (out_of_memory(&oc) ||
+	    WARN_ON_ONCE_GFP(gfp_mask & __GFP_NOFAIL, gfp_mask)) {
 		*did_some_progress = 1;
 
 		/*
@@ -5103,7 +5107,7 @@ nopage:
 		 * All existing users of the __GFP_NOFAIL are blockable, so warn
 		 * of any new users that actually require GFP_NOWAIT
 		 */
-		if (WARN_ON_ONCE(!can_direct_reclaim))
+		if (WARN_ON_ONCE_GFP(!can_direct_reclaim, gfp_mask))
 			goto fail;
 
 		/*
@@ -5111,7 +5115,7 @@ nopage:
 		 * because we cannot reclaim anything and only can loop waiting
 		 * for somebody to do a work for us
 		 */
-		WARN_ON_ONCE(current->flags & PF_MEMALLOC);
+		WARN_ON_ONCE_GFP(current->flags & PF_MEMALLOC, gfp_mask);
 
 		/*
 		 * non failing costly orders are a hard requirement which we
@@ -5119,7 +5123,7 @@ nopage:
 		 * so that we can identify them and convert them to something
 		 * else.
 		 */
-		WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER);
+		WARN_ON_ONCE_GFP(order > PAGE_ALLOC_COSTLY_ORDER, gfp_mask);
 
 		/*
 		 * Help non-failing allocations by giving them access to memory
@@ -5365,10 +5369,8 @@ struct page *__alloc_pages(gfp_t gfp, un
 	 * There are several places where we assume that the order value is sane
 	 * so bail out early if the request is out of bound.
 	 */
-	if (unlikely(order >= MAX_ORDER)) {
-		WARN_ON_ONCE(!(gfp & __GFP_NOWARN));
+	if (WARN_ON_ONCE_GFP(order >= MAX_ORDER, gfp))
 		return NULL;
-	}
 
 	gfp &= gfp_allowed_mask;
 	/*
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-fix-missing-handler-for-__gfp_nowarn.patch
tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock.patch

