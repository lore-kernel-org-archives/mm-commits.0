From: akpm@linux-foundation.org
Subject: [merged] x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:05:06 -0700
Message-ID: <55ef2352.AjRj4AOgjQMYGKqD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272AbbIHSFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, dave.hansen@intel.com, mingo@kernel.org, riel@redhat.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: trace when an IPI is about to be sent
has been removed from the -mm tree.  Its filename was
     x86-mm-trace-when-an-ipi-is-about-to-be-sent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: x86, mm: trace when an IPI is about to be sent

When unmapping pages it is necessary to flush the TLB.  If that page was
accessed by another CPU then an IPI is used to flush the remote CPU.  That
is a lot of IPIs if kswapd is scanning and unmapping >100K pages per
second.

There already is a window between when a page is unmapped and when it is
TLB flushed.  This series increases the window so multiple pages can be
flushed using a single IPI.  This should be safe or the kernel is hosed
already.

Patch 1 simply made the rest of the series easier to write as ftrace
	could identify all the senders of TLB flush IPIS.

Patch 2 tracks what CPUs potentially map a PFN and then sends an IPI
	to flush the entire TLB.

Patch 3 tracks when there potentially are writable TLB entries that
	need to be batched differently

Patch 4 increases SWAP_CLUSTER_MAX to further batch flushes

The performance impact is documented in the changelogs but in the optimistic
case on a 4-socket machine the full series reduces interrupts from 900K
interrupts/second to 60K interrupts/second.


This patch (of 4):

It is easy to trace when an IPI is received to flush a TLB but harder to
detect what event sent it.  This patch makes it easy to identify the
source of IPIs being transmitted for TLB flushes on x86.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c          |    1 +
 include/linux/mm_types.h   |    1 +
 include/trace/events/tlb.h |    3 ++-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/tlb.c~x86-mm-trace-when-an-ipi-is-about-to-be-sent arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-trace-when-an-ipi-is-about-to-be-sent
+++ a/arch/x86/mm/tlb.c
@@ -140,6 +140,7 @@ void native_flush_tlb_others(const struc
 	info.flush_end = end;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
+	trace_tlb_flush(TLB_REMOTE_SEND_IPI, end - start);
 	if (is_uv_system()) {
 		unsigned int cpu;
 
diff -puN include/linux/mm_types.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent include/linux/mm_types.h
--- a/include/linux/mm_types.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent
+++ a/include/linux/mm_types.h
@@ -554,6 +554,7 @@ enum tlb_flush_reason {
 	TLB_REMOTE_SHOOTDOWN,
 	TLB_LOCAL_SHOOTDOWN,
 	TLB_LOCAL_MM_SHOOTDOWN,
+	TLB_REMOTE_SEND_IPI,
 	NR_TLB_FLUSH_REASONS,
 };
 
diff -puN include/trace/events/tlb.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent include/trace/events/tlb.h
--- a/include/trace/events/tlb.h~x86-mm-trace-when-an-ipi-is-about-to-be-sent
+++ a/include/trace/events/tlb.h
@@ -11,7 +11,8 @@
 	EM(  TLB_FLUSH_ON_TASK_SWITCH,	"flush on task switch" )	\
 	EM(  TLB_REMOTE_SHOOTDOWN,	"remote shootdown" )		\
 	EM(  TLB_LOCAL_SHOOTDOWN,	"local shootdown" )		\
-	EMe( TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )
+	EM(  TLB_LOCAL_MM_SHOOTDOWN,	"local mm shootdown" )		\
+	EMe( TLB_REMOTE_SEND_IPI,	"remote ipi send" )
 
 /*
  * First define the enums in TLB_FLUSH_REASON to be exported to userspace
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-increase-swap_cluster_max-to-batch-tlb-flushes.patch

