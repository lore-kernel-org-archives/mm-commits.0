From: akpm@linux-foundation.org
Subject: [folded-merged]
 tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch removed
 from -mm tree
Date: Thu, 28 May 2015 15:41:44 -0700
Message-ID: <556799a8.28CxmXTDuW5Snqsu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbbE1Wlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 May 2015 18:41:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shreyas@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix
has been removed from the -mm tree.  Its filename was
     tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch

This patch was dropped because it was folded into tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus.patch

------------------------------------------------------
From: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>
Subject: tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix

use raw_smp_processor_id()

Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN include/trace/events/kmem.h~tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix
+++ a/include/trace/events/kmem.h
@@ -282,7 +282,16 @@ TRACE_EVENT_CONDITION(mm_page_pcpu_drain
 
 	TP_ARGS(page, order, migratetype),
 
-	TP_CONDITION(cpu_online(smp_processor_id())),
+	/*
+	 * This trace can be potentially called from an offlined cpu.
+	 * Since trace points use RCU and RCU should not be used from
+	 * offline cpus, filter such calls out.
+	 * While this trace can be called from a preemptable section,
+	 * it has no impact on the condition since tasks can migrate
+	 * only from online cpus to other online cpus. Thus its safe
+	 * to use raw_smp_processor_id.
+	 */
+	TP_CONDITION(cpu_online(raw_smp_processor_id())),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	pfn		)
_

Patches currently in -mm which might be from shreyas@linux.vnet.ibm.com are

tracing-mm-dont-trace-kmem_cache_free-on-offline-cpus.patch
tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch
tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus.patch
linux-next.patch

