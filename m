From: akpm@linux-foundation.org
Subject: + elf-mips-build-fix.patch added to -mm tree
Date: Mon, 23 May 2016 13:50:00 -0700
Message-ID: <57436cf8.ggj9cdxFbRZ5LoOJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbcEWUuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 16:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, james.hogan@imgtec.com, macro@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: : ELF/MIPS build fix
has been added to the -mm tree.  Its filename is
     elf-mips-build-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/elf-mips-build-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/elf-mips-build-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralf Baechle <ralf@linux-mips.org>
Subject: : ELF/MIPS build fix

CONFIG_MIPS32_N32=y but CONFIG_BINFMT_ELF disabled results in the following
linker errors:

arch/mips/built-in.o: In function `elf_core_dump':
binfmt_elfn32.c:(.text+0x23dbc): undefined reference to `elf_core_extra_phdrs'
binfmt_elfn32.c:(.text+0x246e4): undefined reference to `elf_core_extra_data_size'
binfmt_elfn32.c:(.text+0x248d0): undefined reference to `elf_core_write_extra_phdrs'
binfmt_elfn32.c:(.text+0x24ac4): undefined reference to `elf_core_write_extra_data'

CONFIG_MIPS32_O32=y but CONFIG_BINFMT_ELF disabled results in the following
linker errors:

arch/mips/built-in.o: In function `elf_core_dump':
binfmt_elfo32.c:(.text+0x28a04): undefined reference to `elf_core_extra_phdrs'
binfmt_elfo32.c:(.text+0x29330): undefined reference to `elf_core_extra_data_size'
binfmt_elfo32.c:(.text+0x2951c): undefined reference to `elf_core_write_extra_phdrs'
binfmt_elfo32.c:(.text+0x29710): undefined reference to `elf_core_write_extra_data'

This is because binfmt_elfn32 and binfmt_elfo32 are using symbols from
elfcore but for these configurations elfcore will not be built.

Fixed by making elfcore selectable by a separate config symbol which
unlike the current mechanism can also be used from other directories than
kernel/, then having each flavor of ELF that relies on elfcore.o, select
it in Kconfig, including CONFIG_MIPS32_N32 and CONFIG_MIPS32_O32 which
fixes this issue.

Link: http://lkml.kernel.org/r/20160520141705.GA1913@linux-mips.org
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig |    1 +
 fs/Kconfig.binfmt |    8 ++++++++
 kernel/Makefile   |    4 +---
 3 files changed, 10 insertions(+), 3 deletions(-)

diff -puN arch/mips/Kconfig~elf-mips-build-fix arch/mips/Kconfig
--- a/arch/mips/Kconfig~elf-mips-build-fix
+++ a/arch/mips/Kconfig
@@ -3117,6 +3117,7 @@ config MIPS32_N32
 config BINFMT_ELF32
 	bool
 	default y if MIPS32_O32 || MIPS32_N32
+	select ELFCORE
 
 endmenu
 
diff -puN fs/Kconfig.binfmt~elf-mips-build-fix fs/Kconfig.binfmt
--- a/fs/Kconfig.binfmt~elf-mips-build-fix
+++ a/fs/Kconfig.binfmt
@@ -1,6 +1,7 @@
 config BINFMT_ELF
 	bool "Kernel support for ELF binaries"
 	depends on MMU && (BROKEN || !FRV)
+	select ELFCORE
 	default y
 	---help---
 	  ELF (Executable and Linkable Format) is a format for libraries and
@@ -26,6 +27,7 @@ config BINFMT_ELF
 config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
+	select ELFCORE
 
 config ARCH_BINFMT_ELF_STATE
 	bool
@@ -34,6 +36,7 @@ config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
 	depends on (FRV || BLACKFIN || (SUPERH32 && !MMU) || C6X)
+	select ELFCORE
 	help
 	  ELF FDPIC binaries are based on ELF, but allow the individual load
 	  segments of a binary to be located in memory independently of each
@@ -43,6 +46,11 @@ config BINFMT_ELF_FDPIC
 
 	  It is also possible to run FDPIC ELF binaries on MMU linux also.
 
+config ELFCORE
+	bool
+	help
+	  This option enables kernel/elfcore.o.
+
 config CORE_DUMP_DEFAULT_ELF_HEADERS
 	bool "Write ELF core dumps with partial segments"
 	default y
diff -puN kernel/Makefile~elf-mips-build-fix kernel/Makefile
--- a/kernel/Makefile~elf-mips-build-fix
+++ a/kernel/Makefile
@@ -91,9 +91,7 @@ obj-$(CONFIG_TASK_DELAY_ACCT) += delayac
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
-obj-$(CONFIG_BINFMT_ELF) += elfcore.o
-obj-$(CONFIG_COMPAT_BINFMT_ELF) += elfcore.o
-obj-$(CONFIG_BINFMT_ELF_FDPIC) += elfcore.o
+obj-$(CONFIG_ELFCORE) += elfcore.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
 obj-$(CONFIG_TRACE_CLOCK) += trace/
_

Patches currently in -mm which might be from ralf@linux-mips.org are

elf-mips-build-fix.patch

