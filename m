Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0371EBFF0
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 20:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811643; cv=none; b=XpSG8s6KU1+s9/Mb731jeHqgIfduHX1ZcKVZcz2J1HTSebkAGn3ATI/gSxEMozvcZsvovk+VjDPmTdoScU83pyOPrNMJscbmpT6TYiXMPpKrGnU9DsxvsOQYsHMcXkq/IHs/a7aK4wpBKxPrVcouaikpZbZrGLnFIni5C3x0Nos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811643; c=relaxed/simple;
	bh=nkDDcGbtdCdp9VfjRkfizRskpQGj74uVTD4/D3IPf8s=;
	h=Date:To:From:Subject:Message-Id; b=VdZIjWDZJ7UcIPd7bAd+Rxu985qU+6oHcRoQpjxEHLPDDMtn+pkdoD4nuoEQXSS7ejfbZI1vqgUfw92EjaXrbDIluwEBrqzSnZzYM9bhlMofW+S8SXIC3v2u3l8a6+MbAhJxw7CXIdFA6kJ6i4//5NbwKUfcPMahGbyzFSuAsPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qoU/AZCF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qoU/AZCF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC7DC4CEDD;
	Wed, 12 Mar 2025 20:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741811642;
	bh=nkDDcGbtdCdp9VfjRkfizRskpQGj74uVTD4/D3IPf8s=;
	h=Date:To:From:Subject:From;
	b=qoU/AZCF7WIRGY89D5I3dojxJYf2AN5JZknf0eXksYhRJX65dNM5Gi0fnE9w8sieW
	 5tmZfz0OhrDfvG0rp/5ozdQrt9HKDPah0ZlALAPn22EYAcu46otNo3I7Nm4ebnzWMC
	 wteaqaHcSWXLSrBBmApI2SFYgaIPwa4AttEHJiFs=
Date: Wed, 12 Mar 2025 13:34:02 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rientjes@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch added to mm-unstable branch
Message-Id: <20250312203402.BAC7DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add trace event for per-zone lowmem reserve setup
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch

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

mm-page_alloc-add-trace-event-for-per-zone-watermark-setup.patch
mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch
mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch

