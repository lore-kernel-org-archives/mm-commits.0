Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32A21EBFF0
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 20:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811654; cv=none; b=S32eNPIntRE5mEUIWa0wfoND61uAvM91kF8zSS5vfmGRSXjUNYnNVVSD9eUPXcKJuKjwtrecJdcm9r6WiTQQtSUgwDm4wxrIMialIfkueK2COAwOHqJ7997WTRYO4kZJaHFiBarixeTaAkw0drFbvYwXp/t2GXR2L2fbpMQDFk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811654; c=relaxed/simple;
	bh=S8veE/qpBi6AHPmEftJp+CpywT+6QtAfFSV9yj+GDXM=;
	h=Date:To:From:Subject:Message-Id; b=sfRFW2nAKs8Iam8e/nR9DpKIHH3hFnldyLMxlFEFjc9eorZwr6B2n5X9x71RSUmEn2WOgPvZeNZcXuxp66HjWbMEHSGcAefGKXxYqxLHGyGcUcG3Oo+oqlRZXQvuzIQ9ByuVgZyyzFB9eQdZPyOVPf1LtNS/d/Y3hdkFcGqtQvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HLJU1Cdw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HLJU1Cdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EFDC4CEDD;
	Wed, 12 Mar 2025 20:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741811654;
	bh=S8veE/qpBi6AHPmEftJp+CpywT+6QtAfFSV9yj+GDXM=;
	h=Date:To:From:Subject:From;
	b=HLJU1CdwfM346MAxmIOyu51P4IclA1dbxIBeTW0GQcvWvB4R3uGFbyxb1ay+BwWNM
	 BoyLDv31edrMsm8Dp1FyFTqti1M6jREppU+fEJO6g/32uRqGwEik625OaJgnnRFxJA
	 vW1esvp1CMUqhBI5op0vFxeb9xYcnmTmqHyis/Sw=
Date: Wed, 12 Mar 2025 13:34:13 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rientjes@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-trace-event-for-per-zone-watermark-setup.patch added to mm-unstable branch
Message-Id: <20250312203414.84EFDC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add trace event for per-zone watermark setup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-trace-event-for-per-zone-watermark-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-trace-event-for-per-zone-watermark-setup.patch

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
From: Martin Liu <liumartin@google.com>
Subject: mm/page_alloc: add trace event for per-zone watermark setup
Date: Sat, 8 Mar 2025 03:46:00 +0000

Patch series "Add tracepoints for lowmem reserves, watermarks and
totalreserve_pages", v2.

This patchset introduces tracepoints to track changes in the lowmem
reserves, watermarks and totalreserve_pages. This helps to track
the exact timing of such changes and understand their relation to
reclaim activities.

The tracepoints added are:

mm_setup_per_zone_lowmem_reserve
mm_setup_per_zone_wmarks
mm_calculate_totalreserve_pagesi


This patch (of 3):

This commit introduces the `mm_setup_per_zone_wmarks` trace event,
which provides detailed insights into the kernel's per-zone watermark
configuration, offering precise timing and the ability to correlate
watermark changes with specific kernel events.

While `/proc/zoneinfo` provides some information about zone watermarks,
this trace event offers:

1. The ability to link watermark changes to specific kernel events and
   logic.

2. The ability to capture rapid or short-lived changes in watermarks
   that may be missed by user-space polling

3. Diagnosing unexpected kswapd activity or excessive direct reclaim
   triggered by rapidly changing watermarks.

Link: https://lkml.kernel.org/r/20250308034606.2036033-1-liumartin@google.com
Link: https://lkml.kernel.org/r/20250308034606.2036033-2-liumartin@google.com
Signed-off-by: Martin Liu <liumartin@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Martin Liu <liumartin@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   33 +++++++++++++++++++++++++++++++++
 mm/page_alloc.c             |    1 +
 2 files changed, 34 insertions(+)

--- a/include/trace/events/kmem.h~mm-page_alloc-add-trace-event-for-per-zone-watermark-setup
+++ a/include/trace/events/kmem.h
@@ -342,6 +342,39 @@ TRACE_EVENT(mm_alloc_contig_migrate_rang
 		  __entry->nr_mapped)
 );
 
+TRACE_EVENT(mm_setup_per_zone_wmarks,
+
+	TP_PROTO(struct zone *zone),
+
+	TP_ARGS(zone),
+
+	TP_STRUCT__entry(
+		__field(int, node_id)
+		__string(name, zone->name)
+		__field(unsigned long, watermark_min)
+		__field(unsigned long, watermark_low)
+		__field(unsigned long, watermark_high)
+		__field(unsigned long, watermark_promo)
+	),
+
+	TP_fast_assign(
+		__entry->node_id = zone->zone_pgdat->node_id;
+		__assign_str(name);
+		__entry->watermark_min = zone->_watermark[WMARK_MIN];
+		__entry->watermark_low = zone->_watermark[WMARK_LOW];
+		__entry->watermark_high = zone->_watermark[WMARK_HIGH];
+		__entry->watermark_promo = zone->_watermark[WMARK_PROMO];
+	),
+
+	TP_printk("node_id=%d zone name=%s watermark min=%lu low=%lu high=%lu promo=%lu",
+		  __entry->node_id,
+		  __get_str(name),
+		  __entry->watermark_min,
+		  __entry->watermark_low,
+		  __entry->watermark_high,
+		  __entry->watermark_promo)
+);
+
 /*
  * Required for uniquely and securely identifying mm in rss_stat tracepoint.
  */
--- a/mm/page_alloc.c~mm-page_alloc-add-trace-event-for-per-zone-watermark-setup
+++ a/mm/page_alloc.c
@@ -6006,6 +6006,7 @@ static void __setup_per_zone_wmarks(void
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = low_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_PROMO] = high_wmark_pages(zone) + tmp;
+		trace_mm_setup_per_zone_wmarks(zone);
 
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
_

Patches currently in -mm which might be from liumartin@google.com are

mm-page_alloc-add-trace-event-for-per-zone-watermark-setup.patch
mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch
mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch

