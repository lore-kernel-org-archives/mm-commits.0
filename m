Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C52CC7EE26
	for <mm-commits@archiver.kernel.org>; Fri, 19 May 2023 21:36:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbjESVgs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 May 2023 17:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjESVgo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 19 May 2023 17:36:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4371FB;
        Fri, 19 May 2023 14:36:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 575F365B4A;
        Fri, 19 May 2023 21:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FCBC433D2;
        Fri, 19 May 2023 21:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684532201;
        bh=Dw//S3qzpvdbT1abJK67RZEQ669ikswGifUGJ7MRy64=;
        h=Date:To:From:Subject:From;
        b=XeP8d44B1C6sND1ItB/2GJqoIsrHH1j9m5ECoAnMrguX6dySL7Y8xGkkChXNgsaDS
         G+Y+TVifDMEccGtKiGUGdJ3B8zgCZMyWBnHo99H8zWtfkXRjQbzv6NqfmDpmQpNozY
         QuavBNEGusFdkzx+V9wxSOrxf0cgGNoJgBebuOck=
Date:   Fri, 19 May 2023 14:36:41 -0700
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
Subject: + powerpc-purgatory-remove-pgo-flags.patch added to mm-hotfixes-unstable branch
Message-Id: <20230519213641.A4FCBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/purgatory: remove PGO flags
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     powerpc-purgatory-remove-pgo-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-purgatory-remove-pgo-flags.patch

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
Subject: powerpc/purgatory: remove PGO flags
Date: Fri, 19 May 2023 16:47:38 +0200

If profile-guided optimization is enabled, the purgatory ends up with
multiple .text sections.  This is not supported by kexec and crashes the
system.

Link: https://lkml.kernel.org/r/20230321-kexec_clang16-v7-3-b05c520b7296@chromium.org
Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <stable@vger.kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Baoquan He <bhe@redhat.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Simon Horman <horms@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/purgatory/Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/powerpc/purgatory/Makefile~powerpc-purgatory-remove-pgo-flags
+++ a/arch/powerpc/purgatory/Makefile
@@ -5,6 +5,11 @@ KCSAN_SANITIZE := n
 
 targets += trampoline_$(BITS).o purgatory.ro
 
+# When profile-guided optimization is enabled, llvm emits two different
+# overlapping text sections, which is not supported by kexec. Remove profile
+# optimization flags.
+KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%,$(KBUILD_CFLAGS))
+
 LDFLAGS_purgatory.ro := -e purgatory_start -r --no-undefined
 
 $(obj)/purgatory.ro: $(obj)/trampoline_$(BITS).o FORCE
_

Patches currently in -mm which might be from ribalda@chromium.org are

kexec-support-purgatories-with-texthot-sections.patch
x86-purgatory-remove-pgo-flags.patch
powerpc-purgatory-remove-pgo-flags.patch
riscv-purgatory-remove-pgo-flags.patch

