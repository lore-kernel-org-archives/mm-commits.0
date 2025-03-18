Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051041A8418
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274643; cv=none; b=uhEtKfe59T63lTzVaiiWiDXYvfdp51mzR0qh/JiCzg8Azuwrk1HFAwOrVeAGIJnhqCGdlIeUm2HLPwg6X0xOA/B9ImyivCuQnx/3nXywqUmCndZJXX7Zk19TamL6fffNTMDDSaTezGFtI1j7rsUp57UuvAMIXEWrkIpWtEthxfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274643; c=relaxed/simple;
	bh=huRIR6IA/uODCt11FvjnX+6uVd1LCkFQFK1BjNFzZVE=;
	h=Date:To:From:Subject:Message-Id; b=j9h9FpdwrdBPoq9V0ZwdHe191kfPptSHyzyThq6PDCQdqYLegY0KBXe2htv7xbXqpR6PPwbGr3UE46EKoSI2JcuJxlJr5N5KnpFkStSmRoBCgSzs95bnpe10u/ku7QhBpOCjI/hAtTuA7OqmVCKZGDtD/IKVN8l2wfLiUhnfcQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKoeiInn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKoeiInn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4710C4CEDD;
	Tue, 18 Mar 2025 05:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274642;
	bh=huRIR6IA/uODCt11FvjnX+6uVd1LCkFQFK1BjNFzZVE=;
	h=Date:To:From:Subject:From;
	b=EKoeiInn2IlfVQAeafAAjG81M9hI+IFNFaPezKyB39HN7smV1Sir+yZu7cuMDMVYb
	 QnHJDojXTse9YD8oyETaakDbCuEAfH/ZrnZfpy7PQinelH+pvjL8fdfNe9NLrZ4XOJ
	 wa/ci6nc7+scvKw5pKsTcxFD2rqHX1VdVz0tpehY=
Date: Mon, 17 Mar 2025 22:10:42 -0700
To: mm-commits@vger.kernel.org,rostedt@goodmis.org,rientjes@google.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,liumartin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch removed from -mm tree
Message-Id: <20250318051042.C4710C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: add trace event for totalreserve_pages calculation
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-add-trace-event-for-totalreserve_pages-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


