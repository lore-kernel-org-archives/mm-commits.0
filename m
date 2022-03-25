Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779E4C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357491AbiCYBhE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357496AbiCYBfx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7D1329B9
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CC00B8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E236EC340ED;
        Fri, 25 Mar 2022 01:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172026;
        bh=H6N7+57JtTs7xSc9oWIhmcUWEVRUrsCGj+Bmoapj4qY=;
        h=Date:To:From:Subject:From;
        b=n/gWQEfi6GcelQEKY3jQBuckA/2Kg3vnzfBAAgQcnMf7zQR8bPz/OaH92BLSciS/C
         lwMOWrNRKl59l3QxmP9WV6BBlr5xPKb8PElkqdY/FJWUfdKfpDgBYEG4O05k/vGCcn
         N9u/HqFT0JnoSMhrWd0sVkAGQF4Db0SRwMYvQmt8=
Date:   Thu, 24 Mar 2022 18:33:45 -0700
To:     mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp,
        ndesaulniers@google.com, nathan@kernel.org, masahiroy@kernel.org,
        arnd@arndb.de, keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] kconfigdebug-make-debug_info-selectable-from-a-choice.patch removed from -mm tree
Message-Id: <20220325013345.E236EC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: make DEBUG_INFO selectable from a choice
has been removed from the -mm tree.  Its filename was
     kconfigdebug-make-debug_info-selectable-from-a-choice.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Kconfig.debug: make DEBUG_INFO selectable from a choice

Currently it's not possible to enable DEBUG_INFO for an all*config build,
since it is marked as "depends on !COMPILE_TEST".  This generally makes
sense because a debug build of an all*config target ends up taking much
longer and the output is much larger.  Having this be "default off" makes
sense.  However, there are cases where enabling DEBUG_INFO for such builds
is useful for doing treewide A/B comparisons of build options, etc.

Make DEBUG_INFO selectable from any of the DWARF version choice options,
with DEBUG_INFO_NONE being the default for COMPILE_TEST.  The mutually
exclusive relationship between DWARF5 and BTF must be inverted, but the
result remains the same.  Additionally moves DEBUG_KERNEL and DEBUG_MISC
up to the top of the menu because they were enabling features _above_ it,
making it weird to navigate menuconfig.

[keescook@chromium.org: make DEBUG_INFO always default=n]
  Link: https://lkml.kernel.org/r/20220128214131.580131-1-keescook@chromium.org
  Link: https://lore.kernel.org/lkml/YfRY6+CaQxX7O8vF@dev-arch.archlinux-ax161
Link: https://lkml.kernel.org/r/20220125075126.891825-1-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |  139 +++++++++++++++++++++++---------------------
 1 file changed, 74 insertions(+), 65 deletions(-)

--- a/lib/Kconfig.debug~kconfigdebug-make-debug_info-selectable-from-a-choice
+++ a/lib/Kconfig.debug
@@ -208,20 +208,87 @@ config DEBUG_BUGVERBOSE
 
 endmenu # "printk and dmesg options"
 
+config DEBUG_KERNEL
+	bool "Kernel debugging"
+	help
+	  Say Y here if you are developing drivers or trying to debug and
+	  identify kernel problems.
+
+config DEBUG_MISC
+	bool "Miscellaneous debug code"
+	default DEBUG_KERNEL
+	depends on DEBUG_KERNEL
+	help
+	  Say Y here if you need to enable miscellaneous debug code that should
+	  be under a more specific debug option but isn't.
+
 menu "Compile-time checks and compiler options"
 
 config DEBUG_INFO
-	bool "Compile the kernel with debug info"
-	depends on DEBUG_KERNEL && !COMPILE_TEST
+	bool
 	help
-	  If you say Y here the resulting kernel image will include
-	  debugging info resulting in a larger kernel image.
+	  A kernel debug info option other than "None" has been selected
+	  in the "Debug information" choice below, indicating that debug
+	  information will be generated for build targets.
+
+choice
+	prompt "Debug information"
+	depends on DEBUG_KERNEL
+	help
+	  Selecting something other than "None" results in a kernel image
+	  that will include debugging info resulting in a larger kernel image.
 	  This adds debug symbols to the kernel and modules (gcc -g), and
 	  is needed if you intend to use kernel crashdump or binary object
 	  tools like crash, kgdb, LKCD, gdb, etc on the kernel.
-	  Say Y here only if you plan to debug the kernel.
 
-	  If unsure, say N.
+	  Choose which version of DWARF debug info to emit. If unsure,
+	  select "Toolchain default".
+
+config DEBUG_INFO_NONE
+	bool "Disable debug information"
+	help
+	  Do not build the kernel with debugging information, which will
+	  result in a faster and smaller build.
+
+config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
+	bool "Rely on the toolchain's implicit default DWARF version"
+	select DEBUG_INFO
+	help
+	  The implicit default version of DWARF debug info produced by a
+	  toolchain changes over time.
+
+	  This can break consumers of the debug info that haven't upgraded to
+	  support newer revisions, and prevent testing newer versions, but
+	  those should be less common scenarios.
+
+config DEBUG_INFO_DWARF4
+	bool "Generate DWARF Version 4 debuginfo"
+	select DEBUG_INFO
+	help
+	  Generate DWARF v4 debug info. This requires gcc 4.5+ and gdb 7.0+.
+
+	  If you have consumers of DWARF debug info that are not ready for
+	  newer revisions of DWARF, you may wish to choose this or have your
+	  config select this.
+
+config DEBUG_INFO_DWARF5
+	bool "Generate DWARF Version 5 debuginfo"
+	select DEBUG_INFO
+	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
+	help
+	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
+	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
+	  draft features until 7.0), and gdb 8.0+.
+
+	  Changes to the structure of debug info in Version 5 allow for around
+	  15-18% savings in resulting image and debug info section sizes as
+	  compared to DWARF Version 4. DWARF Version 5 standardizes previous
+	  extensions such as accelerators for symbol indexing and the format
+	  for fission (.dwo/.dwp) files. Users may not want to select this
+	  config if they rely on tooling that has not yet been updated to
+	  support DWARF Version 5.
+
+endchoice # "Debug information"
 
 if DEBUG_INFO
 
@@ -267,56 +334,12 @@ config DEBUG_INFO_SPLIT
 	  to know about the .dwo files and include them.
 	  Incompatible with older versions of ccache.
 
-choice
-	prompt "DWARF version"
-	help
-	  Which version of DWARF debug info to emit.
-
-config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
-	bool "Rely on the toolchain's implicit default DWARF version"
-	help
-	  The implicit default version of DWARF debug info produced by a
-	  toolchain changes over time.
-
-	  This can break consumers of the debug info that haven't upgraded to
-	  support newer revisions, and prevent testing newer versions, but
-	  those should be less common scenarios.
-
-	  If unsure, say Y.
-
-config DEBUG_INFO_DWARF4
-	bool "Generate DWARF Version 4 debuginfo"
-	help
-	  Generate DWARF v4 debug info. This requires gcc 4.5+ and gdb 7.0+.
-
-	  If you have consumers of DWARF debug info that are not ready for
-	  newer revisions of DWARF, you may wish to choose this or have your
-	  config select this.
-
-config DEBUG_INFO_DWARF5
-	bool "Generate DWARF Version 5 debuginfo"
-	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
-	depends on !DEBUG_INFO_BTF
-	help
-	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
-	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
-	  draft features until 7.0), and gdb 8.0+.
-
-	  Changes to the structure of debug info in Version 5 allow for around
-	  15-18% savings in resulting image and debug info section sizes as
-	  compared to DWARF Version 4. DWARF Version 5 standardizes previous
-	  extensions such as accelerators for symbol indexing and the format
-	  for fission (.dwo/.dwp) files. Users may not want to select this
-	  config if they rely on tooling that has not yet been updated to
-	  support DWARF Version 5.
-
-endchoice # "DWARF version"
-
 config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
 	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
 	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	depends on BPF_SYSCALL
+	depends on !DEBUG_INFO_DWARF5
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert
@@ -585,20 +608,6 @@ source "lib/Kconfig.kcsan"
 
 endmenu
 
-config DEBUG_KERNEL
-	bool "Kernel debugging"
-	help
-	  Say Y here if you are developing drivers or trying to debug and
-	  identify kernel problems.
-
-config DEBUG_MISC
-	bool "Miscellaneous debug code"
-	default DEBUG_KERNEL
-	depends on DEBUG_KERNEL
-	help
-	  Say Y here if you need to enable miscellaneous debug code that should
-	  be under a more specific debug option but isn't.
-
 menu "Networking Debugging"
 
 source "net/Kconfig.debug"
_

Patches currently in -mm which might be from keescook@chromium.org are

selftests-kselftest-framework-provide-finished-helper.patch

