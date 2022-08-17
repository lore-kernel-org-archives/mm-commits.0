Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B848C32772
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 19:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiHQTjb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 15:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239050AbiHQTj3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 15:39:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF2BA1D72
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 12:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E069B81F4A
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 19:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62ADC4347C;
        Wed, 17 Aug 2022 19:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660765164;
        bh=X3H28MN3RjiHxuUcBIj7U9kJEhxKspwzyENIJVh1Dfc=;
        h=Date:To:From:Subject:From;
        b=LKDWoVfavptw/CqDHpDZGiwsSMB1t6fzyuKanxZlNlFTjkmdSak3IPXM8xRuzFESv
         JDrQz+diWlxxzVf/3ln3WIutY+/NxbggU+EmCcglbii346X6qxtSNDPYSCWTNF33c0
         0k5Hsy5f+/6A0WH3eYeBR8qnUfUwgBq4UhMfWtaQ=
Date:   Wed, 17 Aug 2022 12:39:23 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ndesaulniers@google.com, nathan@kernel.org,
        michal.lkml@markovi.net, maskray@google.com, masahiroy@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net, edumazet@google.com,
        dan.j.williams@intel.com, dmitrii.bundin.a@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kbuild-add-debug-level-and-macro-defs-options.patch added to mm-nonmm-unstable branch
Message-Id: <20220817193923.E62ADC4347C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kbuild: add debug level and macro defs options
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kbuild-add-debug-level-and-macro-defs-options.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-add-debug-level-and-macro-defs-options.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Subject: kbuild: add debug level and macro defs options
Date: Mon, 15 Aug 2022 04:33:17 +0300

Add config options to control debug info level and producing of macro
definitions for GCC/Clang.

Option DEBUG_INFO_LEVEL is responsible for controlling debug info level. 
Before GCC 11 and Clang 12 -gsplit-dwarf implicitly uses -g2.  To provide
a way to override the setting with, e.g.  -g1, DEBUG_INFO_LEVEL is set
independently from DEBUG_INFO_SPLIT.

Option DEBUG_MACRO_DEFINITIONS is responsible for controlling inclusion of
macro definitions.  Since Clang uses -fdebug-macro to control if macro
definitions are produced which is different from GCC, provides a
compiler-specific way of handling macro inclusion.  The option is handled
after DEBUG_INFO_LEVEL since -g3 -g2 implies -g2, but -g2 -g3 implies -g3
and GCC uses -g3 to produce macro definitions.

Link: https://lkml.kernel.org/r/20220815013317.26121-1-dmitrii.bundin.a@gmail.com
Signed-off-by: Dmitrii Bundin <dmitrii.bundin.a@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug      |   20 ++++++++++++++++++++
 scripts/Makefile.debug |   12 ++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

--- a/lib/Kconfig.debug~kbuild-add-debug-level-and-macro-defs-options
+++ a/lib/Kconfig.debug
@@ -304,6 +304,26 @@ config DEBUG_INFO_REDUCED
 	  DEBUG_INFO build and compile times are reduced too.
 	  Only works with newer gcc versions.
 
+config DEBUG_INFO_LEVEL
+	int "Debug info level"
+	range 1 3
+	default "2"
+	help
+	  Sets the level of how much debug information to generate (-glevel).
+	  Level 1 produces minimal debug information without including information
+	  about local variables. Level 3 includes extra information like macro
+	  definitions. Setting up level 3 will require significantly more disk
+	  space and increase built time.
+
+config DEBUG_MACRO_DEFINITIONS
+	bool "Add macro definitions to debug info"
+	default n
+	help
+	  Generates macro definitions to provide a way to expand macros right
+	  in the debugging session. This information can be used with macro expand,
+	  info macro in gdb. This option is equivalent to setting -g3 in GCC and
+	  -fdebug-macro in Clang.
+
 config DEBUG_INFO_COMPRESSED
 	bool "Compressed debugging information"
 	depends on $(cc-option,-gz=zlib)
--- a/scripts/Makefile.debug~kbuild-add-debug-level-and-macro-defs-options
+++ a/scripts/Makefile.debug
@@ -2,8 +2,6 @@ DEBUG_CFLAGS	:=
 
 ifdef CONFIG_DEBUG_INFO_SPLIT
 DEBUG_CFLAGS	+= -gsplit-dwarf
-else
-DEBUG_CFLAGS	+= -g
 endif
 
 ifndef CONFIG_AS_IS_LLVM
@@ -16,6 +14,16 @@ dwarf-version-$(CONFIG_DEBUG_INFO_DWARF5
 DEBUG_CFLAGS	+= -gdwarf-$(dwarf-version-y)
 endif
 
+DEBUG_CFLAGS	+= -g$(CONFIG_DEBUG_INFO_LEVEL)
+ifdef CONFIG_DEBUG_MACRO_DEFINITIONS
+ifdef CONFIG_CC_IS_GCC
+DEBUG_CFLAGS	+= -g3
+endif
+ifdef CONFIG_CC_IS_CLANG
+DEBUG_CFLAGS	+= -fdebug-macro
+endif
+endif
+
 ifdef CONFIG_DEBUG_INFO_REDUCED
 DEBUG_CFLAGS	+= -fno-var-tracking
 ifdef CONFIG_CC_IS_GCC
_

Patches currently in -mm which might be from dmitrii.bundin.a@gmail.com are

kbuild-add-debug-level-and-macro-defs-options.patch

