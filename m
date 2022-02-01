Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E58C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 00:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbiBAASh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 19:18:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiBAASh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 19:18:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6010AB82CC0
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 00:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC3DC340E8;
        Tue,  1 Feb 2022 00:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643674715;
        bh=+Nj9g41PbPqH81EZ3VRQHnpdo+Rw+0j8EfAOTuGrTC4=;
        h=Date:To:From:Subject:From;
        b=vd0CFTPs+nMVbwsp73l+LX04I0zGoq0xEXKDWlXl5enF5bwdWCQuxchguF90PLnCH
         nidEt9/VeEhsZY2heNziZOIn6OqdsFKMnbmKR2roaNWZ/OCcKrvkTcKpoNq7b9uw8B
         GbuRx2FR4TysyFjBm+jT7FWnCZpeSlp3ZjvpN+vE=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 16:18:33 -0800
Date:   Mon, 31 Jan 2022 16:18:33 -0800
To:     mm-commits@vger.kernel.org, ojeda@kernel.org,
        ndesaulniers@google.com, nathan@kernel.org, masahiroy@kernel.org,
        keescook@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch added to -mm tree
Message-Id: <20220201001833.DDC3DC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig.debug: make DEBUG_INFO always default=n
has been added to the -mm tree.  Its filename is
     kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch

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
kconfigdebug-make-debug_info-selectable-from-a-choice-fix.patch

