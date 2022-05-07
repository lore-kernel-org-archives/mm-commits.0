Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7569DC433EF
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 18:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386864AbiEGSqv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 14:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiEGSqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 14:46:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624E61EC43
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 11:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2BFC6141B
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 18:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10947C385A6;
        Sat,  7 May 2022 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651948982;
        bh=eyQysPhDOOf10S1Lbc4RZcgeeyfTfrgqw1KI3Df2+9Y=;
        h=Date:To:From:Subject:From;
        b=mmCDrJh/Djze8D8yijJ4y1c4dXbU5dXTD5SGMLRbw7XZi3X6WMH8Yvt5RoF19UiLj
         yFzKD9v+apqdjYlFCub6wgsa/ceBfxTSsJvU9fJQHpThSkPRdXsrYvBnoUnULXxwcM
         atSVs4Knf6u0vipNmPqQ681rk88QCTXc7H2VDbqI=
Date:   Sat, 07 May 2022 11:43:01 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, tj@kernel.org,
        shakeelb@google.com, rostedt@goodmis.org, roman.gushchin@linux.dev,
        mingo@redhat.com, mhocko@suse.com, dennis@kernel.org, cl@linux.com,
        vvs@openvz.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + percpu-improve-percpu_alloc_percpu-event-trace.patch added to mm-unstable branch
Message-Id: <20220507184302.10947C385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: percpu: improve percpu_alloc_percpu event trace
has been added to the -mm mm-unstable branch.  Its filename is
     percpu-improve-percpu_alloc_percpu-event-trace.patch

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
Subject: percpu: improve percpu_alloc_percpu event trace

Add call_site, bytes_alloc and gfp_flags fields to the output of the
percpu_alloc_percpu ftrace event:

mkdir-4393  [001]   169.334788: percpu_alloc_percpu:
 call_site=mem_cgroup_css_alloc+0xa6 reserved=0 is_atomic=0 size=2408 align=8
  base_addr=0xffffc7117fc00000 off=402176 ptr=0x3dc867a62300 bytes_alloc=14448
   gfp_flags=GFP_KERNEL_ACCOUNT

This is required to track memcg-accounted percpu allocations.

Link: https://lkml.kernel.org/r/a07be858-c8a3-7851-9086-e3262cbcf707@openvz.org
Signed-off-by: Vasily Averin <vvs@openvz.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/percpu.h |   23 +++++++++++++++++------
 mm/percpu-internal.h          |    8 ++++----
 mm/percpu.c                   |    5 +++--
 3 files changed, 24 insertions(+), 12 deletions(-)

--- a/include/trace/events/percpu.h~percpu-improve-percpu_alloc_percpu-event-trace
+++ a/include/trace/events/percpu.h
@@ -6,15 +6,20 @@
 #define _TRACE_PERCPU_H
 
 #include <linux/tracepoint.h>
+#include <trace/events/mmflags.h>
 
 TRACE_EVENT(percpu_alloc_percpu,
 
-	TP_PROTO(bool reserved, bool is_atomic, size_t size,
-		 size_t align, void *base_addr, int off, void __percpu *ptr),
+	TP_PROTO(unsigned long call_site,
+		 bool reserved, bool is_atomic, size_t size,
+		 size_t align, void *base_addr, int off,
+		 void __percpu *ptr, size_t bytes_alloc, gfp_t gfp_flags),
 
-	TP_ARGS(reserved, is_atomic, size, align, base_addr, off, ptr),
+	TP_ARGS(call_site, reserved, is_atomic, size, align, base_addr, off,
+		ptr, bytes_alloc, gfp_flags),
 
 	TP_STRUCT__entry(
+		__field(	unsigned long,		call_site	)
 		__field(	bool,			reserved	)
 		__field(	bool,			is_atomic	)
 		__field(	size_t,			size		)
@@ -22,9 +27,11 @@ TRACE_EVENT(percpu_alloc_percpu,
 		__field(	void *,			base_addr	)
 		__field(	int,			off		)
 		__field(	void __percpu *,	ptr		)
+		__field(	size_t,			bytes_alloc	)
+		__field(	gfp_t,			gfp_flags	)
 	),
-
 	TP_fast_assign(
+		__entry->call_site	= call_site;
 		__entry->reserved	= reserved;
 		__entry->is_atomic	= is_atomic;
 		__entry->size		= size;
@@ -32,12 +39,16 @@ TRACE_EVENT(percpu_alloc_percpu,
 		__entry->base_addr	= base_addr;
 		__entry->off		= off;
 		__entry->ptr		= ptr;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
 	),
 
-	TP_printk("reserved=%d is_atomic=%d size=%zu align=%zu base_addr=%p off=%d ptr=%p",
+	TP_printk("call_site=%pS reserved=%d is_atomic=%d size=%zu align=%zu base_addr=%p off=%d ptr=%p bytes_alloc=%zu gfp_flags=%s",
+		  (void *)__entry->call_site,
 		  __entry->reserved, __entry->is_atomic,
 		  __entry->size, __entry->align,
-		  __entry->base_addr, __entry->off, __entry->ptr)
+		  __entry->base_addr, __entry->off, __entry->ptr,
+		  __entry->bytes_alloc, show_gfp_flags(__entry->gfp_flags))
 );
 
 TRACE_EVENT(percpu_free_percpu,
--- a/mm/percpu.c~percpu-improve-percpu_alloc_percpu-event-trace
+++ a/mm/percpu.c
@@ -1884,8 +1884,9 @@ area_found:
 	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
 	kmemleak_alloc_percpu(ptr, size, gfp);
 
-	trace_percpu_alloc_percpu(reserved, is_atomic, size, align,
-			chunk->base_addr, off, ptr);
+	trace_percpu_alloc_percpu(_RET_IP_, reserved, is_atomic, size, align,
+				  chunk->base_addr, off, ptr,
+				  pcpu_obj_full_size(size), gfp);
 
 	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
 
--- a/mm/percpu-internal.h~percpu-improve-percpu_alloc_percpu-event-trace
+++ a/mm/percpu-internal.h
@@ -113,7 +113,6 @@ static inline int pcpu_chunk_map_bits(st
 	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 /**
  * pcpu_obj_full_size - helper to calculate size of each accounted object
  * @size: size of area to allocate in bytes
@@ -123,13 +122,14 @@ static inline int pcpu_chunk_map_bits(st
  */
 static inline size_t pcpu_obj_full_size(size_t size)
 {
-	size_t extra_size;
+	size_t extra_size = 0;
 
-	extra_size = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+#ifdef CONFIG_MEMCG_KMEM
+	extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+#endif
 
 	return size * num_possible_cpus() + extra_size;
 }
-#endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_PERCPU_STATS
 
_

Patches currently in -mm which might be from vvs@openvz.org are

percpu-improve-percpu_alloc_percpu-event-trace.patch

