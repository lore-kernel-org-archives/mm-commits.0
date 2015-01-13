From: akpm@linux-foundation.org
Subject: [alternative-merged]
 remove-recently-added-perl-build-requirement.patch removed from -mm tree
Date: Tue, 13 Jan 2015 14:55:44 -0800
Message-ID: <54b5a270.bYdj1CN/WhL3GwTL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbbAMWzp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jan 2015 17:55:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rob@landley.net, anca.emanuel@gmail.com, eternal.n08@gmail.com, fengguang.wu@intel.com, keescook@chromium.org, stable@vger.kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: remove recently added perl build requirement
has been removed from the -mm tree.  Its filename was
     remove-recently-added-perl-build-requirement.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Rob Landley <rob@landley.net>
Subject: remove recently added perl build requirement

Commit e6023367d779 ("x86, kaslr: Prevent .bss from overlaping initrd")
added perl back to the kernel build dependencies in -rc6.

Replace those 39 lines of perl with 4 lines of shell script.

Note: checkpatch.pl isn't a build dependency, it's a development
dependency (like bloat-o-meter being written in python or "make xconfig"
needing QT).  Those aren't things you need to add to your cross compile
environment to produce a binary.  Different category of dependency.

For more history on the issue, see https://lkml.org/lkml/2013/2/27/18

Signed-off-by: Rob Landley <rob@landley.net>
Acked-by: Anca Emanuel <anca.emanuel@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Junjie Mao <eternal.n08@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/compressed/Makefile |    6 ++--
 arch/x86/tools/calc_run_size.pl   |   39 ----------------------------
 2 files changed, 4 insertions(+), 41 deletions(-)

diff -puN arch/x86/boot/compressed/Makefile~remove-recently-added-perl-build-requirement arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~remove-recently-added-perl-build-requirement
+++ a/arch/x86/boot/compressed/Makefile
@@ -89,8 +89,10 @@ suffix-$(CONFIG_KERNEL_XZ)	:= xz
 suffix-$(CONFIG_KERNEL_LZO) 	:= lzo
 suffix-$(CONFIG_KERNEL_LZ4) 	:= lz4
 
-RUN_SIZE = $(shell $(OBJDUMP) -h vmlinux | \
-	     perl $(srctree)/arch/x86/tools/calc_run_size.pl)
+RUN_SIZE = $(shell NUM='\([0-9a-fA-F]*[ \t]*\)'; $(OBJDUMP) -h vmlinux | \
+sed -n 's/^[ \t0-9]*.b[sr][sk][ \t]*'"$$NUM$$NUM$$NUM$$NUM"'.*/\1\4/p' | \
+xargs | while read a b c d; do [ "$$b" != "$$d" ] && exit 1; \
+expr $$(printf "%d + %d + %d" 0x$$a 0x$$b 0x$$c); done)
 quiet_cmd_mkpiggy = MKPIGGY $@
       cmd_mkpiggy = $(obj)/mkpiggy $< $(RUN_SIZE) > $@ || ( rm -f $@ ; false )
 
diff -puN arch/x86/tools/calc_run_size.pl~remove-recently-added-perl-build-requirement /dev/null
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
