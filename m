From: akpm@linux-foundation.org
Subject: + gcov-enable-gcov_profile_all-for-x86_64.patch added to -mm tree
Date: Tue, 02 Jun 2009 15:03:50 -0700
Message-ID: <200906022203.n52M3oQw011697@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753001AbZFBWFE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 18:05:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oberpar@linux.vnet.ibm.com, W.Li@Sun.COM, andi@firstfloor.org, heicars2@linux.vnet.ibm.com, jdike@addtoit.com, michaele@au1.ibm.com, mingo@elte.hu, mschwid2@linux.vnet.ibm.com, rusty@rustcorp.com.au, sam@ravnborg.org, viro@zeniv.linux.org.uk, xiyou.wangcong@gmail.com, ying.huang@intel.com


The patch titled
     gcov: enable GCOV_PROFILE_ALL for x86_64
has been added to the -mm tree.  Its filename is
     gcov-enable-gcov_profile_all-for-x86_64.patch

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
Subject: gcov: enable GCOV_PROFILE_ALL for x86_64
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Enable gcov profiling of the entire kernel on x86_64. Required changes
include disabling profiling for:

* arch/kernel/acpi/realmode and arch/kernel/boot/compressed:
  not linked to main kernel
* arch/vdso, arch/kernel/vsyscall_64 and arch/kernel/hpet:
  profiling causes segfaults during boot (incompatible context)

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Li Wei <W.Li@Sun.COM>
Cc: Michael Ellerman <michaele@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Heiko Carstens <heicars2@linux.vnet.ibm.com>
Cc: Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/Makefile                 |    1 +
 arch/x86/boot/compressed/Makefile      |    1 +
 arch/x86/kernel/Makefile               |    2 ++
 arch/x86/kernel/acpi/realmode/Makefile |    1 +
 arch/x86/vdso/Makefile                 |    1 +
 kernel/gcov/Kconfig                    |    2 +-
 6 files changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/boot/Makefile~gcov-enable-gcov_profile_all-for-x86_64 arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~gcov-enable-gcov_profile_all-for-x86_64
+++ a/arch/x86/boot/Makefile
@@ -70,6 +70,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 $(obj)/bzImage: asflags-y  := $(SVGA_MODE)
 
diff -puN arch/x86/boot/compressed/Makefile~gcov-enable-gcov_profile_all-for-x86_64 arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~gcov-enable-gcov_profile_all-for-x86_64
+++ a/arch/x86/boot/compressed/Makefile
@@ -15,6 +15,7 @@ KBUILD_CFLAGS += $(call cc-option,-ffree
 KBUILD_CFLAGS += $(call cc-option,-fno-stack-protector)
 
 KBUILD_AFLAGS  := $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 LDFLAGS_vmlinux := -T
diff -puN arch/x86/kernel/Makefile~gcov-enable-gcov_profile_all-for-x86_64 arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~gcov-enable-gcov_profile_all-for-x86_64
+++ a/arch/x86/kernel/Makefile
@@ -24,6 +24,8 @@ CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0
 CFLAGS_hpet.o		:= $(nostackp)
 CFLAGS_tsc.o		:= $(nostackp)
 CFLAGS_paravirt.o	:= $(nostackp)
+GCOV_PROFILE_vsyscall_64.o	:= n
+GCOV_PROFILE_hpet.o		:= n
 
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
diff -puN arch/x86/kernel/acpi/realmode/Makefile~gcov-enable-gcov_profile_all-for-x86_64 arch/x86/kernel/acpi/realmode/Makefile
--- a/arch/x86/kernel/acpi/realmode/Makefile~gcov-enable-gcov_profile_all-for-x86_64
+++ a/arch/x86/kernel/acpi/realmode/Makefile
@@ -42,6 +42,7 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os 
 		   $(call cc-option, -mpreferred-stack-boundary=2)
 KBUILD_CFLAGS	+= $(call cc-option, -m32)
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
+GCOV_PROFILE := n
 
 WAKEUP_OBJS = $(addprefix $(obj)/,$(wakeup-y))
 
diff -puN arch/x86/vdso/Makefile~gcov-enable-gcov_profile_all-for-x86_64 arch/x86/vdso/Makefile
--- a/arch/x86/vdso/Makefile~gcov-enable-gcov_profile_all-for-x86_64
+++ a/arch/x86/vdso/Makefile
@@ -123,6 +123,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^)
 
 VDSO_LDFLAGS = -fPIC -shared $(call ld-option, -Wl$(comma)--hash-style=sysv)
+GCOV_PROFILE := n
 
 #
 # Install the unstripped copy of vdso*.so listed in $(vdso-install-y).
diff -puN kernel/gcov/Kconfig~gcov-enable-gcov_profile_all-for-x86_64 kernel/gcov/Kconfig
--- a/kernel/gcov/Kconfig~gcov-enable-gcov_profile_all-for-x86_64
+++ a/kernel/gcov/Kconfig
@@ -34,7 +34,7 @@ config GCOV_KERNEL
 config GCOV_PROFILE_ALL
 	bool "Profile entire Kernel"
 	depends on GCOV_KERNEL
-	depends on S390 || X86_32
+	depends on S390 || X86
 	default n
 	---help---
 	This options activates profiling for the entire kernel.
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

kernel-constructor-support.patch
seq_file-add-function-to-write-binary-data.patch
gcov-add-gcov-profiling-infrastructure.patch
gcov-enable-gcov_profile_all-for-x86_64.patch

