Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7031D8DE1
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274641; cv=none; b=YAPDMuc5L2Pqdv/KJLSnOXPghWCRAZ0OZ2d+JYlpzd1ExlMYJcUwlx9qvfSdvi8cB+IIOZWUochbfJcpMnXChpMzDmyUOJizXGXIpaRB6qatD85WxAXHnOY97yHUs09GafDzfVnfE3Y6SBHEbCA7oL9aKAwBe3EAG6Qh1gdimvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274641; c=relaxed/simple;
	bh=X2ak3kMibzQGdEAHVTjpNPK6D5+e1f7yEnLa3WTa8l8=;
	h=Date:To:From:Subject:Message-Id; b=JXVKlFtf2wBkV7ljYaid6Kvk/CwK51HlLs7pyiV4MaOkwWhOlr+2SiAu0mQv1KrFVnugMreD8URoKeqrYaTfZapCP4zpye+9A9GA6yp5ZrQndOfbG3Yy8crm6XR751K+zBl1vQDcH7pH/L0T3jMyrAZ23+PZl/2BNFG8axiwuT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uyOxlN/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uyOxlN/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DF8C4CEDD;
	Tue, 18 Mar 2025 05:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274641;
	bh=X2ak3kMibzQGdEAHVTjpNPK6D5+e1f7yEnLa3WTa8l8=;
	h=Date:To:From:Subject:From;
	b=uyOxlN/pMFwShARph2/bWHZO6k4xuayy5Vi4zNjpXcRNOedbTmlbdpkT7qLA1dfvF
	 6J23MLAX22ZSwTA/VW+La0hjs2U2QrXsQc5tgCxEOsrYyGM23uFSzCLqqHQ7x1qbc7
	 nNA+TZ4EOP8XcNdolbf+sZE9iJIICf2Dfzmx6qJw=
Date: Mon, 17 Mar 2025 22:10:40 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rientjes@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch removed from -mm tree
Message-Id: <20250318051041.A0DF8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add trace event for per-zone lowmem reserve setup
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Martin Liu <liumartin@google.com>
Subject: mm/page_alloc: add trace event for per-zone lowmem reserve setup
Date: Sat, 8 Mar 2025 03:46:01 +0000

This commit introduces the `mm_setup_per_zone_lowmem_reserve` trace
event,which provides detailed insights into the kernel's per-zone lowmem
reserve configuration.

The trace event provides precise timestamps, allowing developers to

1. Correlate lowmem reserve changes with specific kernel events and
   able to diagnose unexpected kswapd or direct reclaim behavior triggered
   by dynamic changes in lowmem reserve.

2. Know memory allocation failures that occur due to insufficient
   lowmem reserve, by precisely correlating allocation attempts with
   reserve adjustments.

Link: https://lkml.kernel.org/r/20250308034606.2036033-3-liumartin@google.com
Signed-off-by: Martin Liu <liumartin@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   27 +++++++++++++++++++++++++++
 mm/page_alloc.c             |    2 ++
 2 files changed, 29 insertions(+)

--- a/include/trace/events/kmem.h~mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup
+++ a/include/trace/events/kmem.h
@@ -375,6 +375,33 @@ TRACE_EVENT(mm_setup_per_zone_wmarks,
 		  __entry->watermark_promo)
 );
 
+TRACE_EVENT(mm_setup_per_zone_lowmem_reserve,
+
+	TP_PROTO(struct zone *zone, struct zone *upper_zone, long lowmem_reserve),
+
+	TP_ARGS(zone, upper_zone, lowmem_reserve),
+
+	TP_STRUCT__entry(
+		__field(int, node_id)
+		__string(name, zone->name)
+		__string(upper_name, upper_zone->name)
+		__field(long, lowmem_reserve)
+	),
+
+	TP_fast_assign(
+		__entry->node_id = zone->zone_pgdat->node_id;
+		__assign_str(name);
+		__assign_str(upper_name);
+		__entry->lowmem_reserve = lowmem_reserve;
+	),
+
+	TP_printk("node_id=%d zone name=%s upper_zone name=%s lowmem_reserve_pages=%ld",
+		  __entry->node_id,
+		  __get_str(name),
+		  __get_str(upper_name),
+		  __entry->lowmem_reserve)
+);
+
 /*
  * Required for uniquely and securely identifying mm in rss_stat tracepoint.
  */
--- a/mm/page_alloc.c~mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup
+++ a/mm/page_alloc.c
@@ -5943,6 +5943,8 @@ static void setup_per_zone_lowmem_reserv
 					zone->lowmem_reserve[j] = 0;
 				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
+				trace_mm_setup_per_zone_lowmem_reserve(zone, upper_zone,
+								       zone->lowmem_reserve[j]);
 			}
 		}
 	}
_

Patches currently in -mm which might be from liumartin@google.com are


