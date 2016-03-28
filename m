From: akpm@linux-foundation.org
Subject: + x86-mm-tlb_remote_send_ipi-should-count-pages.patch added to
 -mm tree
Date: Mon, 28 Mar 2016 13:49:14 -0700
Message-ID: <56f998ca.UcdKUd2nXg3bIT0d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbcC1UtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Mar 2016 16:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namit@vmware.com, dave.hansen@intel.com, mgorman@suse.de, mingo@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86/mm: TLB_REMOTE_SEND_IPI should count pages
has been added to the -mm tree.  Its filename is
     x86-mm-tlb_remote_send_ipi-should-count-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-tlb_remote_send_ipi-should-count-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-tlb_remote_send_ipi-should-count-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: x86/mm: TLB_REMOTE_SEND_IPI should count pages

TLB_REMOTE_SEND_IPI was recently introduced, but it counts bytes instead
of pages.  In addition, it does not report correctly the case in which
flush_tlb_page flushes a page.  Fix it to be consistent with other TLB
counters.

Fixes: 5b74283ab251b9d ("x86, mm: trace when an IPI is about to be sent")
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/tlb.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff -puN arch/x86/mm/tlb.c~x86-mm-tlb_remote_send_ipi-should-count-pages arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-mm-tlb_remote_send_ipi-should-count-pages
+++ a/arch/x86/mm/tlb.c
@@ -106,8 +106,6 @@ static void flush_tlb_func(void *info)
 
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
-	if (!f->flush_end)
-		f->flush_end = f->flush_start + PAGE_SIZE;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
@@ -135,12 +133,20 @@ void native_flush_tlb_others(const struc
 				 unsigned long end)
 {
 	struct flush_tlb_info info;
+
+	if (end == 0)
+		end = start + PAGE_SIZE;
 	info.flush_mm = mm;
 	info.flush_start = start;
 	info.flush_end = end;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH);
-	trace_tlb_flush(TLB_REMOTE_SEND_IPI, end - start);
+	if (end == TLB_FLUSH_ALL)
+		trace_tlb_flush(TLB_REMOTE_SEND_IPI, TLB_FLUSH_ALL);
+	else
+		trace_tlb_flush(TLB_REMOTE_SEND_IPI,
+				(end - start) >> PAGE_SHIFT);
+
 	if (is_uv_system()) {
 		unsigned int cpu;
 
_

Patches currently in -mm which might be from namit@vmware.com are

x86-mm-tlb_remote_send_ipi-should-count-pages.patch
mm-rmap-batched-invalidations-should-use-existing-api.patch

