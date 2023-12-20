Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B094692
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 01:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wlYOLP2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522E4C433C8;
	Wed, 20 Dec 2023 01:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703034495;
	bh=UPI7e7SgotE31HpbQmzgFue+A5IBT6OF5nVqsUSJZb4=;
	h=Date:To:From:Subject:From;
	b=wlYOLP2XcfVUV84daoCL1QpFcfGfcEubYOckDpf05uInP9nz9wTGRAtePb9ODTYo/
	 yHVYOzr0R3S2ZfiP9dAzIvkcQYoh7zAGMnqBVzx4H5TDsOmMBnq2J/p0IjLogm/hzw
	 sSUvr57CS/81ELbDHRcjDOVGc1yufrPZaWjridpE=
Date: Tue, 19 Dec 2023 17:08:14 -0800
To: mm-commits@vger.kernel.org,riel@surriel.com,hannes@cmpxchg.org,david@redhat.com,shr@devkernel.io,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-add-tracepoint-for-ksm-advisor.patch added to mm-unstable branch
Message-Id: <20231220010815.522E4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: add tracepoint for ksm advisor
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-add-tracepoint-for-ksm-advisor.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-add-tracepoint-for-ksm-advisor.patch

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
From: Stefan Roesch <shr@devkernel.io>
Subject: mm/ksm: add tracepoint for ksm advisor
Date: Mon, 18 Dec 2023 15:10:53 -0800

This adds a new tracepoint for the ksm advisor.  It reports the last scan
time, the new setting of the pages_to_scan parameter and the average cpu
percent usage of the ksmd background thread for the last scan.

Link: https://lkml.kernel.org/r/20231218231054.1625219-4-shr@devkernel.io
Signed-off-by: Stefan Roesch <shr@devkernel.io>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/ksm.h |   33 +++++++++++++++++++++++++++++++++
 mm/ksm.c                   |    1 +
 2 files changed, 34 insertions(+)

--- a/include/trace/events/ksm.h~mm-ksm-add-tracepoint-for-ksm-advisor
+++ a/include/trace/events/ksm.h
@@ -245,6 +245,39 @@ TRACE_EVENT(ksm_remove_rmap_item,
 			__entry->pfn, __entry->rmap_item, __entry->mm)
 );
 
+/**
+ * ksm_advisor - called after the advisor has run
+ *
+ * @scan_time:		scan time in seconds
+ * @pages_to_scan:	new pages_to_scan value
+ * @cpu_percent:	cpu usage in percent
+ *
+ * Allows to trace the ksm advisor.
+ */
+TRACE_EVENT(ksm_advisor,
+
+	TP_PROTO(s64 scan_time, unsigned long pages_to_scan,
+		 unsigned int cpu_percent),
+
+	TP_ARGS(scan_time, pages_to_scan, cpu_percent),
+
+	TP_STRUCT__entry(
+		__field(s64,		scan_time)
+		__field(unsigned long,	pages_to_scan)
+		__field(unsigned int,	cpu_percent)
+	),
+
+	TP_fast_assign(
+		__entry->scan_time	= scan_time;
+		__entry->pages_to_scan	= pages_to_scan;
+		__entry->cpu_percent	= cpu_percent;
+	),
+
+	TP_printk("ksm scan time %lld pages_to_scan %lu cpu percent %u",
+			__entry->scan_time, __entry->pages_to_scan,
+			__entry->cpu_percent)
+);
+
 #endif /* _TRACE_KSM_H */
 
 /* This part must be outside protection */
--- a/mm/ksm.c~mm-ksm-add-tracepoint-for-ksm-advisor
+++ a/mm/ksm.c
@@ -458,6 +458,7 @@ static void scan_time_advisor(void)
 	advisor_ctx.cpu_time = cpu_time;
 
 	ksm_thread_pages_to_scan = pages;
+	trace_ksm_advisor(scan_time, pages, cpu_percent);
 }
 
 static void advisor_stop_scan(void)
_

Patches currently in -mm which might be from shr@devkernel.io are

mm-ksm-add-ksm-advisor.patch
mm-ksm-add-sysfs-knobs-for-advisor.patch
mm-ksm-add-tracepoint-for-ksm-advisor.patch
mm-ksm-document-ksm-advisor-and-its-sysfs-knobs.patch

