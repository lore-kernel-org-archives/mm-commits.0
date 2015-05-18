From: akpm@linux-foundation.org
Subject: +
 tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch added to -mm tree
Date: Mon, 18 May 2015 15:01:49 -0700
Message-ID: <555a614d.hRaLIMW3pkBz6raW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbbERWBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 May 2015 18:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shreyas@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix
has been added to the -mm tree.  Its filename is
     tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
tracing-mm-dont-trace-kmem_cache_free-on-offline-cpus-fix.patch
tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch
tracing-mm-dont-trace-mm_page_free-on-offline-cpus-fix.patch
tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus.patch
tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus-fix.patch
a.patch

