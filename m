Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF1CC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:43:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbiCWWou (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345321AbiCWWot (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:44:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3861226AD8
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:43:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF02AB81E0A
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96190C340E9;
        Wed, 23 Mar 2022 22:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648075396;
        bh=/+M3QzDyLRDlpK5xxrZWej5hwylHh+z+c7KgPj8WmfU=;
        h=Date:To:From:Subject:From;
        b=EIBRHAV27kGoKPz/k5eyinlpIFZ2TsnuesC7umCpU0ik3+DWE8hHePQ82/o7xoAa5
         /NB7f/7qrgkfL1rKpJtvd2xGHl2szLCGr3s1+bgwmq3w6s91uYODf/Y1RrlQHefNX6
         tnA2yr4Sp0WdH4ZDIm1oqKRipZwhJfjLbZh5Ixj0=
Date:   Wed, 23 Mar 2022 15:43:15 -0700
To:     mm-commits@vger.kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch removed from -mm tree
Message-Id: <20220323224316.96190C340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: make DEBUG_INFO always default=n
has been removed from the -mm tree.  Its filename was
     kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch

This patch was dropped because it was folded into kconfigdebug-make-debug_info-selectable-from-a-choice.patch

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: Kconfig.debug: make DEBUG_INFO always default=n

While trying to make sure CONFIG_DEBUG_INFO wasn't set for COMPILE_TEST, I
ordered the choices incorrectly to retain the prior default=n state.  Move
DEBUG_INFO_NONE to the top so that the default choice is disabled, and
remove the "if COMPILE_TEST" as it is now redundant.

Link: https://lkml.kernel.org/r/20220128214131.580131-1-keescook@chromium.org
Link: https://lore.kernel.org/lkml/YfRY6+CaQxX7O8vF@dev-arch.archlinux-ax161
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/lib/Kconfig.debug~kconfigdebug-make-debug_info-selectable-from-a-choice-fix
+++ a/lib/Kconfig.debug
@@ -234,7 +234,6 @@ config DEBUG_INFO
 choice
 	prompt "Debug information"
 	depends on DEBUG_KERNEL
-	default DEBUG_INFO_NONE if COMPILE_TEST
 	help
 	  Selecting something other than "None" results in a kernel image
 	  that will include debugging info resulting in a larger kernel image.
@@ -245,6 +244,12 @@ choice
 	  Choose which version of DWARF debug info to emit. If unsure,
 	  select "Toolchain default".
 
+config DEBUG_INFO_NONE
+	bool "Disable debug information"
+	help
+	  Do not build the kernel with debugging information, which will
+	  result in a faster and smaller build.
+
 config DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
 	bool "Rely on the toolchain's implicit default DWARF version"
 	select DEBUG_INFO
@@ -283,12 +288,6 @@ config DEBUG_INFO_DWARF5
 	  config if they rely on tooling that has not yet been updated to
 	  support DWARF Version 5.
 
-config DEBUG_INFO_NONE
-	bool "Disable debug information"
-	help
-	  Do not build the kernel with debugging information, which will
-	  result in a faster and smaller build.
-
 endchoice # "Debug information"
 
 if DEBUG_INFO
_

Patches currently in -mm which might be from keescook@chromium.org are

kconfigdebug-make-debug_info-selectable-from-a-choice.patch
selftests-kselftest-framework-provide-finished-helper.patch

