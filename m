Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A10FBF6
	for <mm-commits@vger.kernel.org>; Wed, 12 Mar 2025 20:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741811673; cv=none; b=BaDtTfQwWs+XvBiLAFfXV4AANVrSMBwY7JjimYj/3Lbclkv1VxDler/aSqW40IqVXbs+I4V5fjiK5n5Za8TwkccMv86xdoBkywbOGPtVaLvA1QwOvp3mhTyZ2Wjli5WC0XYMT4heXZH4seOQkHN1knujUi4SYylp+5SPCiq9NVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741811673; c=relaxed/simple;
	bh=1hOy19TkKFLq0H1zPBPY24lm8GvHWsOZrU1aO5YHF/4=;
	h=Date:To:From:Subject:Message-Id; b=EDG/tJBo9Y2vHLL+9BxjDD05/NjzWRGxlk6wEkGPXulX733vDWe/klEzu/vzRzazzgY9mDNhCQu19Kok3bAaHs7NjkISlDkX4LPnEPhYjG4KD0chYUBo2Tcm1WrKBrS5dQ0l/L/1XYUP6V+aN7RvY9CUpO04s0pOUuQjNB6vDpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fWg4o2VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fWg4o2VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEDFC4CEDD;
	Wed, 12 Mar 2025 20:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741811670;
	bh=1hOy19TkKFLq0H1zPBPY24lm8GvHWsOZrU1aO5YHF/4=;
	h=Date:To:From:Subject:From;
	b=fWg4o2VYdKJhJSz76Sm/sMeS1w8X29ONCvNgNAxGaQ1osCiiSgOy9ENV/1Socy63d
	 jt7pmEchH8VUu6wL59Qm0LWKXjwRNzC41GEXWmxsZniMeU/sjOCtUm2wWefTXx63S9
	 5eqopNXauQBaX6JHhabr0ZBcTsv3tU+81HBPeqAE=
Date: Wed, 12 Mar 2025 13:34:30 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rientjes@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch added to mm-unstable branch
Message-Id: <20250312203430.9FEDFC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc: add trace event for totalreserve_pages calculation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch

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
Subject: mm/page_alloc: add trace event for totalreserve_pages calculation
Date: Sat, 8 Mar 2025 03:46:02 +0000

This commit introduces a new trace event,
`mm_calculate_totalreserve_pages`, which reports the new reserve value at
the exact time when it takes effect.

The `totalreserve_pages` value represents the total amount of memory
reserved across all zones and nodes in the system.  This reserved memory
is crucial for ensuring that critical kernel operations have access to
sufficient memory, even under memory pressure.

By tracing the `totalreserve_pages` value, developers can gain insights
that how the total reserved memory changes over time.

Link: https://lkml.kernel.org/r/20250308034606.2036033-4-liumartin@google.com
Signed-off-by: Martin Liu <liumartin@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   18 ++++++++++++++++++
 mm/page_alloc.c             |    1 +
 2 files changed, 19 insertions(+)

--- a/include/trace/events/kmem.h~mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation
+++ a/include/trace/events/kmem.h
@@ -402,6 +402,24 @@ TRACE_EVENT(mm_setup_per_zone_lowmem_res
 		  __entry->lowmem_reserve)
 );
 
+TRACE_EVENT(mm_calculate_totalreserve_pages,
+
+	TP_PROTO(unsigned long totalreserve_pages),
+
+	TP_ARGS(totalreserve_pages),
+
+	TP_STRUCT__entry(
+		__field(unsigned long, totalreserve_pages)
+	),
+
+	TP_fast_assign(
+		__entry->totalreserve_pages = totalreserve_pages;
+	),
+
+	TP_printk("totalreserve_pages=%lu", __entry->totalreserve_pages)
+);
+
+
 /*
  * Required for uniquely and securely identifying mm in rss_stat tracepoint.
  */
--- a/mm/page_alloc.c~mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation
+++ a/mm/page_alloc.c
@@ -5914,6 +5914,7 @@ static void calculate_totalreserve_pages
 		}
 	}
 	totalreserve_pages = reserve_pages;
+	trace_mm_calculate_totalreserve_pages(totalreserve_pages);
 }
 
 /*
_

Patches currently in -mm which might be from liumartin@google.com are

mm-page_alloc-add-trace-event-for-per-zone-watermark-setup.patch
mm-page_alloc-add-trace-event-for-per-zone-lowmem-reserve-setup.patch
mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch

