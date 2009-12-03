From: akpm@linux-foundation.org
Subject: + gru-send-cross-partition-interrupts-using-the-gru.patch added to -mm tree
Date: Thu, 03 Dec 2009 15:20:30 -0800
Message-ID: <200912032320.nB3NKVBr027409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbZLCXU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 18:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: send cross partition interrupts using the gru
has been added to the -mm tree.  Its filename is
     gru-send-cross-partition-interrupts-using-the-gru.patch

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
Subject: gru: send cross partition interrupts using the gru
From: Jack Steiner <steiner@sgi.com>

GRU Message queue instructions are used to deliver messages to other SSIs
within the numalink domain.  In most cases, a single GRU mesq instruction
will deliver both the message AND an interrupt to notify the other SSI
that a messsage is present.  In some cases, however, the interrupt must be
sent explicitly.

To improve resilency, the GRU driver should send these explicit interrupts
using the GRU to write the remote chipset register.  Current code sends
the interrupt using a cpu instruction to write the chipset register.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/gru_instructions.h |   12 ++++++
 drivers/misc/sgi-gru/grukservices.c     |   39 +++++++++++++---------
 2 files changed, 36 insertions(+), 15 deletions(-)

diff -puN drivers/misc/sgi-gru/gru_instructions.h~gru-send-cross-partition-interrupts-using-the-gru drivers/misc/sgi-gru/gru_instructions.h
--- a/drivers/misc/sgi-gru/gru_instructions.h~gru-send-cross-partition-interrupts-using-the-gru
+++ a/drivers/misc/sgi-gru/gru_instructions.h
@@ -367,6 +367,18 @@ static inline void gru_vload_phys(void *
 					(unsigned long)tri0, CB_IMA(hints)));
 }
 
+static inline void gru_vstore_phys(void *cb, unsigned long gpa,
+		unsigned int tri0, int iaa, unsigned long hints)
+{
+	struct gru_instruction *ins = (struct gru_instruction *)cb;
+
+	ins->baddr0 = (long)gpa | ((unsigned long)iaa << 62);
+	ins->nelem = 1;
+	ins->op1_stride = 1;
+	gru_start_instruction(ins, __opdword(OP_VSTORE, 0, XTYPE_DW, iaa, 0,
+					(unsigned long)tri0, CB_IMA(hints)));
+}
+
 static inline void gru_vload(void *cb, unsigned long mem_addr,
 		unsigned int tri0, unsigned char xtype, unsigned long nelem,
 		unsigned long stride, unsigned long hints)
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-send-cross-partition-interrupts-using-the-gru drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-send-cross-partition-interrupts-using-the-gru
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/uaccess.h>
 #include <linux/delay.h>
+#include <asm/io_apic.h>
 #include "gru.h"
 #include "grulib.h"
 #include "grutables.h"
@@ -566,7 +567,7 @@ int gru_create_message_queue(struct gru_
 	mqd->mq = mq;
 	mqd->mq_gpa = uv_gpa(mq);
 	mqd->qlines = qlines;
-	mqd->interrupt_pnode = UV_NASID_TO_PNODE(nasid);
+	mqd->interrupt_pnode = nasid >> 1;
 	mqd->interrupt_vector = vector;
 	mqd->interrupt_apicid = apicid;
 	return 0;
@@ -703,18 +704,6 @@ cberr:
 }
 
 /*
- * Send a cross-partition interrupt to the SSI that contains the target
- * message queue. Normally, the interrupt is automatically delivered by hardware
- * but some error conditions require explicit delivery.
- */
-static void send_message_queue_interrupt(struct gru_message_queue_desc *mqd)
-{
-	if (mqd->interrupt_vector)
-		uv_hub_send_ipi(mqd->interrupt_pnode, mqd->interrupt_apicid,
-				mqd->interrupt_vector);
-}
-
-/*
  * Handle a PUT failure. Note: if message was a 2-line message, one of the
  * lines might have successfully have been written. Before sending the
  * message, "present" must be cleared in BOTH lines to prevent the receiver
@@ -723,7 +712,8 @@ static void send_message_queue_interrupt
 static int send_message_put_nacked(void *cb, struct gru_message_queue_desc *mqd,
 			void *mesg, int lines)
 {
-	unsigned long m;
+	unsigned long m, *val = mesg, gpa, save;
+	int ret;
 
 	m = mqd->mq_gpa + (gru_get_amo_value_head(cb) << 6);
 	if (lines == 2) {
@@ -734,7 +724,26 @@ static int send_message_put_nacked(void 
 	gru_vstore(cb, m, gru_get_tri(mesg), XTYPE_CL, lines, 1, IMA);
 	if (gru_wait(cb) != CBS_IDLE)
 		return MQE_UNEXPECTED_CB_ERR;
-	send_message_queue_interrupt(mqd);
+
+	if (!mqd->interrupt_vector)
+		return MQE_OK;
+
+	/*
+	 * Send a cross-partition interrupt to the SSI that contains the target
+	 * message queue. Normally, the interrupt is automatically delivered by
+	 * hardware but some error conditions require explicit delivery.
+	 * Use the GRU to deliver the interrupt. Otherwise partition failures
+	 * could cause unrecovered errors.
+	 */
+	gpa = uv_global_gru_mmr_address(mqd->interrupt_pnode, UVH_IPI_INT);
+	save = *val;
+	*val = uv_hub_ipi_value(mqd->interrupt_apicid, mqd->interrupt_vector,
+				dest_Fixed);
+	gru_vstore_phys(cb, gpa, gru_get_tri(mesg), IAA_REGISTER, IMA);
+	ret = gru_wait(cb);
+	*val = save;
+	if (ret != CBS_IDLE)
+		return MQE_UNEXPECTED_CB_ERR;
 	return MQE_OK;
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
uv-xpc-pass-nasid-instead-of-nid-to-gru_create_message_queue.patch
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
gru-function-to-generate-chipset-ipi-values.patch
gru-send-cross-partition-interrupts-using-the-gru.patch

