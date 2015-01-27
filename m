From: akpm@linux-foundation.org
Subject: [merged] x86-build-replace-perl-script-with-shell-script.patch
 removed from -mm tree
Date: Tue, 27 Jan 2015 12:22:28 -0800
Message-ID: <54c7f384.VHzw9K3INQnUGFDO%akpm__9208.93649240515$1422390158$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbbA0UW3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 15:22:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, anca.emanuel@gmail.com, eternal.n08@gmail.com, fengguang.wu@intel.com, rob@landley.net, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, build: replace Perl script with Shell script
has been removed from the -mm tree.  Its filename was
     x86-build-replace-perl-script-with-shell-script.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: x86, build: replace Perl script with Shell script

Commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
added Perl to the required build environment.  This reimplements in shell
the Perl script used to find the size of the kernel with bss and brk
added.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Rob Landley <rob@landley.net>
Acked-by: Rob Landley <rob@landley.net>
Cc: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/Makefile |    2 -
 arch/x86/tools/calc_run_size.pl   |   39 --------------------------
 arch/x86/tools/calc_run_size.sh   |   42 ++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 40 deletions(-)

diff -puN arch/x86/boot/compressed/Makefile~x86-build-replace-perl-script-with-shell-script arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~x86-build-replace-perl-script-with-shell-script
+++ a/arch/x86/boot/compressed/Makefile
@@ -90,7 +90,7 @@ suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
 RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
+	     $(CONFIG_SHELL) $(srctree)/arch/x86/tools/calc_run_size.sh)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
 
diff -puN arch/x86/tools/calc_run_size.pl~x86-build-replace-perl-script-with-shell-script /dev/null
--- a/arch/x86/tools/calc_run_size.pl
+++ /dev/null
@@ -1,39 +0,0 @@
-#!/usr/bin/perl
-#
-# Calculate the amount of space needed to run the kernel, including room for
-# the .bss and .brk sections.
-#
-# Usage:
-# objdump -h a.out | perl calc_run_size.pl
-use strict;
-
-my $mem_size = 0;
-my $file_offset = 0;
-
-my $sections=" *[0-9]+ \.(?:bss|brk) +";
-while (<>) {
-	if (/^$sections([0-9a-f]+) +(?:[0-9a-f]+ +){2}([0-9a-f]+)/) {
-		my $size = hex($1);
-		my $offset = hex($2);
-		$mem_size += $size;
-		if ($file_offset == 0) {
-			$file_offset = $offset;
-		} elsif ($file_offset != $offset) {
-			# BFD linker shows the same file offset in ELF.
-			# Gold linker shows them as consecutive.
-			next if ($file_offset + $mem_size == $offset + $size);
-
-			printf STDERR "file_offset: 0x%lx\n", $file_offset;
-			printf STDERR "mem_size: 0x%lx\n", $mem_size;
-			printf STDERR "offset: 0x%lx\n", $offset;
-			printf STDERR "size: 0x%lx\n", $size;
-
-			die ".bss and .brk are non-contiguous\n";
-		}
-	}
-}
-
-if ($file_offset == 0) {
-	die "Never found .bss or .brk file offset\n";
-}
-printf("%d\n", $mem_size + $file_offset);
diff -puN /dev/null arch/x86/tools/calc_run_size.sh
--- /dev/null
+++ a/arch/x86/tools/calc_run_size.sh
@@ -0,0 +1,42 @@
+#!/bin/sh
+#
+# Calculate the amount of space needed to run the kernel, including room for
+# the .bss and .brk sections.
+#
+# Usage:
+# objdump -h a.out | sh calc_run_size.sh
+
+NUM='\([0-9a-fA-F]*[ \t]*\)'
+OUT=$(sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$NUM$NUM$NUM$NUM"'.*/\1\4/p')
+if [ -z "$OUT" ] ; then
+	echo "Never found .bss or .brk file offset" >&2
+	exit 1
+fi
+
+OUT=$(echo ${OUT# })
+sizeA=$(printf "%d" 0x${OUT%% *})
+OUT=${OUT#* }
+offsetA=$(printf "%d" 0x${OUT%% *})
+OUT=${OUT#* }
+sizeB=$(printf "%d" 0x${OUT%% *})
+OUT=${OUT#* }
+offsetB=$(printf "%d" 0x${OUT%% *})
+
+run_size=$(( $offsetA + $sizeA + $sizeB ))
+
+# BFD linker shows the same file offset in ELF.
+if [ "$offsetA" -ne "$offsetB" ] ; then
+	# Gold linker shows them as consecutive.
+	endB=$(( $offsetB + $sizeB ))
+	if [ "$endB" != "$run_size" ] ; then
+		printf "sizeA: 0x%x\n" $sizeA >&2
+		printf "offsetA: 0x%x\n" $offsetA >&2
+		printf "sizeB: 0x%x\n" $sizeB >&2
+		printf "offsetB: 0x%x\n" $offsetB >&2
+		echo ".bss and .brk are non-contiguous" >&2
+		exit 1
+	fi
+fi
+
+printf "%d\n" $run_size
+exit 0
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch
lib-vsprintf-add-%pt-format-specifier.patch
linux-next.patch

