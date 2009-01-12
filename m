From: akpm@linux-foundation.org
Subject: - core_dump_default_elf_headers-depends-on-elf_core.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:57:50 -0800
Message-ID: <200901121957.n0CJvoDf027044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265AbZALT7R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:59:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbrownell@users.sourceforge.net, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     CORE_DUMP_DEFAULT_ELF_HEADERS depends on ELF_CORE
has been removed from the -mm tree.  Its filename was
     core_dump_default_elf_headers-depends-on-elf_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CORE_DUMP_DEFAULT_ELF_HEADERS depends on ELF_CORE
From: David Brownell <dbrownell@users.sourceforge.net>

Kernels that don't support ELF coredumps at all surely can't be supporting
new partial-segment flavored ELF coredumps ...  don't make folk answer
Kconfig questions about that flavor.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig.binfmt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig.binfmt~core_dump_default_elf_headers-depends-on-elf_core fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~core_dump_default_elf_headers-depends-on-elf_core
+++ a/fs/Kconfig.binfmt
@@ -43,7 +43,7 @@ config BINFMT_ELF_FDPIC
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
 	default n
-	depends on BINFMT_ELF
+	depends on BINFMT_ELF && ELF_CORE
 	help
 	  ELF core dump files describe each memory mapping of the crashed
 	  process, and can contain or omit the memory contents of each one.
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

linux-next.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller-update.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch

