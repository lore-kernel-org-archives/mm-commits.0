From: akpm@linux-foundation.org
Subject: + tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch added
 to -mm tree
Date: Tue, 12 May 2015 13:33:40 -0700
Message-ID: <555263a4.9mCS+o4VtCHuveZ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbbELUdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 May 2015 16:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shreyas@linux.vnet.ibm.com, preeti@linux.vnet.ibm.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: tracing/mm: don't trace mm_page_free on offline cpus
has been added to the -mm tree.  Its filename is
     tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch

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
Subject: tracing/mm: don't trace mm_page_free on offline cpus

Since tracepoints use RCU for protection, they must not be called on
offline cpus.  trace_mm_page_free can be called on an offline cpu in this
scenario caught by LOCKDEP:

 ===============================
 [ INFO: suspicious RCU usage. ]
 4.1.0-rc1+ #9 Not tainted
 -------------------------------
 include/trace/events/kmem.h:170 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

RCU used illegally from offline CPU!
rcu_scheduler_active = 1, debug_locks = 1
 no locks held by swapper/1/0.

stack backtrace:
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.1.0-rc1+ #9
 Call Trace:
 [c000001fed2f7790] [c0000000009dee8c] .dump_stack+0x98/0xd4 (unreliable)
 [c000001fed2f7810] [c000000000128d88] .lockdep_rcu_suspicious+0x108/0x170
 [c000001fed2f78a0] [c000000000203bc4] .free_pages_prepare+0x494/0x680
 [c000001fed2f7980] [c000000000207fd0] .free_hot_cold_page+0x50/0x280
 [c000001fed2f7a30] [c00000000004d000] .destroy_context+0x90/0xd0
 [c000001fed2f7ab0] [c0000000000bd1d8] .__mmdrop+0x58/0x160
 [c000001fed2f7b40] [c0000000001068e0] .idle_task_exit+0xf0/0x100
 [c000001fed2f7bc0] [c000000000066948] .pnv_smp_cpu_kill_self+0x58/0x2c0
 [c000001fed2f7ca0] [c00000000003ce34] .cpu_die+0x34/0x50
 [c000001fed2f7d10] [c0000000000176d0] .arch_cpu_idle_dead+0x20/0x40
 [c000001fed2f7d80] [c00000000011f9a8] .cpu_startup_entry+0x708/0x7a0
 [c000001fed2f7ec0] [c00000000003cb6c] .start_secondary+0x36c/0x3a0
 [c000001fed2f7f90] [c000000000008b6c] start_secondary_prolog+0x10/0x14

Fix this by converting mm_page_free trace point into TRACE_EVENT_CONDITION
where condition is cpu_online(smp_processor_id())

Signed-off-by: Shreyas B. Prabhu <shreyas@linux.vnet.ibm.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/kmem.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/trace/events/kmem.h~tracing-mm-dont-trace-mm_page_free-on-offline-cpus include/trace/events/kmem.h
--- a/include/trace/events/kmem.h~tracing-mm-dont-trace-mm_page_free-on-offline-cpus
+++ a/include/trace/events/kmem.h
@@ -149,12 +149,14 @@ DEFINE_EVENT_CONDITION(kmem_free, kmem_c
 	TP_CONDITION(cpu_online(smp_processor_id()))
 );
 
-TRACE_EVENT(mm_page_free,
+TRACE_EVENT_CONDITION(mm_page_free,
 
 	TP_PROTO(struct page *page, unsigned int order),
 
 	TP_ARGS(page, order),
 
+	TP_CONDITION(cpu_online(smp_processor_id())),
+
 	TP_STRUCT__entry(
 		__field(	unsigned long,	pfn		)
 		__field(	unsigned int,	order		)
_

Patches currently in -mm which might be from shreyas@linux.vnet.ibm.com are

tracing-mm-dont-trace-kmem_cache_free-on-offline-cpus.patch
tracing-mm-dont-trace-mm_page_free-on-offline-cpus.patch
tracing-mm-dont-trace-mm_page_pcpu_drain-on-offline-cpus.patch

