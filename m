From: akpm@linux-foundation.org
Subject: + gru-allow-users-to-specify-gru-chiplet-1.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:12 -0800
Message-ID: <200911241958.nAOJwClw018135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35929 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932678AbZKXT6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: allow users to specify gru chiplet 1
has been added to the -mm tree.  Its filename is
     gru-allow-users-to-specify-gru-chiplet-1.patch

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
Subject: gru: allow users to specify gru chiplet 1
From: Jack Steiner <steiner@sgi.com>

Add table & user request infrastructure that is needed to allow users to
specify the blade and chiplet for allocation of GRU contexts.  Use of this
information is in a subsequent patch.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c  |   10 ++++++++++
 drivers/misc/sgi-gru/grulib.h    |    5 +++--
 drivers/misc/sgi-gru/grumain.c   |    2 ++
 drivers/misc/sgi-gru/grutables.h |    2 ++
 4 files changed, 17 insertions(+), 2 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -763,6 +763,16 @@ int gru_set_context_option(unsigned long
 		return -EINVAL;
 
 	switch (req.op) {
+	case sco_blade_chiplet:
+		/* Select blade/chiplet for GRU context */
+		if (req.val1 < -1 || req.val1 >= GRU_MAX_BLADES || !gru_base[req.val1] ||
+		    req.val0 < -1 || req.val0 >= GRU_CHIPLETS_PER_HUB) {
+			ret = -EINVAL;
+		} else {
+			gts->ts_user_blade_id = req.val1;
+			gts->ts_user_chiplet_id = req.val0;
+		}
+		break;
 	case sco_gseg_owner:
  		/* Register the current task as the GSEG owner */
 		gts->ts_tgid_owner = current->tgid;
diff -puN drivers/misc/sgi-gru/grulib.h~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -98,11 +98,12 @@ struct gru_unload_context_req {
 /*
  * Structure used to set context options
  */
-enum {sco_gseg_owner, sco_cch_req_slice};
+enum {sco_gseg_owner, sco_cch_req_slice, sco_blade_chiplet};
 struct gru_set_context_option_req {
 	unsigned long	gseg;
 	int		op;
-	unsigned long	val1;
+	int		val0;
+	long		val1;
 };
 
 /*
diff -puN drivers/misc/sgi-gru/grumain.c~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grumain.c
--- a/drivers/misc/sgi-gru/grumain.c~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grumain.c
@@ -328,6 +328,8 @@ struct gru_thread_state *gru_alloc_gts(s
 	gts->ts_cbr_au_count = cbr_au_count;
 	gts->ts_dsr_au_count = dsr_au_count;
 	gts->ts_user_options = options;
+	gts->ts_user_blade_id = -1;
+	gts->ts_user_chiplet_id = -1;
 	gts->ts_tsid = tsid;
 	gts->ts_ctxnum = NULLCTX;
 	gts->ts_tlb_int_select = -1;
diff -puN drivers/misc/sgi-gru/grutables.h~gru-allow-users-to-specify-gru-chiplet-1 drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-allow-users-to-specify-gru-chiplet-1
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -369,6 +369,8 @@ struct gru_thread_state {
 	long			ts_user_options;/* misc user option flags */
 	pid_t			ts_tgid_owner;	/* task that is using the
 						   context - for migration */
+	short			ts_user_blade_id;/* user selected blade */
+	char			ts_user_chiplet_id;/* user selected chiplet */
 	unsigned short		ts_sizeavail;	/* Pagesizes in use */
 	int			ts_tsid;	/* thread that owns the
 						   structure */
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

