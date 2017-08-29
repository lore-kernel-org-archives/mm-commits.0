From: akpm@linux-foundation.org
Subject: +
 arch-microblaze-add-choice-for-endianness-and-update-makefile.patch added
 to -mm tree
Date: Tue, 29 Aug 2017 12:36:11 -0700
Message-ID: <59a5c22b.O4ObDX/StipoEVCP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40926 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751275AbdH2TgM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Aug 2017 15:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: babu.moger@oracle.com, arnd@arndb.de, davem@davemloft.net, deller@gmx.de, geert@linux-m68k.org, gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jonas@southpole.se, mingo@elte.hu, monstr@monstr.eu, mpe@ellerman.id.au, peterz@infradead.org, shorne@gmail.com, stefan.kristiansson@saunalahti.fi, viro@zeniv.linux.org.uk, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/microblaze: add choice for endianness and update Makefile
has been added to the -mm tree.  Its filename is
     arch-microblaze-add-choice-for-endianness-and-update-makefile.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-microblaze-add-choice-for-endianness-and-update-makefile.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-microblaze-add-choice-for-endianness-and-update-makefile.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-define-cpu_big_endian-for-all-fixed-big-endian-archs.patch
arch-microblaze-add-choice-for-endianness-and-update-makefile.patch
include-warn-for-inconsistent-endian-config-definition.patch

