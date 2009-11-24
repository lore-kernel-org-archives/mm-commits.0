From: akpm@linux-foundation.org
Subject: + gru-check-for-valid-vma.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:58:31 -0800
Message-ID: <200911241958.nAOJwV7u018926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932736AbZKXT61 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:58:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: check for valid vma
has been added to the -mm tree.  Its filename is
     gru-check-for-valid-vma.patch

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
Subject: gru: check for valid vma
From: Jack Steiner <steiner@sgi.com>

Fix bug caused by failure to allocate a GRU gts structure.  The old code
failed to handle the case where the vma was invalid.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-check-for-valid-vma drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-check-for-valid-vma
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -90,19 +90,22 @@ static struct gru_thread_state *gru_allo
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
-	struct gru_thread_state *gts = NULL;
+	struct gru_thread_state *gts = ERR_PTR(-EINVAL);
 
 	down_write(&mm->mmap_sem);
 	vma = gru_find_vma(vaddr);
-	if (vma)
-		gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
-	if (!IS_ERR(gts)) {
-		mutex_lock(&gts->ts_ctxlock);
-		downgrade_write(&mm->mmap_sem);
-	} else {
-		up_write(&mm->mmap_sem);
-	}
+	if (!vma)
+		goto err;
 
+	gts = gru_alloc_thread_state(vma, TSID(vaddr, vma));
+	if (IS_ERR(gts))
+		goto err;
+	mutex_lock(&gts->ts_ctxlock);
+	downgrade_write(&mm->mmap_sem);
+	return gts;
+
+err:
+	up_write(&mm->mmap_sem);
 	return gts;
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

