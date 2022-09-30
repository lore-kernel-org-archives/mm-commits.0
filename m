Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F78BC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 30 Sep 2022 23:57:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbiI3X55 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Sep 2022 19:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbiI3X54 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2022 19:57:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C1018CB05
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 16:57:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9A43B82A43
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 23:57:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A743C433C1;
        Fri, 30 Sep 2022 23:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664582271;
        bh=WPze4eu7n7sPcrUS8k7XvbhEklu/X9/DKFkgkfsPU3w=;
        h=Date:To:From:Subject:From;
        b=AmOvG7BZA8owMjn38aozZIqXhMfeDgTzvuvni71oG/cMmTCV88NE2znv08L4xoKdN
         dI8iuo70Ebb5mVrUOjO8Zff/cb6a4pYgvn2aSMF2OMySfXhPxKB/Mz4JbewD1mpZLk
         aihOkEOMao1HUkdf3INvJJdCrrtYTgOj3kd7UA00=
Date:   Fri, 30 Sep 2022 16:57:50 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com, palmer@dabbelt.com,
        ndesaulniers@google.com, masahiroy@kernel.org,
        conor.dooley@microchip.com, nathan@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-kconfigdebug-add-check-for-non-constant-suleb128-support-to-dwarf5.patch added to mm-nonmm-unstable branch
Message-Id: <20220930235751.7A743C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: add check for non-constant .{s,u}leb128 support to DWARF5
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-kconfigdebug-add-check-for-non-constant-suleb128-support-to-dwarf5.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-kconfigdebug-add-check-for-non-constant-suleb128-support-to-dwarf5.patch

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
From: Nathan Chancellor <nathan@kernel.org>
Subject: lib/Kconfig.debug: add check for non-constant .{s,u}leb128 support to DWARF5
Date: Wed, 28 Sep 2022 11:25:23 -0700

When building with a RISC-V kernel with DWARF5 debug info using clang and
the GNU assembler, several instances of the following error appear:

  /tmp/vgettimeofday-48aa35.s:2963: Error: non-constant .uleb128 is not supported

Dumping the .s file reveals these .uleb128 directives come from
.debug_loc and .debug_ranges:

  .Ldebug_loc0:
          .byte   4                               # DW_LLE_offset_pair
          .uleb128 .Lfunc_begin0-.Lfunc_begin0    #   starting offset
          .uleb128 .Ltmp1-.Lfunc_begin0           #   ending offset
          .byte   1                               # Loc expr size
          .byte   90                              # DW_OP_reg10
          .byte   0                               # DW_LLE_end_of_list

  .Ldebug_ranges0:
          .byte   4                               # DW_RLE_offset_pair
          .uleb128 .Ltmp6-.Lfunc_begin0           #   starting offset
          .uleb128 .Ltmp27-.Lfunc_begin0          #   ending offset
          .byte   4                               # DW_RLE_offset_pair
          .uleb128 .Ltmp28-.Lfunc_begin0          #   starting offset
          .uleb128 .Ltmp30-.Lfunc_begin0          #   ending offset
          .byte   0                               # DW_RLE_end_of_list

There is an outstanding binutils issue to support a non-constant operand
to .sleb128 and .uleb128 in GAS for RISC-V but there does not appear to be
any movement on it, due to concerns over how it would work with linker
relaxation.

To avoid these build errors, prevent DWARF5 from being selected when using
clang and an assembler that does not have support for these symbol deltas,
which can be easily checked in Kconfig with as-instr plus the small test
program from the dwz test suite from the binutils issue.

Link: https://sourceware.org/bugzilla/show_bug.cgi?id=27215
Link: https://github.com/ClangBuiltLinux/linux/issues/1719
Link: https://lkml.kernel.org/r/20220928182523.3105953-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/lib/Kconfig.debug~lib-kconfigdebug-add-check-for-non-constant-suleb128-support-to-dwarf5
+++ a/lib/Kconfig.debug
@@ -231,6 +231,9 @@ config DEBUG_INFO
 	  in the "Debug information" choice below, indicating that debug
 	  information will be generated for build targets.
 
+config AS_HAS_NON_CONST_LEB128
+	def_bool $(as-instr,.uleb128 .Lexpr_end4 - .Lexpr_start3\n.Lexpr_start3:\n.Lexpr_end4:)
+
 choice
 	prompt "Debug information"
 	depends on DEBUG_KERNEL
@@ -275,6 +278,10 @@ config DEBUG_INFO_DWARF5
 	bool "Generate DWARF Version 5 debuginfo"
 	select DEBUG_INFO
 	depends on !CC_IS_CLANG || (CC_IS_CLANG && (AS_IS_LLVM || (AS_IS_GNU && AS_VERSION >= 23502)))
+	# Clang is known to generate .{s,u}leb128 with symbol deltas with
+	# DWARF5, which some targets may not support.
+	# https://sourceware.org/bugzilla/show_bug.cgi?id=27215
+	depends on !CC_IS_CLANG || AS_HAS_NON_CONST_LEB128
 	help
 	  Generate DWARF v5 debug info. Requires binutils 2.35.2, gcc 5.0+ (gcc
 	  5.0+ accepts the -gdwarf-5 flag but only had partial support for some
_

Patches currently in -mm which might be from nathan@kernel.org are

lib-kconfigdebug-add-check-for-non-constant-suleb128-support-to-dwarf5.patch

