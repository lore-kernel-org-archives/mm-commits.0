From: akpm@linux-foundation.org
Subject: + gru-add-comments-raised-in-previous-code-reviews.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:06 -0800
Message-ID: <200911241958.nAOJw7OY017876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932504AbZKXT6C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: add comments raised in previous code reviews
has been added to the -mm tree.  Its filename is
     gru-add-comments-raised-in-previous-code-reviews.patch

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
Subject: gru: add comments raised in previous code reviews
From: Jack Steiner <steiner@sgi.com>

Add comments from previous code reviews.  The comments help explain some
of the more esoteric aspects of the driver.

Move a free() to the other side of an unlock.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c     |    5 +++++
 drivers/misc/sgi-gru/grukservices.c |    4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-add-comments-raised-in-previous-code-reviews drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-add-comments-raised-in-previous-code-reviews
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -733,6 +733,11 @@ long gru_get_gseg_statistics(unsigned lo
 	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
 		return -EFAULT;
 
+	/*
+	 * The library creates arrays of contexts for threaded programs.
+	 * If no gts exists in the array, the context has never been used & all
+	 * statistics are implicitly 0.
+	 */
 	gts = gru_find_lock_gts(req.gseg);
 	if (gts) {
 		memcpy(&req.stats, &gts->ustats, sizeof(gts->ustats));
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-add-comments-raised-in-previous-code-reviews drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-add-comments-raised-in-previous-code-reviews
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -200,13 +200,15 @@ static int gru_free_kernel_contexts(void
 		bs = gru_base[bid];
 		if (!bs)
 			continue;
+
+		/* Ignore busy contexts. Don't want to block here.  */
 		if (down_write_trylock(&bs->bs_kgts_sema)) {
 			kgts = bs->bs_kgts;
 			if (kgts && kgts->ts_gru)
 				gru_unload_context(kgts, 0);
-			kfree(kgts);
 			bs->bs_kgts = NULL;
 			up_write(&bs->bs_kgts_sema);
+			kfree(kgts);
 		} else {
 			ret++;
 		}
_

Patches currently in -mm which might be from steiner@sgi.com are

linux-next.patch
x86-uv-introduce-a-means-to-translate-from-gpa-socket_paddr.patch
x86-uv-xpc-needs-to-provide-an-abstraction-for-uv_gpa.patch
x86-uv-introduce-uv_gpa_is_mmr.patch
x86-uv-implement-a-gru_read_gpa-kernel-function.patch
x86-uv-update-xpc-to-handle-updated-bios-interface.patch
x86-uv-xpc-null-deref-when-mesq-becomes-empty.patch
x86-uv-xpc_make_first_contact-hang-due-to-not-accepting-active-state.patch
x86-uv-xpc-receive-message-reuse-triggers-invalid-bug_on.patch
gru-initial-gru-based-on-blade-topology.patch
gru-add-comments-raised-in-previous-code-reviews.patch
gru-fix-istatus-race-in-gru-tlb-dropin.patch
gru-handle-blades-without-memory.patch
gru-allow-users-to-specify-gru-chiplet-1.patch
gru-allow-users-to-specify-gru-chiplet-2.patch
gru-allow-users-to-specify-gru-chiplet-3.patch
gru-fix-bug-in-module-unload.patch
gru-improve-messages-for-malfunctioning-grus.patch
gru-support-64-bit-gru-addresses.patch
gru-handle-failures-to-mmu_notifier_register.patch
gru-add-debug-option-for-cache-flushing.patch
gru-add-test-for-gru_copy_gpa.patch
gru-check-for-valid-vma.patch
gru-fix-prefetch-and-speculation-bugs.patch
gru-update-irq-infrastructure.patch
gru-add-additional-gru-statistics.patch
gru-expicitly-set-instruction-status-to-active.patch
gru-preload-tlb-for-bcopy-instructions.patch
gru-fix-bug-in-exception-handling.patch
gru-add-symbolic-names-for-gru-error-code.patch
gru-remove-stray-local_irq_enable.patch
gru-check-for-correct-gru-chiplet-assignment.patch
gru-update-gru-structures-to-match-latest-hardware-spec.patch
gru-fix-bug-in-allocation-of-kernel-contexts.patch
gru-add-hugepage-support.patch
gru-fix-gru-interrupt-race-at-deallocate.patch
gru-improve-gru-tlb-dropin-statistics.patch
gru-update-driver-version-number.patch

