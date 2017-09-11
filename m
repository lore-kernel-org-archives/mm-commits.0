From: akpm@linux-foundation.org
Subject: [merged]
 arch-microblaze-add-choice-for-endianness-and-update-makefile.patch removed
 from -mm tree
Date: Mon, 11 Sep 2017 12:41:19 -0700
Message-ID: <20170911194119._meXAg4rA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49862 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdIKTlV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2017 15:41:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, babu.moger@oracle.com, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jonas@southpole.se, mingo@elte.hu, mm-commits@vger.kernel.org, monstr@monstr.eu, mpe@ellerman.id.au, peterz@infradead.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp


The patch titled
     Subject: arch/microblaze: add choice for endianness and update Makefile
has been removed from the -mm tree.  Its filename was
     arch-microblaze-add-choice-for-endianness-and-update-makefile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Babu Moger <babu.moger@oracle.com>
Subject: arch/microblaze: add choice for endianness and update Makefile

microblaze architectures can be configured for either little or big endian
formats.  Add a choice option for the user to select the correct endian
format(default to big endian).

Also update the Makefile so toolchain can compile for the format it is
configured for.

Link: http://lkml.kernel.org/r/1499358861-179979-3-git-send-email-babu.moger@oracle.com
Signed-off-by: Babu Moger <babu.moger@oracle.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/Kconfig  |   16 ++++++++++++++++
 arch/microblaze/Makefile |    2 ++
 2 files changed, 18 insertions(+)

diff -puN arch/microblaze/Kconfig~arch-microblaze-add-choice-for-endianness-and-update-makefile arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~arch-microblaze-add-choice-for-endianness-and-update-makefile
+++ a/arch/microblaze/Kconfig
@@ -36,6 +36,22 @@ config MICROBLAZE
 	select VIRT_TO_BUS
 	select CPU_NO_EFFICIENT_FFS
 
+# Endianness selection
+choice
+	prompt "Endianness selection"
+	default CPU_BIG_ENDIAN
+	help
+	  microblaze architectures can be configured for either little or
+	  big endian formats. Be sure to select the appropriate mode.
+
+config CPU_BIG_ENDIAN
+	bool "Big endian"
+
+config CPU_LITTLE_ENDIAN
+	bool "Little endian"
+
+endchoice
+
 config SWAP
 	def_bool n
 
diff -puN arch/microblaze/Makefile~arch-microblaze-add-choice-for-endianness-and-update-makefile arch/microblaze/Makefile
--- a/arch/microblaze/Makefile~arch-microblaze-add-choice-for-endianness-and-update-makefile
+++ a/arch/microblaze/Makefile
@@ -35,6 +35,8 @@ endif
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_DIV) += -mno-xl-soft-div
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_BARREL) += -mxl-barrel-shift
 CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR) += -mxl-pattern-compare
+CPUFLAGS-$(CONFIG_BIG_ENDIAN) += -mbig-endian
+CPUFLAGS-$(CONFIG_LITTLE_ENDIAN) += -mlittle-endian
 
 CPUFLAGS-1 += $(call cc-option,-mcpu=v$(CPU_VER))
 
_

Patches currently in -mm which might be from babu.moger@oracle.com are


