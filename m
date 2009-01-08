From: akpm@linux-foundation.org
Subject: + core_dump_default_elf_headers-depends-on-elf_core.patch added to -mm tree
Date: Wed, 07 Jan 2009 19:43:33 -0800
Message-ID: <200901080343.n083hXSD026154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbZAHDn6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 22:43:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, roland@redhat.com


The patch titled
     CORE_DUMP_DEFAULT_ELF_HEADERS depends on ELF_CORE
has been added to the -mm tree.  Its filename is
     core_dump_default_elf_headers-depends-on-elf_core.patch

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

origin.patch
rtc-ds1307-remove-legacy-probe-checks.patch
linux-next.patch
acpi-fix-acpi_fadt_s4_rtc_wake-comment.patch
usb-driver-for-freescale-quicc-engine-usb-host-controller.patch
usb-fsl_qe_udc-fix-oops-on-qe-udc-probe-failure.patch
usb-fsl_qe_udc-fix-recursive-locking-bug-in-ch9getstatus.patch
usb-fsl_qe_udc-fix-disconnects-reporting-during-bus-reset.patch
usb-fsl_qe_udc-fix-muram-corruption-by-disabled-endpoints.patch
usb-fsl_qe_udc-fix-stalled-tx-requests-bug.patch
core_dump_default_elf_headers-depends-on-elf_core.patch

