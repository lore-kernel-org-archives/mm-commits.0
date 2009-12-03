From: akpm@linux-foundation.org
Subject: + gru-function-to-generate-chipset-ipi-values.patch added to -mm tree
Date: Thu, 03 Dec 2009 15:20:28 -0800
Message-ID: <200912032320.nB3NKSmF027265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55093 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751376AbZLCXUY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Dec 2009 18:20:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: function to generate chipset IPI values
has been added to the -mm tree.  Its filename is
     gru-function-to-generate-chipset-ipi-values.patch

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
Subject: gru: function to generate chipset IPI values
From: Jack Steiner <steiner@sgi.com>

Create a function to generate the value that is written to the UV hub MMR
to cause an IPI interrupt to be sent.  The function will be used in the
GRU message queue error recovery code that sends IPIs to nodes in remote
partitions.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/uv/uv_hub.h |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/uv/uv_hub.h~gru-function-to-generate-chipset-ipi-values arch/x86/include/asm/uv/uv_hub.h
--- a/arch/x86/include/asm/uv/uv_hub.h~gru-function-to-generate-chipset-ipi-values
+++ a/arch/x86/include/asm/uv/uv_hub.h
@@ -172,6 +172,8 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define UV_LOCAL_MMR_SIZE		(64UL * 1024 * 1024)
 #define UV_GLOBAL_MMR32_SIZE		(64UL * 1024 * 1024)
 
+#define UV_GLOBAL_GRU_MMR_BASE		0x4000000
+
 #define UV_GLOBAL_MMR32_PNODE_SHIFT	15
 #define UV_GLOBAL_MMR64_PNODE_SHIFT	26
 
@@ -328,6 +330,15 @@ static inline unsigned long uv_read_glob
 }
 
 /*
+ * Global MMR space addresses when referenced by the GRU. (GRU does
+ * NOT use socket addressing).
+ */
+static inline unsigned long uv_global_gru_mmr_address(int pnode, unsigned long offset)
+{
+	return UV_GLOBAL_GRU_MMR_BASE | offset | (pnode << uv_hub_info->m_val);
+}
+
+/*
  * Access hub local MMRs. Faster than using global space but only local MMRs
  * are accessible.
  */
@@ -454,6 +465,14 @@ static inline void uv_set_cpu_scir_bits(
 	}
 }
 
+static unsigned long uv_hub_ipi_value(int apicid, int vector, int mode)
+{
+	return (1UL << UVH_IPI_INT_SEND_SHFT) |
+			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
+			(mode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
+			(vector << UVH_IPI_INT_VECTOR_SHFT);
+}
+
 static inline void uv_hub_send_ipi(int pnode, int apicid, int vector)
 {
 	unsigned long val;
@@ -462,10 +481,7 @@ static inline void uv_hub_send_ipi(int p
 	if (vector == NMI_VECTOR)
 		dmode = dest_NMI;
 
-	val = (1UL << UVH_IPI_INT_SEND_SHFT) |
-			((apicid) << UVH_IPI_INT_APIC_ID_SHFT) |
-			(dmode << UVH_IPI_INT_DELIVERY_MODE_SHFT) |
-			(vector << UVH_IPI_INT_VECTOR_SHFT);
+	val = uv_hub_ipi_value(apicid, vector, dmode);
 	uv_write_global_mmr64(pnode, UVH_IPI_INT, val);
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

