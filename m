From: akpm@linux-foundation.org
Subject: - uml-fix-static-linking.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:42:08 -0700
Message-ID: <200703290742.l2T7g8mK030282@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46230 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105AbXC2Hn1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:43:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     uml: fix static linking
has been removed from the -mm tree.  Its filename was
     uml-fix-static-linking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: fix static linking
From: Jeff Dike <jdike@addtoit.com>

During a static link, ld has started putting a .note section in the
.uml.setup.init section.  This has the result that the UML setups begin
with 32 bytes of garbage and UML crashes immediately on boot.

This patch creates a specific .note section for ld to drop this stuff
into.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-um/common.lds.S |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/asm-um/common.lds.S~uml-fix-static-linking include/asm-um/common.lds.S
--- a/include/asm-um/common.lds.S~uml-fix-static-linking
+++ a/include/asm-um/common.lds.S
@@ -15,6 +15,7 @@
   PROVIDE (_unprotected_end = .);
 
   . = ALIGN(4096);
+  .note : { *(note.*) }
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
uml-fix-i-o-hang-when-multiple-devices-are-in-use.patch
uml-fix-device-unplug-crash.patch
uml-irq-locking-fixes.patch
uml-fix-compilation-problems.patch
uml-fix-unreasonably-long-udelay.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-network-interface-hotplug-error-handling.patch
array_size-check-for-type-uml-fix.patch
uml-fix-prototypes.patch
uml-move-sigio-testing-to-sigioc.patch
uml-create-archh.patch
uml-create-as-layouth.patch
uml-move-remaining-useful-contents-of-user_utilh.patch
uml-remove-user_utilh.patch
uml-add-missing-__init-declarations.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
fix-utrace-utrace-tracehook-um.patch
