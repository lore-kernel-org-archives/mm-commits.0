From: akpm@linux-foundation.org
Subject: + uml-fix-static-linking.patch added to -mm tree
Date: Sun, 25 Mar 2007 13:55:04 -0800
Message-ID: <200703252155.l2PLt4Kx003738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59401 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbXCYV4Y (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 17:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, stable@kernel.org


The patch titled
     uml: fix static linking
has been added to the -mm tree.  Its filename is
     uml-fix-static-linking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-fix-epoll.patch
uml-fix-static-linking.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
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
