Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01618C5DF62
	for <mm-commits@archiver.kernel.org>; Wed, 26 Jan 2022 00:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiAZAfw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 19:35:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbiAZAfw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 19:35:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31E0C06173B
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 16:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 935D3614B7
        for <mm-commits@vger.kernel.org>; Wed, 26 Jan 2022 00:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C17BDC340E0;
        Wed, 26 Jan 2022 00:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643157351;
        bh=63CkLJqv9yxvYRGZM3M0bVgHLdoKUR5yz+d3snZXl2U=;
        h=Date:From:To:Subject:From;
        b=cPgGq76H67SM6BaUOAe3BDOtUlfKI3O9T7aRgF6J+Idw2Vz51+Zviv7WTicxAsdpf
         S/tbcp8AsJ+h8GUcqQQ2gGvGE9B1+/7UE9yxT1Yuhix8HuOLlud/uwoS6vYBzcjWbN
         anKcc0slVroBUWnZYh5Xa51jz/xyhi9yKcdHMrtI=
Date:   Tue, 25 Jan 2022 16:35:50 -0800
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, keescook@chromium.org, masahiroy@kernel.org,
        mm-commits@vger.kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, penguin-kernel@I-love.SAKURA.ne.jp
Subject:  +
 kconfigdebug-make-debug_info-selectable-from-a-choice.patch added to -mm
 tree
Message-ID: <20220126003550.LEBG0fgrl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: make DEBUG_INFO selectable from a choice
has been added to the -mm tree.  Its filename is
     kconfigdebug-make-debug_info-selectable-from-a-choice.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kconfigdebug-make-debug_info-selectable-from-a-choice.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kconfigdebug-make-debug_info-selectable-from-a-choice.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 lib/Kconfig.debug |  140 +++++++++++++++++++++++---------------------
 1 file changed, 75 insertions(+), 65 deletions(-)

--- a/lib/Kconfig.debug~kconfigdebug-make-debug_info-selectable-from-a-choice
+++ a/lib/Kconfig.debug
@@ -208,20 +208,88 @@ config DEBUG_BUGVERBOSE
 
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
+	default DEBUG_INFO_NONE if COMPILE_TEST
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
+config DEBUG_INFO_NONE
+	bool "Disable debug information"
+	help
+	  Do not build the kernel with debugging information, which will
+	  result in a faster and smaller build.
+
+endchoice # "Debug information"
 
 if DEBUG_INFO
 
@@ -267,56 +335,12 @@ config DEBUG_INFO_SPLIT
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
@@ -585,20 +609,6 @@ source "lib/Kconfig.kcsan"
 
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

kconfigdebug-make-debug_info-selectable-from-a-choice.patch

