Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BABC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 19:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348896AbiEGTls (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 15:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346517AbiEGTlr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 15:41:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E718420BE4
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 12:37:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 847EE60A6D
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 19:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9173C385A5;
        Sat,  7 May 2022 19:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651952279;
        bh=vICoDT4Qwm1fvq41QZq27Tb25Adh1ARM3rgr3acdN1c=;
        h=Date:To:From:Subject:From;
        b=MmIBqdUAkQa5hGLrEoGBAqeMBGInM9fSCXEt5IqNkWhxSf9hqpq+rdYPLYMKLqpC+
         mwJmpNQMDlxi9z46Yhkb4bU/094U81IzJ3ji+Y/YZURXJ6pyHOvmItbxplnvPh8Nbh
         Jjldc/30TGSTHNqOcPMVkQmaYzNpQUXEQbD7ragg=
Date:   Sat, 07 May 2022 12:37:58 -0700
To:     mm-commits@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        vvs@openvz.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tracing-incorrect-gfp_t-conversion.patch added to mm-unstable branch
Message-Id: <20220507193758.D9173C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tracing: incorrect gfp_t conversion
has been added to the -mm mm-unstable branch.  Its filename is
     tracing-incorrect-gfp_t-conversion.patch

This patch should soon appear in the mm-unstable branch at
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
From: Vasily Averin <vvs@openvz.org>
Subject: tracing: incorrect gfp_t conversion

Fixes the following sparse warnings:

include/trace/events/*: sparse: cast to restricted gfp_t
include/trace/events/*: sparse: restricted gfp_t degrades to integer

gfp_t type is bitwise and requires __force attributes for any casts.

Link: https://lkml.kernel.org/r/331d88fe-f4f7-657c-02a2-d977f15fbff6@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h               |    2 
 include/trace/events/btrfs.h      |    4 -
 include/trace/events/compaction.h |    4 -
 include/trace/events/kmem.h       |   12 ++--
 include/trace/events/mmflags.h    |   78 ++++++++++++++--------------
 include/trace/events/vmscan.h     |   16 ++---
 mm/compaction.c                   |    2 
 7 files changed, 59 insertions(+), 59 deletions(-)

--- a/include/linux/gfp.h~tracing-incorrect-gfp_t-conversion
+++ a/include/linux/gfp.h
@@ -367,7 +367,7 @@ static inline int gfp_migratetype(const
 		return MIGRATE_UNMOVABLE;
 
 	/* Group based on mobility */
-	return (gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
+	return (__force unsigned long)(gfp_flags & GFP_MOVABLE_MASK) >> GFP_MOVABLE_SHIFT;
 }
 #undef GFP_MOVABLE_MASK
 #undef GFP_MOVABLE_SHIFT
--- a/include/trace/events/btrfs.h~tracing-incorrect-gfp_t-conversion
+++ a/include/trace/events/btrfs.h
@@ -1344,13 +1344,13 @@ TRACE_EVENT(alloc_extent_state,
 
 	TP_STRUCT__entry(
 		__field(const struct extent_state *, state)
-		__field(gfp_t, mask)
+		__field(unsigned long, mask)
 		__field(const void*, ip)
 	),
 
 	TP_fast_assign(
 		__entry->state	= state,
-		__entry->mask	= mask,
+		__entry->mask	= (__force unsigned long)mask,
 		__entry->ip	= (const void *)IP
 	),
 
--- a/include/trace/events/compaction.h~tracing-incorrect-gfp_t-conversion
+++ a/include/trace/events/compaction.h
@@ -162,13 +162,13 @@ TRACE_EVENT(mm_compaction_try_to_compact
 
 	TP_STRUCT__entry(
 		__field(int, order)
-		__field(gfp_t, gfp_mask)
+		__field(unsigned long, gfp_mask)
 		__field(int, prio)
 	),
 
 	TP_fast_assign(
 		__entry->order = order;
-		__entry->gfp_mask = gfp_mask;
+		__entry->gfp_mask = (__force unsigned long)gfp_mask;
 		__entry->prio = prio;
 	),
 
--- a/include/trace/events/kmem.h~tracing-incorrect-gfp_t-conversion
+++ a/include/trace/events/kmem.h
@@ -24,7 +24,7 @@ DECLARE_EVENT_CLASS(kmem_alloc,
 		__field(	const void *,	ptr		)
 		__field(	size_t,		bytes_req	)
 		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
+		__field(	unsigned long,	gfp_flags	)
 	),
 
 	TP_fast_assign(
@@ -32,7 +32,7 @@ DECLARE_EVENT_CLASS(kmem_alloc,
 		__entry->ptr		= ptr;
 		__entry->bytes_req	= bytes_req;
 		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
+		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 	),
 
 	TP_printk("call_site=%pS ptr=%p bytes_req=%zu bytes_alloc=%zu gfp_flags=%s",
@@ -75,7 +75,7 @@ DECLARE_EVENT_CLASS(kmem_alloc_node,
 		__field(	const void *,	ptr		)
 		__field(	size_t,		bytes_req	)
 		__field(	size_t,		bytes_alloc	)
-		__field(	gfp_t,		gfp_flags	)
+		__field(	unsigned long,	gfp_flags	)
 		__field(	int,		node		)
 	),
 
@@ -84,7 +84,7 @@ DECLARE_EVENT_CLASS(kmem_alloc_node,
 		__entry->ptr		= ptr;
 		__entry->bytes_req	= bytes_req;
 		__entry->bytes_alloc	= bytes_alloc;
-		__entry->gfp_flags	= gfp_flags;
+		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->node		= node;
 	),
 
@@ -208,14 +208,14 @@ TRACE_EVENT(mm_page_alloc,
 	TP_STRUCT__entry(
 		__field(	unsigned long,	pfn		)
 		__field(	unsigned int,	order		)
-		__field(	gfp_t,		gfp_flags	)
+		__field(	unsigned long,	gfp_flags	)
 		__field(	int,		migratetype	)
 	),
 
 	TP_fast_assign(
 		__entry->pfn		= page ? page_to_pfn(page) : -1UL;
 		__entry->order		= order;
-		__entry->gfp_flags	= gfp_flags;
+		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 		__entry->migratetype	= migratetype;
 	),
 
--- a/include/trace/events/mmflags.h~tracing-incorrect-gfp_t-conversion
+++ a/include/trace/events/mmflags.h
@@ -14,48 +14,48 @@
  */
 
 #define __def_gfpflag_names						\
-	{(unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
-	{(unsigned long)GFP_TRANSHUGE_LIGHT,	"GFP_TRANSHUGE_LIGHT"}, \
-	{(unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},\
-	{(unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
-	{(unsigned long)GFP_USER,		"GFP_USER"},		\
-	{(unsigned long)GFP_KERNEL_ACCOUNT,	"GFP_KERNEL_ACCOUNT"},	\
-	{(unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
-	{(unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
-	{(unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
-	{(unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
-	{(unsigned long)GFP_NOWAIT,		"GFP_NOWAIT"},		\
-	{(unsigned long)GFP_DMA,		"GFP_DMA"},		\
-	{(unsigned long)__GFP_HIGHMEM,		"__GFP_HIGHMEM"},	\
-	{(unsigned long)GFP_DMA32,		"GFP_DMA32"},		\
-	{(unsigned long)__GFP_HIGH,		"__GFP_HIGH"},		\
-	{(unsigned long)__GFP_ATOMIC,		"__GFP_ATOMIC"},	\
-	{(unsigned long)__GFP_IO,		"__GFP_IO"},		\
-	{(unsigned long)__GFP_FS,		"__GFP_FS"},		\
-	{(unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
-	{(unsigned long)__GFP_RETRY_MAYFAIL,	"__GFP_RETRY_MAYFAIL"},	\
-	{(unsigned long)__GFP_NOFAIL,		"__GFP_NOFAIL"},	\
-	{(unsigned long)__GFP_NORETRY,		"__GFP_NORETRY"},	\
-	{(unsigned long)__GFP_COMP,		"__GFP_COMP"},		\
-	{(unsigned long)__GFP_ZERO,		"__GFP_ZERO"},		\
-	{(unsigned long)__GFP_NOMEMALLOC,	"__GFP_NOMEMALLOC"},	\
-	{(unsigned long)__GFP_MEMALLOC,		"__GFP_MEMALLOC"},	\
-	{(unsigned long)__GFP_HARDWALL,		"__GFP_HARDWALL"},	\
-	{(unsigned long)__GFP_THISNODE,		"__GFP_THISNODE"},	\
-	{(unsigned long)__GFP_RECLAIMABLE,	"__GFP_RECLAIMABLE"},	\
-	{(unsigned long)__GFP_MOVABLE,		"__GFP_MOVABLE"},	\
-	{(unsigned long)__GFP_ACCOUNT,		"__GFP_ACCOUNT"},	\
-	{(unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
-	{(unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
-	{(unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
-	{(unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
-	{(unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"}	\
+	{(__force unsigned long)GFP_TRANSHUGE,		"GFP_TRANSHUGE"},	\
+	{(__force unsigned long)GFP_TRANSHUGE_LIGHT,	"GFP_TRANSHUGE_LIGHT"}, \
+	{(__force unsigned long)GFP_HIGHUSER_MOVABLE,	"GFP_HIGHUSER_MOVABLE"},\
+	{(__force unsigned long)GFP_HIGHUSER,		"GFP_HIGHUSER"},	\
+	{(__force unsigned long)GFP_USER,		"GFP_USER"},		\
+	{(__force unsigned long)GFP_KERNEL_ACCOUNT,	"GFP_KERNEL_ACCOUNT"},	\
+	{(__force unsigned long)GFP_KERNEL,		"GFP_KERNEL"},		\
+	{(__force unsigned long)GFP_NOFS,		"GFP_NOFS"},		\
+	{(__force unsigned long)GFP_ATOMIC,		"GFP_ATOMIC"},		\
+	{(__force unsigned long)GFP_NOIO,		"GFP_NOIO"},		\
+	{(__force unsigned long)GFP_NOWAIT,		"GFP_NOWAIT"},		\
+	{(__force unsigned long)GFP_DMA,		"GFP_DMA"},		\
+	{(__force unsigned long)__GFP_HIGHMEM,		"__GFP_HIGHMEM"},	\
+	{(__force unsigned long)GFP_DMA32,		"GFP_DMA32"},		\
+	{(__force unsigned long)__GFP_HIGH,		"__GFP_HIGH"},		\
+	{(__force unsigned long)__GFP_ATOMIC,		"__GFP_ATOMIC"},	\
+	{(__force unsigned long)__GFP_IO,		"__GFP_IO"},		\
+	{(__force unsigned long)__GFP_FS,		"__GFP_FS"},		\
+	{(__force unsigned long)__GFP_NOWARN,		"__GFP_NOWARN"},	\
+	{(__force unsigned long)__GFP_RETRY_MAYFAIL,	"__GFP_RETRY_MAYFAIL"},	\
+	{(__force unsigned long)__GFP_NOFAIL,		"__GFP_NOFAIL"},	\
+	{(__force unsigned long)__GFP_NORETRY,		"__GFP_NORETRY"},	\
+	{(__force unsigned long)__GFP_COMP,		"__GFP_COMP"},		\
+	{(__force unsigned long)__GFP_ZERO,		"__GFP_ZERO"},		\
+	{(__force unsigned long)__GFP_NOMEMALLOC,	"__GFP_NOMEMALLOC"},	\
+	{(__force unsigned long)__GFP_MEMALLOC,		"__GFP_MEMALLOC"},	\
+	{(__force unsigned long)__GFP_HARDWALL,		"__GFP_HARDWALL"},	\
+	{(__force unsigned long)__GFP_THISNODE,		"__GFP_THISNODE"},	\
+	{(__force unsigned long)__GFP_RECLAIMABLE,	"__GFP_RECLAIMABLE"},	\
+	{(__force unsigned long)__GFP_MOVABLE,		"__GFP_MOVABLE"},	\
+	{(__force unsigned long)__GFP_ACCOUNT,		"__GFP_ACCOUNT"},	\
+	{(__force unsigned long)__GFP_WRITE,		"__GFP_WRITE"},		\
+	{(__force unsigned long)__GFP_RECLAIM,		"__GFP_RECLAIM"},	\
+	{(__force unsigned long)__GFP_DIRECT_RECLAIM,	"__GFP_DIRECT_RECLAIM"},\
+	{(__force unsigned long)__GFP_KSWAPD_RECLAIM,	"__GFP_KSWAPD_RECLAIM"},\
+	{(__force unsigned long)__GFP_ZEROTAGS,		"__GFP_ZEROTAGS"}	\
 
 #ifdef CONFIG_KASAN_HW_TAGS
 #define __def_gfpflag_names_kasan ,					       \
-	{(unsigned long)__GFP_SKIP_ZERO,	   "__GFP_SKIP_ZERO"},	       \
-	{(unsigned long)__GFP_SKIP_KASAN_POISON,   "__GFP_SKIP_KASAN_POISON"}, \
-	{(unsigned long)__GFP_SKIP_KASAN_UNPOISON, "__GFP_SKIP_KASAN_UNPOISON"}
+	{(__force unsigned long)__GFP_SKIP_ZERO,	   "__GFP_SKIP_ZERO"},	       \
+	{(__force unsigned long)__GFP_SKIP_KASAN_POISON,   "__GFP_SKIP_KASAN_POISON"}, \
+	{(__force unsigned long)__GFP_SKIP_KASAN_UNPOISON, "__GFP_SKIP_KASAN_UNPOISON"}
 #else
 #define __def_gfpflag_names_kasan
 #endif
--- a/include/trace/events/vmscan.h~tracing-incorrect-gfp_t-conversion
+++ a/include/trace/events/vmscan.h
@@ -96,14 +96,14 @@ TRACE_EVENT(mm_vmscan_wakeup_kswapd,
 		__field(	int,	nid		)
 		__field(	int,	zid		)
 		__field(	int,	order		)
-		__field(	gfp_t,	gfp_flags	)
+		__field(	unsigned long,	gfp_flags	)
 	),
 
 	TP_fast_assign(
 		__entry->nid		= nid;
 		__entry->zid		= zid;
 		__entry->order		= order;
-		__entry->gfp_flags	= gfp_flags;
+		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 	),
 
 	TP_printk("nid=%d order=%d gfp_flags=%s",
@@ -120,12 +120,12 @@ DECLARE_EVENT_CLASS(mm_vmscan_direct_rec
 
 	TP_STRUCT__entry(
 		__field(	int,	order		)
-		__field(	gfp_t,	gfp_flags	)
+		__field(	unsigned long,	gfp_flags	)
 	),
 
 	TP_fast_assign(
 		__entry->order		= order;
-		__entry->gfp_flags	= gfp_flags;
+		__entry->gfp_flags	= (__force unsigned long)gfp_flags;
 	),
 
 	TP_printk("order=%d gfp_flags=%s",
@@ -210,7 +210,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__field(void *, shrink)
 		__field(int, nid)
 		__field(long, nr_objects_to_shrink)
-		__field(gfp_t, gfp_flags)
+		__field(unsigned long, gfp_flags)
 		__field(unsigned long, cache_items)
 		__field(unsigned long long, delta)
 		__field(unsigned long, total_scan)
@@ -222,7 +222,7 @@ TRACE_EVENT(mm_shrink_slab_start,
 		__entry->shrink = shr->scan_objects;
 		__entry->nid = sc->nid;
 		__entry->nr_objects_to_shrink = nr_objects_to_shrink;
-		__entry->gfp_flags = sc->gfp_mask;
+		__entry->gfp_flags = (__force unsigned long)sc->gfp_mask;
 		__entry->cache_items = cache_items;
 		__entry->delta = delta;
 		__entry->total_scan = total_scan;
@@ -446,13 +446,13 @@ TRACE_EVENT(mm_vmscan_node_reclaim_begin
 	TP_STRUCT__entry(
 		__field(int, nid)
 		__field(int, order)
-		__field(gfp_t, gfp_flags)
+		__field(unsigned long, gfp_flags)
 	),
 
 	TP_fast_assign(
 		__entry->nid = nid;
 		__entry->order = order;
-		__entry->gfp_flags = gfp_flags;
+		__entry->gfp_flags = (__force unsigned long)gfp_flags;
 	),
 
 	TP_printk("nid=%d order=%d gfp_flags=%s",
--- a/mm/compaction.c~tracing-incorrect-gfp_t-conversion
+++ a/mm/compaction.c
@@ -2569,7 +2569,7 @@ enum compact_result try_to_compact_pages
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum compact_priority prio, struct page **capture)
 {
-	int may_perform_io = gfp_mask & __GFP_IO;
+	int may_perform_io = (__force int)(gfp_mask & __GFP_IO);
 	struct zoneref *z;
 	struct zone *zone;
 	enum compact_result rc = COMPACT_SKIPPED;
_

Patches currently in -mm which might be from vvs@openvz.org are

percpu-improve-percpu_alloc_percpu-event-trace.patch
tracing-incorrect-gfp_t-conversion.patch

