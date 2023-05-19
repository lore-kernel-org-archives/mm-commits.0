Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F71C7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjESVgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbjESVgq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:36:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348D3101;
        Fri, 19 May 2023 14:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987EE65B4A;
        Fri, 19 May 2023 21:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9D8C433EF;
        Fri, 19 May 2023 21:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532204;
        bh=lcxzIwud3uwyoYHfMBUjGwWcA9PjFfYZ22J6kz88vu4=;
        h=Date:To:From:Subject:From;
        b=tqUiLnsTecyQvteNmNuaqRUhqbzWvVDcpRuyiAqOhYsQnZZNsIuabT+xoU7KdHDmH
         iCE0BrxixSe3Ifd9F34W8Y/AuDhMJvfqdFQ8v5CxxxznEnbCXYamNVG4fU3VbRFGUe
         aFJzV3ZlvLcoG3R6fmrwsrnOERFCbOxKjj5WVePU=
Date:   Fri, 19 May 2023 14:36:43 -0700
To:     mm-commits@vger.kernel.org, zwisler@google.com, trix@redhat.com,
        tglx@linutronix.de, stable@vger.kernel.org, rostedt@goodmis.org,
        prudo@redhat.com, paul.walmsley@sifive.com, palmer@rivosinc.com,
        palmer@dabbelt.com, npiggin@gmail.com, ndesaulniers@google.com,
        nathan@kernel.org, mpe@ellerman.id.au, mingo@redhat.com,
        hpa@zytor.com, horms@kernel.org, ebiederm@xmission.com,
        dyoung@redhat.com, dave.hansen@linux.intel.com,
        christophe.leroy@csgroup.eu, bp@alien8.de, bhe@redhat.com,
        aou@eecs.berkeley.edu, ribalda@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + riscv-purgatory-remove-pgo-flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20230519213643.EA9D8C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: riscv/purgatory: remove PGO flags
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     riscv-purgatory-remove-pgo-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/riscv-purgatory-remove-pgo-flags.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: riscv/purgatory: remove PGO flags
Date: Fri, 19 May 2023 16:47:39 +0200

If profile-guided optimization is enabled, the purgatory ends up with
multiple .text sections.  This is not supported by kexec and crashes the
system.

Link: https://lkml.kernel.org/r/20230321-kexec_clang16-v7-4-b05c520b7296@chromium.org
Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Cc: <stable@vger.kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/purgatory/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/riscv/purgatory/Makefile~riscv-purgatory-remove-pgo-flags
+++ a/arch/riscv/purgatory/Makefile
@@ -35,6 +35,11 @@ CFLAGS_sha256.o := -D__DISABLE_EXPORTS
 CFLAGS_string.o := -D__DISABLE_EXPORTS
 CFLAGS_ctype.o := -D__DISABLE_EXPORTS
 
+# When profile-guided optimization is enabled, llvm emits two different
+# overlapping text sections, which is not supported by kexec. Remove profile
+# optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%,$(KBUILD_CFLAGS))
+
 # When linking purgatory.ro with -r unresolved symbols are not checked,
 # also link a purgatory.chk binary without -r to check for unresolved symbols.
 PURGATORY_LDFLAGS := -e purgatory_start -z nodefaultlib
_

Patches currently in -mm which might be from ribalda@chromium.org are

kexec-support-purgatories-with-texthot-sections.patch
x86-purgatory-remove-pgo-flags.patch
powerpc-purgatory-remove-pgo-flags.patch
riscv-purgatory-remove-pgo-flags.patch

