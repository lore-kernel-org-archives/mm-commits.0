From: akpm@linux-foundation.org
Subject: [merged] mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub.patch removed from -mm tree
Date: Wed, 08 Dec 2010 11:51:04 -0800
Message-ID: <201012081952.oB8JqlLH005730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab0LHTw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2010 14:52:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mn10300: Fix interrupt mask alteration function call name in gdbstub
has been removed from the -mm tree.  Its filename was
     mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mn10300: Fix interrupt mask alteration function call name in gdbstub
From: David Howells <dhowells@redhat.com>

Fix name of interrupt mask alteration function
(local_change_intr_mask_level()) called in gdbstub to have an arch_ prefix
to match the definition in asm/irqflags.h.

(akpm: appears to fix a build error)

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/kernel/gdb-io-serial.c |    3 ++-
 arch/mn10300/kernel/gdb-io-ttysm.c  |    3 ++-
 arch/mn10300/kernel/gdb-stub.c      |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/mn10300/kernel/gdb-io-serial.c~mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub arch/mn10300/kernel/gdb-io-serial.c
--- a/arch/mn10300/kernel/gdb-io-serial.c~mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub
+++ a/arch/mn10300/kernel/gdb-io-serial.c
@@ -73,7 +73,8 @@ void gdbstub_io_init(void)
 	GDBPORT_SERIAL_IER = UART_IER_RDI | UART_IER_RLSI;
 
 	/* permit level 0 IRQs to take place */
-	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
+	arch_local_change_intr_mask_level(
+		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 }
 
 /*
diff -puN arch/mn10300/kernel/gdb-io-ttysm.c~mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub arch/mn10300/kernel/gdb-io-ttysm.c
--- a/arch/mn10300/kernel/gdb-io-ttysm.c~mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub
+++ a/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -87,7 +87,8 @@ void __init gdbstub_io_init(void)
 	tmp = *gdbstub_port->_control;
 
 	/* permit level 0 IRQs only */
-	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
+	arch_local_change_intr_mask_level(
+		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 }
 
 /*
diff -puN arch/mn10300/kernel/gdb-stub.c~mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub arch/mn10300/kernel/gdb-stub.c
--- a/arch/mn10300/kernel/gdb-stub.c~mn10300-fix-interrupt-mask-alteration-function-call-name-in-gdbstub
+++ a/arch/mn10300/kernel/gdb-stub.c
@@ -1194,7 +1194,8 @@ static int gdbstub(struct pt_regs *regs,
 
 	asm volatile("mov mdr,%0" : "=d"(mdr));
 	local_save_flags(epsw);
-	local_change_intr_mask_level(NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
+	arch_local_change_intr_mask_level(
+		NUM2EPSW_IM(CONFIG_GDBSTUB_IRQ_LEVEL + 1));
 
 	gdbstub_store_fpu();
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
frv-duplicate-output_buffer-of-e03.patch
set_rtc_mmss-show-warning-message-only-once.patch
bitops-introduce-little-endian-bitops-for-most-architectures.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

