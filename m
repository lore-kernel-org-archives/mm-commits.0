From: akpm@linux-foundation.org
Subject: + gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch added to -mm tree
Date: Mon, 08 Jun 2009 16:11:30 -0700
Message-ID: <200906082311.n58NBUBK031150@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755490AbZFHXLa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jun 2009 19:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: fix potential use-after-free when purging GRU tlbs
has been added to the -mm tree.  Its filename is
     gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: fix potential use-after-free when purging GRU tlbs
From: Jack Steiner <steiner@sgi.com>

Fix potential SGI GRU bug that could cause a use-after-free.  If one
thread in a task is flushing the GRU and another thread destroys the GRU
context, there is the potential to access a table after it has been freed.

Copy the gms pointer to a local variable before unlocking the gts table. 
Note that no refcnt is needed for the gms - the reference is held
indirectly by the task's mm_struct.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-fix-potential-use-after-free-when-purging-gru-tlbs drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-fix-potential-use-after-free-when-purging-gru-tlbs
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -702,6 +702,7 @@ int gru_user_flush_tlb(unsigned long arg
 {
 	struct gru_thread_state *gts;
 	struct gru_flush_tlb_req req;
+	struct gru_mm_struct *gms;
 
 	STAT(user_flush_tlb);
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
@@ -714,8 +715,9 @@ int gru_user_flush_tlb(unsigned long arg
 	if (!gts)
 		return -EINVAL;
 
-	gru_flush_tlb_range(gts->ts_gms, req.vaddr, req.len);
+	gms = gts->ts_gms;
 	gru_unlock_gts(gts);
+	gru_flush_tlb_range(gms, req.vaddr, req.len);
 
 	return 0;
 }
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dump-chiplet-state-update.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-dynamic-allocation-of-kernel-contexts-update.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
gru-update-gru-kernel-self-tests.patch
gru-update-gru-kernel-self-tests-fix.patch
gru-update-to-rev-09-of-gru-spec.patch
gru-fix-cache-coherency-issues-with-instruction-retry.patch
gru-add-user-request-to-explicitly-unload-a-gru-context.patch
gru-fix-automatic-retry-of-gru-instruction-failures.patch
gru-collect-per-context-user-statistics.patch
gru-delete-user-request-for-fetching-chiplet-status.patch
gru-cleanup-gru-inline-functions.patch
gru-generic-infrastructure-for-context-options.patch
gru-add-user-request-to-specify-gru-slice.patch
gru-fix-potential-use-after-free-when-purging-gru-tlbs.patch
gru-fixes-to-grudump-utility.patch
gru-remove-references-to-the-obsolete-global-status-handle.patch
gru-copyright-fixes.patch

