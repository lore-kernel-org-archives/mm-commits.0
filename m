From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] makefile-support-compressed-debug-info.patch
 removed from -mm tree
Date: Wed, 20 May 2020 20:46:51 -0700
Message-ID: <20200521034651.Ghv7sfYws%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgEUDqx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 May 2020 23:46:53 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, blaikie@google.com, changbin.du@intel.com, krzk@kernel.org, maskray@google.com, mchehab+huawei@kernel.org, michal.lkml@markovi.net, mm-commits@vger.kernel.org, ndesaulniers@google.com, nickc@redhat.com, rdunlap@infradead.org, sedat.dilek@gmail.com, sfr@canb.auug.org.au


The patch titled
     Subject: Makefile: support compressed debug info
has been removed from the -mm tree.  Its filename was
     makefile-support-compressed-debug-info.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Makefile: support compressed debug info

As debug information gets larger and larger, it helps significantly save
the size of vmlinux images to compress the information in the debug
information sections.  Note: this debug info is typically split off from
the final compressed kernel image, which is why vmlinux is what's used in
conjunction with GDB.  Minimizing the debug info size should have no
impact on boot times, or final compressed kernel image size.

All of the debug sections will have a `C` flag set.
$ readelf -S <object file>

$ bloaty vmlinux.gcc75.compressed.dwarf4 -- \
    vmlinux.gcc75.uncompressed.dwarf4

    FILE SIZE        VM SIZE
 --------------  --------------
  +0.0%     +18  [ = ]       0    [Unmapped]
 -73.3%  -114Ki  [ = ]       0    .debug_aranges
 -76.2% -2.01Mi  [ = ]       0    .debug_frame
 -73.6% -2.89Mi  [ = ]       0    .debug_str
 -80.7% -4.66Mi  [ = ]       0    .debug_abbrev
 -82.9% -4.88Mi  [ = ]       0    .debug_ranges
 -70.5% -9.04Mi  [ = ]       0    .debug_line
 -79.3% -10.9Mi  [ = ]       0    .debug_loc
 -39.5% -88.6Mi  [ = ]       0    .debug_info
 -18.2%  -123Mi  [ = ]       0    TOTAL

$ bloaty vmlinux.clang11.compressed.dwarf4 -- \
    vmlinux.clang11.uncompressed.dwarf4

    FILE SIZE        VM SIZE
 --------------  --------------
  +0.0%     +23  [ = ]       0    [Unmapped]
 -65.6%    -871  [ = ]       0    .debug_aranges
 -77.4% -1.84Mi  [ = ]       0    .debug_frame
 -82.9% -2.33Mi  [ = ]       0    .debug_abbrev
 -73.1% -2.43Mi  [ = ]       0    .debug_str
 -84.8% -3.07Mi  [ = ]       0    .debug_ranges
 -65.9% -8.62Mi  [ = ]       0    .debug_line
 -86.2% -40.0Mi  [ = ]       0    .debug_loc
 -42.0% -64.1Mi  [ = ]       0    .debug_info
 -22.1%  -122Mi  [ = ]       0    TOTAL

For x86_64 defconfig + LLVM=1 (before):
Elapsed (wall clock) time (h:mm:ss or m:ss): 3:22.03
Maximum resident set size (kbytes): 43856

For x86_64 defconfig + LLVM=1 (after):
Elapsed (wall clock) time (h:mm:ss or m:ss): 3:32.52
Maximum resident set size (kbytes): 1566776

Link: http://lkml.kernel.org/r/20200520193637.6015-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: David Blaikie <blakie@google.com>
Suggested-by: Fangrui Song <maskray@google.com>
Suggested-by: Nick Clifton <nickc@redhat.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Nick Clifton <nickc@redhat.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Changbin Du <changbin.du@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Makefile          |    6 ++++++
 lib/Kconfig.debug |   15 +++++++++++++++
 2 files changed, 21 insertions(+)

--- a/lib/Kconfig.debug~makefile-support-compressed-debug-info
+++ a/lib/Kconfig.debug
@@ -213,6 +213,21 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
+config DEBUG_INFO_COMPRESSED
+	bool "Compressed debugging information"
+	depends on DEBUG_INFO
+	depends on $(cc-option,-gz=zlib)
+	depends on $(as-option,-Wa,--compress-debug-sections=zlib)
+	depends on $(ld-option,--compress-debug-sections=zlib)
+	help
+	  Compress the debug information using zlib.  Requires GCC 5.0+ or Clang
+	  5.0+, binutils 2.26+, and zlib.
+
+	  Users of dpkg-deb via scripts/package/builddeb may
+	  wish to set the $KDEB_COMPRESS env var to "none" to avoid recompressing
+	  the debug info again with a different compression scheme, which can
+	  result in larger binaries.
+
 config DEBUG_INFO_SPLIT
 	bool "Produce split debuginfo in .dwo files"
 	depends on DEBUG_INFO
--- a/Makefile~makefile-support-compressed-debug-info
+++ a/Makefile
@@ -814,6 +814,12 @@ DEBUG_CFLAGS	+= $(call cc-option, -femit
 		   $(call cc-option,-fno-var-tracking)
 endif
 
+ifdef CONFIG_DEBUG_INFO_COMPRESSED
+DEBUG_CFLAGS	+= -gz=zlib
+KBUILD_AFLAGS	+= -Wa,--compress-debug-sections=zlib
+KBUILD_LDFLAGS	+= --compress-debug-sections=zlib
+endif
+
 KBUILD_CFLAGS += $(DEBUG_CFLAGS)
 export DEBUG_CFLAGS
 
_

Patches currently in -mm which might be from ndesaulniers@google.com are

x86-bitops-fix-build-regression.patch
elfnote-mark-all-note-sections-shf_alloc.patch
