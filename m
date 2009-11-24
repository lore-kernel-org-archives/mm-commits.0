From: akpm@linux-foundation.org
Subject: + gru-add-debug-option-for-cache-flushing.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:27 -0800
Message-ID: <200911241958.nAOJwRu7018722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932732AbZKXT6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: add debug option for cache flushing
has been added to the -mm tree.  Its filename is
     gru-add-debug-option-for-cache-flushing.patch

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
Subject: gru: add debug option for cache flushing
From: Jack Steiner <steiner@sgi.com>

Add a debug option to the SGI GRU driver for flushing GRU cache lines from
memory.  In theory this is not needed but it is useful for debugging. 
This has no use by end users.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grukdump.c |   13 ++++++++-----
 drivers/misc/sgi-gru/grulib.h   |    2 ++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/misc/sgi-gru/grukdump.c~gru-add-debug-option-for-cache-flushing drivers/misc/sgi-gru/grukdump.c
--- a/drivers/misc/sgi-gru/grukdump.c~gru-add-debug-option-for-cache-flushing
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -44,7 +44,8 @@ static int gru_user_copy_handle(void __u
 
 static int gru_dump_context_data(void *grubase,
 			struct gru_context_configuration_handle *cch,
-			void __user *ubuf, int ctxnum, int dsrcnt)
+			void __user *ubuf, int ctxnum, int dsrcnt,
+			int flush_cbrs)
 {
 	void *cb, *cbe, *tfh, *gseg;
 	int i, scr;
@@ -55,6 +56,8 @@ static int gru_dump_context_data(void *g
 	tfh = grubase + GRU_TFH_BASE;
 
 	for_each_cbr_in_allocation_map(i, &cch->cbr_allocation_map, scr) {
+		if (flush_cbrs)
+			gru_flush_cache(cb);
 		if (gru_user_copy_handle(&ubuf, cb))
 			goto fail;
 		if (gru_user_copy_handle(&ubuf, tfh + i * GRU_HANDLE_STRIDE))
@@ -115,7 +118,7 @@ fail:
 
 static int gru_dump_context(struct gru_state *gru, int ctxnum,
 		void __user *ubuf, void __user *ubufend, char data_opt,
-		char lock_cch)
+		char lock_cch, char flush_cbrs)
 {
 	struct gru_dump_context_header hdr;
 	struct gru_dump_context_header __user *uhdr = ubuf;
@@ -159,8 +162,7 @@ static int gru_dump_context(struct gru_s
 			ret = -EFBIG;
 		else
 			ret = gru_dump_context_data(grubase, cch, ubuf, ctxnum,
-							dsrcnt);
-
+							dsrcnt, flush_cbrs);
 	}
 	if (cch_locked)
 		unlock_cch_handle(cch);
@@ -215,7 +217,8 @@ int gru_dump_chiplet_request(unsigned lo
 	for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
 		if (req.ctxnum == ctxnum || req.ctxnum < 0) {
 			ret = gru_dump_context(gru, ctxnum, ubuf, ubufend,
-						req.data_opt, req.lock_cch);
+						req.data_opt, req.lock_cch,
+						req.flush_cbrs);
 			if (ret < 0)
 				goto fail;
 			ubuf += ret;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-add-debug-option-for-cache-flushing drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-add-debug-option-for-cache-flushing
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -125,6 +125,8 @@ struct gru_dump_chiplet_state_req {
 	int		ctxnum;
 	char		data_opt;
 	char		lock_cch;
+	char		flush_cbrs;
+	char		fill[10];
 	pid_t		pid;
 	void		*buf;
 	size_t		buflen;
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

