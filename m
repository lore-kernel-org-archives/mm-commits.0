From: akpm@linux-foundation.org
Subject: [merged] kbuild-fix-gcc-x-syntax.patch removed from -mm tree
Date: Thu, 04 Oct 2012 13:46:48 -0700
Message-ID: <20121004204651.025E6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:38839 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab2JDUqy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 16:46:54 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so74011yhl.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 13:46:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, bernhard@bwalle.de, dmueller@suse.de, hpa@zytor.com, matz@suse.de, mingo@elte.hu, mmarek@suse.cz, ralf@linux-mips.org, rguenther@suse.de, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     From: Jean Delvare <jdelvare@suse.de>
has been removed from the -mm tree.  Its filename was
     kbuild-fix-gcc-x-syntax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kbuild: Fix gcc -x syntax
From: Jean Delvare <jdelvare@suse.de>

The correct syntax for gcc -x is "gcc -x assembler", not
"gcc -xassembler". Even though the latter happens to work, the former
is what is documented in the manual page and thus what gcc wrappers
such as icecream do expect.

This isn't a cosmetic change. The missing space prevents icecream from
recognizing compilation tasks it can't handle, leading to silent kernel
miscompilations.

Besides me, credits go to Michael Matz and Dirk Mueller for
investigating the miscompilation issue and tracking it down to this
incorrect -x parameter syntax.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Bernhard Walle <bernhard@bwalle.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Guenther <rguenther@suse.de>
Cc: Dirk Mueller <dmueller@suse.de>
Cc: Michael Matz <matz@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Makefile                         |    2 +-
 arch/mips/kernel/Makefile                  |    2 +-
 arch/x86/Makefile                          |    2 +-
 scripts/Kbuild.include                     |   12 ++++++------
 scripts/gcc-version.sh                     |    6 +++---
 scripts/gcc-x86_32-has-stack-protector.sh  |    2 +-
 scripts/gcc-x86_64-has-stack-protector.sh  |    2 +-
 scripts/kconfig/check.sh                   |    2 +-
 scripts/kconfig/lxdialog/check-lxdialog.sh |    2 +-
 tools/perf/Makefile                        |    2 +-
 tools/power/cpupower/Makefile              |    2 +-
 11 files changed, 18 insertions(+), 18 deletions(-)

diff -puN arch/mips/Makefile~kbuild-fix-gcc-x-syntax arch/mips/Makefile
--- a/arch/mips/Makefile~kbuild-fix-gcc-x-syntax
+++ a/arch/mips/Makefile
@@ -225,7 +225,7 @@ KBUILD_CPPFLAGS += -DDATAOFFSET=$(if $(d
 LDFLAGS			+= -m $(ld-emul)
 
 ifdef CONFIG_MIPS
-CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -xc /dev/null | \
+CHECKFLAGS += $(shell $(CC) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	egrep -vw '__GNUC_(|MINOR_|PATCHLEVEL_)_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/")
 ifdef CONFIG_64BIT
diff -puN arch/mips/kernel/Makefile~kbuild-fix-gcc-x-syntax arch/mips/kernel/Makefile
--- a/arch/mips/kernel/Makefile~kbuild-fix-gcc-x-syntax
+++ a/arch/mips/kernel/Makefile
@@ -105,7 +105,7 @@ obj-$(CONFIG_MIPS_MACHINE)	+= mips_machi
 
 obj-$(CONFIG_OF)		+= prom.o
 
-CFLAGS_cpu-bugs64.o	= $(shell if $(CC) $(KBUILD_CFLAGS) -Wa,-mdaddi -c -o /dev/null -xc /dev/null >/dev/null 2>&1; then echo "-DHAVE_AS_SET_DADDI"; fi)
+CFLAGS_cpu-bugs64.o	= $(shell if $(CC) $(KBUILD_CFLAGS) -Wa,-mdaddi -c -o /dev/null -x c /dev/null >/dev/null 2>&1; then echo "-DHAVE_AS_SET_DADDI"; fi)
 
 obj-$(CONFIG_HAVE_STD_PC_SERIAL_PORT)	+= 8250-platform.o
 
diff -puN arch/x86/Makefile~kbuild-fix-gcc-x-syntax arch/x86/Makefile
--- a/arch/x86/Makefile~kbuild-fix-gcc-x-syntax
+++ a/arch/x86/Makefile
@@ -92,7 +92,7 @@ endif
 ifdef CONFIG_X86_X32
 	x32_ld_ok := $(call try-run,\
 			/bin/echo -e '1: .quad 1b' | \
-			$(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" - && \
+			$(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" - && \
 			$(OBJCOPY) -O elf32-x86-64 "$$TMP" "$$TMPO" && \
 			$(LD) -m elf32_x86_64 "$$TMPO" -o "$$TMP",y,n)
         ifeq ($(x32_ld_ok),y)
diff -puN scripts/Kbuild.include~kbuild-fix-gcc-x-syntax scripts/Kbuild.include
--- a/scripts/Kbuild.include~kbuild-fix-gcc-x-syntax
+++ a/scripts/Kbuild.include
@@ -98,24 +98,24 @@ try-run = $(shell set -e;		\
 # Usage: cflags-y += $(call as-option,-Wa$(comma)-isa=foo,)
 
 as-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xassembler /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CFLAGS) $(1) -c -x assembler /dev/null -o "$$TMP",$(1),$(2))
 
 # as-instr
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
 as-instr = $(call try-run,\
-	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+	printf "%b\n" "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -x assembler -o "$$TMP" -,$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -x c /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign
@@ -125,7 +125,7 @@ cc-option-align = $(subst -functions=0,,
 # cc-disable-warning
 # Usage: cflags-y += $(call cc-disable-warning,unused-but-set-variable)
 cc-disable-warning = $(call try-run,\
-	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -xc /dev/null -o "$$TMP",-Wno-$(strip $(1)))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -W$(strip $(1)) -c -x c /dev/null -o "$$TMP",-Wno-$(strip $(1)))
 
 # cc-version
 # Usage gcc-ver := $(call cc-version)
@@ -143,7 +143,7 @@ cc-ifversion = $(shell [ $(call cc-versi
 # cc-ldoption
 # Usage: ldflags += $(call cc-ldoption, -Wl$(comma)--hash-style=both)
 cc-ldoption = $(call try-run,\
-	$(CC) $(1) -nostdlib -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(1) -nostdlib -x c /dev/null -o "$$TMP",$(1),$(2))
 
 # ld-option
 # Usage: LDFLAGS += $(call ld-option, -X)
diff -puN scripts/gcc-version.sh~kbuild-fix-gcc-x-syntax scripts/gcc-version.sh
--- a/scripts/gcc-version.sh~kbuild-fix-gcc-x-syntax
+++ a/scripts/gcc-version.sh
@@ -22,10 +22,10 @@ if [ ${#compiler} -eq 0 ]; then
 	exit 1
 fi
 
-MAJOR=$(echo __GNUC__ | $compiler -E -xc - | tail -n 1)
-MINOR=$(echo __GNUC_MINOR__ | $compiler -E -xc - | tail -n 1)
+MAJOR=$(echo __GNUC__ | $compiler -E -x c - | tail -n 1)
+MINOR=$(echo __GNUC_MINOR__ | $compiler -E -x c - | tail -n 1)
 if [ "x$with_patchlevel" != "x" ] ; then
-	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -xc - | tail -n 1)
+	PATCHLEVEL=$(echo __GNUC_PATCHLEVEL__ | $compiler -E -x c - | tail -n 1)
 	printf "%02d%02d%02d\\n" $MAJOR $MINOR $PATCHLEVEL
 else
 	printf "%02d%02d\\n" $MAJOR $MINOR
diff -puN scripts/gcc-x86_32-has-stack-protector.sh~kbuild-fix-gcc-x-syntax scripts/gcc-x86_32-has-stack-protector.sh
--- a/scripts/gcc-x86_32-has-stack-protector.sh~kbuild-fix-gcc-x-syntax
+++ a/scripts/gcc-x86_32-has-stack-protector.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -xc -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -O0 -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
 	echo y
 else
diff -puN scripts/gcc-x86_64-has-stack-protector.sh~kbuild-fix-gcc-x-syntax scripts/gcc-x86_64-has-stack-protector.sh
--- a/scripts/gcc-x86_64-has-stack-protector.sh~kbuild-fix-gcc-x-syntax
+++ a/scripts/gcc-x86_64-has-stack-protector.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 
-echo "int foo(void) { char X[200]; return 3; }" | $* -S -xc -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
+echo "int foo(void) { char X[200]; return 3; }" | $* -S -x c -c -O0 -mcmodel=kernel -fstack-protector - -o - 2> /dev/null | grep -q "%gs"
 if [ "$?" -eq "0" ] ; then
 	echo y
 else
diff -puN scripts/kconfig/check.sh~kbuild-fix-gcc-x-syntax scripts/kconfig/check.sh
--- a/scripts/kconfig/check.sh~kbuild-fix-gcc-x-syntax
+++ a/scripts/kconfig/check.sh
@@ -1,6 +1,6 @@
 #!/bin/sh
 # Needed for systems without gettext
-$* -xc -o /dev/null - > /dev/null 2>&1 << EOF
+$* -x c -o /dev/null - > /dev/null 2>&1 << EOF
 #include <libintl.h>
 int main()
 {
diff -puN scripts/kconfig/lxdialog/check-lxdialog.sh~kbuild-fix-gcc-x-syntax scripts/kconfig/lxdialog/check-lxdialog.sh
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh~kbuild-fix-gcc-x-syntax
+++ a/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -38,7 +38,7 @@ trap "rm -f $tmp" 0 1 2 3 15
 
 # Check if we can link to ncurses
 check() {
-        $cc -xc - -o $tmp 2>/dev/null <<'EOF'
+        $cc -x c - -o $tmp 2>/dev/null <<'EOF'
 #include CURSES_LOC
 main() {}
 EOF
diff -puN tools/perf/Makefile~kbuild-fix-gcc-x-syntax tools/perf/Makefile
--- a/tools/perf/Makefile~kbuild-fix-gcc-x-syntax
+++ a/tools/perf/Makefile
@@ -72,7 +72,7 @@ ifeq ($(ARCH),x86_64)
 	override ARCH := x86
 	IS_X86_64 := 0
 	ifeq (, $(findstring m32,$(EXTRA_CFLAGS)))
-		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -xc - | tail -n 1)
+		IS_X86_64 := $(shell echo __x86_64__ | ${CC} -E -x c - | tail -n 1)
 	endif
 	ifeq (${IS_X86_64}, 1)
 		RAW_ARCH := x86_64
diff -puN tools/power/cpupower/Makefile~kbuild-fix-gcc-x-syntax tools/power/cpupower/Makefile
--- a/tools/power/cpupower/Makefile~kbuild-fix-gcc-x-syntax
+++ a/tools/power/cpupower/Makefile
@@ -111,7 +111,7 @@ GMO_FILES = ${shell for HLANG in ${LANGU
 export CROSS CC AR STRIP RANLIB CFLAGS LDFLAGS LIB_OBJS
 
 # check if compiler option is supported
-cc-supports = ${shell if $(CC) ${1} -S -o /dev/null -xc /dev/null > /dev/null 2>&1; then echo "$(1)"; fi;}
+cc-supports = ${shell if $(CC) ${1} -S -o /dev/null -x c /dev/null > /dev/null 2>&1; then echo "$(1)"; fi;}
 
 # use '-Os' optimization if available, else use -O2
 OPTIMIZATION := $(call cc-supports,-Os,-O2)
_

Patches currently in -mm which might be from jdelvare@suse.de are

origin.patch
linux-next.patch

